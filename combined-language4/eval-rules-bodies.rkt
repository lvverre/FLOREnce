#lang racket

(require syntax/parse)
(require (for-syntax syntax/parse))
(require  "environment.rkt" )
(require "interpret-build.rkt")
(provide  (for-syntax body))
(provide  compile-constraint-rules compile-expression compile-expression-without-syntax compile-constraint-rules-without-syntax)

(provide compile-constraint-rules)
(define constraint-env (make-hash
                        (list (cons 'equal? equal?)
                              (cons '> >)
                              (cons '< <)
                              (cons '<= <=)
                              (cons '>= >=)
                              (cons 'not not)
                              )))
                                 
(define (compile-constraint-rules-without-syntax constraints)
  (define (compile-constraint-atoms atom)
    (match atom
      [`(sym ,val)
       #:when (symbol? val)
       (const-exp val)]
      [val
       #:when (or (string? val) (boolean? val) (number? val))
       (const-exp val)]
      [val
       #:when (symbol? val)
       (var-exp val)]))
    
  (define (compile-constraint constraint)
    (match constraint
      [`(or ,args ...)
       (let ([compiled-args (map compile-constraint args)])
       (or-exp compiled-args))]
      [`( and ,args ...)
        (let ([compiled-args (map compile-constraint args )])
       (and-exp compiled-args))]
      [`(,op ,args ...)
       (let ([val-op (lookup-local-var-error op  constraint-env)]
             [val-args (map compile-constraint-atoms args )])
         (app-exp val-op val-args))]
      ))
  (let ([val-constraints (map compile-constraint constraints)])
    (and-exp val-constraints)))
 
(define (compile-constraint-rules constraints)
  (define (compile-constraint-atoms atom)
    (syntax-parse atom
      [((~literal quote) val:id)
       #'(const-exp 'val)]
      [val:number
       #'(const-exp val)]
      [val:string
       #'(const-exp val)]
      [val:boolean
       #'(const-exp val)]
      [val:id
       #'(var-exp 'val)]))
    
  (define (compile-constraint constraint)
    (syntax-parse constraint
      [((~literal or) args ...)
       (with-syntax ([compiled-args (map compile-constraint (syntax->list #'(args ...)))])
       #'(or-exp compiled-args))]
      [((~literal and) args ...)
        (with-syntax ([compiled-args (map compile-constraint (syntax->list #'(args ...)))])
       #'(and-exp compiled-args))]
      [(op:id args ...)
       (with-syntax ([val-op (lookup-local-var-error (syntax-e #'op) constraint-env)]
                     [val-args (map compile-constraint-atoms (syntax->list #'(args ...)))])
         #'(app-exp val-op val-args))]
      ))
  (with-syntax ([val-constraints (map compile-constraint constraints)])
  #`(and-exp val-constraints)))


(begin-for-syntax 
  (define-syntax-class body
    (pattern ((~literal sym) val:id)
             #:attr value #'(const-exp 'val))
    (pattern val:number
             #:attr  value #'(const-exp val))
    (pattern val:string
             #:attr value #'(const-exp val))
    (pattern val:boolean
             #:attr value #'(const-exp val))
    
    (pattern val:id
             #:attr value #'(var-exp 'val))
    
            
    (pattern ((~literal iff) pred:body then:body else:body)
             #:attr value #'(if-exp pred.value then.value else.value))
    (pattern (op:id args:body ...)
             #:attr value
             #'(app-exp (var-exp 'op) (list args.value ...)))))
    

(define (compile-expression expression)
  (syntax-parse expression
    [ ((~literal sym) val:id)
      #'(const-exp 'val)]
    [ val:number
      #'(const-exp val)]
    [val:string
     #'(const-exp val)]
    [val:boolean
     #'(const-exp val)]
    
    
    [ ((~literal if) pred then else)
      (with-syntax ([pred-val (compile-expression #'pred)]
                    [then-val (compile-expression #'then)]
                    [else-val (compile-expression #'else)])
        #'(if-exp pred-val then-val else-val))]
    [ (op:id args ...)
      (with-syntax ([args-val (map compile-expression (syntax->list #'(args ...)))])
        #'(app-exp 'op args-val))]
    [ val:id
      #'(var-exp 'val)]))


(define (compile-expression-without-syntax expression)
  (match expression
    [ val
      #:when (or (number? val)(string? val) (boolean? val))
     (const-exp val)]
    [`(quote ,val)
     #:when (symbol? val)
     (const-exp val)]
    [ val
      #:when (symbol? val)
      (var-exp val)]
   
    [ `(if ,pred ,then ,else)
      (let ([pred-val (compile-expression-without-syntax pred)]
                    [then-val (compile-expression-without-syntax then)]
                    [else-val (compile-expression-without-syntax else)])
        (if-exp pred-val then-val else-val))]
    [ `(,op ,args ...)
      #:when (symbol? op)
      (let ([args-val (map compile-expression-without-syntax args)])
        (app-exp op args-val))]))
     

                   
(define-syntax (v stx)
  (syntax-parse stx
    [(_ l:body)
   ;  (with-syntax ([l (compile-expression #'body)])
       #'(display l.value)]))




         
             
       
                  
     
      