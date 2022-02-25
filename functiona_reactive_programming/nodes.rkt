#lang br/quicklang
(provide (all-defined-out))

(define counter 0)


(struct node (predecessors successors visited value)  #:mutable)

;;EVENT
(struct event-node node (order test)  #:mutable)

(define (make-event)
  (display "Made event: ")
  (set! counter (+ counter 1))
  (display counter)
  (newline)
  (let ((new-event (event-node '() '() #f 'undefined '() counter)))
    (set-event-node-order! new-event (list new-event))
    new-event))


;FUNCTION

(struct function-node node (function test) )

(define (make-function-node predecessors function)
   (display "Made function node: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (function-node predecessors '() #f 'undefined  function counter))

;OR-node

(struct or-node node (test) )

(define (make-or-node left right)
  (display "Made or node: ")
  (set! counter (+ counter 1))
  (display counter)
  (newline)
  (or-node (list left right) '() #f 'undefined #f counter))

;FILTER-NODE

(struct filter-node node ( filter test) )

(define (make-filter-node predecessors filter )
   (display "Made filter event: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (filter-node predecessors '() #f 'undefined  filter counter))

(struct wrapper-or-node (node activation))

         
         




  
;;MAP EVENT
(define (make-map-event predecessors)
  (display "Made map event: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (let ((new-event (event-node predecessors '() #f 'undefined '() counter)))
    (set-event-node-order! new-event (list new-event))
    new-event))



