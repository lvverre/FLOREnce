#lang racket

(provide (all-defined-out))




(define (local-env-contains? var env)
  (hash-has-key? env var))
(define (env-contains? var env)
  (let loop
    ((idx 0))
    (if (>= idx (vector-length env))
        #f
        
        (if (hash-has-key? (vector-ref env idx) var)
            #t
            (loop (+ idx 1))))))

 


(define make-env vector)
(define new-local-env make-hash)
(define variable-id 0)
(define (increase-id)
  (set! variable-id (+ variable-id 1)))

(define get-local-env vector-ref)

(define (add-to-env! var val env)
  (hash-set! (vector-ref env 0) var val ))

(define (add-to-local-env! var val env)
  (hash-set! env var val))

(define (update-local-env! var val env)
  (if (local-env-contains? var env)
      (hash-set! env var val)
      (error (format "Cannot update undefined variable ~a" var))))
(define (update-env! var val env)
  (let loop
    ((idx 0))
    (if (>= idx (vector-length env))
       (error (format "Cannot update undefined variable ~a" var))
        (let ((local-env (vector-ref env idx)))
          (if (hash-has-key? local-env var)
              (hash-set! local-env var val)
              (loop (+ idx 1)))))))
        


(define (lookup-var var env failure)
  (let loop
    ((idx 0))
    (if (>= idx (vector-length env))
        (failure)
        (let ((local-env (vector-ref env idx)))
          (if (hash-has-key? local-env var)
              (hash-ref local-env var)
              (loop (+ idx 1)))))))
     

(define (lookup-local-var-error var local-env) 
  (hash-ref local-env var (lambda ()(error (format "~a is not defined for this expression" var)))))
(define (lookup-var-false var env)
  (lookup-var var env (lambda () #f)))
(define (lookup-var-error var env)
  (display env)
  (display var)
  (lookup-var var env (lambda ()
                        
                        (error (format "~a is not defined for this expression" var)))))


(define global-env (new-local-env))