#lang racket

(provide (all-defined-out))
;ROOT
(struct root (registered-nodes) #:mutable #:transparent)
(define (register-to-root! alpha-node root)
  (set-root-registered-nodes! root (cons alpha-node (root-registered-nodes root))))
(define (make-root)
  (root '()))
(define (for-all-in-root root function)
  (for-each function
            (root-registered-nodes root)))


;FILTER NODE
;(alpha-nodes, join-nodes)
(struct filter-node (partial-matches successor ) #:transparent #:mutable)

(define (register-successor! node new-successor)
  (set-filter-node-successor! node new-successor))

;ALPHA NODE
(struct alpha-node filter-node ( event-id args (constraints #:mutable) ) #:transparent)
(define (make-alpha-node name args conditions )
  (alpha-node '() -1 name args conditions))

;production NODE
(struct production-node (name args) #:transparent)
(struct emit-node production-node ( alive-time) #:transparent)
(struct retract-node production-node () #:transparent)





;JOIN-NODE
(struct join-node filter-node (left-activation  right-activation constraints ) #:transparent #:mutable)
(define (make-join-node left right condition )
  (join-node '() -1  left right condition ))

