
#lang racket
(require syntax/strip-context)
 
(provide (rename-out [literal-read read]
                     [literal-read-syntax read-syntax])
         test)
 
(define (literal-read in)
  (syntax->datum
   (literal-read-syntax #f in)))


(define test 5)
(define (literal-read-syntax src in)
  (with-syntax ([str (read in)])
    (strip-context
     #'(module language90 "test90.rkt"
         (provide data)
         (define data 'str)))))


;(define-syntax language90-module-begin
;  (syntax-rules ()
;    (language90-module-begin program ...) #'(#%module-begin program ...)))
     
      
       

(provide (rename-out [language90-module-begin #%module-begin]))