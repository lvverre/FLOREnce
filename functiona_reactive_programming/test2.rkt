#lang reader "functional_reactive_language_3.rkt"


(define a (make-event))
(define t (add-observer a (lambda (x) (display x))))
(change-event a 3)
(remove-observer a t)
(change-event a 4)



(define c (make-event))

(define v (event-and c (lambda (el) (> el 2)) (lambda (el) (display el))))

(change-event c 3)

(change-event c 1)



(define z (make-event))
(define y (make-event))
(define l (event-or z y (lambda (x) (display x))))
(change-event z 1)
(change-event y 2)

(define second (make-event))
(
