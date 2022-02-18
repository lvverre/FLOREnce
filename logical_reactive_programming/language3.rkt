#lang br/quicklang


(require "compile.rkt" "nodes3.rkt" "token.rkt" "unification.rkt" "e-environment.rkt")

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

;:=
;assign an event condition to a variable
;that will be used in the body
;(define-macro (:= VARIABLE EVENT-CONDITION)
 ; #'(cons 'VARIABLE EVENT-CONDITION))




;set the arguments of the event-condition in a list

(define-macro (event-condition NAME (ARGS ...) CONDITIONS ...)
  #'(let* ((formal-args (list (quote ARGS) ...))
           (conditions (list (quote CONDITIONS) ...)))
      (make-alpha-node
       
      (quote NAME)
       formal-args
       (map (lambda (condition)
                    (compile condition #t))
            conditions))))
      
      





;MACRO to reform a rule in a rete network(DAG)

;TODO check the variabes in the event-conditions
(define-macro (rule: NAME where: CONDITIONS ... then: BODY)
  #'(let* ((alpha-nodes (list CONDITIONS ...))
           ;take the first alpha-node
           (first-alpha-node (car alpha-nodes))
           ;gives back terminal node
           (terminal-node BODY))
      ;add first alpha-node to the root
      (add-rule-to-root! first-alpha-node)
      ;if there a no more event conditions
      (cond ((null? (cdr alpha-nodes))
             ;then set the successor of the alphanode to the terminal node
             (add-successor-to-node! first-alpha-node terminal-node))
            (else
             ;else convert the other alpha-lists to alpha-nodes and join-nodes
             (let ((last-join-node (combine-to-join-nodes first-alpha-node (cdr alpha-nodes) )))
               ;set the last join-node to the terminal-node
               (add-successor-to-node! last-join-node terminal-node)))))
  )


;BODY
;


(define-macro (emit: NAME with: EXPRS ...)
  ;compile all expressions in the body
  ;#f is given because it is the body that is compiled
  #'(let ((expressions (map (lambda (expr)
                              (compile expr #f))
                            (list (quote EXPRS) ... ) )))
      (if (symbol? (quote NAME))
          (emit-t-node (quote NAME) expressions)
          (error (format "~a is not a symbol" (quote NAME))))))
(define-macro (retract: NAME with: EXPRS ...)
   #'(let ((expressions (map (lambda (expr)
                              (compile expr #f))
                            (list (quote EXPRS) ... ) )))
      (if (symbol? (quote NAME))
          (retract-t-node (quote NAME) expressions)
          (error (format "~a is not a symbol" (quote NAME))))))
(define nothing empty-t-node)


;
;MAKE JOIN NODES
;





;makes the joins nodes and other alpha-nodes and link them together

(define (combine-to-join-nodes left-node alpha-nodes)
  (let* ((first-alpha-node (car alpha-nodes))
         
         (new-join-node  ;make join-node
          (make-join-node
           left-node
           ;the new alpha-nodes is the right node
           first-alpha-node
           (alpha-node-conditions first-alpha-node))))
    (set-alpha-node-conditions! first-alpha-node null)
           
  ;add new alpha to the root
    (add-rule-to-root! first-alpha-node)
    ;set the successor right
    (add-successor-to-node! first-alpha-node new-join-node)
    (add-successor-to-node! left-node new-join-node)
    ;end step
    (if (null? (cdr alpha-nodes))
        new-join-node
        (combine-to-join-nodes new-join-node (cdr alpha-nodes) ))))



;
;HULP
;

(define (update-pms-and-propagate old-token new-pm-env node)
  (let ((beta-token (beta-token (token-add? old-token) (pm new-pm-env) node)))
  
    (if (token-add? old-token)
        (set-filter-node-partial-matches! node (cons (pm new-pm-env) (filter-node-partial-matches node)))
        (begin
          (set-filter-node-partial-matches!
         node
         (remove-partial-matches beta-token (filter-node-partial-matches node)))
          )) 
        
   
    (for-each (lambda (successor)
       
                (propagate-to successor beta-token))
              (filter-node-successors node))))







       
;
;PROCESS-JOIN-NODE
;



;token comes from right
(define (execute-join-node token partial-matches join-node)
  
  (let ((conditions (join-node-conditions join-node))
        (token-pm  (beta-token-pm token)))
    
    (for-each (lambda (store-pm)
               
                (let ((combined-pm-env (combine-env-or-false (pm-env token-pm) (pm-env store-pm))))
                  (when combined-pm-env
                    (when
                        (for/and ([condition conditions])
                          
                          (execute condition  condition-global-env   combined-pm-env))
                 
                    (update-pms-and-propagate token combined-pm-env join-node)))))
                    
              partial-matches)))


      



              
(define (propagate-to node token)
  (match node
    [(alpha-node partial-matches successors event-id formal-args conditions )
     (display (format "Alpha-node \n"))
     
     (when (equal? (alpha-token-id token) event-id)
       
       (let ((event-env (unify-args (alpha-token-args token) formal-args empty-pm-env)))
         (when event-env
           
           (when (for/and ([condition conditions])
                   (execute condition  condition-global-env event-env))
           
               (update-pms-and-propagate token event-env node)))))]
               
    [(join-node _ _ left-predecessor  right-predecessor conditions)
     (display (format "Join-node \n"))
     (if (eq? (beta-token-owner token) left-predecessor)
         (execute-join-node token (filter-node-partial-matches right-predecessor) node)
         (execute-join-node token (filter-node-partial-matches left-predecessor) node))]


    [(emit-t-node name exprs)
      (display (format "Emit node \n"))
     (execute-terminal-node exprs name token #t)]
    [(retract-t-node name exprs)
      (display (format "retract node \n"))
     (execute-terminal-node exprs name token #f)]
    [(empty-t-node)
     (display "END")]
    ))

(define (execute-terminal-node exprs name token purpose)
  (let* ((args (map (lambda (expr)
                      (execute expr
                               body-global-env
                               (pm-env (beta-token-pm token))
                               ))
                    exprs))
         (token (alpha-token purpose name args)))
    
    (make-propagate-function token)))
    




;
;add-fact
;

(define (propagate-alpha-node fact add?)
  (cond ((alpha-token? fact)
         (let ((fact fact))
           (set-token-add?! fact add?)
           (make-propagate-function fact)))
        (else (error (format "~a is not a fact" fact)))))
;propagates an event with name NAME and args -values trough the DAG
(define-macro (add: FACT)
  #'(propagate-alpha-node FACT #t))

(define-macro (remove: FACT)
  #'(propagate-alpha-node FACT #f))

(define-macro (fact: NAME ARGS ...)
  #'(alpha-token null 'NAME (list ARGS ...)))
     

      
(define (make-propagate-function token)
    (for-each (lambda (node)
                (propagate-to node token))
              root))



(rule: problem where:
          (event-condition error-overheating (?temp) (> ?temp 76))
          (event-condition error-cooling (?cooling-liquid) (< ?cooling-liquid 0.10))
      
         then: (emit: Problem-overheating with: ?temp ?cooling-liquid))










        



