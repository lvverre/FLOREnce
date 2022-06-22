#lang racket


#|
Interface plus min underneath word
|#
 (require racket/gui/base)
(define pFanta 3.1)
(define pCoca-cola 3.1)
(define pIce-tea 3.1)
(define pOrange-juice 2.2)
(define pBig-mac 7.2)
(define pVeggie 5.1)
(define pBacon  6.5)
(define pChicken 7.1)
(define pChocolate-ice 2.2)
(define pVanille-ice 2.2)
(define pSalade-big 6.5)
(define pFries-big 4.2)
(define pSalade-small 3.5)
(define pFries-small 3.5)
(define pFrit-fondue 4.5)
(define pChicken-nuggets 4.7)
(define pChicken-wings 4.7)
(define pCheese 4.5)
(define pMayo 1.5)
(define pKetchup 1.5)



(struct food (id price) #:mutable)
(struct food-size food (info))
(struct food-menu food (info))


      
(define order '())

(define (remove-at-index-order index)
  (let loop
    ((before '())
     (after order)
     (idx 0))
    (displayln idx)
    (cond ((= idx index)
           (set! order (append before (cdr after)))
           (car after))
          (else (loop
                 (append before (list (car after)))
                 (cdr after)
                 (+ idx 1))))))


(define total 0)


(define (update-storage! add-events remove-events)
  (let ((new-storage-items (remove* remove-events  order)))
    (set! order (append add-events new-storage-items))))

 
 

(define (soft-drink?  food)
  (or (equal? (food-id food) 'Fanta)
      (equal? (food-id food) '|Coca Cola|)
      (equal? (food-id food) '|Ice Tea|)))

(define (fries? food)
  (or (equal? (food-id food) '|Fries Small| )
      (equal? (food-id food) '|Fries Big|)))
     

(define (small? food)
  (and (food-size? food)
       (food-size-info food)))



(define (get-first l)
  (if (null? l)
      #f
      (car l)))

(define (veggie? food)
    (equal? 'Veggie (food-id food)))

(define (make-detect-menu type1? type2? type3? price-function name)
  (lambda (event)
    (let-values ([(type1 type2 type3)
                  (cond ((type3? event)
                         (values (get-first (filter type1?  order))
                                 (get-first (filter type2? order))
                                 event))                
                        ((type1? event)
                          (values event
                                 (get-first (filter type2? order))
                                 (get-first (filter type3? order))))  
                        ((type2? event)
                          (values (get-first (filter type1?  order))
                                 event
                                 (get-first (filter type3? order)))))])  
                       
  (cond ((not (and type1 type2 type3))
         #f)
        (else
         
         (let ((menu (food-menu name (price-function type1 type2 type3) (list type1 type2 type3))))
         
           (update-storage! (list menu) (list type1 type2 type3))
           (displayln (* (if promo 0.5 1)(food-price menu)))
           (set! total (+ total (* (if promo 0.5 1)(food-price menu))))
           (for-each (lambda (food) (set! total (- total  (food-price food))))(list type1 type2 type3))
           
           #t))))))

(define fries-small? (lambda (item) (equal? (food-id item) '|Fries Small|)))

(define detect-chicken-nuggets-menu
  (make-detect-menu (lambda (item) (equal? (food-id item) '|Chicken Nuggets|))
                    (lambda (item) (equal? (food-id item) 'Frit&Fondue))
                    (lambda (item) (or (equal? (food-id item) '|Chocolate Ice|)
                                       (equal? (food-id item) '|Vanille Ice|)))
                    (lambda (nuggets frit ice)
                      8.1)
                    '|Chicken Nuggets Menu|))

(define detect-salade-menu
  (make-detect-menu (lambda (item) (equal? (food-id item) '|Salade Big|))
                    fries-small?
                    (lambda (item) (or (equal? (food-id item) 'Mayo)
                                       (equal? (food-id item) 'Ketchup)))
                    (lambda (salade fries saus)9.4)
                    '|Salade Menu|))





(define detect-menu-veggie 
   (make-detect-menu (lambda (item) (equal? (food-id item) '|Fries Big|))
                     soft-drink?
                    (lambda (item)  (equal? (food-id item) 'Veggie))
                    (lambda (fries drink burger) 8.4)
                    '|Veggie Menu|))


 
(define detect-menu-big-mac 
   (make-detect-menu fries?
                     soft-drink?
                    (lambda (item)  (equal? (food-id item) '|Big Mac|))
                    (lambda (fries drink burger) (if (small? fries) 11.2 12.4))
                    '|Big Mac Menu|))
  



(define (add-food food)
  (set! order (append order (list food)))
  (set! total (+ (food-price food) total))
  (send order-list-box append (symbol->string (food-id food)))
  (send total-message set-label (number->string total)))

(define (process-food-button event)
  (match event
          ('Mayo
           (let ((item (food event pMayo)))
             (add-food item)
             (detect-salade-menu item)))
          ('Ketchup
           (let ((item (food event pKetchup)))
             (add-food item)
             (detect-salade-menu item)))
          ('Fanta
           (let ((item (food event pFanta)))
             (add-food item)
             (or (detect-menu-veggie item)
                 (detect-menu-big-mac item)
                 )))
          ('|Coca Cola|
           (let ((item (food event pCoca-cola)))
             (add-food item)
             (or  (detect-menu-veggie item)
                  (detect-menu-big-mac item))))
          ('|Ice Tea|
           (let ((item (food event pIce-tea)))
             (add-food item)
             (or  (detect-menu-veggie item)
                  (detect-menu-big-mac item))))
          ('|Orange Juice| (add-food (food event pOrange-juice)))
          ('|Big Mac|
           (let ((item (food event pBig-mac)))
             (add-food item)
             (detect-menu-big-mac item)
             ))
          ('Veggie
           (let ((item (food event pVeggie)))
             (add-food item)
             (detect-menu-veggie item)))
          ('Bacon
           (let ((item (food event pBacon)))
             (add-food item)
             ;(detect-menu-veggie item)
             ))
          ('Chicken
           (let ((item (food event pChicken)))
             (add-food item)
             
             ;(detect-menu-veggie item)
             ))
          ('|Chicken Wings| (add-food (food event pChicken-wings)))
          ('|Chicken Nuggets|
           (let ((item (food event pChicken-nuggets)))
             (add-food item)
             (detect-chicken-nuggets-menu item)))
          ('Cheese (add-food (food event pCheese)))
          ('|Fries Small|
           (let ((item (food-size event pFries-small #t)))
             (add-food item)
             (or  (detect-menu-veggie item)
                  (detect-menu-big-mac item)
                  (detect-salade-menu item))))
          ('|Fries Big|
           (let ((item (food-size event pFries-big #f)))
             (add-food item)
             
                  (detect-menu-big-mac item)))
          ('Frit&Fondue
            (let ((item (food event pFrit-fondue)))
             (add-food item)
             (detect-chicken-nuggets-menu item)))
          ('|Vanille Ice|
            (let ((item (food event pVanille-ice)))
             (add-food item)
             (detect-chicken-nuggets-menu item)))
          ('|Chocolate Ice|
            (let ((item (food event pChocolate-ice)))
             (add-food item)
             (detect-chicken-nuggets-menu item)))
          ('|Salade Big|
           (let ((item (food-size event pSalade-big #f )))
             (add-food item)
             (detect-salade-menu item)))
          ('|Salade Small| (add-food (food-size event pSalade-small #t))))
    (send total-message set-label (number->string total))
    (send order-list-box set (map (lambda (item)
                                    (symbol->string (food-id item)))order)))
  
     
     





    




(define customerID 0)

  

(define event-id 0)

(define frame (new frame% [label "Electronic menu"] [width 800] [height 800] ))
(define panel (new vertical-panel%  [alignment (list 'left 'top)] [parent frame][style (list 'auto-vscroll 'auto-hscroll)]))
(define button-panel (new vertical-panel%  [parent panel][alignment (list 'left 'top)][min-height 500][style (list 'auto-vscroll 'auto-hscroll) ]))
#|Layers|#
(define drink-message (new message% [parent button-panel]  [label "DRINK"]))
(define drink-layer (new horizontal-panel% [parent button-panel]   [style (list 'auto-hscroll)]))
(define burger-message (new message% [parent button-panel]  [label "BURGER"]))
(define burger-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define dessert-message (new message% [parent button-panel]  [label "DESSERT"]))
(define dessert-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define snack-message (new message% [parent button-panel]  [label "SNACK"]))
(define snack-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define salade-message (new message% [parent button-panel]  [label "SALADE"]))
(define salade-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define saus-message (new message% [parent button-panel]  [label "SAUS"]))
(define saus-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define fries-message (new message% [parent button-panel]  [label "FRIES"]))
(define fries-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))


(define current-selected-index #f)
(define (select-remove-order list-box event)
  (let ((indexs (send list-box get-selections)))
    (displayln indexs)
    (set! current-selected-index (car indexs))))
(define order-list-box (new list-box% [parent panel] [min-width 200] [min-height 200] [choices '()][label "ORDER"] [callback select-remove-order]))

(define (remove-from-order button event)
  (when current-selected-index
    (send order-list-box delete current-selected-index)
    (let ((remove-item (remove-at-index-order current-selected-index)))
      
      (set! total (- total (food-price remove-item)))
      (displayln total)
      (send total-message set-label (number->string total)))))

(define remove-button (new button% [parent panel] [label "REMOVE"][callback remove-from-order]))
(define total-panel (new horizontal-panel% [parent panel] ))
(define message (new message% [label "Total: "] [parent total-panel] ))
(define total-message (new message% [label "0"] [auto-resize #t] [parent total-panel]))
(define end-session (new horizontal-panel% [parent panel] ))
(define reset-button-function (lambda (button event) (reset)))
(define abort-button (new button% [parent end-session] [label "ABORT"][callback reset-button-function]))
(define payer-button (new button% [parent end-session] [label "PAYER"][callback reset-button-function]))




(define (make-food-buttons labels prices layer)
  (define (make-button type price)
    (define food-layer (new vertical-panel% [parent layer] [min-width 20] [stretchable-width #f]))
    (define message-layer (new horizontal-panel% [parent food-layer]))
    (define price-message (new message% [parent message-layer] [min-width 150][label (string-append (symbol->string type) ": €" (number->string price))]))
    (define button-layer (new horizontal-panel% [parent food-layer]))
    (define plus-button  (new button% [parent button-layer] [label "+"] [callback (lambda (button event)
                                                                                    (process-food-button type))]))
    plus-button )
  (map make-button labels prices))

(define drink-buttons (make-food-buttons '(Fanta |Coca Cola| |Ice Tea| |Orange Juice|)
                                         (list pFanta pCoca-cola pIce-tea pOrange-juice)
                                         drink-layer))
(define burgers-buttons (make-food-buttons '(|Big Mac| Veggie Bacon Chicken)
                                         (list pBig-mac pVeggie pBacon pChicken)
                                         burger-layer))

(define dessert-buttons (make-food-buttons '(|Chocolate Ice| |Vanille Ice|)
                                         (list pChocolate-ice pVanille-ice )
                                         dessert-layer))
(define snack-buttons (make-food-buttons '(|Chicken Wings| |Chicken Nuggets| Cheese)
                                         (list pChicken-wings pChicken-nuggets pCheese)
                                         snack-layer))
(define fries-buttons (make-food-buttons '(|Fries Big| |Fries Small| Frit&Fondue)
                                         (list pFries-big pFries-small pFrit-fondue)
                                         fries-layer))
(define salade-buttons (make-food-buttons '(|Salade Big| |Salade Small|)
                                         (list pSalade-big pSalade-small )
                                         salade-layer))
(define saus-buttons (make-food-buttons '(Mayo Ketchup)
                                         (list pMayo pKetchup)
                                         saus-layer))


  

#|ALLERGICS|#
(define allergic-layer  (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define (make-check-box name buttons-to-effect)
  (new check-box% [label name] [parent allergic-layer]
       [callback (lambda (check-box event)
                   (send timer start 10000)
                   (let ((allergic-on? (send check-box get-value)))
                     (for-each (lambda (button)                                                                        
                                 (send button  enable (not allergic-on?)))
                                                                                  
                               buttons-to-effect)))]))



(define check-boxes (map make-check-box
                        (list "MILK: " "EGGS: ")
                        (list dessert-buttons burgers-buttons)))

  
  (define reset (lambda ()
                                               (set! order '())
                                               (set! total 0)
                                               (for-each (lambda (button)
                                                           (send button enable #t))
                                                         (append dessert-buttons burgers-buttons))
                                               (for-each (lambda (check-box)
                                                           (send check-box set-value #f))
                                                         check-boxes)
                                               (send order-list-box clear)
                                               
                                       
                                             ))
  
  (define timer (new timer% [notify-callback reset]))
(define promo #t)
(define timer-promo (new timer% [notify-callback (lambda ()
                                                   (cond (promo
                                                          (set! promo #f)
                                                          (send timer-promo start 400000 #t))
                                                         (else
                                                          (set! promo #t)
                                                          (send timer-promo start 200000 #t))))]))
                                                          
 


(define (give-promo)
  (for-each (lambda (item)
              (when (food-menu item)
                (set-food-price! item (* (food-price 0.5)))))
            order)
  )
            

 
                                        
(send timer start  100000)
(send timer-promo start 100000 #t)

  (send frame show #t)



;fries, burger, ice cream, 