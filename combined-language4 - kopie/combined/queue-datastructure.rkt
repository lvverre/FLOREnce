#lang racket
 (require data/heap)
(require "../logical/tokens.rkt")
(provide (all-defined-out))
(struct pn-pair (priority val) #:mutable #:transparent)
(struct vnt-pair (val node turn) #:transparent)

#|(define priority-queue (make-heap (lambda (pn-pair-1 pn-pair-2)
                                    (equal? (pn-pair-val pn-pair-1)
                                            (pn-pair-val pn-pair-2)))))|#

(define priority-queue '())

(define empty? null?)
(define (add! value)
  (set! priority-queue (cons value priority-queue)))

(define (remove-from-priority-queue! token-to-remove node)

  (let ((filtered-priority-queue (filter (lambda (item)
                                     ;      
                                           (let ((token (vnt-pair-val (pn-pair-val item))))
                                              
                                             (not
                                              (and
                                              
                                               (equal? (vnt-pair-node (pn-pair-val item))
                                                           node)
                                               (equal? (beta-token-owner token)
                                                               (beta-token-owner token-to-remove))
                                                  (equal? (beta-token-pm token)
                                                              (beta-token-pm token-to-remove))))))
                                         
                                         priority-queue)))
   
    (set! priority-queue filtered-priority-queue)))

(define current-priority 0)


(define (add-to-priority-queue! turn-number node value)
  (add! (pn-pair current-priority (vnt-pair value node (- turn-number 1))))
; (heap-add! priority-queue (pn-pair current-priority (vnt-pair value node (- turn-number 1))))
  (set! current-priority (+ current-priority 1)))

(define (serve-priority-queue!)
  (if (null? priority-queue)
      #f
       (let ((top (car priority-queue)))
        (set!  priority-queue (cdr priority-queue))
        top)))
  #|(if (= 0 (heap-count priority-queue))
      #f
      (let ((top (heap-min priority-queue)))
        (heap-remove-min! priority-queue)
        top)))|#


