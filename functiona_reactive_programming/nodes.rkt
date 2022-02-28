#lang br/quicklang
(provide (all-defined-out))

(define counter 0)


(struct node (test predecessors visited value)  #:mutable)

;;EVENT
(struct event-node node (order leafs n-successors)  #:mutable)

(define (make-event)
  (display "Made event: ")
  (set! counter (+ counter 1))
  (display counter)
  (newline)
  (let ((new-event (event-node counter '() #f 'undefined '() '() 0)))
    (set-event-node-order! new-event (list new-event))
    new-event))


;FUNCTION

(struct function-node node (function ) )

(define (make-function-node predecessors function )
   (display "Made function node: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (function-node counter predecessors #f 'undefined  function ))

;OR-node

(struct or-node node () )

(define (make-or-node left right )
  (display "Made or node: ")
  (set! counter (+ counter 1))
  (display counter)
  (newline)
  (or-node counter (list left right) #f 'undefined ))

;FILTER-NODE

(struct filter-node node ( filter ) #:mutable )

(define (make-filter-node predecessors filter )
   (display "Made filter event: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (filter-node counter predecessors #f 'undefined  filter ))
  
;;MAP EVENT
(define (make-event-with-predecessor predecessors )
  (display "Made map event: ")

    (set! counter (+ counter 1))
    (display counter)
  (newline)
  (let ((new-event (event-node counter predecessors #f  'undefined '() '() 0)))
    (set-event-node-order! new-event (list new-event))
    new-event))

;;MAKE-JUMP-NODE
(struct start-jump-node (counter condition jump-to) #:mutable)
(define (make-start-jump-node condition jump-to )
  (set! counter (+ counter 1))

  (start-jump-node counter condition jump-to))

(struct end-jump-node (counter direction))
(define (make-end-jump-node direction)
  (set! counter (+ counter 1))

  (end-jump-node counter direction))
  



