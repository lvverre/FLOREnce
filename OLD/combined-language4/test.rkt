#lang reader "reader.rkt"

 (main: (model: (def: counter-val 0))
       (view: (def: plus en-p (button 0 0 40 40 "+"))
              (def: min en-m (button 0 40 40 40 "-"))
              (def: label (message 100 20 40 40 "0")))
                
       (react: (reactor: change-counter-r (in: p m #:model val)
                         
                         (def: min-res (map: m (- val 1)))
                         (def: plus-res (map: p (+ val 1)))
                         (def: result-number (or: plus-res min-res))
                         (def: result-string (map: result-number (number->string result-number)))
                         (out: result-string result-number))
                         
               (deploy: change-counter-r with: plus min counter-val as: counter)
               (update: label counter-val with: counter)
               ))
              
