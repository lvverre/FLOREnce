#lang reader "language-plus-reader.rkt"
(reactor: testr1
          (in: e1 e2)
          (def: e3 (map: e2 (+ e2 5)))
          (def: e4 (map: e1 (+ e1 1)))
          (out: e3 e4))

(deploy: testr1 with: e1 e2 as: trt)
(rule: test where:
       (t1 (?a ?b) (> ?a ?b))
       (t2 (?c) (< ?c ?a))
       then: (add: (fact: t3 ?c) for: 4000))

(add-collect2: trt as: t1 for: 5000)
;(add-collect2: e1  as: t2 for: 5000)
