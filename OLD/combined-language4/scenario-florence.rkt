#lang reader "reader.rkt"
(main:
 (model:
  (def: nothing 0)
  (def: cFanta 120)
  (def: cCola 120)
  (def: cIce-tea 120)
  (def: cOrange-juice 80)
  (def: cBig-mac 290)
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

  
  (def: small? #t)
  (def: big? #f) 

  (def: pFanta 3.1)
  (def: pCola 3.1)
  (def: pIce-tea 3.1)
  (def: pOrange-juice 2.2)
  (def: pBig-mac 7.3)
  (def: pVeggie 5.1)
  (def: pBacon 6.5)
  (def: pChicken 7.1)
  (def: pChocolate-ice 2.2)
  (def: pVanille-ice 2.2)
 ; (def: pVanille-ice-nuts 2.7)
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

  (def: price-1 (list))
  (def: price-2 (list))
  (def: order-1 (list))
  (def: order-2 (list))
  (def: customerID 2)
  (def: customerID-1 0)
  (def: customerID-2 1)
  (def: currentItemID-1 0)
  (def: currentItemID-2 0)
;  (def: total-calories 0)
;  (def: max-total-calories 0)
  (def: total-1 0)
  (def: total-2 0)
  (def: current-selected-item-1 #f)
  (def: current-selected-item-2 #f)

  
  
   )
 
 (view:
  (def-window: client-1
    (def: startB-source startB-sink (button 0 0 100 30 "Start"))
    ;DRINKS
    (def: drinksL-sink (message 0 30 100 20 "DRINKS" ))
    (def: fantaL-sink (message 35 80 100 20 "€ 3.1" ))
    (def: fantaB-source fantaB-sink (button 0 50 100 30 "Fanta"))
    
    (def: colaL-sink (message 170 80 100 20 "€ 3.1"))
    (def: colaB-source colaB-sink (button 135 50 100 30 "Coca Cola"))
 
    (def: ice-teaL-sink (message 305 80 100 20 "3.1"))
    (def: ice-teaB-source ice-teaB-sink (button 270 50 100 30 "Ice Tea"))

    (def: orange-juiceL-sink (message 440 80 100 20 "€ 3.1"))
    (def: orange-juiceB-source orange-juiceB-sink (button 405 50 100 30 "Orange Juice"))
    
  
  
    ;BURGER
    (def: burgerL-sink (message 0 110  100 20 "BURGERS"))
    (def: big-macL-sink (message 35 160 100 20 "€ 7.2"))
    (def: big-macB-source big-macB-sink (button 0 130 100 30 "Big Mac"))
    
    (def: veggieL-sink (message 170 160 100 20 "€ 5.1 "))
    (def: veggieB-source veggieB-sink (button 135 130 100 30 "Veggie"))
    
    (def: baconL-sink (message 305 160 100 20 "€ 6.5"))
    (def: baconB-source baconB-sink (button 270 130 100 30 "Bacon"))
    
    (def: chickenL-sink (message 440 160 100 20 "€ 7.1"))
    (def: chickenB-source chickenB-sink (button 405 130 100 30 "Chicken"))
  
  ;DESSERT
  (def: dessertL-sink (message 0 190  100 20 "DESSERTS"))
  (def: chocolate-iceL-sink (message 35 240 100 20 "€ 2.2"))
  (def: chocolate-iceB-source chocolate-iceB-sink (button 0 210 100 30 "Chocolate Ice"))

  (def: vanille-iceL-sink (message 170 240 100 20 "€ 2.2"))
  (def: vanille-iceB-source vanille-iceB-sink (button 135 210 100 30 "Vanille Ice"))

 
  
  ;SNACKS
    (def: snackL-sink (message 0 270  100 20 "SNACKS"))
    (def: chicken-nuggetsL-sink (message 35 320 100 20 "€ 4.7"))
    (def: chicken-nuggetsB-source chicken-nuggetsB-sink (button 0 290 100 30 "Chicken Nuggets"))
    
    (def: chicken-wingsL-sink (message 170 320 100 20 "€ 4.7"))
    (def: chicken-wingsB-source chicken-wingsB-sink (button 135 290 100 30 "Chicken Wings"))
  
    (def: cheese-croquettesL-sink  (message 305 320 150 20 "€ 4.7"))
    (def: cheese-croquettesB-source cheese-croquettesB-sink (button 270 290 100 30 "Cheese Croquettes"))
  
  
  ;FRIES
    (def: friesL-sink (message 0 350  100 20 "FRIES"))
    (def: fries-smallL-sink (message 35 400 100 20 "€ 3.5"))
    (def: fries-smallB-source fries-smallB-sink (button 0 370 100 30 "Fries Small"))
    (def: fries-bigL-sink (message 170 400 100 20 "€ 4.7"))
    (def: fries-bigB-source fries-bigB-sink (button 135 370 100 30 "Fries Big"))
    (def: frit-fondueL-sink  (message 305 400 150 20 "€ 4.2"))
    (def: frit-fondueB-source frit-fondueB-sink (button 270 370 100 30 "Frit Fondue"))
  ;SALADE
    (def: saladeL-sink (message 0 430  100 20 "SALADES"))
    (def: salade-smallL-sink (message 35 480 100 20 "€ 3.5"))
    (def: salade-smallB-source salade-smallB-sink (button 0 450 100 30 "Salade Small"))
    (def: salade-bigL-sink (message 170 480 100 20 "€ 6.5"))
    (def: salade-bigB-source salade-bigB-sink (button 135 450 100 30 "Salade Big"))
    ;SAUS
    (def: sausL-sink (message 0 510 100 20 "SAUS"))
    (def: mayoL-sink (message 35 560 100 20 "€ 1.5"))
    (def: mayoB-source mayoB-sink (button 0 530 100 30 "Mayonnaise"))
    (def: ketchupL-sink (message 170 560 100 20 "€ 1.5"))
    (def: ketchupB-source ketchupB-sink (button 135 530 100 30 "Ketchup"))
    ;ALLERGIC
    (def: allergicL-sink (message 0 590 100 20 "ALLERGICS"))
    (def: milkC-source milkC-sink (check-box 0 610 40 50 "Milk"))
    (def: eggsC-source eggsC-sink (check-box 55 610 40 50 "Eggs"))
 
  
    ;ORDER
    (def: orderLB-source orderLB-sink (list-box 0 680 700 200 "ORDER: " (list)))
    (def: removeB-source removeB-sink (button 0 885 50 30 "Remove"))

    (def: promoL-sink (message 0 925 50 20 "ACTION"))
    (def: promoB-source promoB-sink (text-field 0 945 100 20 "Promo Code"))
     
  ;TOTAL
    (def: totalL-sink (message 0 975 50 20 "Total: "))
    (def: sum-totalL-sink (message 50 995 50 20 "0"))
    (def: payerB-source payerB-sink (button 0 1015 60 30 "Payer"))
    (def: abortB-source abortB-sink (button 65 1015 60 30 "Abort"))
  

  

  )

  (def-window: client-2
    (def: startB-source startB-sink (button 0 0 100 30 "Start"))
    ;DRINKS
    (def: drinksL-sink (message 0 30 100 20 "DRINKS" ))
    (def: fantaL-sink (message 35 80 100 20 "€ 3.1" ))
    (def: fantaB-source fantaB-sink (button 0 50 100 30 "Fanta"))
    
    (def: colaL-sink (message 170 80 100 20 "€ 3.1"))
    (def: colaB-source colaB-sink (button 135 50 100 30 "Coca Cola"))
 
    (def: ice-teaL-sink (message 305 80 100 20 "3.1"))
    (def: ice-teaB-source ice-teaB-sink (button 270 50 100 30 "Ice Tea"))

    (def: orange-juiceL-sink (message 440 80 100 20 "€ 3.1"))
    (def: orange-juiceB-source orange-juiceB-sink (button 405 50 100 30 "Orange Juice"))
    
  
  
    ;BURGER
    (def: burgerL-sink (message 0 110  100 20 "BURGERS"))
    (def: big-macL-sink (message 35 160 100 20 "€ 7.2"))
    (def: big-macB-source big-macB-sink (button 0 130 100 30 "Big Mac"))
    
    (def: veggieL-sink (message 170 160 100 20 "€ 5.1 "))
    (def: veggieB-source veggieB-sink (button 135 130 100 30 "Veggie"))
    
    (def: baconL-sink (message 305 160 100 20 "€ 6.5"))
    (def: baconB-source baconB-sink (button 270 130 100 30 "Bacon"))
    
    (def: chickenL-sink (message 440 160 100 20 "€ 7.1"))
    (def: chickenB-source chickenB-sink (button 405 130 100 30 "Chicken"))
  
  ;DESSERT
  (def: dessertL-sink (message 0 190  100 20 "DESSERTS"))
  (def: chocolate-iceL-sink (message 35 240 100 20 "€ 2.2"))
  (def: chocolate-iceB-source chocolate-iceB-sink (button 0 210 100 30 "Chocolate Ice"))

  (def: vanille-iceL-sink (message 170 240 100 20 "€ 2.2"))
  (def: vanille-iceB-source vanille-iceB-sink (button 135 210 100 30 "Vanille Ice"))

 
  
  ;SNACKS
    (def: snackL-sink (message 0 270  100 20 "SNACKS"))
    (def: chicken-nuggetsL-sink (message 35 320 100 20 "€ 4.7"))
    (def: chicken-nuggetsB-source chicken-nuggetsB-sink (button 0 290 100 30 "Chicken Nuggets"))
    
    (def: chicken-wingsL-sink (message 170 320 100 20 "€ 4.7"))
    (def: chicken-wingsB-source chicken-wingsB-sink (button 135 290 100 30 "Chicken Wings"))
  
    (def: cheese-croquettesL-sink  (message 305 320 150 20 "€ 4.7"))
    (def: cheese-croquettesB-source cheese-croquettesB-sink (button 270 290 100 30 "Cheese Croquettes"))
  
  
  ;FRIES
    (def: friesL-sink (message 0 350  100 20 "FRIES"))
    (def: fries-smallL-sink (message 35 400 100 20 "€ 3.5"))
    (def: fries-smallB-source fries-smallB-sink (button 0 370 100 30 "Fries Small"))
    (def: fries-bigL-sink (message 170 400 100 20 "€ 4.7"))
    (def: fries-bigB-source fries-bigB-sink (button 135 370 100 30 "Fries Big"))
    (def: frit-fondueL-sink  (message 305 400 150 20 "€ 4.2"))
    (def: frit-fondueB-source frit-fondueB-sink (button 270 370 100 30 "Frit Fondue"))
  ;SALADE
    (def: saladeL-sink (message 0 430  100 20 "SALADES"))
    (def: salade-smallL-sink (message 35 480 100 20 "€ 3.5"))
    (def: salade-smallB-source salade-smallB-sink (button 0 450 100 30 "Salade Small"))
    (def: salade-bigL-sink (message 170 480 100 20 "€ 6.5"))
    (def: salade-bigB-source salade-bigB-sink (button 135 450 100 30 "Salade Big"))
    ;SAUS
    (def: sausL-sink (message 0 510 100 20 "SAUS"))
    (def: mayoL-sink (message 35 560 100 20 "€ 1.5"))
    (def: mayoB-source mayoB-sink (button 0 530 100 30 "Mayonnaise"))
    (def: ketchupL-sink (message 170 560 100 20 "€ 1.5"))
    (def: ketchupB-source ketchupB-sink (button 135 530 100 30 "Ketchup"))
    ;ALLERGIC
    (def: allergicL-sink (message 0 590 100 20 "ALLERGICS"))
    (def: milkC-source milkC-sink (check-box 0 610 40 50 "Milk"))
    (def: eggsC-source eggsC-sink (check-box 55 610 40 50 "Eggs"))
 
  
    ;ORDER
    (def: orderLB-source orderLB-sink (list-box 0 680 700 200 "ORDER: " (list)))
    (def: removeB-source removeB-sink (button 0 885 50 30 "Remove"))
  
  ;TOTAL
    (def: totalL-sink (message 0 925 50 20 "Total: "))
    (def: sum-totalL-sink (message 50 945 50 20 "0"))
    (def: payerB-source payerB-sink (button 0 965 60 30 "Payer"))
    (def: abortB-source abortB-sink (button 65 965 60 30 "Abort")))
  
  (def: bs bss (button  0 0  0 0 "jfdk"))
  )
 (react:

  (reactor: select-remove-itemR
            (in: list-box)
            (out: list-box))

  (deploy: select-remove-itemR with: (fact: client-1 orderLB-source) as: selected-for-remove-1)
  (update: current-selected-item-1 with: selected-for-remove-1)

  (deploy: select-remove-itemR with: (fact: client-2 orderLB-source) as: selected-for-remove-2)
  (update: current-selected-item-2 with: selected-for-remove-2)
  

  (reactor: removeR
            (in: button #:model selected-index order)
            (def: index (map: button (lambda: button selected-index)))
            (def: index-e (filter: index (lambda: index index)))
            (def: itemID (map: index-e (lambda: index-e (list-ref order index-e)))) 
            (def: nothing (map: index-e (lambda: index-e ?)))
            (out: itemID nothing nothing nothing))

    
  (deploy:  removeR with: (fact: client-1 removeB-source) current-selected-item-1 order-1 as: remove-1)
  (remove-collect1: remove-1 as: fries)
  (remove-collect1: remove-1 as: burger)
  (remove-collect1: remove-1 as: saus)
  (remove-collect1: remove-1 as: ice)
  (remove-collect1: remove-1 as: salade)
  (remove-collect1: remove-1 as: drink)
  (remove-collect1: remove-1 as: snack)
  (remove-collect1: remove-1 as: menu)


  (deploy:  removeR with: (fact: client-2 removeB-source) current-selected-item-2 order-2 as: remove-2)
  (remove-collect1: remove-2 as: fries)
  (remove-collect1: remove-2 as: burger)
  (remove-collect1: remove-2 as: saus)
  (remove-collect1: remove-2 as: ice)
  (remove-collect1: remove-2 as: salade)
  (remove-collect1: remove-2 as: drink)
  (remove-collect1: remove-2 as: snack)
  (remove-collect1: remove-2 as: menu)
    
  (reactor: allergicR
            (in: check-box)
            (def: value (map: check-box (lambda: check-box (not check-box))))
            (out: value))

    (deploy: allergicR with: (fact: client-1 milkC-source) as: milk-allergic-1)
    (deploy: allergicR with: (fact: client-1 eggsC-source) as: eggs-allergic-1)
    (update: (fact: client-1 baconB-sink enabled) with: eggs-allergic-1)
    (update: (fact: client-1 chickenB-sink enabled) with: eggs-allergic-1)
    (update: (fact: client-1 vanille-iceB-sink enabled) with: milk-allergic-1)
    (update: (fact: client-1 chocolate-iceB-sink enabled) with: milk-allergic-1)

    (deploy: allergicR with: (fact: client-2 milkC-source) as: milk-allergic-2)
    (deploy: allergicR with: (fact: client-2 eggsC-source) as: eggs-allergic-2)
    (update: (fact: client-2 baconB-sink enabled) with: eggs-allergic-2)
    (update: (fact: client-2 chickenB-sink enabled) with: eggs-allergic-2)
    (update: (fact: client-2 vanille-iceB-sink enabled) with: milk-allergic-2)
    (update: (fact: client-2 chocolate-iceB-sink enabled) with: milk-allergic-2)

    (reactor: add-ID-itemR
              (in: button #:model  itemID customerID price)
              (def: new-itemID (map: button (lambda: button itemID)))
              (def: new-customerID (map: button (lambda: button customerID)))
              (def: new-price (map: button (lambda: button price)))
              (out: new-itemID new-customerID button new-price))
    
    (reactor: add-order-listR 
              (in: label #:model current-item-id order)
              (def: new-item-id (map: label (lambda: button-event (+ current-item-id 1))))
              (def: new-order (map: new-item-id (lambda: new-item-id (append order (list new-item-id)))))
              (out: label new-order new-item-id))
    
    (reactor: add-total-sumR
              (in: button-event #:model price total)
              (def: new-total (map: button-event (lambda: button-event (+ price total))))
              (def: label-new-total (map: new-total (lambda: new-total (number->string new-total))))
              (out: new-total label-new-total))
    

    ;FANTA
    
    (deploy: add-total-sumR with: (fact: client-1 fantaB-source) pFanta total-1 as: fanta-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: fanta-total-1 )
    (deploy: add-order-listR with: (fact: client-1 fantaB-source) currentItemID-1 order-1 as: fanta-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: fanta-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 fantaB-source) currentItemID-1 customerID-1 pFanta as: fanta-id-1)
    (add-collect1: fanta-id-1 as: drink for: 180)
    (update: currentItemID-1 nothing nothing nothing with: fanta-id-1)

    (deploy: add-total-sumR with: (fact: client-2 fantaB-source) pFanta total-2 as: fanta-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: fanta-total-2 )
    (deploy: add-order-listR with: (fact: client-2 fantaB-source) currentItemID-2 order-2 as: fanta-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: fanta-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 fantaB-source) currentItemID-2 customerID-2 pFanta as: fanta-id-2)
    (add-collect1: fanta-id-2 as: drink for: 180)
    (update: currentItemID-2 nothing nothing nothing with: fanta-id-2)


    ;COLA

    (deploy: add-total-sumR with: (fact: client-1 colaB-source) pCola total-1 as: cola-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: cola-total-1 )
    (deploy: add-order-listR with: (fact: client-1 colaB-source) currentItemID-1 order-1 as: cola-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: cola-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 colaB-source) currentItemID-1 customerID-1 pcola as: cola-id-1)
    (add-collect1: cola-id-1 as: drink for: 180)
    (update: currentItemID-1 nothing nothing nothing with: cola-id-1)

    (deploy: add-total-sumR with: (fact: client-2 colaB-source) pCola total-2 as: cola-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: cola-total-2 )
    (deploy: add-order-listR with: (fact: client-2 colaB-source) currentItemID-2 order-2 as: cola-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: cola-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 colaB-source) currentItemID-2 customerID-2 pcola as: cola-id-2)
    (add-collect1: cola-id-2 as: drink for: 180)
    (update: currentItemID-2 nothing nothing nothing with: cola-id-2)

    ;ICE TEA

    (deploy: add-total-sumR with: (fact: client-1 ice-teaB-source) pIce-tea total-1 as: ice-tea-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: ice-tea-total-1 )
    (deploy: add-order-listR with: (fact: client-1 ice-teaB-source) currentItemID-1 order-1 as: ice-tea-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: ice-tea-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 ice-teaB-source) currentItemID-1 customerID-1 pIce-tea as: ice-tea-id-1)
    (add-collect1: ice-tea-id-1 as: drink for: 180)
    (update: currentItemID-1 nothing nothing nothing with: ice-tea-id-1)

    (deploy: add-total-sumR with: (fact: client-2 ice-teaB-source) pIce-tea total-2 as: ice-tea-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: ice-tea-total-2 )
    (deploy: add-order-listR with: (fact: client-2 ice-teaB-source) currentItemID-2 order-2 as: ice-tea-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: ice-tea-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 ice-teaB-source) currentItemID-2 customerID-2 pIce-tea as: ice-tea-id-2)
    (add-collect1: ice-tea-id-2 as: drink for: 180)
    (update: currentItemID-2 nothing nothing nothing with: ice-tea-id-2)

    ;ORANGE JUICE

    (deploy: add-total-sumR with: (fact: client-1 orange-juiceB-source) pOrange-juice total-1 as: orange-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: orange-total-1 )
    (deploy: add-order-listR with: (fact: client-1 orange-juiceB-source) currentItemID-1 order-1 as: orange-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: orange-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 orange-juiceB-source) currentItemID-1 customerID-1 pOrange-juice as: orange-id-1)
    (add-collect1: orange-id-1 as: drink for: 180)
    (update: currentItemID-1 nothing nothing nothing with: orange-id-1)

    (deploy: add-total-sumR with: (fact: client-2 orange-juiceB-source) pOrange-juice total-2 as: orange-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: orange-total-2 )
    (deploy: add-order-listR with: (fact: client-2 orange-juiceB-source) currentItemID-2 order-2 as: orange-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: orange-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 orange-juiceB-source) currentItemID-2 customerID-2 pOrange-juice as: orange-id-2)
    (add-collect1: orange-id-2 as: drink for: 180)
    (update: currentItemID-2 nothing nothing nothing with: orange-id-2)

    ;BIG MAC
    
    (deploy: add-total-sumR with: (fact: client-1 big-macB-source) pBig-mac total-1 as: big-mac-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: big-mac-total-1 )
    (deploy: add-order-listR with: (fact: client-1 big-macB-source) currentItemID-1 order-1 as: big-mac-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: big-mac-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 big-macB-source) currentItemID-1 customerID-1 pBig-mac as: big-mac-id-1)
    (add-collect1: big-mac-id-1 as: burger for: 180)
    (update: currentItemID-1 nothing nothing nothing with: big-mac-id-1)

    (deploy: add-total-sumR with: (fact: client-2 big-macB-source) pBig-mac total-2 as: big-mac-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: big-mac-total-2 )
    (deploy: add-order-listR with: (fact: client-2 big-macB-source) currentItemID-2 order-2 as: big-mac-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: big-mac-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 big-macB-source) currentItemID-2 customerID-2 pBig-mac as: big-mac-id-2)
    (add-collect1: big-mac-id-2 as: burger for: 180)
    (update: currentItemID-2 nothing nothing nothing with: big-mac-id-2)

    ;VEGGIE
    
    (deploy: add-total-sumR with: (fact: client-1 veggieB-source) pVeggie total-1 as: veggie-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: veggie-total-1 )
    (deploy: add-order-listR with: (fact: client-1 veggieB-source) currentItemID-1 order-1 as: veggie-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: veggie-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 veggieB-source) currentItemID-1 customerID-1 pVeggie as: veggie-id-1)
    (add-collect1: veggie-id-1 as: burger for: 180)
    (update: currentItemID-1 nothing nothing nothing with: veggie-id-1)

    (deploy: add-total-sumR with: (fact: client-2 veggieB-source) pVeggie total-2 as: veggie-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: veggie-total-2 )
    (deploy: add-order-listR with: (fact: client-2 veggieB-source) currentItemID-2 order-2 as: veggie-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: veggie-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 veggieB-source) currentItemID-2 customerID-2 pVeggie as: veggie-id-2)
    (add-collect1: veggie-id-2 as: burger for: 180)
    (update: currentItemID-2 nothing nothing nothing with: veggie-id-2)

    ;CHICKEN

    (deploy: add-total-sumR with: (fact: client-1 chickenB-source) pChicken total-1 as: chicken-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: chicken-total-1 )
    (deploy: add-order-listR with: (fact: client-1 chickenB-source) currentItemID-1 order-1 as: chicken-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: chicken-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chickenB-source) currentItemID-1 customerID-1 pChicken as: chicken-id-1)
    (add-collect1: chicken-id-1 as: burger for: 180)
    (update: currentItemID-1 nothing nothing nothing with: chicken-id-1)

    (deploy: add-total-sumR with: (fact: client-2 chickenB-source) pChicken total-2 as: chicken-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: chicken-total-2 )
    (deploy: add-order-listR with: (fact: client-2 chickenB-source) currentItemID-2 order-2 as: chicken-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: chicken-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 chickenB-source) currentItemID-2 customerID-2 pChicken as: chicken-id-2)
    (add-collect1: chicken-id-2 as: burger for: 180)
    (update: currentItemID-2 nothing nothing nothing with: chicken-id-2)
    
    ;BACON

     (deploy: add-total-sumR with: (fact: client-1 baconB-source) pBacon total-1 as: bacon-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: bacon-total-1 )
    (deploy: add-order-listR with: (fact: client-1 baconB-source) currentItemID-1 order-1 as: bacon-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: bacon-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 baconB-source) currentItemID-1 customerID-1 pBacon as: bacon-id-1)
    (add-collect1: bacon-id-1 as: burger for: 180)
    (update: currentItemID-1 nothing nothing nothing with: bacon-id-1)

    (deploy: add-total-sumR with: (fact: client-2 baconB-source) pBacon total-2 as: bacon-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: bacon-total-2 )
    (deploy: add-order-listR with: (fact: client-2 baconB-source) currentItemID-2 order-2 as: bacon-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: bacon-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 baconB-source) currentItemID-2 customerID-2 pBacon as: bacon-id-2)
    (add-collect1: bacon-id-2 as: burger for: 180)
    (update: currentItemID-2 nothing nothing nothing with: bacon-id-2)

    ;CHOCOlATE-ICE

    (deploy: add-total-sumR with: (fact: client-1 chocolate-iceB-source) pChocolate-ice total-1 as: chocolate-ice-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: chocolate-ice-total-1 )
    (deploy: add-order-listR with: (fact: client-1 chocolate-iceB-source) currentItemID-1 order-1 as: chocolate-ice-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: chocolate-ice-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chocolate-iceB-source) currentItemID-1 customerID-1 pChocolate-ice as: chocolate-ice-id-1)
    (add-collect1: chocolate-ice-id-1 as: ice for: 180)
    (update: currentItemID-1 nothing nothing nothing with: chocolate-ice-id-1)

    (deploy: add-total-sumR with: (fact: client-2 chocolate-iceB-source) pChocolate-ice total-2 as: chocolate-ice-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: chocolate-ice-total-2 )
    (deploy: add-order-listR with: (fact: client-2 chocolate-iceB-source) currentItemID-2 order-2 as: chocolate-ice-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: chocolate-ice-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 chocolate-iceB-source) currentItemID-2 customerID-2 pChocolate-ice as: chocolate-ice-id-2)
    (add-collect1: chocolate-ice-id-2 as: ice for: 180)
    (update: currentItemID-2 nothing nothing nothing with: chocolate-ice-id-2)

    ;VANILLE-ICE

    (deploy: add-total-sumR with: (fact: client-1 vanille-iceB-source) pVanille-ice total-1 as: vanille-ice-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: vanille-ice-total-1 )
    (deploy: add-order-listR with: (fact: client-1 vanille-iceB-source) currentItemID-1 order-1 as: vanille-ice-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: vanille-ice-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 vanille-iceB-source) currentItemID-1 customerID-1 pVanille-ice as: vanille-ice-id-1)
    (add-collect1: vanille-ice-id-1 as: ice for: 180)
    (update: currentItemID-1 nothing nothing nothing with: vanille-ice-id-1)

    (deploy: add-total-sumR with: (fact: client-2 vanille-iceB-source) pVanille-ice total-2 as: vanille-ice-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: vanille-ice-total-2 )
    (deploy: add-order-listR with: (fact: client-2 vanille-iceB-source) currentItemID-2 order-2 as: vanille-ice-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: vanille-ice-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 vanille-iceB-source) currentItemID-2 customerID-2 pVanille-ice as: vanille-ice-id-2)
    (add-collect1: vanille-ice-id-2 as: ice for: 180)
    (update: currentItemID-2 nothing nothing nothing with: vanille-ice-id-2)

    ;Chicken-nuggets

    (deploy: add-total-sumR with: (fact: client-1 chicken-nuggetsB-source) pChicken-nuggets total-1 as: chicken-nuggets-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: chicken-nuggets-total-1 )
    (deploy: add-order-listR with: (fact: client-1 chicken-nuggetsB-source) currentItemID-1 order-1 as: chicken-nuggets-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: chicken-nuggets-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chicken-nuggetsB-source) currentItemID-1 customerID-1 pChicken-nuggets as: chicken-nuggets-id-1)
    (add-collect1: chicken-nuggets-id-1 as: snack for: 180)
    (update: currentItemID-1 nothing nothing nothing with: chicken-nuggets-id-1)

    (deploy: add-total-sumR with: (fact: client-2 chicken-nuggetsB-source) pChicken-nuggets total-2 as: chicken-nuggets-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: chicken-nuggets-total-2 )
    (deploy: add-order-listR with: (fact: client-2 chicken-nuggetsB-source) currentItemID-2 order-2 as: chicken-nuggets-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: chicken-nuggets-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 chicken-nuggetsB-source) currentItemID-2 customerID-2 pChicken-nuggets as: chicken-nuggets-id-2)
    (add-collect1: chicken-nuggets-id-2 as: snack for: 180)
    (update: currentItemID-2 nothing nothing nothing with: chicken-nuggets-id-2)

    ;Chicken-wings

    (deploy: add-total-sumR with: (fact: client-1 chicken-wingsB-source) pChicken-wings total-1 as: chicken-wings-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: chicken-wings-total-1 )
    (deploy: add-order-listR with: (fact: client-1 chicken-wingsB-source) currentItemID-1 order-1 as: chicken-wings-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: chicken-wings-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chicken-wingsB-source) currentItemID-1 customerID-1 pChicken-wings as: chicken-wings-id-1)
    (add-collect1: chicken-wings-id-1 as: snack for: 180)
    (update: currentItemID-1 nothing nothing nothing with: chicken-wings-id-1)

    (deploy: add-total-sumR with: (fact: client-2 chicken-wingsB-source) pChicken-wings total-2 as: chicken-wings-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: chicken-wings-total-2 )
    (deploy: add-order-listR with: (fact: client-2 chicken-wingsB-source) currentItemID-2 order-2 as: chicken-wings-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: chicken-wings-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 chicken-wingsB-source) currentItemID-2 customerID-2 pChicken-wings as: chicken-wings-id-2)
    (add-collect1: chicken-wings-id-2 as: snack for: 180)
    (update: currentItemID-2 nothing nothing nothing with: chicken-wings-id-2)

    ;cheese-corquettes

    (deploy: add-total-sumR with: (fact: client-1 cheese-croquettesB-source) pCheese-croquettes total-1 as: cheese-croquettes-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: cheese-croquettes-total-1 )
    (deploy: add-order-listR with: (fact: client-1 cheese-croquettesB-source) currentItemID-1 order-1 as: cheese-croquettes-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: cheese-croquettes-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 cheese-croquettesB-source) currentItemID-1 customerID-1 pCheese-croquettes as: cheese-croquettes-id-1)
    (add-collect1: cheese-croquettes-id-1 as: snack for: 180)
    (update: currentItemID-1 nothing nothing nothing with: cheese-croquettes-id-1)

    (deploy: add-total-sumR with: (fact: client-2 cheese-croquettesB-source) pCheese-croquettes total-2 as: cheese-croquettes-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: cheese-croquettes-total-2 )
    (deploy: add-order-listR with: (fact: client-2 cheese-croquettesB-source) currentItemID-2 order-2 as: cheese-croquettes-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: cheese-croquettes-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 cheese-croquettesB-source) currentItemID-2 customerID-2 pCheese-croquettes as: cheese-croquettes-id-2)
    (add-collect1: cheese-croquettes-id-2 as: snack for: 180)
    (update: currentItemID-2 nothing nothing nothing with: cheese-croquettes-id-2)

    ;fries-small

    (deploy: add-total-sumR with: (fact: client-1 fries-smallB-source) pFries-small total-1 as: fries-small-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: fries-small-total-1 )
    (deploy: add-order-listR with: (fact: client-1 fries-smallB-source) currentItemID-1 order-1 as: fries-small-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: fries-small-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 fries-smallB-source) currentItemID-1 customerID-1 pFries-small as: fries-small-id-1)
    (add-collect1: fries-small-id-1 as: fries for: 180)
    (update: currentItemID-1 nothing nothing nothing with: fries-small-id-1)

    (deploy: add-total-sumR with: (fact: client-2 fries-smallB-source) pFries-small total-2 as: fries-small-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: fries-small-total-2 )
    (deploy: add-order-listR with: (fact: client-2 fries-smallB-source) currentItemID-2 order-2 as: fries-small-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: fries-small-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 fries-smallB-source) currentItemID-2 customerID-2 pFries-small as: fries-small-id-2)
    (add-collect1: fries-small-id-2 as: fries for: 180)
    (update: currentItemID-2 nothing nothing nothing with: fries-small-id-2)

    ;Fries Big

    (deploy: add-total-sumR with: (fact: client-1 fries-bigB-source) pFries-big total-1 as: fries-big-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: fries-big-total-1 )
    (deploy: add-order-listR with: (fact: client-1 fries-bigB-source) currentItemID-1 order-1 as: fries-big-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: fries-big-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 fries-bigB-source) currentItemID-1 customerID-1 pFries-big as: fries-big-id-1)
    (add-collect1: fries-big-id-1 as: fries for: 180)
    (update: currentItemID-1 nothing nothing nothing with: fries-big-id-1)

    (deploy: add-total-sumR with: (fact: client-2 fries-bigB-source) pFries-big total-2 as: fries-big-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: fries-big-total-2 )
    (deploy: add-order-listR with: (fact: client-2 fries-bigB-source) currentItemID-2 order-2 as: fries-big-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: fries-big-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 fries-bigB-source) currentItemID-2 customerID-2 pFries-big as: fries-big-id-2)
    (add-collect1: fries-big-id-2 as: fries for: 180)
    (update: currentItemID-2 nothing nothing nothing with: fries-big-id-2)
    
    ;salade-small

     (deploy: add-total-sumR with: (fact: client-1 salade-smallB-source) pSalade-small total-1 as: salade-small-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: salade-small-total-1 )
    (deploy: add-order-listR with: (fact: client-1 salade-smallB-source) currentItemID-1 order-1 as: salade-small-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: salade-small-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 salade-smallB-source) currentItemID-1 customerID-1 pSalade-small as: salade-small-id-1)
    (add-collect1: salade-small-id-1 as: salade for: 180)
    (update: currentItemID-1 nothing nothing nothing with: salade-small-id-1)

    (deploy: add-total-sumR with: (fact: client-2 salade-smallB-source) pSalade-small total-2 as: salade-small-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: salade-small-total-2 )
    (deploy: add-order-listR with: (fact: client-2 salade-smallB-source) currentItemID-2 order-2 as: salade-small-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: salade-small-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 salade-smallB-source) currentItemID-2 customerID-2 pSalade-small as: salade-small-id-2)
    (add-collect1: salade-small-id-2 as: salade for: 180)
    (update: currentItemID-2 nothing nothing nothing with: salade-small-id-2)

    ;salade-big

     (deploy: add-total-sumR with: (fact: client-1 salade-bigB-source) pSalade-big total-1 as: salade-big-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: salade-big-total-1 )
    (deploy: add-order-listR with: (fact: client-1 salade-bigB-source) currentItemID-1 order-1 as: salade-big-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: salade-big-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 salade-bigB-source) currentItemID-1 customerID-1 pSalade-big as: salade-big-id-1)
    (add-collect1: salade-big-id-1 as: salade for: 180)
    (update: currentItemID-1 nothing nothing nothing with: salade-big-id-1)

    (deploy: add-total-sumR with: (fact: client-2 salade-bigB-source) pSalade-big total-2 as: salade-big-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: salade-big-total-2 )
    (deploy: add-order-listR with: (fact: client-2 salade-bigB-source) currentItemID-2 order-2 as: salade-big-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: salade-big-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 salade-bigB-source) currentItemID-2 customerID-2 pSalade-big as: salade-big-id-2)
    (add-collect1: salade-big-id-2 as: salade for: 180)
    (update: currentItemID-2 nothing nothing nothing with: salade-big-id-2)

    ;Frit-fondue

    (deploy: add-total-sumR with: (fact: client-1 frit-fondueB-source) pFrit-fondue total-1 as: frit-fondue-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: frit-fondue-total-1 )
    (deploy: add-order-listR with: (fact: client-1 frit-fondueB-source) currentItemID-1 order-1 as: frit-fondue-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: frit-fondue-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 frit-fondueB-source) currentItemID-1 customerID-1 pFrit-fondue as: frit-fondue-id-1)
    (add-collect1: frit-fondue-id-1 as: fries for: 180)
    (update: currentItemID-1 nothing nothing nothing with: frit-fondue-id-1)

    (deploy: add-total-sumR with: (fact: client-2 frit-fondueB-source) pFrit-fondue total-2 as: frit-fondue-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: frit-fondue-total-2 )
    (deploy: add-order-listR with: (fact: client-2 frit-fondueB-source) currentItemID-2 order-2 as: frit-fondue-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: frit-fondue-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 frit-fondueB-source) currentItemID-2 customerID-2 pFrit-fondue as: frit-fondue-id-2)
    (add-collect1: frit-fondue-id-2 as: fries for: 180)
    (update: currentItemID-2 nothing nothing nothing with: frit-fondue-id-2)

    ;Mayo

    (deploy: add-total-sumR with: (fact: client-1 mayoB-source) pMayo total-1 as: mayo-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: mayo-total-1 )
    (deploy: add-order-listR with: (fact: client-1 mayoB-source) currentItemID-1 order-1 as: mayo-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: mayo-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 mayoB-source) currentItemID-1 customerID-1 pMayo as: mayo-id-1)
    (add-collect1: mayo-id-1 as: saus for: 180)
    (update: currentItemID-1 nothing nothing nothing with: mayo-id-1)

    (deploy: add-total-sumR with: (fact: client-2 mayoB-source) pMayo total-2 as: mayo-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: mayo-total-2 )
    (deploy: add-order-listR with: (fact: client-2 mayoB-source) currentItemID-2 order-2 as: mayo-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: mayo-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 mayoB-source) currentItemID-2 customerID-2 pMayo as: mayo-id-2)
    (add-collect1: mayo-id-2 as: saus for: 180)
    (update: currentItemID-2 nothing nothing nothing with: mayo-id-2)

    ;Ketchup

    (deploy: add-total-sumR with: (fact: client-1 ketchupB-source) pKetchup total-1 as: ketchup-total-1)
    (update: total-1 (fact: client-1 sum-totalL-sink change-value) with: ketchup-total-1 )
    (deploy: add-order-listR with: (fact: client-1 ketchupB-source) currentItemID-1 order-1 as: ketchup-order-list-1)
    (update: (fact: client-1 orderLB-sink add) order-1 currentItemID-1 with: ketchup-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 ketchupB-source) currentItemID-1 customerID-1 pKetchup as: ketchup-id-1)
    (add-collect1: ketchup-id-1 as: saus for: 180)
    (update: currentItemID-1 nothing nothing nothing with: ketchup-id-1)

    (deploy: add-total-sumR with: (fact: client-2 ketchupB-source) pKetchup total-2 as: ketchup-total-2)
    (update: total-2 (fact: client-2 sum-totalL-sink change-value) with: ketchup-total-2 )
    (deploy: add-order-listR with: (fact: client-2 ketchupB-source) currentItemID-2 order-2 as: ketchup-order-list-2)
    (update: (fact: client-2 orderLB-sink add) order-2 currentItemID-2 with: ketchup-order-list-2)
    (deploy: add-ID-itemR with: (fact: client-2 ketchupB-source) currentItemID-2 customerID-2 pKetchup as: ketchup-id-2)
    (add-collect1: ketchup-id-2 as: saus for: 180)
    (update: currentItemID-2 nothing nothing nothing with: ketchup-id-2)

    
    
    (reactor: update-state-addR
              (in: itemIDs customerID label price #:model  order  total)
              (def: new-total (map: price (lambda: price (+ total price)))) 
              
              (def: new-order (map: itemIDs (lambda: itemIDs (append order (list itemIDs)))))
              (out: label new-total new-order ))
    

  
 
    (reactor: update-state-removeR 
              (in: itemID customerID type price #:model order total)
              (def: index (map: itemID (lambda: itemID (index-of  order itemID))))
              (def: new-order (map: index (lambda: index (remove (list-ref order index)                                                                order))))
              (def: selected (map: itemID (lambda: itemID #f)))
              (def: new-total (map: price (lambda: price (- total price))))
              (def: string-new-total (map: new-total (lambda: new-total (number->string new-total))))
              (out: new-order selected index new-total string-new-total))
    
  (reactor: nothing-reactor
            (in: i x y z)
            (out: i x y z))
            
  (forall: (fries (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing1)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-fries-1))
  
  (forall: (snack (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing2)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-snack-1))
  
  (forall: (ice (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing3)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-ice-1))
 
  
  (forall: (burger (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing4)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-burger-1))
 
  
  (forall: (drink (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing5)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-drink-1))
  
  (forall: (salade (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing6)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-salade-1))
  
  (forall: (saus (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: nothing-reactor as: nothing7)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-saus-1))


  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value) with: remove-drink-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value) with: remove-burger-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value)  with: remove-fries-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value)  with: remove-saus-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value)  with: remove-salade-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value)  with: remove-ice-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value)  with: remove-snack-1)


   (forall: (fries (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing2)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-fries-2))
  
  (forall: (snack (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing2)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-snack-2))
  
  (forall: (ice (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing3)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-ice-2))
 
  
  (forall: (burger (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing4)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-burger-2))
 
  
  (forall: (drink (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing5)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-drink-2))
  
  (forall: (salade (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing6)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-salade-2))
  
  (forall: (saus (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: nothing-reactor as: nothing7)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-saus-2))


  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value) with: remove-drink-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value) with: remove-burger-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value)  with: remove-fries-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value)  with: remove-saus-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value)  with: remove-salade-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value)  with: remove-ice-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value)  with: remove-snack-2)
  

  (reactor: add-to-order-reactor
            (in: itemIDs customerID label price #:model total order)           
            (def: new-total (map: price (lambda: price (+ total price))))
            (def: new-order (map: itemIDs (lambda: itemIDs (append  order                                                (list itemIDs)))))
            (def: string-new-total (map: new-total (lambda: new-total (number->string new-total))))
            (out: label new-total new-order string-new-total))
            
  (forall: (menu (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-1))
           (add-deploy: add-to-order-reactor total-1  order-1 as: add-menu-1)
           (remove-deploy: update-state-removeR order-1 total-1 as: remove-menu-1))

  (forall: (menu (?itemID ?customerID ?type ?price) (equal? ?customerID customerID-2))
           (add-deploy: add-to-order-reactor   total-2 order-2 as: add-menu-2)
           (remove-deploy: update-state-removeR order-2 total-2 as: remove-menu-2))

  (update: (fact: client-1 orderLB-sink add) total-1 order-1 (fact: client-1 sum-totalL-sink change-value) with: add-menu-1)
  (update: order-1 current-selected-item-1 (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value) with: remove-menu-1)


  (update: (fact: client-2 orderLB-sink add) total-2 order-2 (fact: client-2 sum-totalL-sink change-value) with: add-menu-2)
  (update: order-2 current-selected-item-2 (fact: client-2 orderLB-sink remove) total-2 (fact: client-2 sum-totalL-sink change-value) with: remove-menu-2)
 
  
  (rule: menu-saus where:
         (fries (?friesID ?customerID ?small-fries ?friesPrice) )
         (saus (?sausID ?customerID ?type ?saus-price))
         (salade (?itemIDSalade ?customerID ?small-salade ?saladePrice) )
         then: (add: (fact: menu
                            (list ?friesID ?itemIDSalade ?sausID)
                            ?customerID
                            (string-append "Menu-saus: " ?small-fries " " ?small-salade " " ?type)
                     (* (+ ?friesPrice ?saladePrice ?saus-price) 0.67));       (iff ?small 6.5 9.5))
                     for: 180))

  (rule: menu-chicken-bacon where:
         (salade (?itemIDSalade ?customerID ?small ?saladePrice) (equal? ?small "Salade Small"))
         (drink (?drinkIDDrink ?customerID ?drinkType ?drinkPrice))
         (burger (?burgerID ?customerID ?burgerType ?burgerPrice) (or
                                                                   (equal? "Bacon" ?burgerType)
                                                                   (equal? "Chicken" ?burgerType)))
         then: (add: (fact: menu
                            (list ?itemIDFries ?itemIDDrink ?itemIDBurger)
                            ?customerID
                            (string-append "Chicken-or-bacon-menu: " ?drinkType " " ?burgerType)
                            (* (+ ?saladePrice ?drinkPrice ?burgerPrice) 0.75))
                     for: 180))
  
  
  (rule: menu-veggie where:
         (fries (?itemIDFries ?customerID ?small ?friesPrice) (equal? "Fries Small" ?small))
         (drink (?itemIDDrink ?customerID ?typeDrink ?drink-price))
         (burger (?itemIDBurger ?customerID ?typeBurger ?burger-price) (equal? "Veggie"
                                                                               ?typeBurger))
         then: (add: (fact: menu
                            (list ?itemIDFries ?itemIDDrink ?itemIDBurger)
                            ?customerID
                            (string-append "menu-veggie: " ?typeDrink)
                            (* (+ ?friesPrice ?drink-price ?burger-price ) 0.60))
                     for: 180))
  
  
  
  (rule: menu-big-mac where:
         (fries (?itemIDFries ?customerID ?small ?friesPrice) )
         (drink (?itemIDDrink ?customerID ?typeDrink ?drink-price))
         (burger (?itemIDBurger ?customerID ?typeBurger ?burger-price) (equal? "Big Mac"
                                                                               ?typeBurger))
         then: (add: (fact: menu
                            (list ?itemIDFries ?itemIDDrink ?itemIDBurger)
                            ?customerID
                            (string-append "Menu-big-mac:" ?typeDrink " " ?small)
                            (* (+ ?friesPrice ?drink-price ?burger-price) 0.57)) for: 180))


  (rule: remove where:
        (burger (?itemIDBurger ?customerID ?typeBurger ?burger-price) )                                                                 
        (menu ((?itemIDFries ?itemIDDrink ?itemIDBurger ) ?customerID ?info ?price))
         then: (remove: (fact: burger  ?itemIDBurger ?customerID ?typeBurger ?burger-price)))

  (rule: remove where:
        (drink (?itemIDDrink ?customerID ?typeDrink ?drinkprice))
        (menu ((?itemIDFries ?itemIDDrink ?itemIDBurger) ?customerID ?info ?price))
         then: (remove: (fact: drink  ?itemIDDrink ?customerID ?typeDrink ?drinkprice)))
  

  (rule: remove where:
         (fries (?itemIDFries ?customerID ?small ?friesPrice) )
         (menu ((?itemIDFries ?itemIDDrink ?itemIDBurger) ?customerID ?info ?price))
         then: (remove: (fact: fries  ?itemIDFries ?customerID ?small ?friesPrice)))

  (rule: remove where:
         (salade (?itemIDSalade ?customerID ?small ?saladePrice) )
         (menu ((?otherItemID1 ?itemIDSalade ?otherItemID2) ?customerID ?info ?price))
         then: (remove: (fact: salade  ?itemIDSalade ?customerID ?small ?saladePrice)))

  (rule: remove where:
         (salade (?itemIDSalade ?customerID ?small ?saladePrice) )
         (menu ((?itemIDSalade ?otherItemID1 ?otherItemID2) ?customerID ?info ?price))
         then: (remove: (fact: salade  ?itemIDSalade ?customerID ?small ?saladePrice)))

  (rule: remove where:
         (saus (?itemIDSaus ?customerID ?small ?sausPrice) )
         (menu ((?otherItemID1 ?otherItemID2 ?itemIDSaus) ?customerID ?info ?price))
         then: (remove: (fact: saus  ?itemIDSaus ?customerID ?small ?sausPrice)))



   (add: (fact: session customerID-1) for: 20)
   (add: (fact: session customerID-2) for: 20)
  
                            

   (reactor: nothing-1-reactor
             (in: p)
             (out: p))

 
 

  (reactor: session-buttonR
   (in: event )
   (def: change (map: event (lambda: value  #t)))
   (out: change))


  
            
  (deploy: session-buttonR with: (fact: client-1 startB-source) as: start-deployed)
  (update: (fact: client-1 fantaB-sink enabled) with: start-deployed)
  (update: (fact: client-1 colaB-sink enabled) with: start-deployed)
  (update: (fact: client-1 ice-teaB-sink enabled) with: start-deployed)
  (update: (fact: client-1 orange-juiceB-sink enabled) with: start-deployed)
  (update: (fact: client-1 baconB-sink enabled) with: start-deployed)
  (update: (fact: client-1 chickenB-sink enabled) with: start-deployed)
  (update: (fact: client-1 veggieB-sink enabled) with: start-deployed)
  (update: (fact: client-1 big-macB-sink enabled) with: start-deployed)
  (update: (fact: client-1 ketchupB-sink enabled) with: start-deployed)
  (update: (fact: client-1 mayoB-sink enabled) with: start-deployed)
  (update: (fact: client-1 fries-smallB-sink enabled) with: start-deployed)
  (update: (fact: client-1 fries-bigB-sink enabled) with: start-deployed)
  (update: (fact: client-1 salade-smallB-sink enabled) with: start-deployed)
  (update: (fact: client-1 salade-bigB-sink enabled) with: start-deployed)
  (update: (fact: client-1 chicken-nuggetsB-sink enabled) with: start-deployed)
  (update: (fact: client-1 chicken-wingsB-sink enabled) with: start-deployed)
  (update: (fact: client-1 frit-fondueB-sink enabled) with: start-deployed)
  (update: (fact: client-1 cheese-croquettesB-sink enabled) with: start-deployed)
  (update: (fact: client-1 chocolate-iceB-sink enabled) with: start-deployed)
  (update: (fact: client-1 vanille-iceB-sink enabled) with: start-deployed)
  

    (reactor: clear-orderR
            (in: event)
            (def: clear-listbox (map: event (lambda: event #t)))
            (def: new-total (map: event (lambda: event 0)))
            (def: new-total-label (map: new-total (lambda: new-total "0.0")))
            (def: new-order (map: event (lambda: event (list))))
            (out: clear-listbox new-total new-total-label new-order))
    
  (reactor: clear-check-boxR
            (in: event)
            (def: new-value (map: event (lambda: event #f)))
            (out: new-value))

  
  
  (forall: (session (?customerID) (equal? customerID-1 ?customerID))
           (add-deploy: nothing-1-reactor as: nothing-1)
           (remove-deploy: clear-orderR as: session-ended-clear))

  (forall: (session (?customerID) (equal? customerID-1 ?customerID))
           (add-deploy: nothing-1-reactor as: nothing-1)
           (remove-deploy: clear-check-boxR as: session-ended-check-box-1))

  (forall: (session (?customerID) (equal? customerID-1 ?customerID))
           (add-deploy: nothing-1-reactor as: nothing-1)
           (remove-deploy: clear-check-boxR  as: session-ended-buttons))


  (deploy: clear-orderR with: (fact: client-1 startB-source) as: start-clear-order-1)
  (update:(fact: client-1 orderLB-sink clear) total-1 (fact: client-1 totalL-sink change-value)  order-1 with: start-clear-order-1)
  (update:(fact: client-1 orderLB-sink clear) total-1 (fact: client-1 totalL-sink change-value)  order-1 with: session-ended-clear)
  (update: (fact: client-1 milkC-sink change-value) with: session-ended-check-box-1)
  (update: (fact: client-1 eggsC-sink change-value) with: session-ended-check-box-1)
  (update: (fact: client-1 fantaB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 colaB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 ice-teaB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 orange-juiceB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 baconB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 chickenB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 veggieB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 big-macB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 ketchupB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 mayoB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 fries-smallB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 fries-bigB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 salade-smallB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 salade-bigB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 chicken-nuggetsB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 chicken-wingsB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 frit-fondueB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 cheese-croquettesB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 chocolate-iceB-sink enabled) with: session-ended-buttons)
  (update: (fact: client-1 vanille-iceB-sink enabled) with: session-ended-buttons)

   (deploy: session-buttonR with: (fact: client-2 startB-source) as: start-deployed-2)
  (update: (fact: client-2 fantaB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 colaB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 ice-teaB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 orange-juiceB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 baconB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 chickenB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 veggieB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 big-macB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 ketchupB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 mayoB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 fries-smallB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 fries-bigB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 salade-smallB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 salade-bigB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 chicken-nuggetsB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 chicken-wingsB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 frit-fondueB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 cheese-croquettesB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 chocolate-iceB-sink enabled) with: start-deployed-2)
  (update: (fact: client-2 vanille-iceB-sink enabled) with: start-deployed-2)
  

  
  (forall: (session (?customerID) (equal? customerID-2 ?customerID))
           (add-deploy: nothing-1-reactor as: nothing-2)
           (remove-deploy: clear-orderR as: session-ended-clear-2))

  (forall: (session (?customerID) (equal? customerID-2 ?customerID))
           (add-deploy: nothing-1-reactor as: nothing-2)
           (remove-deploy: clear-check-boxR as: session-ended-check-box-2))

  (forall: (session (?customerID) (equal? customerID-2 ?customerID))
           (add-deploy: nothing-1-reactor as: nothing-2)
           (remove-deploy: clear-check-boxR  as: session-ended-buttons-2))


  (deploy: clear-orderR with: (fact: client-2 startB-source) as: start-clear-order-2)
  (update:(fact: client-2 orderLB-sink clear) total-2 (fact: client-2 totalL-sink change-value)  order-2 with: start-clear-order-2)
  (update:(fact: client-2 orderLB-sink clear) total-2 (fact: client-2 totalL-sink change-value)  order-2 with: session-ended-clear-2)
  (update: (fact: client-2 milkC-sink change-value) with: session-ended-check-box-2)
  (update: (fact: client-2 eggsC-sink change-value) with: session-ended-check-box-2)
  (update: (fact: client-2 fantaB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 colaB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 ice-teaB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 orange-juiceB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 baconB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 chickenB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 veggieB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 big-macB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 ketchupB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 mayoB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 fries-smallB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 fries-bigB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 salade-smallB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 salade-bigB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 chicken-nuggetsB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 chicken-wingsB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 frit-fondueB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 cheese-croquettesB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 chocolate-iceB-sink enabled) with: session-ended-buttons-2)
  (update: (fact: client-2 vanille-iceB-sink enabled) with: session-ended-buttons-2)
  

  
  
  
  ))
  
  
  
