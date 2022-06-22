#lang reader "language.rkt"
(main: (model: )
       (view: (def: fries-b fries-en (button 0 0 30 30 "fries"))
              (def: ice-cream-b ice-cream-en (button 0 30 30 30 "ICE-cream"))
              (def: alg-box alg-en alg-val (check-box  50 0 40 40 "MILK")))
       (react:
        (reactor: milk-reactor (in: box-val) (def: val (map: box-val (not box-val))) (out: val))
        (deploy: milk-reactor with: alg-box as: milk)
        (update: ice-cream with: milk)))