#lang racket
(require (for-syntax syntax/parse))

(provide (all-defined-out))
 (require racket/gui/base
          "../model.rkt"
          "../logical/logical-variables.rkt"
          "../GUI-update.rkt")
(require (except-in  "../logical/nodes.rkt" root)
         "../logical/unification.rkt"
         "../logical/tokens.rkt"
         "../compile-interpret.rkt"
         "../environment.rkt"
         ;"../logical/compiler.rkt" 
         "../logical/environment.rkt"
         "../functional/datastructures.rkt"
       ;  "../parse-values.rkt"
         
         (only-in "forall.rkt"
                  logic-connector
                  logic-connector-deployedR-add
                  logic-connector-deployedR-remove)
       
       )



       
       

;MAKE NODES


    
        
(define (make-production-node todo)
  
  (match todo
    [`(remove: (fact: ,name ,args ...))
     (let ((compiled-args (map (lambda (arg)
                                 (compile #'arg ))
                                 args)))
       (retract-node name compiled-args))]
    
    [`(add: (fact: ,name ,args ...) for: ,alive-time)
      (let ((compiled-args (map (lambda (arg)
                                 (compile #'arg ))
                                 args)))
     (emit-node name compiled-args alive-time))]

    [_ (error (format "~a is not a valide expression for the then:-part of a rule" todo))]))


(define (remove-constraint-from-alpha-node! alpha-node)
  (set-alpha-node-constraints! alpha-node (list true)))

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
(define-syntax (rule: stx)
  (syntax-parse stx
    [((~literal rule:) name:id (~literal where:) (event-name:id (parameters ...) constraints ...) ... (~literal then:) then-clause)          
    #'(let* (
           (alpha-nodes (map (lambda (name pars constrs)
                                (let ((new-node (make-alpha-node name pars
                                                                  (compile-multiple-in-one constrs))))
                                 
                                  (register-to-root!  new-node root)
                                   
                                  new-node))
                              '(event-name ...)
                              '((parameters ...) ...)
                              '((constraints ...) ...)))
             ;gives back terminal node
         
             (production-node (make-production-node 'then-clause)))
      
        (let ((last-node (combine-to-join-nodes alpha-nodes)))
          ;set the last join-node to the terminal-node
          (register-successor! last-node production-node)))]))
        
  















       
;
;PROCESS-JOIN-NODE
;








      



(define (logic-propagate token node turn-number ); events)
  (define (compute-constraint event-env constraint)
    (displayln (format "Constraint: ~a" constraint))
      (let ((result (eval-rule-body  event-env constraint)))
        result))
       
  
  (define (execute-alpha-node token alpha-node  )
  (when (equal? (alpha-token-id token) (alpha-node-event-id alpha-node))
    (let ((event-env (unify-args (alpha-token-args token)
                                 (alpha-node-args alpha-node)
                                 (make-hash)
                                 (add-token? token))))
      (when event-env
        (when (compute-constraint event-env (alpha-node-constraints alpha-node))
          (update-pms-and-propagate token event-env alpha-node  ))))))

  
  (define (execute-join-node token opposite-partial-matches join-node  )
  (let ((constraints (join-node-constraints join-node))
        (token-partial-match-env  (beta-token-pm token)))
    (for-each
     (lambda (opposite-partial-match)     
       (let ((combined-partial-match-env (try-to-combine-env token-partial-match-env (pm-env opposite-partial-match))))
         (when combined-partial-match-env
           (when
               (compute-constraint combined-partial-match-env constraints)
               
             (update-pms-and-propagate token combined-partial-match-env join-node  )))))
     opposite-partial-matches)))

  
  (define (execute-production-node node token purpose  )
    (when (add-token? token)
      
      (let* ((args   (eval-rule-body (func:make-env (beta-token-pm token))
                                     
                                     (production-node-args node)
                                     
                                     
                                     ))
             
             (token (if purpose
                        (make-alpha-token-add  (production-node-name node) args (emit-node-alive-time node))
                      (make-alpha-token-remove (production-node-name node) args))))
        
        (propagate-from-root token  turn-number )))); events))))

  (define (execute-logic-connector node token )
   
    (let* ((order-args (alpha-node-args (beta-token-owner token)))
         (pm-env  (beta-token-pm token))
         (input (for/vector ([variable order-args])
                  (lookup-event-variable  variable pm-env)))
         (deployedR (if (add-token? token)
                        (logic-connector-deployedR-add node)
                        (logic-connector-deployedR-remove node))))
      (execute-turn deployedR  input turn-number )))
           

  
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
    [(logic-connector _ _ )
     (execute-logic-connector node token )]
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

 (define (remove-expired-facts  ); events)
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
                                                        5)); events))
                                                            
                                               )
                                  remove-pms)))))
                    
                       
    

;Makes a timer that will go off to clean up the expired facts
(define (make-timer )
  (let ((lock (root-lock root))); events)
  (new timer% [notify-callback
               (lambda ()
                 
                 (when (semaphore-try-wait? lock)
                   (remove-expired-facts  ); events)
                   (semaphore-post lock)))])))
 
                                     
                                 

;
;add-fact
;

(define (start-propagation token  turn-number); events)
  (display "start propagation")
  (semaphore-wait (root-lock root))
  ;(send timer start 1000)
  (propagate-from-root token turn-number); events)
  (remove-expired-facts  );events))
  (semaphore-post (root-lock root)))

;propagates an event with name NAME and args -values trough the DAG


(define-syntax (add: stx)
  (syntax-parse stx
    [((~literal add:) FACT (~literal for:) alive-interval:number)
  #'(if (token? FACT)
      (start-propagation
       (make-alpha-token-add (token-id FACT)(token-args FACT) alive-interval)
       
       5
       
      )
      (error (format "~a is not a fact" FACT)))]))
(define-syntax (remove: stx)
  (syntax-parse stx
    [((~literal remove:) FACT)
     #'(if (token? FACT)
           (start-propagation
            (make-alpha-token-remove (token-id FACT)(token-args FACT))
            5
       
       )
      (error (format "~a is not a fact" FACT)))]))

(define-syntax (fact: stx)
  (syntax-parse stx
    [((~literal fact:) name:id args ...)
      #'(token 'NAME (map (lambda (arg)                           
                           (interpret-body arg rule-env))
                          '(args ...)))]))
     

(define (propagate-from-root token   turn-number)
  ;(func:fire-from-logic-graph events token)
  (for-each (lambda (node)
              (when (> turn-number 0)
                (logic-propagate token node (- turn-number ))
              ))
            (root-registered-nodes root)))




;
;FUNCTIONAL
;


(require 
         (prefix-in  func: "../functional/nodes.rkt" )
        
         
         (prefix-in func: "../environment.rkt")
        
         
          racket/local)

(provide (all-defined-out))



(define (functional-propagate nodes node-values start-idx model-env)
 
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
          [(func:single-function-node idx predecessor function event-var)
           (let* ((predecessor-value (vector-ref node-values (car predecessor)))
                  (local-env (hash-set model-env event-var predecessor-value)))
             (displayln "HIER")
           ;  (displayln (eval-reactor-body function local-env))
           ;  (displayln predecessor-value)
             (cond ((eq? 'empty predecessor-value)
                    ;;in case a filter occurred
                    (vector-set! node-values idx 'empty))
                   (else 
                    ;calculate new value and store
                    (vector-set! node-values idx  (eval-reactor-body function local-env)))))
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
            
    
          [(func:filter-node idx predecessor filter event-variable)
         
           (let* ((value (vector-ref node-values (car predecessor)))
                  (local-env (hash-set model-env event-variable value)))
             ;(displayln value)
             ;;if already been filtered out by previous filter or value is not #t by condition
             (if (or (eq? 'empty value) (not (eval-reactor-body  filter local-env )))
                 (vector-set! node-values idx 'empty)
                 ;;value allowed to pass
                 (vector-set! node-values idx value))
             (loop  (+ idx 1)  ))]
         
          
          ))))
  
  (loop start-idx ))



(define (execute-turn deployedr input  turn-number)
 
  (define ins (deployedR-ins deployedr))
  (define nodes (deployedR-dag deployedr))
  (define outs (deployedR-outs deployedr))
  (define model-vars (for/fold ([vars '()])
                               ([in ins])
                       (let ((var (vector-ref nodes in)))
                         (if (model-var? var)
                             (cons (cons model-var-var model-var-val) vars)
                             vars))))
                             
  (define values (make-vector (vector-length nodes) 'empty))
  (if (not (= (vector-length ins) (vector-length input)))
      (error (format "Wrong number of inputs expected ~a given ~a"
                     (vector-length ins)
                     (vector-length input)))
      (for ([idx ins]
            [value input])
        
        (vector-set! values idx value)))
  (let ((local-env (hash-map (deployedR-model-vars deployedr) (lambda (k v) (cons k (model-var-val v))))))
 
  (functional-propagate  nodes values (vector-length ins) (make-immutable-hash local-env))

  (let ((output  (for/vector ([idx outs])
                    (vector-ref values idx))))
                    
    
    (for ([connector (functional-node-connectors deployedr)])
    
      (match connector
        [(external-connector args)
         (for ([arg args]
               [out output])
           (when (not (equal? 'empty out))
         (match arg
           [(model-var var val)
            (set-model-var-val! arg out)]
           [_ (update-view arg out)])))]
        [(internal-connector inputinfo app-info)
         (put-in-collector-from-deployedR! connector output  turn-number)])))))
       
     
  
              
;(define (turn: deployedr  input)
; #:keywords turn: with:
;  (execute-turn deployedr
;                           input))


(define-syntax (fire stx)
  (syntax-parse stx
    [((~literal fire) event value)
     #'(let ((env global-env))
         (for ([deployement (functional-node-connectors event)])
           (match deployement
             [(func->func-connector input-idxs deployedr)
              (let ((input (make-vector (vector-length (deployedR-ins deployedr))
                                        'empty)))
                (for ([input-idx input-idxs])
                  (vector-set! input input-idx value))
                (execute-turn deployedr input  5))]
             [(func->logic-connector _ _)
              (put-in-collector-from-event! deployement value  5)])))]))




;
;PROPAGATION BETWEEN GRAPHS
;

(define (propagate-to-logic-graph collector full-collection   turn-number)
 
  (let ((token (if (add-fact-collector? collector)
                   (make-alpha-token-add (fact-collector-fact-name collector)
                                         (vector->list full-collection)
                                         (add-fact-collector-time-interval collector))
                   (make-alpha-token-remove (fact-collector-fact-name collector)
                                            (vector->list full-collection)))))
    (start-propagation token turn-number )))

(define (put-in-collector-from-event! func->logic-connector value  turn-number)
  (let ((idxs-to-update (functional-connector-input-info func->logic-connector))
        (collector (functional-connector-app-info func->logic-connector)))
    (for ([idx idxs-to-update])
      (let ((full-collection (put-in-collector!  collector value idx)))
        (when full-collection
          (propagate-to-logic-graph collector full-collection  turn-number ))))
    ))
          

(define (put-in-collector-from-deployedR! collector values   turn-number)
  (display values)
  (let ((collector (functional-connector-app-info collector)))
  (let loop-put-in-colletor
    ([idx 0])
    
    (when (< idx (vector-length values))
      (let ((value (vector-ref values idx)))
        (when (not (eq? 'empty value))
            
            (let ((full-collection (put-in-collector! collector
                                                      value
                                                      idx)))
              (when full-collection
              (propagate-to-logic-graph collector full-collection turn-number
                                         ))))
           
          (loop-put-in-colletor (+ idx 1)))))
  
        ))
            
    

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
                 (move!)
                  #f)))
          (else
           (loop-for-place (modulo (+ idx-fact-collector 1) size))))))