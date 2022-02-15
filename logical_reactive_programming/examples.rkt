#lang reader "language3.rkt"
(rule: j where:
         (:= kl (event-condition z (?x ?y) (> ?x ?y)))
         (:= v (event-condition z (?x ?y) (< ?x ?y)))
         (! (event-condition z (?x ?y) (= ?x 2)))
         then: (emit: l with: 2 1))

(add-fact z 3 1)
(add-fact z 1 3)
(add-fact 2 1)