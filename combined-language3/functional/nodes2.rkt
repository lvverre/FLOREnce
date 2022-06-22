#lang racket
(provide (all-defined-out))



(struct node ())
(struct dependency-node node (idx)  #:mutable)
(struct hulp-node node ())

;;EVENT

(struct root-node dependency-node ()  #:mutable)





;FUNCTION

(struct internal-node dependency-node ( predecessors) #:mutable)

;;FUNCTION WITH 1 ARGUMENT
(struct single-function-node internal-node (body event-var) #:mutable #:transparent)
(define (make-single-function-node predecessor body var)
  (single-function-node  -2 (list predecessor) body var))





;OR-node

(struct or-node internal-node () )

;FILTER-NODE

(struct filter-node internal-node ( body event-var) #:mutable )

  


;;MAKE-JUMP-NODE
(struct start-jump-node hulp-node ( condition jump) #:mutable #:transparent)


(struct end-jump-node hulp-node ( direction idx) #:mutable #:transparent)
(define (make-end-jump-node direction idx)
  (end-jump-node  direction idx))