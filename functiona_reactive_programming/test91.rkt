
#lang racket
(require syntax/strip-context)
 
(provide (rename-out [literal-read read]
                     [literal-read-syntax read-syntax]))
 
(define (literal-read in)
  (syntax->datum
   (literal-read-syntax #f in)))
 
(define (literal-read-syntax src in)
  (with-syntax ([str (read in)])
    (strip-context
     #'(module anything racket
     
         (define-syntax ll
    (syntax-rules ()
      ((ll a ...)
       (printf "~a\n" (list a ...)))))
         (define l (make-parameter 10))
         (parameterize ([l 9])
           str
           )))))