#lang racket
(require "token.rkt")
(provide (all-defined-out))



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



(struct pm (env ) #:transparent)

(define get-var car)
(define get-val cdr)


;check if pm env correspond to other pm-env
(define (pm-contains-pm? pm-contained pm-contains)
  ;taken envs
     (newline)
  (display pm-contained)
  (newline)
  (display pm-contains)
  (newline)
     (let ((contained-pm-env (pm-env pm-contained))
           (contains-pm-env (pm-env pm-contains)))
       ;for every element in token env
       (let ((z (for/and ([var-val-pair contained-pm-env])
                 ;check if it corresponds to the value in the contains-pm
                  (and (occurs? (get-var var-val-pair) contains-pm-env)
                       (equal? (lookup-pm-var contains-pm-env (get-var var-val-pair))
                               (get-val var-val-pair))))))
         (display z)
         z)
       ))

;check if token env correspond to pm-env
(define (pm-contains-token? token partial-match)
  
  (pm-contains-pm? (beta-token-pm token) partial-match))
        

(define (remove-partial-matches token partial-matches)
  (filter
   (lambda (partial-match)
     (pm-contains-token? token partial-match))
   partial-matches))


(define (occurs? var env)
  (assoc var env))

(define empty-pm-env '())

(define (ext-pm-env var val env)
  (if (occurs? var env)
      #f
      (cons  (cons var val) env)))


(define (combine-env-or-false env-1 env-2)     
    (if (possible-to-combine? env-1 env-2)
        (combine-pm-env env-1 env-2)
        #f))

(define (possible-to-combine? env-1 env-2)
  (cond ((null? env-1)
         (append env-1 env-2))
        ((or (not (occurs?  (get-var (car env-1)) env-2))
             (equal? (lookup-pm-var env-2 (get-var (car env-1))) (get-val (car env-1))))
         (possible-to-combine? (cdr env-1) env-2 ))
        (else #f)))

(define (combine-pm-env env-1 env-2)
  (remove-duplicates (append env-1 env-2)))




(define (lookup-pm-var env var)
  (let ((val-env-pair (occurs? var env)))
    (if val-env-pair
        (cdr val-env-pair)
        (error (format "variable: ~a not found" var))))) 








;







        


         