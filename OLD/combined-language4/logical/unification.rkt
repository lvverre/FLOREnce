#lang racket
(require (only-in "environment.rkt" extend-pm-env lookup-event-variable)
         ;(only-in "compiler.rkt" event-variable?)
         )
       ;  "../parse-values.rkt")
(provide unify-args )


;check if a string is a event-variable
(define (event-variable-string? variable-string)
  ;check for ?
  (and (equal? (string-ref variable-string 0) #\?)
       ;there exist a x-part
       (> (string-length variable-string) 1)
       ))
;check if a symbol is an event-variable
(define (event-variable? variable)
  (and (symbol? variable)
       (let ((variable-string (symbol->string variable)))
         (event-variable-string? variable-string))))

(define (walk var env)
  (cond
   ((event-variable? var)
    (let ((val (lookup-event-variable var env )))
      (if val
          (walk val env)
          var)))
   (else var)))




 

(define (unify var val env remove?)
  ;lookup value of variable
  (let ((var-value (walk var env)))
    (cond
      ;variable has already been added
      ;and has same value
     
      ( (equal? var-value val)
        (equal? var-value '?) env)
      ;symbol
      ((event-variable? var-value) (extend-pm-env var-value val env) env)
      ((and
        (equal? '? var-value)
        remove?)
       (extend-pm-env  var val env) env)
      ;=> variable has not yet been added so add variable
      ;with correct value
    ;  ((sym? var-value) (extend-pm-env var-value val env) )
      ;is a pair
      ;unify arguments
      ((and
        (pair? var-value)
        (pair? val))
       
       (let ((new-env (unify (car var-value) (car val) env remove?)))
         
         (if new-env
             (begin (unify (cdr var-value) (cdr val) new-env remove?) new-env )
             (begin (displayln (format "u ~a ~a" var val))#f))))
      ;one is a pair and the other isn't
      ;will be stopped here
   ;   ((equal? var-value val) env)
      ;no unification
      (else (displayln (format "u ~a ~a" var val))#f))))


(define (unify-args args variables env add?)
  ;check if there are the same number of variables as arguments
  (if (eq? (length args) (length variables))
      (let loop ((env env)
                 (to-do-args args)
                 (to-do-variables variables))
       (cond
         ;;environment cannot be unified
         ((not env)
          #f)
         ;;environment could be unified
         ((null? to-do-args)
          env)
         
        (else
         ;;still values left so unify  
         (loop
          (unify (car to-do-variables) (car to-do-args) env (not add?))
          (cdr to-do-args)
          (cdr to-do-variables)))))
      #f))
         





           
