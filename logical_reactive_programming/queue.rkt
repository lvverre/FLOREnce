#lang br/quicklang
(provide make-queue enqueue! serve! empty?)
(struct queue (storage first last) #:transparent #:mutable)
(define (make-queue size)
  (queue (make-vector size 0) 0 0))

(define element-at-index vector-ref)
(define set-element-at-index! vector-set! )
(define size-queue vector-length)

(define (empty? queue)
  (equal? (queue-first queue) (queue-last queue)))

(define (serve! queue)
  (let ((element (element-at-index (queue-storage queue) (queue-first queue))))
    (set-queue-first! queue (modulo (+ (queue-first queue) 1) (size-queue (queue-storage queue))))
    element))

(define (enqueue! queue element)
  (set-element-at-index! (queue-storage queue) (queue-last queue) element)
  (set-queue-last! queue (modulo (+ (queue-last queue) 1) (size-queue (queue-storage queue)) )))