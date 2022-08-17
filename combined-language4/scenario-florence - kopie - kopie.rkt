#lang reader "reader.rkt"
(main:
 (model:
  (def: nothing1 #f)
  (def: client1-start-time 2)
  
  (def: small? #t)
  (def: big? #f) 
  (def: customerID-1 1)
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

  (def: customerID 2)
  (def: currentItemID-1 0)
  (def: total-1 0)
  (def: first 0)
  (def: reduction-price -3)
  (def: promoC #t)
  (def: promoE #t)
)
 
 (view:
  (def-window: client-1
    (def: timer-source timer-sink (timer 10))
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
    (def: frit-fondueB-source frit-fondueB-sink (button 270 370 100 30 "Frit&Fondue"))
  ;SALADE
    (def: saladeL-sink (message 0 430  100 20 "SALADES"))
    (def: salade-smallL-sink (message 35 480 100 20 "€ 3.5"))
    (def: salade-smallB-source salade-smallB-sink (button 0 450 100 30 "Salade Small"))
    (def: salade-bigL-sink (message 170 480 100 20 "€ 6.5"))
    (def: salade-bigB-source salade-bigB-sink (button 135 450 100 30 "Salade Big"))
    ;SAUS
    (def: sausL-sink (message 0 510 100 20 "SAUS"))
    (def: mayoL-sink (message 35 560 100 20 "€ 1.5"))
    (def: mayoB-source mayoB-sink (button 0 530 100 30 "Mayo"))
    (def: ketchupL-sink (message 170 560 100 20 "€ 1.5"))
    (def: ketchupB-source ketchupB-sink (button 135 530 100 30 "Ketchup"))
    ;ALLERGIC
    (def: allergicL-sink (message 0 590 100 20 "ALLERGICS"))
    (def: milkC-source milkC-sink (check-box 0 610 40 50 "Milk"))
    (def: eggsC-source eggsC-sink (check-box 55 610 40 50 "Eggs"))
 
  
    ;ORDER
    (def: orderLB-source orderLB-sink (list-box 0 680 700 200 "ORDER: " (list)))
    
    (def: promoL-sink (message 0 925 50 20 "ACTION"))
    (def: promoTC-source promoTC-sink (text-field 0 945 100 30 "Promo Code"))
  ;TOTAL
    (def: totalL-sink (message 0 975 50 20 "Total: "))
    (def: sum-totalL-sink (message 50 995 50 20 "0"))
    (def: payerB-source payerB-sink (button 0 1015 60 30 "Payer"))
   
    )

  (def: customerC-source customerC-sink (check-box 0 10 100 30 "Client screen 1"))
  (def: promoTE-source promoTE-sink (text-field 0 40 100 30 "Promo field")) 
  )
 (react:

 (reactor: pass1-R
             (in: p)
             (out: p))

  (deploy: pass1-R with: (fact: main customerC-source) as: show-client-1)
  (update: (fact: client-1 show) with: show-client-1)

  (reactor: checkInput-R
            (in: string #:model already-used)
            (def: string-allowed
              (filter: string (lambda: string (and  already-used
                                                    (equal? (string-length string) 4)))))
            (out: string-allowed))

  (deploy: checkInput-R with: (fact: client-1 promoTC-source)  promoC as: add-codeC)
  (deploy: checkInput-R with: (fact: main promoTE-source) promoE as: add-codeE)
  (add-collect1: add-codeC as: promoC for: 1)
  (add-collect1: add-codeE as: promoE for: 7000)  
  (update: (fact: client-1 promoTC-sink clear) with: add-codeC)
  (update: (fact: main promoTE-sink clear) with: add-codeE)

  (reactor: update-totalR
            (in: ID #:model total price)
            (def: new-total (map: ID (lambda: ID (+ total price))))
            (def: new-total-string (map: new-total (lambda: total (number->string total))))
            (def: promo (map: ID (lambda: ID #f)))
            (out: new-total new-total-string promo))
            
  (rule: promo where: (promo (?id))(promoC (?id)) then: (remove: (fact: promoC ?id)))
  (rule: promo where: (promo (?id))(promoE (?id))then: (remove: (fact: promoE ?id)))
  (rule: promo where: (promoC (?id)) (promoE (?id )) then: (add: (fact: promo ?id) for: 1))

  (forall: (promo (?id))
           (add-deploy: update-totalR total-1 reduction-price as: update-total)
           (remove-deploy: pass1-R as: n1))
  
  (update: total-1 (fact: client-1 sum-totalL-sink change-value) promoC with: update-total)

  (reactor: removeFromListItemIDR
            (in: ID)
            (def: anything (map: ID (lambda: ID ?)))
            (out: ID anything anything anything))
 
  (deploy:  removeFromListItemIDR with: (fact: client-1 orderLB-source) as: removeItemID)
  (remove-collect1: removeItemID as: food)
  (remove-collect1: removeItemID as: food-menu)

  (reactor: reverse-R
             (in: val)
             (def: reverse (map: val (lambda: val (not val))))
             (out: reverse))
    
  (deploy: reverse-R with: (fact: client-1 milkC-source) as: milk-allergic-1)
  (deploy: reverse-R with: (fact: client-1 eggsC-source) as: eggs-allergic-1)
  (update: (fact: client-1 baconB-sink enabled) with: eggs-allergic-1)
  (update: (fact: client-1 chickenB-sink enabled) with: eggs-allergic-1)
  (update: (fact: client-1 vanille-iceB-sink enabled) with: milk-allergic-1)
  (update: (fact: client-1 chocolate-iceB-sink enabled) with: milk-allergic-1)

  (reactor: add-ID-itemR
            (in: button #:model  itemID customerID price)
            (def: new-itemID (map: button (lambda: button (string-append ":" (number->string itemID) ":"))))
            (def: new-customerID (map: button (lambda: button customerID)))
            (def: new-price (map: button (lambda: button price)))
            (out: new-itemID new-customerID button new-price))
    
  (reactor: update-IDR 
            (in: label #:model current-item-id )
            (def: new-item-id (map: label (lambda: button-event (+ current-item-id 1))))
            (out: new-item-id))  

    ;FANTA
    
    (deploy: update-IDR with: (fact: client-1 fantaB-source) currentItemID-1 as: fanta-order-list-1)
    (update:  currentItemID-1 with: fanta-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 fantaB-source) currentItemID-1 customerID-1 pFanta as: fanta-id-1)
    (add-collect1: fanta-id-1 as: food for: 180)
   
    ;COLA

    (deploy: update-IDR with: (fact: client-1 colaB-source) currentItemID-1  as: cola-order-list-1)
    (update:  currentItemID-1 with: cola-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 colaB-source) currentItemID-1 customerID-1 pCola as: cola-id-1)
    (add-collect1: cola-id-1 as: food for: 180)
   
    ;ICE TEA
    
    (deploy: update-IDR with: (fact: client-1 ice-teaB-source) currentItemID-1  as: ice-tea-order-list-1)
    (update:   currentItemID-1 with: ice-tea-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 ice-teaB-source) currentItemID-1 customerID-1 pIce-tea as: ice-tea-id-1)
    (add-collect1: ice-tea-id-1 as: food for: 180)
   
    ;ORANGE JUICE

    (deploy: update-IDR with: (fact: client-1 orange-juiceB-source) currentItemID-1  as: orange-order-list-1)
    (update:   currentItemID-1 with: orange-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 orange-juiceB-source) currentItemID-1 customerID-1 pOrange-juice as: orange-id-1)
    (add-collect1: orange-id-1 as: food for: 180)
  
    ;BIG MAC
    
    (deploy: update-IDR with: (fact: client-1 big-macB-source) currentItemID-1  as: big-mac-order-list-1)
    (update:   currentItemID-1 with: big-mac-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 big-macB-source) currentItemID-1 customerID-1 pBig-mac as: big-mac-id-1)
    (add-collect1: big-mac-id-1 as: food for: 180)
   
    ;VEGGIE
    
    (deploy: update-IDR with: (fact: client-1 veggieB-source) currentItemID-1  as: veggie-order-list-1)
    (update: currentItemID-1 with: veggie-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 veggieB-source) currentItemID-1 customerID-1 pVeggie as: veggie-id-1)
    (add-collect1: veggie-id-1 as: food for: 180)
   
    ;CHICKEN

    (deploy: update-IDR with: (fact: client-1 chickenB-source) currentItemID-1  as: chicken-order-list-1)
    (update:   currentItemID-1 with: chicken-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chickenB-source) currentItemID-1 customerID-1 pChicken as: chicken-id-1)
    (add-collect1: chicken-id-1 as: food for: 180)
   
    ;BACON

    (deploy: update-IDR with: (fact: client-1 baconB-source) currentItemID-1  as: bacon-order-list-1)
    (update:  currentItemID-1 with: bacon-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 baconB-source) currentItemID-1 customerID-1 pBacon as: bacon-id-1)
    (add-collect1: bacon-id-1 as: food for: 180)
    
    ;CHOCOlATE-ICE

    (deploy: update-IDR with: (fact: client-1 chocolate-iceB-source) currentItemID-1  as: chocolate-ice-order-list-1)
    (update:   currentItemID-1 with: chocolate-ice-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chocolate-iceB-source) currentItemID-1 customerID-1 pChocolate-ice as: chocolate-ice-id-1)
    (add-collect1: chocolate-ice-id-1 as: food for: 180)
    
    ;VANILLE-ICE

    (deploy: update-IDR with: (fact: client-1 vanille-iceB-source) currentItemID-1  as: vanille-ice-order-list-1)
    (update:   currentItemID-1 with: vanille-ice-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 vanille-iceB-source) currentItemID-1 customerID-1 pVanille-ice as: vanille-ice-id-1)
    (add-collect1: vanille-ice-id-1 as: food for: 180)
    (update: currentItemID-1 nothing1 nothing1 nothing1 with: vanille-ice-id-1)

   ;Chicken-nuggets

    (deploy: update-IDR with: (fact: client-1 chicken-nuggetsB-source) currentItemID-1  as: chicken-nuggets-order-list-1)
    (update:  currentItemID-1 with: chicken-nuggets-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chicken-nuggetsB-source) currentItemID-1 customerID-1 pChicken-nuggets as: chicken-nuggets-id-1)
    (add-collect1: chicken-nuggets-id-1 as: food for: 180)
   
    ;Chicken-wings

    (deploy: update-IDR with: (fact: client-1 chicken-wingsB-source) currentItemID-1  as: chicken-wings-order-list-1)
    (update:   currentItemID-1 with: chicken-wings-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 chicken-wingsB-source) currentItemID-1 customerID-1 pChicken-wings as: chicken-wings-id-1)
    (add-collect1: chicken-wings-id-1 as: food for: 180)
   
    ;cheese-corquettes

    (deploy: update-IDR with: (fact: client-1 cheese-croquettesB-source) currentItemID-1  as: cheese-croquettes-order-list-1)
    (update:  currentItemID-1 with: cheese-croquettes-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 cheese-croquettesB-source) currentItemID-1 customerID-1 pCheese-croquettes as: cheese-croquettes-id-1)
    (add-collect1: cheese-croquettes-id-1 as: food for: 180)
   
    ;fries-small

    (deploy: update-IDR with: (fact: client-1 fries-smallB-source) currentItemID-1  as: fries-small-order-list-1)
    (update: currentItemID-1 with: fries-small-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 fries-smallB-source) currentItemID-1 customerID-1 pFries-small as: fries-small-id-1)
    (add-collect1: fries-small-id-1 as: food for: 180)
   
    ;Fries Big

    (deploy: update-IDR with: (fact: client-1 fries-bigB-source) currentItemID-1  as: fries-big-order-list-1)
    (update:   currentItemID-1 with: fries-big-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 fries-bigB-source) currentItemID-1 customerID-1 pFries-big as: fries-big-id-1)
    (add-collect1: fries-big-id-1 as: food for: 180)
  
  ;salade-small

    (deploy: update-IDR with: (fact: client-1 salade-smallB-source) currentItemID-1  as: salade-small-order-list-1)
    (update:   currentItemID-1 with: salade-small-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 salade-smallB-source) currentItemID-1 customerID-1 pSalade-small as: salade-small-id-1)
    (add-collect1: salade-small-id-1 as: food for: 180)

    ;salade-big

    (deploy: update-IDR with: (fact: client-1 salade-bigB-source) currentItemID-1  as: salade-big-order-list-1)
    (update:   currentItemID-1 with: salade-big-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 salade-bigB-source) currentItemID-1 customerID-1 pSalade-big as: salade-big-id-1)
    (add-collect1: salade-big-id-1 as: food for: 180)
   
    ;Frit-fondue

    (deploy: update-IDR with: (fact: client-1 frit-fondueB-source) currentItemID-1  as: frit-fondue-order-list-1)
    (update: currentItemID-1 with: frit-fondue-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 frit-fondueB-source) currentItemID-1 customerID-1 pFrit-fondue as: frit-fondue-id-1)
    (add-collect1: frit-fondue-id-1 as: food for: 180)
    
   ;Mayo
    
    (deploy: update-IDR with: (fact: client-1 mayoB-source) currentItemID-1  as: mayo-order-list-1)
    (update:   currentItemID-1 with: mayo-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 mayoB-source) currentItemID-1 customerID-1 pMayo as: mayo-id-1)
    (add-collect1: mayo-id-1 as: food for: 180)
    

      ;Ketchup

    (deploy: update-IDR with: (fact: client-1 ketchupB-source) currentItemID-1  as: ketchup-order-list-1)
    (update:   currentItemID-1 with: ketchup-order-list-1)
    (deploy: add-ID-itemR with: (fact: client-1 ketchupB-source) currentItemID-1 customerID-1 pKetchup as: ketchup-id-1)
    (add-collect1: ketchup-id-1 as: food for: 180)
    


    (reactor: update-state-addR
              (in: itemIDs customerID label price #:model    total)
              (def: new-total (map: price (lambda: price (+ total price))))
              (def: new-total-string (map: new-total (lambda: total (number->string total))))
              (out: label itemIDs new-total new-total-string))
    
 
    (reactor: update-state-removeR 
              (in: itemID customerID label price #:model  total)
              (def: new-total (map: price (lambda: price (- total price))))
              (def: string-new-total (map: new-total (lambda: new-total (number->string new-total))))
              (out: itemID new-total string-new-total))

 (forall: (food (?itemID ?customerID ?type ?price))
           (add-deploy: update-state-addR total-1   as: add-menu-1)
           (remove-deploy: update-state-removeR  total-1 as: remove-menu-1))

  (forall: (food-menu (?itemID ?customerID ?type ?price))
           (add-deploy: update-state-addR total-1   as: add-menu-2)
           (remove-deploy: update-state-removeR  total-1 as: remove-menu-2))
   
    
  (rule: menu-saus where:
         (food (?friesID ?customerID "Fries Small" ?friesPrice))
         (food (?sausID ?customerID ?type ?saus-price) (or (equal? "Mayo" ?type) (equal? ?type "Ketchup")))
         then: (add: (fact: food-menu
                             (string-append ":"?friesID":" ?sausID":")
                            ?customerID
                            (string-append "Menu-saus: Small Fries "  ?type)
                            (* (+ ?friesPrice ?saus-price) 0.90))   for: 180))

  
  (rule: menu-veggie where:
         (food (?itemIDSalade ?customerID "Salade Small" ?saladePrice))
         (food (?itemIDDrink ?customerID "Orange Juice" ?drink-price))
         (food (?itemIDBurger ?customerID "Veggie" ?burger-price))
         then: (add: (fact: food-menu
                            (string-append ":"?itemIDSalade":" ?itemIDDrink":"?itemIDBurger":")
                            ?customerID
                            "Menu Veggie"
                            (* (+ ?saladePrice ?drink-price ?burger-price ) 0.85))
                     for: 180))

    (rule: menu-bacon where:
         (food (?itemIDIce ?customerID "Vanille Ice" ?icePrice))
         (food (?itemIDDrink ?customerID "Ice Tea" ?drink-price))
         (food (?itemIDBurger ?customerID ?typeBurger ?burger-price) (or (equal? ?typeBurger "Bacon")
                                                                         (equal? ?typeBurger "Chicken")))
         then: (add: (fact: food-menu
                            (string-append ":"?itemIDIce":" ?itemIDDrink":"?itemIDBurger":")
                            ?customerID
                            (string-append "Menu-Bacon-Chicken: " ?typeBurger)
                            (* (+ ?saladePrice ?drink-price ?burger-price ) 0.60))
                     for: 180))
  
  (rule: menu-big-mac where:
         (food (?itemIDFries ?customerID "Fries Big" ?friesPrice) )
         (food (?itemIDSalade ?customerID "Salade Big" ?saladePrice) )
         (food (?itemIDIce ?customerID "Chocolate Ice" ?ice-price) )
         (food (?itemIDBurger ?customerID "Big Mac" ?burger-price))
         then: (add: (fact: food-menu
                            (string-append ":" ?itemIDFries ":" ?itemIDIce ":" ?itemIDBurger ":" ?itemIDSalade ":")
                            ?customerID
                            "Menu-big-mac"
                            (* (+ ?friesPrice ?ice-price ?burger-price ?saladePrice) 0.70)) for: 180))

   (rule: menu-snack where:
         (food (?itemIDs ?customerID "Frit&Fondue" ?friesPrice) )
         (food (?itemIDSalade ?customerID "Salade Big" ?saladePrice) )
         (food (?itemIDDrink ?customerID "Coca Cola" ?drink-price))
         (food (?itemIDSnack ?customerID "Chicken Wings" ?snack-price))
         (food (?itemIDSnack2 ?customerID ?typeSnack ?snack2-price) (or (equal? "Chicken Nuggets" ?typeSnack)
                                                                        (equal? "Cheese Croquettes" ?typeSnack )))
         then: (add: (fact: food-menu
                            (string-append ":" ?itemIDFries ":" ?itemIDDrink ":" ?itemIDSnack2 ":" ?itemIDSalade ":" ?itemIDSnack)
                            ?customerID
                            (string-append "Menu-snack:" ?typeSnack)
                            (* (+ ?friesPrice ?drink-price ?snack2-price ?saladePrice ?snack-price) 0.60)) for: 180))


  (rule: remove where:
         (food (?itemID ?customerID ?type ?price))
         (food-menu (?itemID-menu ?customerID ?type-menu ?price-menu) (string-contains? ?itemID-menu ?itemID))
         then: (remove: (fact: food  ?itemID ?customerID ?type ?price)))


 
  
  (update: (fact: client-1 orderLB-sink add) total-1  (fact: client-1 sum-totalL-sink change-value) with: add-menu-1)
  (update: (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value) with: remove-menu-1)
  (update: (fact: client-1 orderLB-sink add) total-1  (fact: client-1 sum-totalL-sink change-value) with: add-menu-2)
  (update: (fact: client-1 orderLB-sink remove) total-1 (fact: client-1 sum-totalL-sink change-value) with: remove-menu-2)
  
  
  (reactor: session-buttonR
   (in: event )
   (def: change (map: event (lambda: value  #t)))
   (out: change))

  (reactor: session-resetR
            (in: event #:model customerID)
            (def: interval (map: event (lambda: event 180)))
            (def: new-customerID (map: event (lambda: event (+ customerID))))
            (out: interval new-customerID))

  (deploy: session-resetR with: (fact: client-1 startB-source) customerID-1 as: reset)
  (update: (fact: client-1 timer-sink start) customerID-1 with: reset)
  
            
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
  (update: (fact: client-1 eggsC-sink enabled) with: start-deployed)
  (update: (fact: client-1 milkC-sink enabled) with: start-deployed)
  (update: (fact: client-1 promoTC-sink enabled) with: start-deployed)
  (update: (fact: client-1 orderLB-sink enabled)  with: start-deployed)
  (update: (fact: client-1 payerB-sink enabled)  with: start-deployed)
  (update: promoC with: start-deployed)
  
  (reactor: sessionEndedER
            (in: time #:model start-time)
            (def: in-session (filter: time (lambda: time (> start-time 0))))
            (def: session-ended (filter: in-session (lambda: cTime (> cTime start-time))))
            (def: state (map: session-ended (lambda: time #f)))
            (out: state))

  (reactor: clear-textR
            (in: time #:model start-time )
            (def: in-session (filter: time (lambda: time (> start-time 0))))
            (def: session-ended (filter: in-session (lambda: cTime (> cTime start-time))))
            (def: result (map: session-ended (lambda: val "")))
            (out: result))
  
    (reactor: clear-orderR
            (in: time #:model start-time )
            (def: in-session (filter: time (lambda: time (> start-time 0))))
            (def: session-ended (filter: in-session (lambda: cTime (> cTime start-time))))
            (def: clear-listbox (map: session-ended (lambda: event #t)))
            (def: new-total (map: session-ended (lambda: event 0)))
            (def: new-total-label (map: new-total (lambda: new-total "0.0")))          
            (out: clear-listbox new-total new-total-label))

    (deploy: clear-textR with: (fact: client-1 timer-source) client1-start-time as: sessionEndedTEXT)
    (update: (fact: client-1 promoTC-sink clear) with: sessionEndedTEXT)
    (deploy: clear-orderR with: (fact: client-1 timer-source) client1-start-time as: sessionEndedEL)
    (update: (fact: client-1 orderLB-sink clear) total-1 (fact: client-1 sum-totalL-sink change-value) with: sessionEndedEL)

  (deploy: sessionEndedER with: (fact: client-1 timer-source) client1-start-time as: sessionEndedED)
  (update: (fact: client-1 orderLB-sink enabled)  with: sessionEndedED)
  (update: (fact: client-1 fantaB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 colaB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 ice-teaB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 orange-juiceB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 baconB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 chickenB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 veggieB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 big-macB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 ketchupB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 mayoB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 fries-smallB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 fries-bigB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 salade-smallB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 salade-bigB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 chicken-nuggetsB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 chicken-wingsB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 frit-fondueB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 cheese-croquettesB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 chocolate-iceB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 vanille-iceB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 promoTC-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 payerB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 orderLB-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 milkC-sink change-value) with: sessionEndedED)
  (update: (fact: client-1 eggsC-sink change-value) with: sessionEndedED)
  (update: (fact: client-1 milkC-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 eggsC-sink enabled) with: sessionEndedED)
  (update: (fact: client-1 timer-sink stop) with: sessionEndedED)

))
  
  
  
