#lang racket
(require syntax/parse)
(provide interpret-functional-part)
(require "../environment.rkt")
(define (interpret-functional-part stx env)
  (syntax-parse stx
    [((~literal if) pred then else)
     (let ((val-pred (interpret-functional-part (syntax-e #'pred) env)))
       (if val-pred
           (interpret-functional-part (syntax-e #'then) env)
           (interpret-functional-part (syntax-e #'else) env)))]
     [((~literal sym) val:id)
     (syntax-e #'val)]
    [(op:id args ...)
     (let ((val-op (lookup-var-error (syntax-e #'op) env))
           (val-args (map (lambda (arg) (interpret-functional-part arg env))  (syntax->list #'(args ...)))))
       (apply val-op val-args))]
    [val:number
     (syntax-e #'val)]
    [val:string
     (syntax-e #'val)]
     [val:id
     (lookup-var-error (syntax-e #'val) env)]
    
    ))