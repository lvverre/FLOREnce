#lang reader "reader.rkt"
(main: (model: (def: counter_1 0)
               (def: counter_2 0))
       (view:
        (def-window: jl
          (def: button-plus-in button-plus-out (button 0 0 40 40 "+"))
          (def: button-min-in button-min-out (button 100 0 40 40 "-"))
          (def: l n (button 200 200 40 40 "v"))
          (def: fanta-out (message  200 0 20 40 "0" )))
        (def: sourceTimer (timer 1))
          (def: button-plus-in button-plus-out (button 0 0 40 40 "+"))
        (def: button-min-in button-min-out (button 100 0 40 40 "-"))
        (def: fanta-out (message  200 0 20 40 "0" ))
        (def: ti to (text-field 300 0 40 50 "jjj"))
        (def: m v (list-box 500 0 60 60 "vv" (list))))
       
       (react:
       

        #|(reactor: l
                  (in: p)
                  (out: p p))
        (deploy: l with: (fact: main ti) as: mm)
        (update: (fact: main v add) with: mm)

        (reactor: pp
                  (in: w)
                  (out: w))
        
        (deploy: pp with: (fact: main m) as: vm)
        (update: (fact: main v remove) with: vm)
        
        (reactor: reactor-counter
                  (in: plus-b min-b #:model counter)
                  (def: state-min (map: min-b (lambda: c (- counter 1))));(c ->(- c 1))))
                  (def: state-plus (map: plus-b (lambda: c (+ counter 1))))
                  (def: state (or: state-min state-plus))
                  (def: state-string (map: state (lambda: s (number->string s))))
                  (out: state state-string))
        (deploy: reactor-counter
                 with: (fact: jl button-plus-in) (fact: jl button-min-in) counter_1
                 as: counter1)
        (deploy: reactor-counter
                 with: (fact: main sourceTimer) (fact: main button-min-in) counter_2 as: counter2)
        (update: counter_1 (fact: jl fanta-out change-value) with: counter1)
        (update: counter_2 (fact: main fanta-out change-value) with: counter2)))|#
        (add-collect1: (factt: main button-min-in) as: pushed for: 180)
        (rule: v where: (pushed (?v))
               then: (add: (fact: op 30) for: 33))
        (reactor: i
                  (in: plus-b #:model counter)
                  (def: state-min (map: plus-b (lambda: c (- counter 1))));(c ->(- c 1))))
                  
                  (def: state-string (map: state-min (lambda: s (number->string s))))
                  (out: state-min state-string))

        (reactor: n (in: i) (out: i))
        (forall: (pushed ("-"))
                 (add-deploy: i counter_1 as: counter-1)
                 (remove-deploy: n as: counter-2))
        (update: counter_1 (fact: main fanta-out change-value) with: counter-1)
        ))
        
                       