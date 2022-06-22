#lang racket 
(require syntax/parse)
(require "environment.rkt"
         "functional/datastructures.rkt"
         "interpret-build.rkt")
(provide interpret-model parse-body)




                                       




(define (interpret-model stx)
  (syntax-parse stx  
    [(((~literal def:) var:id body:expr )...)
       (for-each (lambda (var body)             
                   (let ((val (model-var (syntax-e var) (parse-body body global-env))))
                     (add-to-local-env! (syntax-e var)
                                        val
                                        global-env)))
                 (syntax->list #'(var ...))
                 (syntax->list #'(body ...)))]))



  