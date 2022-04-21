#lang reader "language-plus-reader.rkt"





(rule: pl where:
       (burger (?customerId ?burgerType))
       (drink (?customerId ?drink) (equal? ?drink 'fanta))
       then: (add: (fact: pl-menu ?drink ?burgerType) for: 5))
;(define e10 (forall: (b (?c) ) on-add: (+ ?c 1) on-remove: (- ?c 1)))



;(define e1 (make-event))
;(define e2 (event-filter e1 (lambda (e) (> e 1))))
;(define e3 (event-map e2 (lambda (e) (+ e 3))))
;(define e4 (make-event))
;(define e5 (event-map e4 (lambda (e) (+ e 4))))
;(define e6 (event-or e3 e5))
;(define e7 (make-event))
;(define e8 (event-or e6 e7))
;(define e9 (event-or e8 e10))

(define o1 (add-observer e9 (lambda (e)(display "START") (display e))))

(define e11 (make-event))
(define o13 (add-observer e11 (lambda (e) (display "hier")(add: (fact: 'b 4) for: -1))))
(define o12 (add-observer e11 (lambda (e) (display "OBSERVER: ") (display e))))
(define o2 (add-observer events (lambda (e) (display "EVENTS: ") (display  e))))




(rule: check-calories
       where:
       (max-calories (?customerID ?max-calories))
       (current-calories (?customerID ?current-calories) (> (+ 50 ?current-calories) ?max-calories))
       then:
       (add: (fact: remove-button 'fries) for: 60))
(define event-remove-button (forall: (remove-button (?button))
                                     on-add: ?button
                                     on-remove: ?button))



       
(add-observer event-remove-button (lambda (button)
                                    (add: (fact: name button) for: 50)
                                    (display "Removed button: ")
                                    (display button)))
