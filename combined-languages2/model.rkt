#lang racket
(require "defmac.rkt")

(require "functional/environment.rkt")
#|
(struct undefined-expr ())
(define undefined (undefined-expr)) 

(define (add-undefined-variable-to-env! var env)
  (cond ((env-contains? var env)
         (error (format "Model cannot have a variable defined twice ~a" var)))
        (else (add-to-env! var undefined))))

(defmac (model: global-variables ...)
  #:keywords env
  (for-each |#