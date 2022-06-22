
#lang reader "reader.rkt"
(main:
 (model:
  (def: customerID 0)
  (def: total 0))
 (view:
  (def: plus plus-enable (button 0 0 30 30 "+"))
  (def: min min-enable (button 0 30 30 30 "-"))
  (def: label (message 100 20 30 30 (number->string total))))
 (react:
  (reactor: customer
            (in: x #:model total)
            (def: i (map: x (+ total 1)))
            (def: z (map: i (number->string i)))
            (out: z i))
  (add-collect1: plus as: test for: -1)
  (remove-collect1: min as: test)
  (forall: (test (?x ))
           (add-deploy:  customer  total as: nothing)
           (remove-deploy: customer  total as: do-something))
 (add: (fact: total total) for: -1)
  (update: label total with: do-something)))