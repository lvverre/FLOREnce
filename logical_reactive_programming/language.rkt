#lang br/quicklang

(require "nodes.rkt" "token.rkt" "environment.rkt" (prefix-in e-env: "e-environment.rkt")(prefix-in queue: "queue.rkt"))

(define (read-syntax path port)
  (define parse-tree (port->lines port))
  (define module-datum `(module stacker-mod "language.rkt"
                          ,parse-tree))
  (datum->syntax #f module-datum))
(provide read-syntax)




(define-macro (stacker-module-begin PARSE-TREE )
  #'(#%module-begin
       PARSE-TREE ))
(provide (rename-out [stacker-module-begin #%module-begin]))


;(define-macro (rule: RULE-NAME where: CONDITIONS)
 ; )


(define-macro (:= VARIABLE-NAME EVENT-CONDITION)
  #'(make-alpha-node (quote VARIABLE-NAME)
                     @EVENT-CONDITION))

(define-macro (event-condition NAME (ARGS ...) CONDITIONS ...)
  #'(let* ((formal-args (list (quote ARGS) ...))
          (conditions (compile-conditions global-env-formal formal-args (list (quote CONDITIONS) ... ))))
      (list (quote NAME) formal-args conditions)))



(define (condition-variable? event-env variable)

  (and (symbol? variable)
       (get-condition-variable-idx  variable event-env)))
(define (body-variable? event-env variable)
  (display "check body")
  (and (symbol? variable)
       (get-body-variable-idx variable event-env)))

(define (prim-variable? global-env variable)
  (display "check prim")
  (and (symbol? variable)
       (get-prim-variable-idx  variable global-env)))

(define (event-variable? variable)
  (and (symbol? variable)
       (let ((variable-string (symbol->string variable)))
         (string-contains? variable-string ":"))))

(define (split-event-variable variable)
  (let ((variable-string (symbol->string variable)))
    (map (lambda (string)
           (string->symbol string))
         (if (string-contains? variable-string ":")
             (string-split variable-string ":")
             #f))))

(define (condition-event-variable? el env)
  #t)

(define (body-event-variable? variable env)
  (let ((string-variable (symbol->string variable)))
    (string-contains? string-variable ":")
         ))

(define (compile get-event-variable
                 ;get-event-variable-idx
                 event-variable?)
  (define (compile-loop global-env event-env expr)
    (cond ((or (number? expr) (string? expr))
           (lambda (global local)
             expr))
          ((prim-variable? global-env expr)
           (let ((idx (get-prim-variable-idx  expr global-env)))
             (lambda (global local)
               
               (get-prim-variable-at   global idx))))
          ((event-variable? event-env expr)
           ;(let ((idx (get-event-variable-idx  expr event-env)))
             (lambda (global local)
               (get-event-variable local expr)))
        
          
          
          ((pair? expr)
           (let ((op (compile-loop global-env event-env (car expr)))
               (args (map (lambda (exp)
                            (compile-loop  global-env event-env exp))
                          (cdr expr))))
             (lambda (global local)
               (apply (op global local)
                      (map (lambda (arg)
                             (arg global local))
                         args)))))))
  compile-loop)
;(define compile-condition (compile get-condition-variable-at get-condition-variable-idx condition-variable?))
;(define compile-body (compile get-body-variable-at get-body-variable-idx body-variable?))
(define compile-body (compile e-env:lookup-variable body-event-variable?))
(define compile-condition (compile e-env:lookup-e-variable condition-event-variable?))
  

(define (compile-conditions global-env event-env exps)
  (map (lambda (exp)
         (compile-condition global-env event-env exp))
       exps))




(define-macro (body EXPRS ...)
  #'(lambda (local-env)
      (let ((expressions (compile-body action-env-formal local-env (list (quote EXPRS) ... ))))
        (make-terminal-node expressions))))

(define (add-successor-to-node node new-successor)
  (set-filter-node-successors! node (cons new-successor (filter-node-successors))))
 ; (match node
  ;  [(alpha-node _ _ _ _ successors)
   ;  (set-alpha-node-successors! node (cons new-successor successors))]
    ;[(join-node _ _  _ successors)
    ; (set-join-node-successors! node (cons new-successor successors))]))

(define (convert-to-join-nodes alpha-nodes)
  (let ((event-env (make-vector (length alpha-nodes))))
    (vector-set! event-env 0 (alpha-node-args (car alpha-nodes)))
    (cons (let join-loop
            ((nodes alpha-nodes)
             (event-idx 1))
            (if (= (length nodes) 1)
                (car nodes)
                (let* ((first-node (car nodes))
                       (second-node (cadr nodes))
                       (new-join-node (make-join-node first-node second-node)))
            (vector-set! event-env event-idx (alpha-node-args second-node))
                  (add-successor-to-node first-node new-join-node)
                  (add-successor-to-node second-node new-join-node)
                  (join-loop (cons new-join-node (cddr nodes)) (+ event-idx 1)))))
          event-env)))



  

(define-macro (rule: NAME where: CONDITIONS ... then: BODY)
  #'(let* ((conditions-pairs (list CONDITIONS ...))
           (predecessor-terminal-and-local-body-env (convert-to-join-nodes (map cdr conditions-pairs))
           (terminal-node (BODY (cdr predecessor-terminal-and-local-body-env))))
      
      (for-each (lambda (alpha-node)
                  ;(add-successor! alpha-node terminal-node)
                  (add-rule-to-root! alpha-node))
                alpha-nodes)
      (add-successor-to-node (car predecessor-terminal-and-local-body-env) terminal-node)))

(struct alpha-token (name arguments) #:transparent)
(define number-of-arguments vector-length )
;(struct event (name args) #:transparent)
(struct partial-match (events) #:transparent)
(struct beta-token (events owner) #:transparent)

(define (propagate-from-join-node partial-matches token join-node)
  (let ((events (beta-token-events token))
        (successors (filter-node-successors join-node))) 
    (for-each (lambda (partial-match)
                (let* ((events-partial-match (beta-token-events partial-match))
                       (new-token (beta-token (append events events-partial-match) join-node)))
                  (for-each (lambda (successor)
                              (propagate-to successor new-token))
                            successors)))
              partial-matches)))
              
(define (propagate-to node token)
  (match node
    [(alpha-node partial-matches successors id args conditions )
     (when (and (equal? (alpha-token-name token) id)
                (number-of-arguments (alpha-token-arguments token))
                (for/and ([condition conditions])
                  (apply condition (list global-env-actual (alpha-token-arguments token)))))
       (display "alpha-node passed")
       (let ((beta-token (beta-token  (list token) node)))
         (for-each (lambda (successor)
                     (set-filter-node-partial-matches! node (cons token partial-matches))
                     (propagate-to successor beta-token))
                   successors)))]
    [(join-node _ _ left-predecessor  right-predecessor )
     (if (eq? (beta-token-owner token) left-predecessor)
         (propagate-from-join-node (filter-node-partial-matches right-predecessor))
         (propagate-from-join-node (filter-node-partial-matches left-predecessor)))]

    [(terminal-node actions)
     (display "terminal node")
     (for-each (lambda (action)
                 (action action-env-actual (beta-token-events token)))
               actions)]))
                   
     

(define-macro (add-fact NAME ARGS ...)
  #'(let ((token (alpha-token 'NAME (vector ARGS ...))))
      (for-each (lambda (node)
                  (propagate-to node token))
                root)))


(define-macro (:= NAME EVENT-CONDITION)
  #'(cons 'NAME EVENT-CONDITION))
  