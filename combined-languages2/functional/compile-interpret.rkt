#lang racket

(require "environment.rkt")
(require "../primitives.rkt")
(require "../parse-values.rkt")
(provide (all-defined-out))

(define native-reactor-env (make-hash
                            (list (cons '+ prim-add)
                                  (cons '- prim-sub)
                                  (cons '* prim-mul)
                                  (cons '/ prim-div)
                                  (cons 'equal? prim-equal?)
                                  (cons '> prim-greater-then?)
                                  (cons '< prim-smaller-then?)
                                  (cons '<= prim-smaller-equal-then?)
                                  (cons '>= prim-greater-equal-then?)
                                  (cons '! prim-not)
                                  (cons 'and prim-and)
                                  (cons 'string-append prim-string-append)
                                  (cons 'or prim-or))))
 

(define (error-wrong-syntax place syntax)
  (error (format "~a is not allowed in ~a" syntax place)))

(define (compile-reactors exprs) 
  (define (compile-reactor-function-call op args)
      (displayln (format "op: ~a ~a" op args))
    (let ((compiled-op (if (symbol? op)
                         (lookup-local-var-error op native-reactor-env)
                         (error-wrong-syntax "operator function call" op)))
          (compiled-args (map compile-reactors-argument args)))
      (app compiled-op compiled-args)))
  (define (compile-reactors-argument arg )
      (displayln (format "argument: ~a" arg))
    (match arg
      [`(sym arg)
       (when (not (symbol? arg))
         (error-wrong-syntax "Inside sym" arg))
       (sym arg)]
      [arg
       #:when (number? arg)
       (nmb arg)]
      [arg
       #:when (string? arg)
       (str arg)]
      [`(pair ,first ,rest)
       (pair (compile-reactors-argument first )
             (compile-reactors-argument rest ))]
      [arg
       #:when (symbol? arg)
       (var-exp arg)]
      [`(if ,pred ,then-branch ,else-branch)
       (if-exp (compile-reactors-argument pred)
               (compile-reactors-argument then-branch)
               (compile-reactors-argument else-branch))]
      [`(,op ,args ...)
       (compile-reactor-function-call op args)]
      
      [_ (error-wrong-syntax "argument inside functional call" arg)]))


 
       
  (define (compile-reactor-body-expr expr)
    (displayln (format "Body: ~a" expr))
    (match expr
      [`(def: ,def-var ,expr)
       (let ((compiled-var (if (symbol? def-var)
                               (var-exp def-var)
                               (error-wrong-syntax  "first argument in def:" def-var)))
             (compiled-expr (compile-reactors-argument expr)))
         (def compiled-var compiled-expr))
         ]
      
      
      [_ (compile-reactors-argument expr)]))
  (displayln exprs)
  (compile-reactor-body-expr exprs))

  



