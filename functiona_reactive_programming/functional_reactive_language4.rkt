#lang br/quicklang

(require "nodes.rkt")
(define (read-syntax path port)
  (define string-tree  (port->lines port))
;  (display string-tree)
;  (define parse-tree (quote string-tree))
  ;(display string-tree)
  (display string-tree)
  (define parse-tree (format-datums '~a string-tree))
  (display parse-tree)
  (define module-datum `(module functionalRE3-mod "functional_reactive_language4.rkt"
                          ,@parse-tree))
;  (display module-datum)
  (display module-datum)
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (functionalRE3-module-begin PARSE-TREE ...)
  #'(#%module-begin
     (begin 
        PARSE-TREE ...)))
(provide (rename-out [functionalRE3-module-begin #%module-begin]))


(define-macro (compile-graph EXPS ...)
  #'(list  EXPS ...))

(provide +)

