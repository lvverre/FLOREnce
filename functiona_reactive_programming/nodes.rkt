#lang br/quicklang
(provide (all-defined-out))

(define counter 0)


(struct node (test predecessors visited value)  #:mutable)

;;EVENT
(struct event-node node (order)  #:mutable)

(define (make-event)
  (display "Made event: ")
  (set! counter (+ counter 1))
  (display counter)
  (newline)
  (let ((new-event (event-node counter '() #f 'undefined '() )))
    (set-event-node-order! new-event (list new-event))
    new-event))


;FUNCTION

(struct function-node node (function) )

(define (make-function-node predecessors function)
   (display "Made function node: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (function-node counter predecessors  #f 'undefined  function ))

;OR-node

(struct or-node node () )

(define (make-or-node left right)
  (display "Made or node: ")
  (set! counter (+ counter 1))
  (display counter)
  (newline)
  (or-node counter (list left right) #f 'undefined  ))

;FILTER-NODE

(struct filter-node node ( filter ) )

(define (make-filter-node predecessors filter )
   (display "Made filter event: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (filter-node counter predecessors  #f 'undefined  filter ))



         
         




  
;;MAP EVENT
(define (make-map-event predecessors)
  (display "Made map event: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (let ((new-event (event-node counter predecessors  #f 'undefined '() )))
    (set-event-node-order! new-event (list new-event))
    new-event))


;;JUMP node
(struct jump-node node (to-node condition))
(define (make-jump-node to-node condition)
  (jump-node 



