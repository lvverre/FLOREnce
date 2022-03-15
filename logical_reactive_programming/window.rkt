#lang br/quicklang
(provide (all-defined-out))
(require "e-environment.rkt" )

(struct window (tail head partial-matches interval start-time) #:mutable #:transparent)
(define (make-window size interval)
  (window 0 0 (make-vector size 0 ) interval (current-seconds)))



(define (for-all-partial-matches function window)
  (define end-idx (window-tail window))
  (define pms (window-partial-matches window))
  (define (loop idx)
    (when (< idx end-idx)
      (function (vector-ref pms idx))
      (loop (+ idx 1))))
  (loop 0))


(define size-of-window vector-length)

;;adds element to a window
(define (add-partial-match! pm window)
 
    (cond
      ;((<= (+ (window-start-time window) (window-interval window)) (current-seconds))
      ; (reset-window window)
      ; (vector-set! (window-partial-matches window) 0 pm)
      ; (set-window-tail! window 1))
      ;;window full
      ((full? window)
           ;;in case of no more place
       (remove-first-partial-match window)
       (add-to-window! pm window)
       
       ;give back #t when sucessors other also need to be updates
       #t)
      ; (set-window-tail! window 1))
       ;    (error-window-overflowing))
      ;;add element to window
      (else 
       (add-to-window! pm window)
       ;give back #f when sucessors does not need to be updates
       #f)))



(define (add-to-window! element window)
  (let ((idx (window-tail window))
        )
    (vector-set! (window-partial-matches window) idx element)
    (set-window-tail! window (get-next-place idx window))))

(define get-pm vector-ref)
(define set-pm! vector-set!)

(define (remove-from-window! function)
  (lambda (element window)
    (define tail-idx (window-tail window))
    (define pms (window-partial-matches window))
    (define (loop current-idx free-idx)
      (display current-idx)
      (display tail-idx)
      (display free-idx)
      (if (not(equal? current-idx tail-idx))
          (begin (display "hier")
          (cond ((function element (get-pm pms current-idx))
                 (display "skip")
                 (loop (get-next-place current-idx window) free-idx))
                (else (set-pm! pms free-idx (get-pm pms current-idx))
                      (loop
                       (get-next-place current-idx window)
                       (get-next-place free-idx window)))))
          (set-window-tail! window free-idx)))
    (loop (window-head window) (window-head window))))
      
   

;remove partial match
(define remove-partial-match! (remove-from-window! pm-contains-pm?))

;remove tokens
(define (remove-partial-matches! v l)
  (display "remove")
  ((remove-from-window! pm-contains-token?) v l))
  
   
   

(define (get-start-time-window current-start-time current-time interval)
  (if (and (< current-start-time current-time)
           (< current-time (+ current-start-time interval)))
      current-start-time
      (get-start-time-window
       (+ current-start-time interval)
       current-time
       interval)))

(define (full? window)
  (equal? (get-next-place (window-tail window) window)
          (window-head window)))

(define (empty? window)
  (equal? (window-tail window)
          (window-head window)))

(define (get-next-place place window)
  (modulo (+ place 1) (vector-length (window-partial-matches window))))
;;remove first element
(define (remove-first-partial-match window)
  (set-window-head! window (get-next-place (window-head window) window)))
  
   ; (set-window-start-time! window
   ;                         (get-start-time-window
   ;                          (window-start-time window)
   ;                          (current-seconds)
   ;                          (window-interval window)))
 ; ))

;;WINDOW OVERFLOW
(define window-overflow-handlers '())
;hulp function to add handler for overflowing window to list
(define (add-overflow-handler handler)
  (set!
     window-overflow-handlers 
     (cons
      handler
      window-overflow-handlers)))
;macro to add exprs as lambda to list of handlers
(define-macro (window-overflow-handler EXPRS ...)
  #'(add-overflow-handler (lambda () EXPRS ...)))
;executing handlers that are registered
(define (error-window-overflowing)
  (for-each
   (lambda (proc)
     (proc))
   window-overflow-handlers))




;;
;;TIME
;;

(define (minutes->seconds minutes)
  (* minutes 60))

(define (hours->minutes hour)
  (* hour 60))

(define (days->hours days)
  (* days 24))



(define-macro (seconds: SECONDS)
  #'(if (number? SECONDS)
        SECONDS
        (error "Seconds: need a number as argument")))

(define-macro (minutes: MINUTES)
  #'(if (number? MINUTES)
        (minutes->seconds MINUTES)
        (error "Minutes: need a number as argument")))

(define-macro (hours: HOURS)
  #'(if (number? HOURS)
        (minutes->seconds (hours->minutes HOURS))
        (error "hours: need a number as argument")))

(define-macro (day: DAYS)
  #'(if (number? DAYS)
        (minutes->seconds (hours->minutes (days->hours DAYS)))
        (error "Days: need a number as argument")))




(define l (make-window 3 2))
(add-partial-match! 3 l )
(add-partial-match! 4 l )
(add-partial-match! 5 l)
((remove-from-window! (lambda (el v) (eq? v el))) 4 l)

               