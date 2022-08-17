#lang racket
       
       

;MAKE NODES
(require syntax/parse)
(require (for-syntax syntax/parse))

(require "../eval-rules-bodies.rkt")
(require (except-in  "../logical/nodes.rkt" root)
         "../logical/tokens.rkt"
         "queue-datastructure.rkt"
         "../interpret-build.rkt"
         "../logical/unification.rkt"
         "../compile-interpret.rkt"
         "../environment.rkt"
         ;"../logical/compiler.rkt" 
         "../logical/environment.rkt"
          "../functional/datastructures.rkt"
       ;  "../parse-values.rkt"
            "../logical/logical-variables.rkt"
          "../GUI-update.rkt"
          racket/gui/base
         (only-in "forall.rkt"
                  logic-connector
                  logic-connector-deployedR-add
                  logic-connector-deployedR-remove)
         )

(provide (all-defined-out))
    
        
(define-syntax (make-production-node todo)
  (syntax-parse todo
    [(_ ((~literal remove:) ((~literal fact:) name:id args:body ...)))
     #'(retract-node 'name (list args.value ...))]
    [(_ ((~literal add:) ((~literal fact:) name:id args:body ...) (~literal for:) alive-time:number))
     #'(emit-node 'name (list args.value ...) alive-time)]
    [_ (error (format "~a is not a valide expression for the then:-part of a rule" todo))]))


(define (remove-constraint-from-alpha-node! alpha-node)
  (set-alpha-node-constraints! alpha-node (const-exp #t)))

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
     (with-syntax ([production-node #'(make-production-node then-clause)])
       #'(let* (
                (alpha-nodes (map (lambda (name pars constrs)
                                    (let ((new-node (make-alpha-node name pars
                                                                     (compile-constraint-rules-without-syntax  constrs))))
                                      
                                      (register-to-root!  new-node root)
                                      
                                      new-node))
                                  '(event-name ...)
                                  '((parameters ...) ...)
                                  '((constraints ...) ...)))
                ;gives back terminal node
                
                ;(production-node (make-production-node 'then-clause))
                )
      
        (let ((last-node (combine-to-join-nodes alpha-nodes)))
          ;set the last join-node to the terminal-node
          (register-successor! last-node production-node))))]))
        
  















       
;
;PROCESS-JOIN-NODE
;




  (define (execute-logic-connector node token turn)

    (let* ((order-args (alpha-node-args (beta-token-owner token)))
         (pm-env  (beta-token-pm token))
         (input (for/vector ([variable order-args])
                  (lookup-event-variable  variable pm-env)))
         (displayln token)
         (deployedR (if (add-token? token)
                        (logic-connector-deployedR-add node)
                        (logic-connector-deployedR-remove node))))
  
       (add-to-priority-queue! turn deployedR input) 
      ;(execute-turn deployedR  input turn-number )
      ))

 
  (define (execute-production-node node token purpose  turn-number)
   
    
    (when (add-token? token)
      
      (let* ((args   (map (lambda (arg) (eval-rule-body-then arg (beta-token-pm token) (get-sub-env global-env 'model)))
                          (production-node-args node)))        
             (token (if purpose
                        (make-alpha-token-add  (production-node-name node) args (emit-node-alive-time node))
                        (make-alpha-token-remove (production-node-name node) args))))
        
        (propagate-from-root token  turn-number ))))



      



(define (logic-propagate token node turn-number)
  
  (define (compute-constraint event-env constraint)
    
      (let ((result (eval-rule-body-where   constraint event-env (get-sub-env global-env 'model))))
        result))
       
  
  (define (execute-alpha-node token alpha-node  )
   
    (cond ((add-token? token)
        
           (when (equal? (alpha-token-id token) (alpha-node-event-id alpha-node))
            
             (let ((event-env (unify-args (alpha-token-args token)
                                          (alpha-node-args alpha-node)
                                          (make-hash)
                                          (add-token? token))))
               
               (when event-env
                
                 (when (compute-constraint event-env (alpha-node-constraints alpha-node))
                   (displayln token)
                   (update-pms-and-propagate token event-env alpha-node  ))))))
          (else
         
           (when (equal? (alpha-token-id token) (alpha-node-event-id alpha-node))
           
           (let ((existing-pms                  (filter-node-partial-matches alpha-node))
                 (event-env (unify-args (alpha-token-args token)
                                        (alpha-node-args alpha-node)
                                        (make-hash)
                                        (add-token? token))))
            
             (when event-env
               (for-each
                (lambda (opposite-partial-match)
                 
                  (let ((combined-partial-match-env (try-to-combine-env event-env (pm-env opposite-partial-match))))
                    (when combined-partial-match-env
                  
                      (update-pms-and-propagate
                       token
                       (pm-env opposite-partial-match)
                       alpha-node))))
                existing-pms)))))))

  
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
                        (begin (add-partial-match! (alpha-pm
                                             new-pm-env
                                             (alpha-token-add-expiration-time old-token))
                                            node) ))))
                 (else (add-partial-match! (pm new-pm-env) node))))
          (else
                 
           (set! pms-removed? (remove-partial-matches! new-pm-env node))
           ))
    (when pms-removed?
      (propagate-to-node new-beta-token (filter-node-successor node)   ))))
                

  
(define (propagate-to-node token node )
  
  (match node
    [(alpha-node _ _ _  _ _  )
     (execute-alpha-node token node  )]             
    [(join-node _ _  left-predecessor  right-predecessor _)

     (if (eq? (beta-token-owner token) left-predecessor)
         (execute-join-node token (filter-node-partial-matches right-predecessor) node  )
         (execute-join-node token (filter-node-partial-matches left-predecessor) node  ))]
    ;[(logic-connector _ _)
    [(logic-connector _ _)
     (displayln 'logic-connector)
     (displayln token)
     (add-to-priority-queue! turn-number node token )]
     [_
      
        (if (add-token? token)
            (begin (add-to-priority-queue! turn-number node token))
            (begin (remove-from-priority-queue! token node)))]))
     ;(add-to-priority-queue! turn-number node token)]))
   #| [(emit-node _ _ _)
     (printf (format "Emit node \n"))
     (execute-production-node node token #t  )]
    [(retract-node _ _)
     (printf (format "retract node \n"))   
     (execute-production-node node token #f  )]
    [(logic-connector _ _ )
     (execute-logic-connector node token )]
    ))|#
 
 
  (propagate-to-node token node))
     
  
  





(define (expired? pm)
  
 
  (and (not (= -1 (alpha-pm-expiration-time pm)))
       (> (current-seconds) (alpha-pm-expiration-time pm))))

(define (split-remove-keep-pms node)
  (for/fold ([keep '()]
             [remove '()])
            ([partial-match (filter-node-partial-matches node )])
    
    (if (expired? partial-match)
        (begin (values keep (cons partial-match remove)))
        (begin  (values (cons partial-match keep) remove)))))

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
                                                        50)); events))
                                                            
                                               )
                                  remove-pms)))))
                    
                       
    


 
                                     
                                 

;
;add-fact
;

(define (start-propagation token  turn-number); events)
  
  ;(send timer start 1000)
  (propagate-from-root token turn-number); events)
  (remove-expired-facts  );events))
  )

;propagates an event with name NAME and args -values trough the DAG



(begin-for-syntax 
  (define-syntax-class fact
    (pattern ((~literal fact:) name:id args ...)
             #:attr token #'(token 'name  (map (lambda (arg)
                                                 (eval-fact-body (compile-expression-without-syntax arg ) (make-hash) (get-sub-env global-env 'model)))
                                               '(args ...))))))


(define-syntax (add: stx)
  (syntax-parse stx
    [((~literal add:) FACT:fact (~literal for:) alive-interval:number)
     #'(let ((alpha-t (make-alpha-token-add (token-id FACT.token)
                                            (token-args FACT.token)
                                            alive-interval)))
        
         (add-to-priority-queue! 50 'root alpha-t ))]))
              
      #|(start-propagation
       (make-alpha-token-add (token-id FACT)(token-args FACT) alive-interval)
       
       50
       
      )|#
           
       
(define-syntax (remove: stx)
  (syntax-parse stx
    [((~literal remove:) FACT:fact)
     #'(let ((alpha-t (alpha-token-remove (token-id fact.token)
                                          (token-args fact.token))))
         (add-to-priority-queue! 50 'root alpha-t ))]))
              
           
           #|(start-propagation
            (make-alpha-token-remove (token-id FACT)(token-args FACT))
            50
       
       )|#
           



#|(define-syntax (fact: stx)
  (syntax-parse stx
    [((~literal fact:) name:id args ...)
      #'(token 'name (map (lambda (arg)
                            
                           (eval-fact-body (compile-expression-without-syntax arg ) (make-hash)))
                          '(args ...)))]))|#
     

(define (propagate-from-root token   turn-number)
  ;(func:fire-from-logic-graph events token)
  (for-each (lambda (node)
              (when (> turn-number 0)
                (logic-propagate token node turn-number ))
              )
            (root-registered-nodes root)))

