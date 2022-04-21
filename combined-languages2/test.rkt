#lang reader "language-plus-reader.rkt"



(reactor: testr1
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
         (remove-deploy: testr2 as: deployK))




