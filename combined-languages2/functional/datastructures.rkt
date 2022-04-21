#lang racket
(provide (all-defined-out))
(struct deployedL (input-places  collector) #:mutable)


(define put-collection! vector-set!)
(define make-collection make-vector)
(define get-collection vector-ref)
(define size-collection vector-length)



(struct fact-collector (head tail storage fact-name ) #:mutable #:transparent)
(struct add-fact-collector fact-collector (time-interval) #:transparent)
(struct remove-fact-collector fact-collector ())




(struct logic-connector (logical-cmpts) #:mutable)
(struct deployedR logic-connector (ins dag outs) #:transparent)
(struct functional-event logic-connector (functional-cmpnts ) #:mutable #:transparent)
(struct functional-cmpnt (input-idxs deployedR) #:mutable #:transparent)