#lang br/quicklang
(require "../functional/environment.rkt")
(provide compile event-variable? compile-multiple-in-one compile-arguments)
(require "../parse-values.rkt")
(require "../primitives.rkt")
;COMPILE 


;EVENT-VARIABLES
;event-variables have the form  ?x and x can't contain : or ?

;check if a string is a event-variable
(define (event-variable-string? variable-string)
  ;check for ?
  (and (equal? (string-ref variable-string 0) #\?)
       ;there exist a x-part
       (> (string-length variable-string) 1)
       ))
;check if a symbol is an event-variable
(define (event-variable? variable)
  (let ((variable-string (symbol->string variable)))
    (event-variable-string? variable-string)))




;GLOBAL VARIABLE
;global variables are from the form x
;can't contain "?"

(define (global-variable? variable)
  (let ((variable-string (symbol->string variable)))
    (not (string-contains? (substring variable-string 0 1) "?"))))


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
                                  (cons 'or prim-or))))



(define (compile-arguments expr env) ; global-env condition-part)
  (match expr
    ;check if the expression is a number of string
    [arg
     #:when (number? expr)
     (nmb expr)]
    [arg
     #:when (string? expr)
     (str expr)]
    ;check if it is a function application
    [`(pair ,first ,rest)
     (pair (compile-arguments first )
           (compile-arguments rest ))]
    [`(sym ,val)
     #:when (symbol? val)
     (sym val)]
    [var
     #:when (symbol? var)
     (lookup-var-error var env)]
    [_ (error (format "fact: has not a good argument"))]))

(define (compile-multiple-in-one exprs condition-part)
  (let ((result (let loop
                  ((exprs exprs))
                  (cond ((null? exprs) true)
                        ((null? (cdr exprs))
                         (compile (car exprs) condition-part))
                        (else (app prim-and
                                   (cons (compile (car exprs) condition-part)
                           (loop (cdr exprs)))))))))
    (list result)))
;compile expr
;condition-part is a boolean that indicates if it compiles the condition-part
;or body-part of the rule (#t ->condition part / #f body part)
(define (compile expr condition-part )
  (define (compile-args expr condition-part) ; global-env condition-part)
    (match expr
      ;check if the expression is a number of string
      [arg
       #:when (number? expr)
       (nmb expr)]
      [arg
       #:when (string? expr)
       (str expr)]
      ;check if it is a function application
      [`(pair ,first ,rest)
       (pair (compile-args first condition-part)
             (compile-args rest condition-part))]
      [`(sym ,val)
       #:when (symbol? val)
       (sym val)]
      [_ (compile-app-val expr condition-part)]))

  (define (compile-app-val expr condition-part)
    (match expr
    [`(,op ,args ...)
     (let ((compiled-operator (lookup-var-error op native-reactor-env ))
           (compiled-args (map (lambda (oprnd)
                                 (compile-args oprnd condition-part))
                               args)))
       (app compiled-operator compiled-args))]
      
    ;check if event-variable
    [var
     #:when (symbol? var)
     (var-exp var)]
    [_  (error (format "wrong expression: ~a" expr))]))
  (compile-app-val expr condition-part))


#|

(define (execute expr global-env  event-env)
  (match expr
    [(const value) value]
    [(event-var var) (lookup-event-variable var event-env)]
    [(global-var var) (lookup-global-variable global-env var)]
    [(fun-apl operator operands)
    
     (let ((op (execute operator global-env event-env))
           (opnds (map (lambda (operand)
                         (execute operand global-env event-env))
                       operands)))
       (apply op opnds))]))


(define true (const #t))|#
