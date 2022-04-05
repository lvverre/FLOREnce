
#lang br/quicklang
(require  "defmac.rkt")

(provide (all-defined-out))
(define (read-syntax path port)
  (define string-tree  (read port))
;  (display string-tree)
;  (define parse-tree (quote string-tree))
  ;(display string-tree)
  (define parse-tree (format-datums '~a string-tree))
  (define module-datum `(module functionalRE5-mod "test89.rkt"
                          
                          
                           ,@parse-tree))
;  (display module-datum)
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (functionalRE5-module-begin PARSE-TREE ...)
  #'(#%module-begin
     (program
      
         PARSE-TREE ...)))

(defmac (program exps ...)
  #:keywords program
  #:captures tree
  (let ((tree 5))
    (begin exps ...)))
(provide (rename-out [functionalRE5-module-begin #%module-begin]) program display)