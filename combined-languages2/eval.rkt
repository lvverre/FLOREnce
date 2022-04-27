#lang racket
(require "functional/environment.rkt"
         "parse-values.rkt"
         "functional/datastructures.rkt"
         "functional/reactor.rkt"
         "functional/deployment.rkt"
         "root-env.rkt")
(provide (all-defined-out))
(define (eval env  exprs root-env)
  (define (loop expr)
  
    (match expr
      [(def var right-expr)
       (let ((val-right-expr (loop right-expr)))
         (add-to-env! var val-right-expr env))]
       [(set var val)
       (let ((eval-val (loop val)))
         (update-env! var eval-val env))
             ]
      [(app op args)
       (let ((val-op op)
             (val-args (map loop args)))
         (apply val-op (cons root-env val-args)))]
      [(pair first rest)
       (pair (loop first)
             (loop rest))]
      [(if-exp pred then-branch else-branch)
       (let ((result-pred (loop pred)))
         (if (eq? true result-pred)
             (loop then-branch)
             (loop else-branch)))]
      [(var-exp var)
      (lookup-var-error var env)]
      [_ expr]))
  (map loop exprs))