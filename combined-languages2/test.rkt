#lang reader "language-plus-reader.rkt"


(view: view1 with:
       (output: b33 e11 e22 e44)
       (def: e (make-frame "test" 400 300))
       (def: b11 (make-button "enable"  e 30 30))
       (def: b22 (make-button "disable" e 30 30))
       (def: b33 (make-button "does nothing" e 30 30))
       (def: e11 (get-event b11))
       (def: e22 (get-event b22))
       (def: e44 6))

(init: view1 as: b3 e1 e2 e4)

(reactor: test
          (in: e1 e2)
          (def: e3 (map: e1 (> 2 1)))
          (def: e4 (map: e2 (< 2 1)))
          (def: e5 (or: e3 e4))
          (out: e5))

(deploy: test with: e1 e2 as: testd)

(update: update1 with:
         (input: o1)
          (set: e4 (+ e4 1))
          (change-enable b3 o1))

(connect: testd with: update1)

(rule: problem where:
       (fries (?customerId) )
       (drink (?customerId ?drink) )
       (burger (?customerId ?type) (equal? (sym cycliste) ?type))
       then: (add: (fact: menu-cycliste ?customerId ?drink) for: 1000))
       
#|(reactor: testr1
          (in: e1 e2)
          (def: e3 (map: e2 (+ e2 5)))
          (def: e4 (map: e1 (+ e1 1)))
          (def: e5 (or: e3 e4))
          ;(def: e6 (filter: e5 (> e3 3)))
          (out: e3 e4 e5 ));e6))


(reactor: testr2
          (in: e1 e2)
          (def: e3 (map: e2 (+ e2 5)))
          (def: e4 (map: e1 (+ e1 1)))
          (out: e4 e3))

(deploy: testr1 with: e1 e2 as: trt)
(rule: test where:
       (t1 (?a ?b) (> ?a ?b))
       (t2 (?c) (< ?c ?a))
       then: (add: (fact: t3 ?c) for: 4000))

(add-collect2: trt as: t1 for: 10)
(add-collect2: e1 as: t2 for: 2000)

(deploy: testr1 with: e1 e3 as: trt2)
(remove-collect1: trt2 as: t1)

(forall: (t1 (?a ?b) (> ?a ?b))
         (add-deploy: testr1 as: deployA)
         (remove-deploy: testr2 as: deployK))|#




