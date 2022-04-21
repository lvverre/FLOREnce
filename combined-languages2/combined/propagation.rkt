#lang racket


;
;LOGIC PART 
;



(provide (all-defined-out))
 (require racket/gui/base
          "../defmac.rkt"
          rebellion/concurrency/lock)
(require "../logical/nodes.rkt"
         "../logical/unification.rkt"
         "../logical/tokens.rkt"
         "../logical/compiler.rkt"
         "../logical/environment.rkt"
         "../functional/datastructures.rkt"
          (prefix-in func: "../functional/compile-interpret.rkt")
         (only-in "forall.rkt"
                  functional-connector
                  functional-connector-deployedR-add
                  functional-connector-deployedR-remove)
       
       )



       
       

;MAKE NODES


    
        
(define (make-production-node todo)
  
  (match todo
    [`(remove: (fact: ,name ,args ...))
     (let ((compiled-args (map (lambda (arg)
                                 (compile arg #f))
                                 args)))
       (retract-node name compiled-args))]
    
    [`(add: (fact: ,name ,args ...) for: ,alive-time)
      (let ((compiled-args (map (lambda (arg)
                                 (compile arg #f))
                                 args)))
     (emit-node name compiled-args alive-time))]

    [_ (error (format "~a is not a valide expression for the then:-part of a rule" todo))]))


(define (remove-constraint-from-alpha-node! alpha-node)
  (set-alpha-node-constraints! alpha-node null))

;makes the joins nodes and other alpha-nodes and link them together

(define (combine-to-join-nodes alpha-nodes)
  (define (combine-loop left-node alpha-nodes)
  
    (if (null? alpha-nodes)
        left-node
        (let* ((right-node (car alpha-nodes))
               (new-join-node  ;make join-node
                (make-join-node left-node right-node  (alpha-node-constraints right-node))))
          ; constraint is moved to join node
          (remove-constraint-from-alpha-node! right-node)
          ;set the successor right
          (register-successor! right-node new-join-node)
          (register-successor! left-node new-join-node)
          ;end step
          (combine-loop new-join-node (cdr alpha-nodes)))))
  (combine-loop (car alpha-nodes) (cdr alpha-nodes)))


;TODO check the variabes in the event-conditions
(defmac (rule: name where: (event-name (parameters ...) constraints ...) ... then: then-clause)
  #:keywords rule: where: then:
  #:captures root            
    (let ((alpha-nodes (map (lambda (name pars constrs)
                                (let ((new-node (make-alpha-node name pars
                                                                  (map (lambda (condition) (compile condition #t)) constrs))))
                                 
                                  (register-to-root!  new-node root)
                                   
                                  new-node))
                              '(event-name ...)
                              '((parameters ...) ...)
                              '((constraints ...) ...)))
             ;gives back terminal node
         
             (production-node (make-production-node 'then-clause)))
      
        (let ((last-node (combine-to-join-nodes alpha-nodes)))
          ;set the last join-node to the terminal-node
          (register-successor! last-node production-node))))
        
  















       
;
;PROCESS-JOIN-NODE
;








      



(define (logic-propagate token node root root-lock ); events)

  
  (define (execute-alpha-node token alpha-node  )
  (when (equal? (alpha-token-id token) (alpha-node-event-id alpha-node))
    (let ((event-env (unify-args (alpha-token-args token)
                                 (alpha-node-args alpha-node)
                                 (make-immutable-hash))))
      (when event-env
        (when (for/and ([constraint (alpha-node-constraints alpha-node)])
                (execute constraint  condition-global-env event-env))
          (update-pms-and-propagate token event-env alpha-node  ))))))

  
  (define (execute-join-node token opposite-partial-matches join-node  )
  (let ((constraints (join-node-constraints join-node))
        (token-partial-match-env  (beta-token-pm token)))
    (for-each
     (lambda (opposite-partial-match)     
       (let ((combined-partial-match-env (try-to-combine-env token-partial-match-env (pm-env opposite-partial-match))))
         (when combined-partial-match-env
           (when 
               (for/and ([constraint constraints])
                 (execute constraint condition-global-env   combined-partial-match-env))
             (update-pms-and-propagate token combined-partial-match-env join-node  )))))
     opposite-partial-matches)))

  
  (define (execute-production-node node token purpose  )
  (when (add-token? token)
   
    (let* ((args (map (lambda (expr)
                        (execute expr
                                 body-global-env
                                 (beta-token-pm token)
                                 ))
                      (production-node-args node)))
           (token (if purpose
                      (make-alpha-token-add  (production-node-name node) args (emit-node-alive-time node))
                      (make-alpha-token-remove (production-node-name node) args))))
      
      (propagate-from-root token  root root-lock)))); events))))

  (define (execute-functional-connector node token )
    (let* ((order-args (alpha-node-args (beta-token-owner token)))
         (pm-env  (beta-token-pm token))
         (input (for/vector ([variable order-args])
                  (func:c-const (lookup-event-variable  variable pm-env))))
         (deployedR (if (add-token? token)
                        (functional-connector-deployedR-add node)
                        (functional-connector-deployedR-remove node))))
      (execute-turn deployedR  input root root-lock )))
           

  
  (define (update-pms-and-propagate old-token new-pm-env node   )
  (let ((new-beta-token (if (add-token? old-token)
                         (make-beta-token-add  new-pm-env  node)
                         (make-beta-token-remove new-pm-env  node)))
        (pms-removed? #t))
  
    (cond ((add-token? old-token)
           (cond ((alpha-token? old-token)
                  (let ((pm (partial-match-occurs? new-pm-env node))) 
                    (if pm
                        (set-alpha-pm-expiration-time! pm (alpha-token-add-expiration-time old-token))
                        (add-partial-match! (alpha-pm
                                             new-pm-env
                                             (alpha-token-add-expiration-time old-token))
                                            node))))
                 (else (add-partial-match! (pm new-pm-env) node))))
          (else
           
           (set! pms-removed? (remove-partial-matches! new-pm-env node))))
    (when pms-removed?
      (propagate-to-node new-beta-token (filter-node-successor node)   ))))
                

  
(define (propagate-to-node token node )
  (match node
    [(alpha-node _ _ _  _ _  )
     (execute-alpha-node token node  )]             
    [(join-node _ _  left-predecessor  right-predecessor _)
     (printf (format "Join-node \n"))
     (if (eq? (beta-token-owner token) left-predecessor)
         (execute-join-node token (filter-node-partial-matches right-predecessor) node  )
         (execute-join-node token (filter-node-partial-matches left-predecessor) node  ))]
    [(emit-node _ _ _)
     (printf (format "Emit node \n"))
     (execute-production-node node token #t  )]
    [(retract-node _ _)
     (printf (format "retract node \n"))   
     (execute-production-node node token #f  )]
    [(functional-connector _ _ )
     (execute-functional-connector node token )]
    ))
  (propagate-to-node token node))
     
  
  





(define (expired? pm)
  (and (not (= -1 (alpha-pm-expiration-time pm)))
       (> (current-seconds) (alpha-pm-expiration-time pm))))

(define (split-remove-keep-pms node)
  (for/fold ([keep '()]
             [remove '()])
            ([partial-match (filter-node-partial-matches node )])
    (if (expired? partial-match)
        (values keep (cons partial-match remove))
        (values (cons partial-match keep) remove))))

(define for-all-partial-matches for-each)
(define for-all-successors for-each)

 (define (remove-expired-facts root root-lock ); events)
   (for-all-in-root root
                    (lambda (alpha-node)
                      (let-values ([(keep-pms remove-pms) (split-remove-keep-pms alpha-node)])
                        (set-filter-node-partial-matches! alpha-node keep-pms)
                        (for-all-partial-matches
                         (lambda (partial-match)
                           
                                    (let ((new-token (make-beta-token-remove (pm-env partial-match)
                                                                             alpha-node)))
                                      (logic-propagate new-token
                                                       (filter-node-successor alpha-node)
                                                       root root-lock )); events))
                                                            
                                               )
                                  remove-pms)))))
                    
                       
    

;Makes a timer that will go off to clean up the expired facts
(define (make-timer root root-lock ); events)
  (new timer% [notify-callback
               (lambda ()
                 
                 (when (semaphore-try-wait? root-lock)
                   (remove-expired-facts root root-lock ); events)
                   (semaphore-post root-lock)))]))
 
                                     
                                 

;
;add-fact
;

(define (start-propagation token root-lock root ); events)
  (semaphore-wait root-lock)
  ;(send timer start 1000)
  (propagate-from-root token root root-lock); events)
  (remove-expired-facts root root-lock );events))
  (semaphore-post root-lock))

;propagates an event with name NAME and args -values trough the DAG


(defmac (add: FACT for: alive-interval)
  #:keywords add: for:
  #:captures root-lock  root 
  (if (token? FACT)
      (start-propagation
       (make-alpha-token-add (token-id FACT)(token-args FACT) alive-interval)
       root-lock
       root
       
      )
      (error (format "~a is not a fact" FACT))))
(defmac (remove: FACT)
  #:keywords remove:
  #:captures root-lock  root  
  (if (token? FACT)
      (start-propagation
       (make-alpha-token-remove (token-id FACT)(token-args FACT))
       root-lock
       root
       )
      (error (format "~a is not a fact" FACT))))

(defmac (fact: NAME ARGS ...)
  #:keywords fact:
  (token 'NAME '(ARGS ...)))
     

(define (propagate-from-root token root  root-lock)
  ;(func:fire-from-logic-graph events token)
  (for-each (lambda (node)
              (logic-propagate token node root root-lock )
              )
            (root-registered-nodes root)))




;
;FUNCTIONAL
;


(require 
         (prefix-in  func: "../functional/nodes.rkt" )
        
         "../functional/deployment.rkt"
         (prefix-in func: "../functional/environment.rkt")
         
          racket/local)

(provide (all-defined-out))



(define (functional-propagate nodes node-values start-idx)
  (define (loop idx )
    
    (when (> (vector-length nodes) idx)
      (let ((current-node (vector-ref nodes idx)))
        ;(displayln node-values)
        ;(displayln current-node)
        (match current-node
        
          
          [(func:start-jump-node roots jump-add)
           ;check condition
           (let* ((condition (for/or ([root-idx roots])
                           (not (eq? (vector-ref node-values root-idx) 'empty)))))
          ;   (display "condition:" )
          ;   (displayln condition)
             
             (if condition 
                 ;if true return nothing
                 (loop (+ idx 1)  )
               ;if false give back idx to where to jump
                 (loop (+ jump-add idx) )))]
          
          
          
          
          ;for a function execute the function on the give value and store result
          [(func:single-function-node idx predecessor function)
           (let ((predecessor-value (vector-ref node-values (car predecessor))))
           ;  (displayln predecessor-value)
             (cond ((eq? 'empty predecessor-value)
                    ;;in case a filter occurred
                    (vector-set! node-values idx 'empty))
                   (else 
                    ;calculate new value and store
                    (vector-set! node-values idx (func:interpret function predecessor-value)))))
             (loop  (+ idx 1)  )]
          
          ;for a function with random number of arguments
         ; [(multi-function-node idx predecessor function)
         ;  (let ((args (cdr (vector-ref node-values (car predecessor)))))
         ;    ;calculate new value and store
         ;    (vector-set! node-values idx (apply function args))
         ;    (loop  (+ idx 1) branch ))]
  
          [(func:or-node  idx predecessors )
           
           ;;check branch to see which value it needs to take
           (let* ((left-predecessor-idx (car predecessors))
                  (right-predecessor-idx (cadr predecessors))
                  (value (if (not (eq? (vector-ref node-values left-predecessor-idx) 'empty))
                                 ;left
                             (vector-ref node-values left-predecessor-idx)
                             ;right
                             (vector-ref node-values right-predecessor-idx))))
            ; (displayln value)
             (vector-set! node-values idx value)
             (loop  (+ idx 1)  ))]
            
    
          [(func:filter-node idx predecessor filter)
           
           (let ((value (vector-ref node-values (car predecessor))))
             ;(displayln value)
             ;;if already been filtered out by previous filter or value is not #t by condition
             (if (or (eq? 'empty value) (not (func:interpret filter value)))
                 (vector-set! node-values idx 'empty)
                 ;;value allowed to pass
                 (vector-set! node-values idx value))
             (loop  (+ idx 1)  ))]
         
          
          ))))
  
  (loop start-idx ))


(define (execute-turn deployedr input root root-lock )
  (define ins (deployedR-ins deployedr))
  (define nodes (deployedR-dag deployedr))
  (define outs (deployedR-outs deployedr))
  (define values (make-vector (vector-length nodes) 'empty))
  (if (not (= (vector-length ins) (vector-length input)))
      (error (format "Wrong number of inputs expected ~a given ~a"
                     (vector-length ins)
                     (vector-length input)))
      (for ([idx ins]
            [value input])
        
        (vector-set! values idx value)))
 
  (functional-propagate  nodes values (vector-length ins))
  (let ((output  (for/vector ([idx outs])
                    (vector-ref values idx))))
                    
    (display (format "Output: ~a\n" output))
    (for ([collector (logic-connector-logical-cmpts deployedr)])
      
      (put-in-collector-from-deployedR! collector output root root-lock ))))
  
              
;(define (turn: deployedr  input)
; #:keywords turn: with:
;  (execute-turn deployedr
;                           input))


(defmac (fire name value)
  #:keywords fire
  #:captures root-lock  root functional-environment
  (let ((event (func:lookup-var 'name functional-environment)))
    (for ([deployement (functional-event-functional-cmpnts event)])
      (let* ((deployedr (functional-cmpnt-deployedR deployement))
             (input (make-vector (vector-length (deployedR-ins deployedr))
                                'empty)))
        (for ([input-idx (functional-cmpnt-input-idxs deployement)])
          (vector-set! input input-idx value))
        
        (execute-turn deployedr input root root-lock )))
    (for ([logical-cmpnt (logic-connector-logical-cmpts event)])
      (put-in-collector-from-event! logical-cmpnt value root root-lock ))))




;
;PROPAGATION BETWEEN GRAPHS
;

(define (propagate-to-logic-graph collector full-collection root root-lock )
  (let ((token (if (add-fact-collector? collector)
                   (make-alpha-token-add (fact-collector-fact-name collector)
                                         (map func:c-const-value (vector->list full-collection))
                                         (add-fact-collector-time-interval collector))
                   (make-alpha-token-remove (fact-collector-fact-name collector)
                                            (map func:c-const-value (vector->list full-collection))))))
    (start-propagation token  root-lock root )))

(define (put-in-collector-from-event! deployedL value root root-lock )
  (let ((idxs-to-update (deployedL-input-places deployedL))
        (collector (deployedL-collector deployedL)))
    (for ([idx idxs-to-update])
      (let ((full-collection (put-in-collector!  collector value idx)))
        (when full-collection
          
          (propagate-to-logic-graph collector full-collection
                                    root root-lock ))))
    ))
          

(define (put-in-collector-from-deployedR! collector values root root-lock )
  (let loop-put-in-colletor
    ([idx 0])
 
    (when (< idx (vector-length values))
      (let ((value (vector-ref values idx)))
        (when (not (eq? 'empty value))
            
            (let ((full-collection (put-in-collector! collector
                                                      value
                                                      idx)))
             
              (when full-collection
              
              (propagate-to-logic-graph collector full-collection
                                        root root-lock ))))
           
          (loop-put-in-colletor (+ idx 1)))))
  
        )
            
    

(define (empty-place? collection idx)
  (eq? 'empty (get-collection collection idx)))


(define (full? collection)
  
  (for/and ([value collection])
    (not (equal? 'empty value))))

(define (put-in-collector! fact-collector value idx-collection )
  (define collections (fact-collector-storage fact-collector))
  (define size (vector-length collections))
  (define (move!)
    (let ((new-collection  (make-collection (size-collection
                                             (vector-ref (fact-collector-storage fact-collector)
                                                         (fact-collector-head fact-collector)))
                                            'empty))
         
          (old-head (fact-collector-head fact-collector)))
          
      (vector-set! collections
                   (fact-collector-tail fact-collector) 
                   new-collection)
      
      ;(put-collection! new-collection idx-collection value)
     
      (set-fact-collector-tail! fact-collector (modulo (+ (fact-collector-tail fact-collector) 1)
                                                       size))
                                                          
      (set-fact-collector-head! fact-collector (modulo (+ old-head 1) size))
      
      (vector-ref collections old-head)))
 
  (let loop-for-place
    ((idx-fact-collector (fact-collector-head fact-collector)))
    
    (cond ((= idx-fact-collector (fact-collector-tail fact-collector))
        
           (move!)
           (put-collection! (get-collection collections idx-fact-collector)
                            idx-collection
                            value)
          
           #f)          
          ((empty-place? (vector-ref collections  idx-fact-collector) idx-collection)
           (let ((collection (vector-ref collections idx-fact-collector)))
            
             (put-collection! collection idx-collection value)
            
             (if (full? collection)
                 (begin 
                        (move!))
                 #f)))
          (else
           (loop-for-place (modulo (+ idx-fact-collector 1) size))))))