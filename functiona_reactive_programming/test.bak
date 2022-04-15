#lang reader "functional_reactive_language_3.rkt"
(define e (make-event))
(define e2 (make-event))
(display (event-or e e2 (lambda (x) (display (+ x 1)))))
(change-event e2 3)
(change-event e 4)
(define l (make-event))
(define v (map (lambda (x) (display x)) l))
(add-observer v (lambda (x) (display 3)))
(define b (make-event))
(event-and b (lambda (x) (> x 0))(lambda (x) (display (+ x x))) )
(change-event b 0)
(change-event b 4)


               