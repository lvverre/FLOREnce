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
       ;check for :
       (not (string-contains? variable-string ":"))
       ;check for ?
       (not (string-contains? (substring variable-string 1) "?"))))
;check if a symbol is an event-variable
(define (event-variable? variable)
  (let ((variable-string (symbol->string variable)))
    (event-variable-string? variable-string)))


;PARTIAL-EVENT-VARIABLES (pm-variable)
;variables have the form event:?x
;event refers to the event the variable belongs
;?x refers to one of the arguments of the event


;split a pm-variable symbol in two parts:
;1. the event part
;2. the variable part
(define (split-pm-variable variable)
  (let ((string-variables (split-pm-variable-string (symbol->string variable))))
    (map (lambda (string-variable)
           (string->symbol string-variable))
         string-variables)))

;split a pm-variable string in two parts:
;1. event part
;2. variable part
(define (split-pm-variable-string variable-string)
  (string-split variable-string ":"))

;checks if a symbol is a pm-variable
(define (pm-variable? variable)
  (let* ((variable-string (symbol->string variable))
         (variable-string-list (split-pm-variable-string variable-string)))    
    (and
     ;first part is not empty
     (not (equal? (string-ref variable-string 0) #\:))
     ;second part is not empty
     (not (equal? (string-ref variable-string
                              (- (string-length variable-string) 1))
                  #\:))
     ;there can be max 2 parts
     (= (length variable-string-list) 2)
     ;first part can't contain ?
     (not (string-contains? (car variable-string-list) "?"))
     
     ;is second part an event-variable
     (event-variable-string? (cadr variable-string-list)))))


;GLOBAL VARIABLE
;global variables are from the form x
;can't contain ":"
;can't contain "?"

(define (global-variable? variable)
  (let ((variable-string (symbol->string variable)))
    (and
     ;check for ":"
     (not (string-contains? variable-string ":"))
     ;check for "?"
     (not (string-contains? variable-string "?")))))


;COMPILE
(struct const (value) #:transparent)
(struct event-var (variable) #:transparent)
(struct pm-var (event variable) #:transparent)
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
     ;compile operator
     ;compile operands
     (let ((operator (compile (car expr ) condition-part)); global-env condition-part))
           (operands (map (lambda (operand)
                            (compile operand condition-part)); global-env condition-part))
                          (cdr expr))))
       
       (fun-apl operator operands)))
    ;check if event-variable
    ((event-variable? expr)
     ;check if it is in the body or condition part
     (if condition-part
         (event-var expr)
         (error (format "event-variable not allowed in body with event-part: ~a" expr)))) 
    ;check if pm-variable
    ((pm-variable? expr)
     (let ((event-variable-pair (split-pm-variable expr)))
       (pm-var (car event-variable-pair) (cadr event-variable-pair))))
    ;check if global variable
    ((global-variable? expr)
     (global-var expr))
    (else
     (error (format "wrong expression: ~a" expr)))))




(define (execute expr global-env pm-env event-env)
  (match expr
    [(const value) value]
    [(event-var var) (lookup-event-var event-env var)]
    [(pm-var event var) (lookup-event-var(lookup-pm-var pm-env event) var)]
    [(global-var var) (lookup-global-var global-env var)]
    [(fun-apl operator operands)
     (let ((op (execute operator global-env pm-env event-env))
           (opnds (map (lambda (operand)
                         (execute operand global-env pm-env event-env))
                       operands)))
       (apply op opnds))]))


(define true (const #t))
       
         




 
         
                      
                                  
                                  
         
    
        