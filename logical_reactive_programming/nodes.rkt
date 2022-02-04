#lang br/quicklang
(provide (all-defined-out))
;(provide terminal-node alpha-node alpha-node-args alpha-node-conditions make-alpha-node make-terminal-node add-successor! add-rule-to-root! root); send-to-successors!)
(require "inbox.rkt" (prefix-in queue: "queue.rkt"))
;ALPHA
(struct filter-node (partial-matches successors) #:transparent #:mutable)

 
(struct alpha-node filter-node (id args conditions  ) #:transparent #:mutable)
(define (make-alpha-node id args conditions)
  (alpha-node '() '() id args conditions  ))

;(define (add-successor! alpha-node successor-node)
 ; (set-alpha-node-successors! alpha-node (cons successor-node (alpha-node-successors alpha-node))))

;(define (process-alpha-node node queue)
 ; (let ((token (take-message (alpha-node-inbox node))))
  ;  (if ((alpha-node-conditions node) token)
   ;     (for-each (lambda (successor) 
    ;                (enqueue!  
     ;               (alpha-node-successors node)


;TERMINAL
(struct terminal-node ( actions) #:transparent)
(define (make-terminal-node actions)
  (terminal-node actions ))

;JOIN-NODE
(struct join-node filter-node (left-activation  right-activation) #:transparent #:mutable)
(define (make-join-node left right)
  (join-node '() '() left right ))



;ROOT
(define root '())
(define (add-rule-to-root! alpha-node)
  (set! root (cons alpha-node root)))

;(struct root (successors) #:mutable #:transparent)
;(define (make-root)
 ; (root '()))
;(define (add-rule-to-root! root successor-node)
 ; (set-root-successors! root (cons successor-node (root-successors root) )))

;(define (send-to-successors! queue root token)
 ; (for-each
  ; (lambda (successor)
   ;  (add-message (alpha-node-inbox successor) token)
    ; (enqueue! queue successor))
   ;(root-successors root)))
  