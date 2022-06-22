#lang reader "reader.rkt"
(main:
 (model:
  (def: cFanta 120)
  (def: cCola 120)
  (def: cIce-tea 120)
  (def: cOrange-juice 80)
  (def: cBigMac 290)
  (def: cVeggie 243)
  (def: cChicken 283)
  (def: cBacon 312)
  (def: cChocalate-ice 190)
  (def: cVanille-ice 180)
  (def: cVanille-ice-nuts 201)
  (def: cChicken-nuggets 240)
  (def: cChicken-wings 240)
  (def: cCheese-croquettes 230)
  (def: cfries-small 160)
  (def: cfries-big 290)
  (def: cSalade-small 80)
  (def: cSalade-big 160)
  (def: cFrit-fondue 310)
  (def: cMayo 50)
  (def: cKetchup 50)
  

  (def: pFanta 3.1)
  (def: pCola 3.1)
  (def: pIce-tea 3.1)
  (def: pOrange-juice 2.2)
  (def: pBigMac 7.3)
  (def: pVeggie 5.1)
  (def: pBacon 6.5)
  (def: pChicken 7.1)
  (def: pChocolate-ice 2.2)
  (def: pVanille-ice 2.2)
  (def: pVanille-ice-nuts 2.7)
  (def: pSalade-small 3.5)
  (def: pSalade-big 6.5)
  (def: pFries-small 3.5)
  (def: pFries-big 4.5)
  (def: pFrit-fondue 4.7)
  (def: pChicken-nuggets 4.7)
  (def: pChicken-wings 4.7)
  (def: pCheese-croquettes 4.2)
  (def: pMayo 1.5)
  (def: pKetchup 1.5)
  
  (def: orders (list))
  (def: customerID 0)
  (def: itemID 0)
  (def: total-calories 0)
  (def: max-total-calories 0)
  (def: total 0))
 
 (view:
  ;DRINKS
  (def: drinks-label (message 0 0 100 20 "DRINKS" ))
  (def: fanta-label (message 0 20 100 20 "Fanta: € 3.1" ))
  (def: fanta-plus fanta-plus-enable (button 0 40 60 30 "+"))
  (def: fanta-min fanta-min-enable (button 65  40 60 30 "-"))
  (def: cola-label (message 135 20 100 20 "Coca Cola: € 3.1"))
  (def: cola-plus cola-plus-enable (button 135 40 60 30 "+"))
  (def: cola-min cola-min-enable (button 200  40 60 30 "-"))
  (def: ice-tea-label (message 270 20 100 20 "Ice Tea: € 3.1"))
  (def: ice-tea-plus ice-tea-plus-enable (button 270 40 60 30 "+"))
  (def: ice-tea-min ice-tea-min-enable (button 335  40 60 30 "-"))
  (def: orange-juice-label (message 405 20 100 20 "Orange Juice: € 3.1"))
  (def: orange-juice-plus orange-juice-plus-enable (button 405 40 60 30 "+"))
  (def: orange-juice-min orange-juice-min-enable (button 470  40 60 30 "-"))
  ;BURGER
  (def: burger-label (message 0 80  100 20 "BURGERS"))
  (def: big-mac-label (message 0 100 100 20 "Big Mac: € 7.2"))
  (def: big-mac-plus big-mac-plus-enable (button 0 120 60 30 "+"))
  (def: big-mac-min big-mac-min-enable (button 65  120 60 30 "-"))
  (def: veggie-label (message 135 100 100 20 "Veggie: € 5.1 "))
  (def: veggie-plus veggie-plus-enable (button 135 120 60 30 "+"))
  (def: veggie-min veggie-min-enable (button 200  120 60 30 "-"))
  (def: bacon-label (message 270 100 100 20 "Bacon: € 6.5"))
  (def: bacon-plus bacon-plus-enable (button 270 120 60 30 "+"))
  (def: bacon-min bacon-min-enable (button 335  120 60 30 "-"))
  (def: chicken-label (message 405 100 100 20 "Chicken: € 7.1"))
  (def: chicken-plus chicken-plus-enable (button 405 120 60 30 "+"))
  (def: chicken-min chicken-min-enable (button 470  120 60 30 "-"))
  ;DESSERT
  (def: dessert-label (message 0 160  100 20 "DESSERTS"))
  (def: chocolate-ice-label (message 0 180 100 20 "Chocolate Ice: € 2.2"))
  (def: chocolate-ice-plus chocolate-ice-plus-label (button 0 200 60 30 "+"))
  (def: chocolate-ice-min chocolate-ice-min-enable (button 65  200 60 30 "-"))
  (def: vanille-ice-label (message 135 180 100 20 "Vanille Ice: € 2.2"))
  (def: vanille-ice-plus vanille-ice-plus-enable (button 135 200 60 30 "+"))
  (def: vanille-ice-min vanille-ice-min-enable (button 200  200 60 30 "-"))
  (def: vanille-ice-nuts-label (message 270 180 150 20 "Vanille Ice Nuts: € 2.7"))
  (def: vanille-ice-nuts-plus vanille-ice-nuts-plus-enable (button 270 200 60 30 "+"))
  (def: vanille-ice-nuts-min vanille-ice-nuts-min-enable (button 335  200 60 30 "-"))
  ;SNACKS
  (def: snack-label (message 0 240  100 20 "SNACKS"))
  (def: chicken-nuggets-label (message 0 260 100 20 "Chicken Nuggets: € 4.7"))
  (def: chicken-nuggets-plus-e chicken-nuggets-plus-en (button 0 280 60 30 "+"))
  (def: chicken-nuggets-min-e chicken-nuggets-min-en (button 65 280 60 30 "-"))
  (def: chicken-wings-label (message 135 260 100 20 "Chicken Wings: € 4.7"))
  (def: chicken-wings-plus-e chicken-wings-plus-en (button 135 280 60 30 "+"))
  (def: chicken-wings-min-e chicken-wings-min-en(button 200  280 60 30 "-"))
  (def: cheese-croquettes-label  (message 270 260 150 20 "Cheese croquettes: 4.7"))
  (def: cheese-croquettes-plus-e cheese-croquettes-plus-en (button 270 280 60 30 "+"))
  (def: cheese-croquettes-min-e cheese-croquettes-min-en (button 335  280 60 30 "-"))
  
  ;FRIES
  (def: fries-label (message 0 320  100 20 "FRIES"))
  (def: fries-small-label (message 0 340 100 20 "Fries Small: € 3.5"))
  (def: fries-small-plus-e fries-small-plus-en (button 0 360 60 30 "+"))
  (def: fries-small-min-e fries-small-min-en (button 65 360 60 30 "-"))
  (def: fries-big-label (message 135 340 100 20 "Fries Big: € 4.7"))
  (def: fries-big-plus-e fries-big-plus-en (button 135 360 60 30 "+"))
  (def: fries-big-min-e fries-big-min-en (button 200  360 60 30 "-"))
  (def: frit-fondue-label  (message 270 340 150 20 "Cheese croquettes: 4.2"))
  (def: frit-fondue-plus-e frit-fondue-plus-en (button 270 360 60 30 "+"))
  (def: frit-fondue-min-e frit-fondue-min-en (button 335  360 60 30 "-"))
  ;SALADE
  (def: salade-label (message 0 400  100 20 "SALADES"))
  (def: salade-small-label (message 0 420 100 20 "Salade Small: € 3.5"))
  (def: salade-small-plus-e salade-small-plus-en (button 0 440 60 30 "+"))
  (def: salade-small-min-e salade-small-min-en (button 65 440 60 30 "-"))
  (def: salade-big-label (message 135 420 100 20 "Salade Big: € 6.5"))
  (def: salade-big-plus-e salade-big-plus-en (button 135 440 60 30 "+"))
  (def: salade-big-min-e salade-big-min-en (button 200  440 60 30 "-"))
  ;SAUS
  (def: saus-label (message 0 480 100 20 "SAUS"))
  (def: mayo-label (message 0 500 100 20 "Mayonnaise: € 3.5"))
  (def: mayo-plus-e mayo-plus-en (button 0 520 60 30 "+"))
  (def: mayo-min-e mayo-min-en (button 65 520 60 30 "-"))
  (def: ketchup-label (message 135 500 100 20 "Ketchup: € 6.5"))
  (def: ketchup-plus-e ketchup-plus-en (button 135 520 60 30 "+"))
  (def: ketchup-min-e ketchup-min-en (button 200  520 60 30 "-"))
  ;ALLERGIC
  (def: allergic-label (message 0 560 100 20 "ALLERGICS"))
  (def: milk-event milk-enable milk-value (check-box 0 580 40 50 "Milk"))
  (def: eggs-event eggs-enable eggs-value (check-box 55 580 40 50 "Eggs"))
  (def: nuts-event nuts-enable nuts-value (check-box 110 580 40 50 "Nuts"))
  
  ;ORDER
  (def: order-list-box add-list-box remove-list-box clear-list-box (list-box 0 650 700 200 "ORDER: " (list)))

  ;TOTAL
  (def: total-label (message 0 870 50 20 "Total: "))
  (def: sum-total-label (message 50 870 50 20 "0"))
  (def: payer-event payer-enable (button 0 885 60 30 "Payer"))
  (def: abort-event abort-enable (button 65 885 60 30 "Abort"))

  

  )
 (react:
  (reactor: add-id-reactor
            (in: button-event #:models type current-item-id current-customer-id)
            (def: new-item-id (map: button-event (+ current-item-id 1)))
            (def: new-customer-id (map: button-event (+ current-customer-id 1)))
            (def: args (map: button-event (list type)))
            (out: new-item-id new-customer-id type))
  (deploy: add-id-reactor with: fanta-e current-item-id as: fanta-id)
  (deploy: add-id-reactor with: cola-e current-item-id as: cola-id)
  (deploy: add-id-reactor with: ice-tea-e current-item-id as: ice-tea-id)
  (deploy: add-id-reactor with: orange-juice-e current-item-id as: orange-juice-id)


  (add-collect1: fanta-id as: drink for: -1)
  (add-collect1: cola-id as: drink for: -1)
  (add-collect1: ice-tea-id as: drink for: -1)
  (add-collect1: orange-juice-id as: drink for: -1)

  (rule: menu-big-mac where:
         (drink (?item-id-drink ?customer-id (list ?drink-type)) (or (equal? 'fanta)
                                                                     (equal? 'cola)
                                                                     (equal? 'ice-tea)))
         
         


  
  (reactor: allergic-reactor
           (in: check-box-event)
           (def: change (map: check-box-event (not check-box-event)))
           (out: change))
  (deploy: allergic-reactor with: milk-event as: allergic-milk)
  (deploy: allergic-reactor with: eggs-event as: allergic-eggs)
  (deploy: allergic-reactor with: nuts-event as: allergic-nuts)
  (update: bacon-plus-enable with: allergic-eggs)
  (update: bacon-min-enable with: allergic-eggs)
  (update: chicken-plus-enable with: allergic-eggs)
  (update: chicken-min-enable with: allergic-eggs)


  (react: check-calories-reactor
          (in: button #:models calories total-calories max-calories)
          (def: new-total (map: button (+ calories total-calories)))
          (def: filtered-new-total (filter: new-total (<= new-total max-calories)))
          (def: string-new-total (map: filtered-new-total (number->string filtered-new-total)))
          (out: filtered-new-total))

  (deploy: check-calories-reactor with: fanta-plus cFanta total-calories max-calories)
  (deploy: check-calories-reactor with: cola-plus cCola total-calories max-calories)
  (deploy: check-calories-reactor with: ice-tea-plus cIce-tea total-calories max-calories)
  (deploy: check-calories-reactor with: orange-juice-plus cIce-tea total-calories max-calories)
  




  


  
  

  

  ))
  
  
  

#| (reactor: reactor-counter
           (in: plus min #:model count)
           (def: plus-count (map: plus (+ count 1)))
           (def: min-count (map: min (- count 1)))
           (def: new-count (or: plus-count min-count))
           (def: string-new-count (map: new-count (number->string new-count)))
           (out: new-count string-new-count))
(deploy: reactor-counter with: plus min total as: counter)
(update: total label with: counter)


 (reactor: world-reactor
           (in: plus min #:model customerID)
           (def: happened (or: plus min))
           (def: ID (map: happened customerID))
           (out: ID))
 (deploy: world-reactor with: plus min customerID as: world)
 (reactor: new-customer-reactor
           (in: id)
           (def: new-ID (map: id (+ id 1)))
           (def: total (map: id 0))
           (def: new-message (map: id "0"))
           (out: new-ID total new-message))

 (reactor: nothing-reactor (in: id) (out: id))
 
            
           
(add-collect1: world as: period for: 5)

(forall: (period (?customerID))
         (add-deploy: nothing-reactor as: nothing)
         (remove-deploy: new-customer-reactor as: new-customer))

(update: customerID total label with: new-customer)))|#

  
           
  