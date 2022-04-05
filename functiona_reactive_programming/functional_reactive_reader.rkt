#lang racket
(require "defmac.rkt")
(require "functional_reactive_language_3.rkt"  "nodes.rkt" )
;(provide (all-defined-out))
(define (read-syntax path port)
  (define string-tree  (read port))
;  (display string-tree)
;  (define parse-tree (quote string-tree))
  ;(display string-tree)
  ;(define parse-tree (format-datums '~a string-tree))
  (define module-datum `(module functionalRE4-mod "test500.rkt"
                          
                          ,string-tree))
;  (display module-datum)
  (datum->syntax #f module-datum))
(provide read-syntax)

(defmac (functionalRE4-module-begin parse-tree ...)
  #:keywords functionalRE4-module-begin
  #:captures function-thd inside-turn
  (#%module-begin
   (begin
    (display  (add-observer 4 5))
   (let ((reaction-loop-functional (make-loop))
         (inside-turn (make-parameter #f)))
       parse-tree ...))))


(define counter 0)


(struct node (test predecessors visited value)  #:mutable)

;;EVENT

(struct event-node node (order leafs n-successors)  #:mutable)

(define (make-event)
  (let ((new-event (event-node counter '() #f 'undefined '() '() 0)))
    (set-event-node-order! new-event (list new-event))
    new-event))

(provide (rename-out [functionalRE4-module-begin #%module-begin]))
(provide (except-out (all-from-out  racket)
                     #%module-begin set!)
   define + - display add-observer event-map event-filter make-event lambda)
;(provide  add-observer define  make-event lambda  display event-map event-filter >   newline)