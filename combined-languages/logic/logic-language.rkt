#lang racket

(provide (all-defined-out))
 (require racket/gui/base)
(require "nodes.rkt"
         "../defmac.rkt"
         "unification.rkt"
         "tokens.rkt"
         "compiler.rkt"
         "environment.rkt"
        "../have-lock.rkt"
        (only-in "../combination/forall2.rkt"
                 functional-connector
                 functional-connector-deployedR-add
                 functional-connector-deployedR-remove)
        (only-in "../functional/functional2.rkt" execute-turn))

       
       

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








      



(define (logic-propagate token node root timer); events)

  
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
      
      (propagate-from-root token  root)))); events))))

  (define (execute-functional-connector node token )
    (let* ((order-args (alpha-node-args (beta-token-owner token)))
         (pm-env  (beta-token-pm token))
         (input (for/vector ([variable order-args])
                  (lookup-event-variable  variable pm-env)))
         (deployedR (if (add-token? token)
                        (functional-connector-deployedR-add node)
                        (functional-connector-deployedR-remove node))))
      (execute-turn deployedR  input root root-lock timer)))
           

  
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
      (for-each (lambda (successor)
                  (propagate-to-node new-beta-token successor   ))
                (filter-node-successors node)))))

  
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

 (define (remove-expired-facts root); events)
   (for-all-in-root root
                    (lambda (alpha-node)
                      (let-values ([(keep-pms remove-pms) (split-remove-keep-pms alpha-node)])
                        (set-filter-node-partial-matches! alpha-node keep-pms)
                        (for-all-partial-matches
                         (lambda (partial-match)
                           
                                    (let ((new-token (make-beta-token-remove (pm-env partial-match)
                                                                             alpha-node)))
                                      (for-all-successors (lambda (successor)
                                                            (logic-propagate new-token successor root)); events))
                                                            
                                                (filter-node-successors alpha-node))))
                                  remove-pms)))))
                    
                       
    

;Makes a timer that will go off to clean up the expired facts
(define (make-timer root root-lock); events)
  (new timer% [notify-callback
               (lambda ()
                 
                 (when (semaphore-try-wait? root-lock)
                   (remove-expired-facts root); events)
                   (semaphore-post root-lock)))]))
 
                                     
                                 

;
;add-fact
;

(define (start-propagation token root-lock root timer); events)
  (semaphore-wait root-lock)
  (send timer start 1000)
  (propagate-from-root token root timer); events)
  (remove-expired-facts root );events))
  (semaphore-post root-lock))

;propagates an event with name NAME and args -values trough the DAG


(defmac (add: FACT for: alive-interval)
  #:keywords add: for:
  #:captures root-lock timer root 
  (if (token? FACT)
      (start-propagation
       (make-alpha-token-add (token-id FACT)(token-args FACT) alive-interval)
       root-lock
       root
       timer
      )
      (error (format "~a is not a fact" FACT))))
(defmac (remove: FACT)
  #:keywords remove:
  #:captures root-lock timer root  
  (if (token? FACT)
      (start-propagation
       (make-alpha-token-remove (token-id FACT)(token-args FACT))
       root-lock
       root
       timer)
      (error (format "~a is not a fact" FACT))))

(defmac (fact: NAME ARGS ...)
  #:keywords fact:
  (token 'NAME '(ARGS ...)))
     

(define (propagate-from-root token root timer)
  ;(func:fire-from-logic-graph events token)
  (for-each (lambda (node)
              (logic-propagate token node root  timer)
              )
            (root-registered-nodes root)))

