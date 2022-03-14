#lang br/quicklang
(require
  (prefix-in logic: "../logical_reactive_programming/language3.rkt")
  (prefix-in logic: "../logical_reactive_programming/nodes3.rkt")
  (prefix-in logic: "../logical_reactive_programming/token.rkt")
  (prefix-in func: "../functiona_reactive_programming/functional_reactive_language_3.rkt"))
 
(define-macro (if: ALPHA-NODE then: THEN-EXPRS ... else: ELSE-EXPRS ...)
  #'(if (logic:alpha-node? ALPHA-NODE)
        (let (()))
        (error (format "Wrong argument, expected event-condition given ~a" ALPHA-NODE))))

(define-macro (compile '( EXPR ... ))
  #'(+ 1 z))
(define-macro (l EXPRS ...)
  #'(compile '( EXPRS ...)))

(define-macro (m e '(+ 1 2))
  #'(+ 1 e))
(define-macro (id V)
  #'(let* ((l (generate-temporaries #'(env)))
           (n (car l)))
      (lambda (n)
        (m n 'V))))

