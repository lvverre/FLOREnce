#lang racket ; br/quicklang
(require "queue.rkt")
(provide enqueue-event! serve-event! mailbox?) 
 (define size-queue 15)

(struct mailbox (semaphore queue))
(define (make-mailbox)
  (mailbox (make-semaphore 1) (make-queue size-queue)))
(struct loop (thread mailbox))
(define (make-loop function)
  (loop (thread function) (make-mailbox)))

(define (enqueue-event! loop tag info)
  (let ((thd (loop-thread loop))
        (thd-queue-semaphore (loop-mailbox (loop-mailbox loop)))
        (thd-queue (mailbox-queue (loop-mailbox loop))))
    (semaphore-wait thd-queue-semaphore)
    (enqueue! thd-queue tag info)
    (semaphore-post thd-queue-semaphore)
    (thread-resume thd)))
  

(define (serve-event! mailbox)
  (let
      ((val '()))
   
    (if (empty? (mailbox-queue mailbox))
        (set! val #f)
        (set! val (serve! (mailbox-queue mailbox))))
    
    val))
    

