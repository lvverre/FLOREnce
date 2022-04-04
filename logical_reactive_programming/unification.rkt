#lang br/quicklang
(require (only-in "e-environment.rkt" ext-pm-env))
(provide unify-args )




(define (walk var env)
  (cond
   ((symbol? var)
    (let ((var-val-pair (assoc var env)))
      (if var-val-pair
          (walk (cdr var-val-pair) env)
          var)))
   (else var)))




 

(define (unify var val env)
  ;lookup value of variable

  (let ((var-value (walk var env)))

    (cond
      ;variable has already been added
      ;and has same value
      ((eq? var-value val) env)
      ;symbol
      ;=> variable has not yet been added so add variable
      ;with correct value
      ((symbol? var-value)(ext-pm-env var-value val env))
      ;is a pair
      ;unify arguments
      ((and
        (pair? var-value)
        (pair? val))
       
       (let ((new-env (unify (car var-value) (car val) env)))
         
         (if new-env
             (unify (cdr var-value) (cdr val) new-env)
             #f)))
      ;one is a pair and the other isn't
      ;will be stopped here
      ((equal? var-value val) env)
      ;no unification
      (else #f))))


(define (unify-args args variables env)
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
          (unify (car to-do-variables) (car to-do-args) env)
          (cdr to-do-args)
          (cdr to-do-variables)))))
      #f))
         
        
  


           