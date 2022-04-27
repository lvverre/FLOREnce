#lang reader "language-plus-reader.rkt"
(main:
 (model: add-fries-event remove-fries-event add-button-fries
          remove-button-fries
          add-Milk-Shake remove-Milk-Shake add-button-Milk-Shake remove-button-Milk-Shake
          add-drink-event remove-drink-event add-drink-button remove-drink-button
          add-burgerc-event remove-burgerc-event add-burgerc-button remove-burgerc-button
          frame
          button-panel
          message-panel
          event-milk
          alg-panel
          event-paprika
          add-burgers-event remove-burgers-event add-burgers-button remove-burgers-button)
 (view: make-frame with: (input:) (set: frame (make-frame "Client" 400 400)) (set: button-panel (make-v-panel frame)) (set: message-panel (make-v-panel frame))
        (set: alg-panel (make-h-panel frame)) (output: ))
 (init: make-frame with: (input:) (output:))
(view: client with: (input: purpose)
       (def: panel-food-button (make-h-panel button-panel))
       (def: food-button-panel (make-v-panel panel-food-button))
       (def: txt-panel (make-v-panel panel-food-button))
       
       (def: message-txt (make-message purpose txt-panel))
       (def: counter-txt (make-message "0" txt-panel))
       (def: add-button (make-button "ADD" food-button-panel 50 50))
       (def: add-event (get-event add-button))
       (def: remove-button remove-event (make-button "REMOVE" food-button-panel 50 50))
       (def: remove-event (get-event remove-button))
       (output: add-event remove-event add-button remove-button ))
(init: client with: (input: "Fries - €2") (output: add-fries-event remove-fries-event add-button-fries
          remove-button-fries))

(init: client with: (input: "MilkShake - 3") (output: add-Milk-Shake remove-Milk-Shake add-button-Milk-Shake remove-button-Milk-Shake))
(init: client with: (input: "Drink - 2.30") (output: add-drink-event remove-drink-event add-drink-button remove-drink-button))
(init: client with: (input: "Burger Cycliste - 2.30") (output: add-burgerc-event remove-burgerc-event add-burgerc-button remove-burgerc-button))
(init: client with: (input: "Standard Cycliste - 2.30") (output: add-burgers-event remove-burgers-event add-burgers-button remove-burgers-button))
(view: allergic with: (input: name)
       (def: allergic-radio-box (make-radio-box name (pair "yes" "no") alg-panel ))
       (def: event (get-event allergic-radio-box))
       (output: event))

(init: allergic with: (input: "MILK: ") (output: event-milk))
;(init: allergic with: (input: "PAPRIKA ") (output: event-paprika))
      ; (set: radio-box-milk (make-radio-box "MILK: " (pair "yes" "no") frame ))
      ; (set: milk-event (get-event radio-box-milk)))
)

(reactor: add-burger (in: cycliste standard)
         (def: c-e (map: cycliste "cycliste"))
         (def: s-e (map: standard "standard"))
         (def: output (or: c-e s-e))
         (out: output))

(deploy: add-burger with: add-burgerc-event add-burgers-event as: deployed-add-burger)


(add-collect1: deployed-add-burger as: burger for: 300)

(reactor: change-state-button
          (in: button state)
          (def: state-in-boolean (map: state (if (equal? "yes" state)
                                                true
                                                false)))
          (out: button state-in-boolean))

(reactor: do-nothing (in: button state)
         (out: button state))
          
(update: enable-disable-button with: (input: button state)
         (change-enable button state))
 
(update: food-added with: (input: menu drink side)
         (make-message menu message-panel )
         (make-message drink message-panel )
         (make-message side message-panel))
(rule: menu where:
       (drink (?drink) (equal? "fanta" ?drink))
       (side (?side) (or (equal? salade)
                         (equal? fries)))
       (burger (?burger) (equal? "cycliste" ?burger))
       then: (add: (fact: menu-detected "Cycliste" ?drink ?side) for: 300))

(reactor: make-string-of-menu
          (in: menu drink side)
          (def: s-menu (map: menu (string-append "Menu: " menu)))
          (out: s-menu drink side))


          

(forall: (menu-detected (?burger ?drink ?side))
         (add-deploy: make-string-of-menu as: menu-detection-deployed)
         (add-deploy: do-nothing as: nothing))

 
       
(rule: allergic
       where:
       (BUTTON-ALLERGIC (?button ?paprika ?milk) (equal? ?milk "true"))
       (ALLERGIC-MILK (?state))
       then:
       (add: (fact: CHANGE-BUTTON ?button ?state) for: -1))


(rule: allergic
       where:
       (BUTTON-MILK (?button ))
       (ALLERGIC-MILK (?state))
       then:
       (add: (fact: CHANGE-BUTTON ?button ?state) for: -1))

(forall: (CHANGE-BUTTON (?button ?state) )
        (add-deploy: change-state-button as: deployed-change-button)
        (remove-deploy: do-nothing as: deployed-nothing))

(connect: deployed-change-button with: enable-disable-button)
       
(add: (fact: BUTTON-MILK add-button-Milk-Shake ) for: -1)
(add: (fact: BUTTON-MILK remove-button-Milk-Shake  ) for: -1)

(add-collect1: event-milk as: ALLERGIC-MILK for: 200)

       
