#lang reader "language-plus-reader.rkt"

(view: client with: (output: button-fries
                            button-salade
                            button-ice-cream
                            radio-box-milk
                            milk-event)
       (def: frame (make-frame "Client" 400 400))
       (def: button-fries (make-button "FRIES" frame 40 40))
       (def: button-salade (make-button "SALADE" frame 40 40))
       (def: button-ice-cream (make-button "ICE CREAM" frame 40 40))
       (def: radio-box-milk (make-radio-box "MILK: " (pair "yes" "no") frame ))
       (def: milk-event (get-event radio-box-milk)))

(init: client as: bt bs bi rm me)
(reactor: change-state-button
          (in: button state)
          (def: state-in-boolean (map: state (if (equal? "yes" state)
                                                true
                                                false)))
          (out: button state-in-boolean))

(reactor: do-nothing (in: button state)
         (out: button state))
          
(update: enable-disable-button with: (input button state)
         (change-enable button state))
(rule: allergic
       where:
       (MILK-BUTTON (?button))
       (ALLERGIC-MILK (?state))
       then:
       (add: (fact: CHANGE-BUTTON ?button ?state) for: -1))

(forall: (CHANGE-BUTTON (?button ?state) )
        (add-deploy: change-state-button as: deployed-change-button)
        (remove-deploy: do-nothing as: deployed-nothing))

(connect: deployed-change-button with: enable-disable-button)
       
(add: (fact: MILK-BUTTON bi) for: -1)
(add-collect1: me as: ALLERGIC-MILK for: 200)

       
