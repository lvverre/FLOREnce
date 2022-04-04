#lang br/quicklang
(require "e-environment.rkt")
(provide compile execute true)

;COMPILE 


;EVENT-VARIABLES
;event-variables have the form  ?x and x can't contain : or ?

;check if a string is a event-variable
(define (event-variable-string? variable-string)
  ;check for ?
  (and (equal? (string-ref variable-string 0) #\?)
       ;there exist a x-part
       (> (string-length variable-string) 1)
       ;check for ?
       (not (string-contains? (substring variable-string 1) "?"))))
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


;COMPILE
(struct const (value) #:transparent)
(struct event-var (variable) #:transparent)
(struct global-var (variable) #:transparent)
(struct fun-apl (operator operands) #:transparent)

;compile expr
;condition-part is a boolean that indicates if it compiles the condition-part
;or body-part of the rule (#t ->condition part / #f body part)
(define (compile expr condition-part); global-env condition-part)
  (cond
    ;check if the expression is a number of string
    ((or (number? expr)
         (string? expr))
     (const expr))
    ;check if it is a function application
    ((pair? expr)
     (cond ((equal? 'quote (car expr))
            (const (cadr expr)))
           (else 
     ;compile operator
     ;compile operands
     (let ((operator (compile (car expr ) condition-part)); global-env condition-part))
           (operands (map (lambda (operand)
                            (compile operand condition-part)); global-env condition-part))
                          (cdr expr))))
       
       (fun-apl operator operands)))))
    ;check if event-variable
    ((event-variable? expr)
     (event-var expr))
       
    ;check if global variable
    ((global-variable? expr)
     (global-var expr))
    (else
    
     (error (format "wrong expression: ~a" expr)))))




(define (execute expr global-env  event-env)
  (match expr
    [(const value) value]
    [(event-var var) (lookup-pm-var event-env var)]
    [(global-var var) (lookup-global-var global-env var)]
    [(fun-apl operator operands)
    
     (let ((op (execute operator global-env event-env))
           (opnds (map (lambda (operand)
                         (execute operand global-env event-env))
                       operands)))
       (display expr)
       (display opnds)
       (apply op opnds))]))


(define true (const #t))
       
         




 
         
                      
                                  
                                  
         
    
        