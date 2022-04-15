#lang racket

(require "defmac.rkt")
 
#|(defmac (pro el ...)
  #:keywords pro|#
#|(define-syntax (test stx)
  
    (syntax-case stx ()
      [(_ (name (args ...) constraints ...))
       (with-syntax  ([root (datum->syntax stx 'root stx)])
       #'(vector 'name  '(args ...) '( constraints ...)))]))|#
(defmac (pro (name (args ...) constraint))
    #:keywords pro
  #:captures root

     
       (vector 'name  '(args ...) constraint)) 

(defmac (pv c ...)
  (list (map pro #'(c ...))))
 
              
                      
