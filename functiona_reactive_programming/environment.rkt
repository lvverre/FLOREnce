#lang br/quicklang
(provide (all-defined-out))
;MAKE-EVENT
(struct event (observers) #:mutable)
(define (make-event)
  (event '()))

;:=
(define (:= var val env)
  (environment var val env))

;ADD-observer
(define (add-observer event new-function)
  (set-event-observers! event (cons new-function (event-observers event))))

(define (propagate-event event new-value)
  (for-each (lambda (observer)
              (observer new-value))
            (event-observers event)
           ))

(define (change-event event new-value)
  (propagate-event event new-value))

