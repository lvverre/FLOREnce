#lang racket
(provide (all-defined-out))

;
;EVENT-VARIABLES
;
(define (occurs? var val env)
  (assoc var env))

(define empty-event-env '())
(define (ext-event-env var val env)
  (if (occurs? val var env)
      #f
      (cons  (cons var val) env)))


(define (lookup-event-var env var)
  (let ((val-env-pair (assoc var env)))
    (if val-env-pair
        (cdr val-env-pair)
        (error (format "event-variable: ~a not found" var))))) 

;
;GLOBAL-VARIABLES
;
(define body-global-env (map (lambda (x)
                               x)
                             (list (cons '+ +) (cons '- -) (cons 'display display))))
(define condition-global-env (map (lambda (x)
                                    x)
                                  (list (cons '= =) (cons '>= >=) (cons '<= <=) (cons '> >) (cons '< <) (cons 'eq? eq?) (cons 'equal? equal?))))


(define (lookup-global-var env var)
  (let ((val-env-pair (assoc var env)))
    (if val-env-pair
        (cdr val-env-pair)
        (error (format "global-variable: ~a not found" var)))))

(define (ext-global-env env var val)
  (if (occurs? val var env)
      #f
      (cons  (cons var val) env)))

;
;PM-variables
;


(struct pm (event-var event-id env original) #:transparent)
(define (pm-equal? pm1 pm2)
  (and (equal? (pm-event-var pm1)
               (pm-event-var pm2))
       (equal? (pm-event-id pm1)
               (pm-event-id pm2))
       (equal? (pm-env pm1)
               (pm-env pm2))))


(define empty-pm-env '())

(define (lookup-pm-var env var)
  (cond ((eq? empty-pm-env env)
         (error (format "pm-variable: ~a not found" var)))
        ((equal? var (pm-event-var (car env)))
         (pm-env (car env)))
        (else
         (lookup-pm-var (cdr env) var))))
 ; (let ((val-env-pair (assoc var env)))
  ;  (if val-env-pair
   ;     (cdr val-env-pair)
    ;    (error (format "pm-variable: ~a not found" var)))))
;
;todo look at this
(define (ext-pm-env env val)
  (cons val env))
 ; (if (occurs? val var env)
  ;    #f
   ;   (cons  (cons var val) env)))





        


         