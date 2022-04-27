#lang racket
(provide (all-defined-out))
(define (new-env)
  (make-hash))

(define (env-contains? var env)
  (hash-has-key? env var))
(define (add-to-env! var val env)
  (hash-set! env var val))
      

(define (lookup-var-false var env)
  (if (hash-has-key? env var)
      (hash-ref env var)
      #f))

(define (lookup-var-error var env)
   (if (hash-has-key? env var)
       (hash-ref env var)
       (error (format "~a is not defined" var))))