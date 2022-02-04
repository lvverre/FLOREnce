#lang br/quicklang
(provide make-inbox take-message add-message empty?)
(struct inbox (messages first last) #:transparent #:mutable)
(define (make-inbox size)
  (inbox (make-vector size 0) 0 0))

(define message-at-index vector-ref)
(define set-message-at-index! vector-set! )
(define size-inbox vector-length)

(define (empty? inbox)
  (equal? (inbox-first inbox) (inbox-last inbox)))

(define (take-message inbox)
  (let ((message (message-at-index (inbox-messages inbox) (inbox-first inbox))))
    (set-inbox-first! inbox (modulo (+ (inbox-first inbox) 1) (size-inbox (inbox-messages inbox))))
    message))

(define (add-message inbox message)
  (set-message-at-index! (inbox-messages inbox) (inbox-last inbox) message)
  (set-inbox-last! inbox (modulo (+ (inbox-last inbox) 1) (size-inbox (inbox-messages inbox)) )))
