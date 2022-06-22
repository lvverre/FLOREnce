#lang racket
(require "primitives..rkt")
(require  "environment.rkt" )
(require "interpret-build.rkt")
(require syntax/parse)
(provide compile compile-multiple-in-one eval-reactor-body eval-rule-body rule-env)



(define native-env (make-hash
                            (list (cons '+ prim-add)
                                  (cons '- prim-sub)
                                  (cons '* prim-mul)
                                  (cons '/ prim-div)
                                  (cons 'equal? prim-equal?)
                                  (cons '> prim-greater-then?)
                                  (cons '< prim-smaller-then?)
                                  (cons '<= prim-smaller-equal-then?)
                                  (cons '>= prim-greater-equal-then?)
                                  (cons 'not prim-not)
                                  (cons 'and prim-and)
                                  (cons 'true  #t)
                                  (cons 'false #f)
                                  (cons 'or prim-or))))



(define reactor-env (make-hash
                            (list (cons '+ prim-add)
                                  (cons '- prim-sub)
                                  (cons '* prim-mul)
                                  (cons '/ prim-div)
                                  (cons 'equal? prim-equal?)
                                  (cons '> prim-greater-then?)
                                  (cons '< prim-smaller-then?)
                                  (cons '<= prim-smaller-equal-then?)
                                  (cons '>= prim-greater-equal-then?)
                                  (cons 'not prim-not)
                                  (cons 'and prim-and)
                                  (cons 'true  #t)
                                  (cons 'false #f)
                                  (cons 'number->string prim-number->string)
                                  (cons 'string->number prim-string->number)
                                  (cons 'or prim-or))))

(define rule-env (make-hash
                            (list (cons '+ prim-add)
                                  (cons '- prim-sub)
                                  (cons '* prim-mul)
                                  (cons '/ prim-div)
                                  (cons 'equal? prim-equal?)
                                  (cons '> prim-greater-then?)
                                  (cons '< prim-smaller-then?)
                                  (cons '<= prim-smaller-equal-then?)
                                  (cons '>= prim-greater-equal-then?)
                                  (cons 'not prim-not)
                                  (cons 'and prim-and)
                                  (cons 'true  #t)
                                  (cons 'false #f)
                                   (cons 'number->string prim-number->string)
                                  (cons 'string->number prim-string->number)
                                  (cons 'or prim-or))))

(define (compile stx )
  (define (loop stx)
    (syntax-parse stx
      [((~literal if) pred then else)
       (if-exp (loop #'pred)
               (loop #'then)
               (loop #'else))]
      [(op:id args ...)
       (app-exp (var-exp (syntax-e #'op))
                (map loop (syntax->list #'(args ...))))]
      [var:id
    ;   (if (hash-has-key? model-env (syntax-e #'var))
     ;      (var-exp (hash-ref model-env (syntax-e #'var)))
           (var-exp (syntax-e #'var))
       ]
      [(list args ...)
       (map loop (syntax->list #'(args ...)) )]
      [val:number
       (syntax-e #'val)]
      [val:string
       (syntax-e #'val)]
      [(sym var:id)
       (syntax-e #'var)]))
  (loop stx))




(define (compile-multiple-in-one exprs )
  (let ((result (let loop
                  ((exprs exprs))
                  (cond ((null? exprs) true)
                        ((null? (cdr exprs))
                         (compile (car exprs) (make-hash)))
                        (else (app-exp prim-and
                                       (cons (compile (car exprs) )
                                             (loop (cdr exprs)))))))))
    result))


(define (eval expr env)
  (define (eval-loop expr)
    (match expr
      [(if-exp pred then else)
       (if (eval-loop pred)
           (eval-loop then)
           (eval-loop else))]
      [(app-exp op args)
       (let ((operator (eval-loop op))
             (arguments (map eval-loop args)))
         (apply operator arguments))]
      [(var-exp var)
       (lookup-var-error var env)]
      [(const-exp val) val]))

  (eval-loop expr))


(define (eval-reactor-body expr local-env)
  (eval expr (make-env local-env reactor-env)))

(define (eval-rule-body expr local-env)
  (eval expr (make-env local-env rule-env)))
            