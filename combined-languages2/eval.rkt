#lang racket
(require "functional/environment.rkt"
         "parse-values.rkt"
         "functional/datastructures.rkt"
         "functional/reactor.rkt"
         "functional/deployment.rkt"
         "root-env.rkt")
(provide (all-defined-out))
(define (eval local-env global-env  exprs root-env)
  (define (already-defined? var)
    (env-contains? var local-env))
  (define (loop expr)
    (displayln expr)
    (match expr
      [(def var right-expr)
       (cond ((already-defined? (var-exp-val var))
              (error (format "Variable already defined ~a" (var-exp-val var))))
             (else 
              (let ((val-right-expr (loop right-expr)))
                (add-to-env! (var-exp-val var) val-right-expr local-env))))]
       [(set var val)
       (let ((eval-var (loop var))
             (eval-val (loop val)))
         (display (format "EVALVAL: ~a" eval-val))
         (if (and (not (reactor? eval-var))
                  (not (deployedR? eval-var))
                  (not (view? eval-var))
                  (not (event-node? eval-var)))
             (add-to-env! var eval-val (root-env-env root-env))
             (error "Cannot reassign reactor, deloyed-reactor or event-node")))]
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
       #:when (equal? var 'true)
       true]
      [(var-exp var)
       #:when (equal? var 'false)
       false]
     
      [(var-exp val)
       (displayln val)
       (displayln expr)
       (let ((try-local (lookup-var-false val local-env)))
         (if try-local
             try-local
             (let ((try-global (lookup-var-false val global-env)))
               (if try-global
                   try-global
                   (error (format "~a is not defined" val))))))]
      [_ expr]))
  (map loop exprs))