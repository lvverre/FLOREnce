#lang racket
(provide (all-defined-out))
(require "logical_reactive_programming/e-environment.rkt"
         "logical_reactive_programming/variables.rkt")



(struct window (head tail size start-time) #:mutable #:transparent)



(define (make-window size)
  (window '() '() size (current-seconds)))


(define (empty? window)
  (null? (window-head window)))



(define (add-partial-match! pm window)
  (if (empty? window)
      (set-window-head! window pm)
      (set-pm-next! (window-tail window) pm))
    (set-window-tail! window pm)
    (set-window-size! window (- (window-size window) 1)))


(define (remove-partial-matches! token window)
  (define (loop pm)
    (when (not (null? pm))
      (when (pm-contains-token? token pm)
        (set-window-size! window (+ (window-size window) 1))
        (if (null? (pm-previous pm))
            (set-window-head! window (pm-next pm))
            (set-pm-next! (pm-previous pm)
                          (pm-next pm)))
        (if (null? (pm-next pm))
            (set-window-tail! window (pm-previous pm))
            (set-pm-previous! (pm-next pm)
                                   (pm-previous pm))))
      (loop (pm-next pm))))
  (loop (window-head window)))




(define (for-all-partial-matches function window)
  (define (loop pm)
    (when (not (null? pm))
      (function pm)
      (loop (pm-next pm))))
  (loop (window-head window)))


(define (reset-window! window interval)
  (let ((upperbound (+ (window-start-time window) interval)))
    (let loop
      ((pm (window-head window)))
      (cond ((null? pm)
             (set-window-head! window '())
             (set-window-tail! window '()))
            ((>= (pm-time pm) upperbound)
             (set-window-head! window pm)
             (set-pm-previous! pm '()))
            (else
             (loop (pm-next pm)))))
    (set-window-start-time! window upperbound)))


 #|(define m (make-window 4))
 (add-partial-match! (make-pm '((p 9)) (current-seconds)) m)
 (add-partial-match! (make-pm '((s 8)) (current-seconds)) m)
 (add-partial-match! (make-pm '((z 6)) (current-seconds)) m)
(sleep 11)
(add-partial-match! (make-pm '((v 3)) (current-seconds)) m)
(add-partial-match! (make-pm '((b 2)) (current-seconds)) m)
(reset-window! m)|#