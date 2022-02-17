#lang br/quicklang
(provide (all-defined-out))
;ROOT
(define root '())
(define (add-rule-to-root! alpha-node)
  (set! root (cons alpha-node root)))


;FILTER NODE
;(alpha-nodes, join-nodes)
(struct filter-node (partial-matches successors) #:transparent #:mutable)

(define (add-successor-to-node! node new-successor)
  (set-filter-node-successors! node (cons new-successor (filter-node-successors node))))

;ALPHA NODE
(struct alpha-node filter-node (variable event-id args conditions) #:transparent)

(define (make-alpha-node variable event-id args conditions)
  (alpha-node '() '() variable event-id args conditions))


;TERMINAL NODE
(struct terminal-node () #:transparent)
(struct empty-t-node terminal-node ())
(struct emit-t-node terminal-node (name args) #:transparent)
(struct retract-t-node terminal-node (name args) #:transparent)



;JOIN-NODE
(struct join-node filter-node (left-activation  right-activation conditions) #:transparent #:mutable)
(define (make-join-node left right condition)
  (join-node '() '() left right condition))

