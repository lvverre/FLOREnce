#lang br/quicklang
(provide (all-defined-out))

(define counter 0)


(struct node (test predecessors visited value)  #:mutable)

;;EVENT

(struct event-node node (order leafs n-successors)  #:mutable)

(define (make-event)
  (let ((new-event (event-node counter '() #f 'undefined '() '() 0)))
    (set-event-node-order! new-event (list new-event))
    new-event))
(define (graph-size event-or-if-node)
  (match event-or-if-node
    [(event-node _ _ _ _ order _ _)
     (vector-length order)]
    [(start-if-node _ order)
      (vector-length order)]
    [value (error "needs if-node or event-node for graph-size")]))

;FUNCTION

(struct function-node node (function ) #:transparent)

;;FUNCTION WITH 1 ARGUMENT
(struct single-function-node function-node ())
(define (make-single-function-node predecessors function )
  (single-function-node counter predecessors #f 'undefined  function ))

;;FUNCTION WITH MULTIPLE ARGUMENTS
(struct multi-function-node function-node ())
(define (make-multi-function-node predecessors function )
  (multi-function-node counter predecessors #f 'undefined  function ))



;OR-node

(struct or-node node () )

(define (make-or-node left right )
  (or-node counter (list left right) #f 'undefined ))

;FILTER-NODE

(struct filter-node node ( filter ) #:mutable )

(define (make-filter-node predecessors filter )
  (filter-node counter predecessors #f 'undefined  filter ))
  
;;MAP EVENT
(define (make-event-with-predecessor predecessors )
  (let ((new-event (event-node counter predecessors #f  'undefined '() '() 0)))
    (set-event-node-order! new-event (list new-event))
    new-event))

;;MAKE-JUMP-NODE
(struct start-jump-node (counter condition jump-to) #:mutable)
(define (make-start-jump-node condition jump-to )
  (start-jump-node counter condition jump-to))

(struct end-jump-node (counter direction idx) #:mutable)
(define (make-end-jump-node direction idx)
  (end-jump-node counter direction idx))


;;MAKE-IF-NODE

(struct start-if-node (values order) #:mutable #:transparent)
(define (make-start-if-node)
  (start-if-node '() '()  ))

(struct end-if-node (direction ) #:mutable #:transparent)
(define (make-end-if-node direction )
  (end-if-node direction ))

(define (end-if-then-node node)
  (car (node-predecessors node)))
(define (end-if-else-node node)
  (cadr (node-predecessors node)))

  



