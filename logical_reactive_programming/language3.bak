#lang br/quicklang
(provide (all-defined-out))

(require "compile.rkt" "nodes3.rkt" "token.rkt" "unification.rkt" "e-environment.rkt" "../window-linked-list.rkt"
          (prefix-in func: "../functiona_reactive_programming/nodes.rkt")
          (prefix-in func: "../functiona_reactive_programming/functional_reactive_language_3.rkt")
          "variables.rkt"
          web-server/private/timer
          )

(define (read-syntax path port)
  (define parse-tree (port->lines port))
  (define module-datum `(module stacker-mod "language3.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)


(define-macro (stacker-module-begin PARSE-TREE )
  #'(#%module-begin
       PARSE-TREE ))
(provide (rename-out [stacker-module-begin #%module-begin]))









;make of event condition argument an alpha-node

(define (event-condition->alpha-node name args conditions interval )
 
  (make-alpha-node
       
       name
       args
       (map (lambda (condition)
                    (compile condition #t))
            conditions)
       interval))



;Store-intervals

;MACRO to reform a rule in a rete network(DAG)
(define (check-for-options options)
  (pattern-case options
                [() #'(sliding time-interval)]
                [(window: SIZE) #'(sliding SIZE)]
                [(sliding: SIZE) #'(SIZE time-interval)]
                [(window: WINDOW-SIZE sliding: SLIDING-SIZE) #'(SLIDING-SIZE WINDOW-SIZE)]))
;TODO check the variabes in the event-conditions
(define-macro
  (rule: NAME
                     where:
                     (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...) ...
                     then: BODY
                     OPTIONS ...)
  (with-pattern ([( SLIDING WINDOW)
                ;  #'(check-for-options #'(OPTIONS ...))])
                  (pattern-case #'(OPTIONS ...)
                [() #'(sliding time-interval)]
                [(window: SIZE) #'(sliding SIZE)]
                [(sliding: SIZE) #'(SIZE time-interval)]
                [(window: WINDOW-SIZE sliding: SLIDING-SIZE) #'(SLIDING-SIZE WINDOW-SIZE)])])              
    #'(make-graph-from-rule (map (lambda (event-name args conditions)
                                 (event-condition->alpha-node
                                  event-name
                                  args
                                  conditions
                                  SLIDING))
                               '(EVENT-NAME ...)
                               '((ARGS ...) ...)
                               '((CONDITIONS ...) ...))
                          
                          'BODY
                           SLIDING
                           WINDOW)))
    
    
#|(define-macro-cases rule:
  [ (rule: NAME
                     where:
                     (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...) ...
                     then: BODY
                     OPTIONS ...)
  
  ;make alpha-nodes
  #'(make-graph-from-rule (map event-condition->alpha-node
                               '(EVENT-NAME ...)
                               '((ARGS ...) ...)
                               '((CONDITIONS ...) ...))
                          'BODY)]
  [(rule: NAME
                     where:
                     (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...) ...
                     interval: SLIDING-INTERVAL
                     then: BODY
                     )
   #'(if (number? SLIDING-INTERVAL)
         (make-graph-from-rule (map (lambda (event-name args conditions)
                                      (event-condition->alpha-node
                                       event-name
                                       args
                                       conditions
                                       #:interval SLIDING-INTERVAL))
                                    '(EVENT-NAME ...)
                                    '((ARGS ...) ...)
                                    '((CONDITIONS ...) ...))
                              
                               'BODY
                               #:interval SLIDING-INTERVAL)
         (error "Rule: is not given correct number?"))]
  [(rule: NAME
                     where:
                     (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...) ...
                     size: SLIDING-SIZE
                     then: BODY
                     )
   #'(if (number? SLIDING-SIZE)
         (make-graph-from-rule (map
                                event-condition->alpha-node
                                '(EVENT-NAME ...)
                                '((ARGS ...) ...)
                                '((CONDITIONS ...) ...))
                              
                               'BODY
                               #:size SLIDING-SIZE)
         (error "Rule: is not given correct number?"))]
   [(rule: NAME
                     where:
                     (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...) ...
                     size: SLIDING-SIZE
                     interval: SLIDING-INTERVAL
                     then: BODY
                     )
   #'(if (number? SLIDING-SIZE)
         (make-graph-from-rule (map
                                (lambda (event-name args conditions)
                                      (event-condition->alpha-node
                                       event-name
                                       args
                                       conditions
                                       #:interval SLIDING-INTERVAL))
                                    '(EVENT-NAME ...)
                                    '((ARGS ...) ...)
                                    '((CONDITIONS ...) ...))
                              
                               'BODY
                               #:size SLIDING-SIZE
                               #:interval SLIDING-INTERVAL)
         (error "Rule: is not given correct number?"))])|#

(define (make-graph-from-rule
         alpha-nodes
         body
         
        interval 
         size )

  (let* (;take the first alpha-node
          (first-alpha-node (car alpha-nodes))
          ;gives back terminal node
          (terminal-node (make-terminal-node body))
          (time-manager (start-timer-manager)))
    (letrec ((time-function  (lambda ()
                               
                               (reset-logic-graph alpha-nodes)
                               (start-timer time-manager size time-function))))
    
      ;add first alpha-node to the root
      (add-rule-to-root! first-alpha-node)
      ;if there a no more event conditions
      (cond ((null? (cdr alpha-nodes))
             ;then set the successor of the alphanode to the terminal node
             (add-successor-to-node! first-alpha-node terminal-node))
            (else
             ;else convert the other alpha-lists to alpha-nodes and join-nodes
             (let ((last-join-node (combine-to-join-nodes first-alpha-node (cdr alpha-nodes) interval)))
               ;set the last join-node to the terminal-node
               (add-successor-to-node! last-join-node terminal-node))))
      (start-timer time-manager size time-function))))
  



;;
;;MAKE TERMINAL-NODES
;;

(define (make-terminal-node todo)
  (match todo
    [`(,op (fact: ,name ,args ...))
     (let ((compiled-args (map (lambda (arg)
                                 (compile arg #f))
                                 args)))
       (if (symbol? name)
           (match op
             ['add:
              (emit-t-node name compiled-args)]
             ['remove:
              (retract-t-node name compiled-args)]
             [ _ (error (format "~a operator is not allowed then:-part of rule" op))])
           (error (format "~a is not a symbol" name))))]
    ['nothing 
     empty-node]
    [_ (error (format "~a is not a valide expression for the then:-part of a rule" todo))])) 
     



(define nothing empty-t-node)


;
;MAKE JOIN NODES
;





;makes the joins nodes and other alpha-nodes and link them together

(define (combine-to-join-nodes left-node alpha-nodes interval)
  (define (combine-loop left-node alpha-nodes)
    (let* ((first-alpha-node (car alpha-nodes))
           
           (new-join-node  ;make join-node
            (make-join-node
             left-node
             ;the new alpha-nodes is the right node
             first-alpha-node
             (alpha-node-conditions first-alpha-node)
             interval)))
      (set-alpha-node-conditions! first-alpha-node null)
      
      ;add new alpha to the root
      (add-rule-to-root! first-alpha-node)
      ;set the successor right
      (add-successor-to-node! first-alpha-node new-join-node)
      (add-successor-to-node! left-node new-join-node)
    ;end step
      (if (null? (cdr alpha-nodes))
          new-join-node
          (combine-loop new-join-node (cdr alpha-nodes) ))))
  (combine-loop left-node alpha-nodes))



;
;HULP
;

(define (update-pms-and-propagate old-token new-pm-env node new-time)
  (let* (
         (beta-token (if (add-token? old-token)
                         (make-beta-token-add (make-pm new-pm-env new-time) node)
                         (make-beta-token-remove (make-pm new-pm-env new-time) node))))
  
    (if (add-token? old-token)
        (add-partial-match! (make-pm new-pm-env new-time) (filter-node-partial-matches node) )         
        (remove-partial-matches! beta-token (filter-node-partial-matches node)))
    (for-each (lambda (successor)
                (propagate-to successor beta-token))
              (filter-node-successors node))))











       
;
;PROCESS-JOIN-NODE
;


(define (combine-times time1 time2)
  (cond ((and (number? time1)
              (number? time2))
         (min time1 time2))
        (else
         #f)))

;token comes from right
(define (execute-join-node token partial-matches join-node)
  
  (let ((conditions (join-node-conditions join-node))
        (token-pm  (beta-token-pm token))
        (token-time (get-time token )))
    
    (for-all-partial-matches
     (lambda (store-pm)
       
       (let ((combined-pm-env (combine-env-or-false (pm-env token-pm) (pm-env store-pm)))
             (combined-time  (combine-times token-time (pm-time store-pm))))
         (when combined-pm-env
           (when 
               (for/and ([condition conditions])
                 
                 (execute condition  condition-global-env   combined-pm-env))
           ;  (display "propagate")
             (update-pms-and-propagate token combined-pm-env join-node combined-time)))))
     
     partial-matches)))


      



              
(define (propagate-to node token)
  (match node
    [(alpha-node partial-matches successors _  event-id formal-args conditions )
     (printf (format "Alpha-node \n" ))
     
     (when (equal? (alpha-token-id token) event-id)
       
       (let ((event-env (unify-args (alpha-token-args token) formal-args empty-pm-env)))
        
         (when event-env
           
           (when (for/and ([condition conditions])
                   (execute condition  condition-global-env event-env))
           
               (update-pms-and-propagate token event-env node (get-time token))))))]
               
    [(join-node _ _ _ left-predecessor  right-predecessor conditions)
     (printf (format "Join-node \n"))
     (if (eq? (beta-token-owner token) left-predecessor)
         (execute-join-node token (filter-node-partial-matches right-predecessor) node)
         (execute-join-node token (filter-node-partial-matches left-predecessor) node))]


    [(emit-t-node name exprs)
     (printf (format "Emit node \n"))
     (execute-terminal-node exprs name token #t)
     ]
    [(retract-t-node name exprs)
     (printf (format "retract node \n"))
     
     (execute-terminal-node exprs name token #f)]
    [(empty-t-node)
     (display "END")]
    [(func:start-if-node _ _)
     (execute-function-node node token)]
    ))

(define (get-args node)
  (cond ((alpha-node? node)
         (alpha-node-args node))
        (else
         (append (get-args (join-node-left-activation node))
                 (get-args (join-node-right-activation node))))))

;in case of add fact then it does the then-branch
(define (execute-function-node node token)
  (let* ((order-args (get-args (beta-token-owner token)))
         (pm-env (pm-env (beta-token-pm token)))
         (ordered-args (map (lambda (variable)
                              (lookup-pm-var pm-env variable))
                            order-args)))
    (func:set-start-if-node-values! node ordered-args)
    ;in case of add fact then it does remove
    (func:propagate-event (func:start-if-node-order node) 1 node 'undefined)
    ))
            
(define (execute-terminal-node exprs name token purpose)
  (when (add-token? token)
    (display "add?")
    (let* ((args (map (lambda (expr)
                        (execute expr
                                 body-global-env
                                 (pm-env (beta-token-pm token))
                                 ))
                      exprs))
           (token (if purpose
                      (make-alpha-token-add  name args)
                      (make-alpha-token-remove name args))))
      
      (make-propagate-function token))))
  




;
;add-fact
;

(define (propagate-alpha-node token )
  
  (get-lock-logic-graph)
  (make-propagate-function token)
  (release-lock-logic-graph))
;propagates an event with name NAME and args -values trough the DAG
(define-macro (add: FACT)
  #'(if (token? FACT)
        (propagate-alpha-node
         (make-alpha-token-add
          (token-id FACT)
          (token-args FACT)))
        (error (format "~a is not a fact" FACT))))
(define-macro (remove: FACT)
  #'(if (token? FACT)
        (propagate-alpha-node
         (make-alpha-token-remove
          (token-id FACT)
          (token-args FACT)))
        (error (format "~a is not a fact" FACT))))

(define-macro (fact: NAME ARGS ...)
  #'(token 'NAME '(ARGS ...)))
     

(define (make-propagate-function token)
    (for-each (lambda (node)
                (propagate-to node token))
              root))

;;
;;LOCKING SYSTEM FOR THREADS USED IN WINDOW
;;
(define lock-logic-graph (make-semaphore 1))
(define (get-lock-logic-graph)
  (semaphore-wait lock-logic-graph))
(define (release-lock-logic-graph)
  (semaphore-post lock-logic-graph))


;;
;;RESET NODES
;;
  
(define (reset-logic-graph alpha-nodes)
  (define (reset-node node)
    (when (filter-node? node)
      ;for each successor do reset
      (for-each
       (lambda (successor-node)
         (match successor-node
           ;for each successor do reset except for if-node
           ;if-node needs to check if the window is empty
           ;EMPTY => activate else-branch
           [(func:start-if-node values order)
            (when (empty? (filter-node-partial-matches node))
              (func:set-start-if-node-values! successor-node '())
              (func:propagate-event (func:start-if-node-order successor-node) 3 node 'undefined))]
           [_ (reset-node successor-node)]))
       (filter-node-successors node))
       (reset-window! (filter-node-partial-matches node) (filter-node-interval node))))
  (get-lock-logic-graph)     
  (for-each 
   reset-node
   alpha-nodes)
  (semaphore-post lock-logic-graph))
#|(define (reset-logic-graph)
  (define (reset-node node)
    (when (filter-node? node)
      ;for each successor do reset
      (for-each
       (lambda (successor-node)
         (match successor-node
           ;for each successor do reset except for if-node
           ;if-node needs to check if the window is empty
           ;EMPTY => activate else-branch
           [(func:start-if-node values order)
            (when (empty? (filter-node-partial-matches node))
              (func:set-start-if-node-values! successor-node '())
              (func:propagate-event (func:start-if-node-order successor-node) 3 node 'undefined))]
           [_ (reset-node successor-node)]))
       (filter-node-successors node))
       (reset-window! (filter-node-partial-matches node) (filter-node-interval node))))
  (get-lock-logic-graph)     
  (for-each 
   reset-node
   root)
  (semaphore-post lock-logic-graph))|#
#|
(thread
 (lambda ()
   (define (window-timing-loop)
     (display "timer started")
     (reset-logic-graph)
     (display "reset")
     (sleep 60)
     (window-timing-loop)) 
   (window-timing-loop)))|#





#|(rule: problem where:
          (event-condition error-overheating () )
          (event-condition error-cooling (?cooling-liquid) (< ?cooling-liquid 0.10))
      
         then: (add: (fact: Problem-overheating  ?cooling-liquid)))

(rule: problem2 where:
          (event-condition error-overheating2 () )
          
          then: (add: (fact: problem-overheating  ))
          window: 30
          sliding: 20)|#
;(rule: 2 where:
 ;;         (event-condition error-overheating (?temp) (> ?temp 76))
  ;        (event-condition error-cooling (?cooling-liquid) (< ?cooling-liquid 0.10))
      
  ;       then: nothing)
;(rule: 2 where:
 ;         (event-condition error-overheating (?temp) (> ?temp 76))
  ;        (event-condition error-cooling (?cooling-liquid) (< ?cooling-liquid 0.10))
   ;   
    ;     then: (remove: (fact: error-overheating ?temp)))










        



