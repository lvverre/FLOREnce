#lang racket 
(require syntax/parse)
(require "environment.rkt"
         "functional/datastructures.rkt"
         "interpret-build.rkt"
          "eval-rules-bodies.rkt")


(require (for-syntax syntax/parse))

(provide (for-syntax def-model))

(begin-for-syntax 
  (define-syntax-class def-model
    (pattern ((~literal def:) var:id val:body)
             #:attr variable #'var
             #:attr value #'val.value)))

                                       




#|(define (interpret-model stx)
  (syntax-parse stx  
    [(((~literal def:) var:id body:body )...)
       (for-each (lambda (var body)             
                   (let ((val (model-var (syntax-e var) (parse-body body global-env))))
                     (add-to-local-env! (syntax-e var)
                                        val
                                        global-env)))
                 (syntax->list #'(var ...))
                 (syntax->list #'(body ...)))]))|#



  