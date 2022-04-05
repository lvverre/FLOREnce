#lang racket
(require "defmac.rkt")
;(provide (all-defined-out))
(define (read-syntax path port)
  (define string-tree  (read port))
;  (display string-tree)
;  (define parse-tree (quote string-tree))
  ;(display string-tree)
  ;(define parse-tree 'string-tree)
  (define module-datum `(module functionalRE4-mod "test500.rkt"
                          
                         ,string-tree))
;  (display module-datum)
  (datum->syntax #f module-datum))
(provide read-syntax)
 (defmac (ll jkl)
   #:keywords ll
   #:captures tree
   
     (+ jkl tree))
(defmac (functionalRE4-module-begin parse-tree ...)
  #:keywords functionalRE4-module-begin
  #:captures tree m
 
  (#%module-begin
    
   (begin 
   (let ((tree 6))
     (define m (make-parameter 9))
     
     (parameterize ([m 10])
       parse-tree ...)))))

    

#|(define-macro (functionalRE4-module-begin PARSE-TREE ...)
  #'(#%module-begin
     (begin
       (define z (make-parameter 10))
       (parameterize ([z 11])
         PARSE-TREE ...))))|#

(define (z x)
  (+ 9 x))
(provide (rename-out [functionalRE4-module-begin #%module-begin]))
(provide (except-out (all-from-out  racket)
                     #%module-begin set!)
         z ll)
#|(define m (make-parameter #f))
     (parameterize ([m #f])
       (m))|#
