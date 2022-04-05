

#lang s-exp syntax/module-reader
"test6.rkt"

(require "defmac.rkt")
(require syntax/strip-context)


 
(provide (rename-out [literal-read read]
                     [literal-read-syntax read-syntax]
                    )
         )
         
 
(define (literal-read in)
  (syntax->datum
   (literal-read-syntax #f in)))

(defmac (k ll)
  #:keywords
  (display ll))

(define (vl x)
  (display x))

#|(define-syntax rotate
  (syntax-rules ()
    [(rotate a b) (+ a b)]
    [(rotate a b c) (begin
                     (+ a b)
                     (+ b c))]))|#

(define (get-info in mod line col pos)
    (lambda (key default)
      (case key
        [(color-lexer)
         (dynamic-require 'syntax-color/default-lexer
                          'default-lexer)]
        [else default])))

(define (literal-read-syntax src in)
  (with-syntax ([str (read in)])
    (strip-context
     #'(module anything racket
         
        ; (require vl)
         str
          ))))
