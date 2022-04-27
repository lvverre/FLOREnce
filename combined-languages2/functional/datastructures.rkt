#lang racket
(provide (all-defined-out))



(define put-collection! vector-set!)
(define make-collection make-vector)
(define get-collection vector-ref)
(define size-collection vector-length)



(struct fact-collector (head tail storage fact-name ) #:mutable #:transparent)
(struct add-fact-collector fact-collector (time-interval) #:transparent)
(struct remove-fact-collector fact-collector ())




(struct functional-node (connectors) #:mutable)
(struct deployedR functional-node (ins dag outs) #:transparent)
(struct event-node functional-node () #:mutable #:transparent)
(struct functional-connector (input-info app-info) #:mutable #:transparent)
(struct internal-connector functional-connector ())
(struct func->func-connector internal-connector ())
(struct func->logic-connector internal-connector ())
(struct external-connector functional-connector ())

(struct view (input body output))
(struct update (input body))