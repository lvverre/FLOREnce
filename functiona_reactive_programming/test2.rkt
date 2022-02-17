#lang reader "functional_reactive_language_3.rkt"


(define a (make-event))
(define b (make-event))

(define o1 (add-observer a (lambda (x) (display "Event a occurred"))))
(define c (event-map a (lambda (x) (+ x 1))))
(define o3 (event-or c b (lambda (x) (display "Event b or c occurred"))))
(define o2 (event-filter c (lambda (x) (> x 4)) (lambda (el) (display "Event c greater than 4 occurred"))))

(change-event a 6)




