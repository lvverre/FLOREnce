#lang reader "reader.rkt"
(main: (model: (def: counter_1 0)
               (def: counter_2 0))
       (view:
        (def-window: jl
          (def: button-plus-in button-plus-out (button 0 0 40 40 "+"))
          (def: button-min-in button-min-out (button 100 0 40 40 "-"))
          (def: fanta-out (message  200 0 20 40 "0" )))
        (def: button-plus-in button-plus-out (button 0 0 40 40 "+"))
        (def: button-min-in button-min-out (button 100 0 40 40 "-"))
        (def: fanta-out (message  200 0 20 40 "0" )))
       (react:
        (reactor: reactor-counter
                  (in: plus-b min-b #:model counter)
                  (def: state-min (map: min-b (- counter 1)))
                  (def: state-plus (map: plus-b (+ counter 1)))
                  (def: state (or: state-min state-plus))
                  (def: state-string (map: state (number->string state)))
                  (out: state state-string))
        (deploy: reactor-counter
                 with: (fact: jl button-plus-in) (fact: jl button-min-in) counter_1
                 as: counter1)
        (deploy: reactor-counter
                 with: (fact: main button-plus-in) (fact: main button-min-in) counter_2 as: counter2)
        (update: counter_1 (fact: jl fanta-out change-value) with: counter1)
        (update: counter_2 (fact: main fanta-out change-value) with: counter2)))
        
                       