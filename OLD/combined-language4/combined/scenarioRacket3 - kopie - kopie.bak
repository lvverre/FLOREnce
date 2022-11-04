#lang racket
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


#|DATABASE|#
(struct database (tables) #:mutable #:transparent)
(struct table (data) #:mutable #:transparent)
(define tuple list)


  

(define current-database (database '()))

(define (get-table table-name)
  
  (cdr (assoc table-name (database-tables current-database)) ))

(define (insert-into! table-name id . args)
  (let ((table (get-table table-name)))
    (set-table-data! table
                     (cons (cons id args) (table-data table)))))

(define (delete-from! table-name constraint)
  (define table (get-table table-name))
  (set-table-data! table
                   (for/list ([tuple (table-data table)]
                              #:when (not (apply constraint tuple)))
                     tuple)))
                     

(define (select-where table constraint)
  (for/first ([tuple (table-data (get-table table))]
              #:when (apply constraint tuple))
    tuple))
             

(define (create-table! table-name)
  (set-database-tables! current-database (cons (cons table-name (table '()))
                                               (database-tables current-database))))

(define (drop-table! table-name)
   (set-database-tables! current-database
                         (for/list ([table (database-tables current-database)]
                                    #:when (not (eq? (car table) table-name)))
                           table)))

#|PROMO|#

(define total  0)
(define total-message '())
(define promo #t)
(define  promo-s (make-semaphore 1))


(define (add-new-promoE! promo time)
  (insert-into! 'employee-promo promo time))


(define (check-promoE promo)
  (if promo
    (let ((result (select-where 'employee-promo (lambda (promoE time) (eq? promoE promo)))))
      (delete-from! 'employee-promo (lambda (promoE time) (eq? (car result ) promoE)))
      #t)
    #f))
    

(create-table! 'order)


(create-table! 'employee-promo)


  #| PATTERN MATCHING |#
 


(define (veggie? food price idx)
  (equal? 'Veggie food))
(define (orange-juice? food price idx)
  (equal? '|Orange Juice| food))

(define (salade-small? food price idx)
  (equal? '|Salade Small| food))

(define (vanille-ice? food price idx)
  (equal? '|Vanille Ice| food))

(define (bacon-or-chicken? food price idx)
  (or (equal? 'Bacon food)
      (equal? 'Chicken food)))

(define (ice-tea? food price idx)
  (equal? food '|Ice Tea|))


(define (find-food type? )
  (select-where 'order type?))

(define food-type car)
(define food-price cadr)
(define food-id caddr)


(define (make-new-type name foods)
  (string->symbol
   (foldl (lambda (item acc)
            (string-append acc " " (symbol->string (food-type item))))
          (string-append (symbol->string name) ":")
          foods)))

(define (check-for-menu-saus food price)
  (define (saus? food price idx)
    (or (equal? 'Mayo food)
        (equal? 'Ketchup food)))
  (define (small-fries? food price idx)
    (equal? '|Fries Small| food))
  (let-values (([food-1 food-2]
                (cond ((small-fries? food price -1)
                       (values (list food price #t) (find-food saus?)))
                      ((saus? food price -1)
                       (values (find-food small-fries?) (list food price #t)))
                      (else
                       (values #f #f )))))
    (cond ((not (and food-1 food-2))
           (values #f #f #f))
          (else
           (values (list food-1 food-2)
                   0.10
                   (make-new-type 'Menu-saus (list food-1 food-2)))))))


(define (create-menu-for-three food-1? food-2? food-3? name reduction)
  (lambda (food price)
    (let-values (([food-1 food-2 food-3]
                  (cond ((food-1? food price -1)
                         (values (list food price ) (find-food food-2?) (find-food food-3?)))
                        ((food-2? food price -1)
                         (values (find-food food-1?) (list food price ) (find-food food-3?)))
                        ((food-3? food price -1)
                         (values (find-food food-1?) (find-food food-2?) (list food price )))
                        (else
                         (values #f #f #f)))))
      (cond ((not (and food-1 food-2 food-3))
             (values #f #f #f))
            (else
            
       
             (values (list food-1 food-2 food-3)
                     reduction
                     (make-new-type name (list food-1 food-2 food-3))))))))


(define check-for-veggie-menu (create-menu-for-three veggie? salade-small? orange-juice? '|Menu Veggie| 0.15))
(define check-for-BC-menu (create-menu-for-three vanille-ice? ice-tea? bacon-or-chicken? '|Menu Bacon Or Chicken| 0.15))

  
(define (check-for-menu-big-mac? food price)
  (define (fries-big? food price idx)
    (equal? '|Fries Big| food))
  (define (salade-big? food price ix)
    (equal? food '|Salade Big|))
  (define (big-mac? food price idx)
    (equal? food '|Big Mac|))
  (define (chocolate-ice? food price idx)
    (equal? '|Chocolate Ice| food))
    (let-values (([food-1 food-2 food-3 food-4]
                  (cond ((salade-big? food price -1)
                         (values (list food price ) (find-food fries-big?) (find-food big-mac?) (find-food chocolate-ice?)))
                        ((fries-big? food price -1)
                         (values (find-food salade-big?) (list food price ) (find-food big-mac?) (find-food chocolate-ice?)))
                        ((big-mac? food price -1)
                         (values (find-food salade-big?) (find-food fries-big?) (list food price ) (find-food chocolate-ice?)))
                        ((chocolate-ice? food price -1)
                         (values (find-food salade-big?) (find-food fries-big?) (find-food big-mac?) (list food price )))
                        (else
                         (values #f #f #f #f)))))
      (cond ((not (and food-1 food-2 food-3 food-4))
             (values #f #f #f ))
            
            (else
            
       
             (values (list food-1 food-2 food-3 food-4)
                     0.30
                     (make-new-type '|Menu Big Mac| (list food-1 food-2 food-3 food-4)))))))

(define (check-for-snack-menu? food price)
  (define (chicken-wings? food price idx )
    (equal? food '|Chicken Wings|))
  (define (frit-fondue? food price idx)
    (equal? food 'Frit&Fondue))
  (define (cola? food price idx)
    (equal? food '|Coca Cola|))
  (define (other-snack? food price idx)
    (or (equal? 'Cheese food)
        (equal? '|Chicken Nuggets| food)))
  (define (salade-big? food price idx)
    (equal? '|Salade Big| food))
  (let-values (([food-1 food-2 food-3 food-4 food-5]
                (cond ((salade-big? food price -1)
                       (values (list food price ) (find-food frit-fondue?) (find-food other-snack?) (find-food cola?)  (find-food chicken-wings?)))
                      ((frit-fondue? food price -1)
                       (values (find-food salade-big?) (list food price ) (find-food other-snack?) (find-food cola?)  (find-food chicken-wings?)))
                      ((other-snack? food price -1)
                       (values (find-food salade-big?) (find-food frit-fondue?) (list food price ) (find-food cola?)  (find-food chicken-wings?)))
                      ((cola? food price -1)
                       (values (find-food salade-big?) (find-food frit-fondue?) (find-food other-snack?) (list food price ) (find-food chicken-wings?)))
                      ((chicken-wings? food price -1) 
                       (values (find-food salade-big?)(find-food frit-fondue?)(find-food other-snack?) (find-food cola?) (list food price )))
                      (else
                       (values #f #f #f #f #f)))))
    (cond ((not (and food-1 food-2 food-3 food-4 food-5))
           (values #f #f #f ))
          (else
         
           (values (list food-1 food-2 food-3 food-4 food-5)
                   0.40
                   (make-new-type '|Menu Snack| (list food-1 food-2 food-3 food-4 food-5)))))))

    

(define menus? (list check-for-snack-menu? check-for-menu-big-mac? check-for-veggie-menu check-for-BC-menu check-for-menu-saus))

(define itemID 0)
(define (add-food food price remove-index)
  (set! itemID (+ itemID 1))
  (insert-into! 'order food price itemID)
  (let loop ([idx (send order-list-box get-number)])
    (when (> idx 0)
      (when (member (send order-list-box get-data (- idx 1)) remove-index)
         (send order-list-box delete (- idx 1)))
         (loop (- idx 1))))
  (send order-list-box append (symbol->string  food) itemID)
  (send total-message set-label (number->string total)))

(define (food-inserted? food-item)
  (= (length food-item) 3))


    
(define (remove-from-database! food-items)
  (for-each (lambda (food-item)
              (when (food-inserted? food-item)
                (delete-from! 'order (lambda (type price idx) (equal? (food-id food-item)
                                                                    idx)))))
            food-items))



(define (detect-menu? food-item price)
  (semaphore-wait promo-s)
  (set! total (+ total price))
  (let loop ((current-menus? menus?))
    
    (if (not (null? current-menus?))
        (let-values (([events reduction menu-name] ((car current-menus?) food-item price)))
          
          (cond ((not events)
                 
                 (loop (cdr current-menus?)))
                (else
                 
                 (let* ((individual-price (foldl (lambda (event acc) (+ acc (food-price event))) 0 events))
                        (reduction-price (* reduction individual-price))
                        (price (* (- 1 reduction) individual-price))
                                                )
                   (remove-from-database! events)
                   (set! total (- total reduction-price))
                   (add-food menu-name price (map caddr (filter food-inserted? events)))
                   #t))))
        
               (add-food food-item price '())))
  (semaphore-post promo-s))
  
  


(define frame (new frame% [label "Electronic menu"] [width 800] [height 800] ))
(define panel (new vertical-panel%  [alignment (list 'left 'top)] [parent frame][style (list 'auto-vscroll 'auto-hscroll)]))
(define start-panel (new horizontal-panel% [parent panel]))
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




;TODO
(define order-list-box (new list-box% [parent panel] [min-width 200] [min-height 200] [choices '()][label "ORDER"] [callback
                                                                                                                    (lambda (item control)
                                                                                                                      (let ((indexs (send item get-selections)))
                                                                                                                        (when (not (null? indexs))
                                                                                                                         ( remove-from-order (send item get-data  (car indexs)) (car indexs)))))]))
                                                                                                                          
(define (remove-from-order remove-ID idx)
   (let ((remove-item (select-where 'order (lambda (type price ID) (equal? ID remove-ID)))))
     (semaphore-wait promo-s)
     (set! total (- total (food-price remove-item)))
     (send total-message set-label (number->string total))
     (send order-list-box delete idx)
     (semaphore-post promo-s)))



(define panel-text (new horizontal-panel%   [parent panel]))
(define total-panel (new horizontal-panel% [parent panel] ))

(define message (new message% [label "Total: "] [parent total-panel] ))
(set! total-message (new message% [label "0"] [auto-resize #t] [parent total-panel]))
(define end-session (new horizontal-panel% [parent panel] ))

(define food-layer-fanta (new vertical-panel% [parent drink-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-fanta (new horizontal-panel% [parent food-layer-fanta]))
(define price-message-fanta (new message% [parent message-layer-fanta] [min-width 150][label (string-append "€" (number->string pFanta))]))
(define button-layer-fanta (new horizontal-panel% [parent food-layer-fanta]))
(define plus-button-fanta  (new button% [parent button-layer-fanta] [label "Fanta"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Fanta pFanta))]))

(define food-layer-cola (new vertical-panel% [parent drink-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-cola (new horizontal-panel% [parent food-layer-cola]))
(define price-message-cola (new message% [parent message-layer-cola] [min-width 150][label (string-append "€" (number->string pCoca-cola))]))
(define button-layer-cola (new horizontal-panel% [parent food-layer-cola]))
(define plus-button-cola  (new button% [parent button-layer-cola] [label "Coca Cola"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Coca Cola| pCoca-cola))]))

(define food-layer-ice-tea (new vertical-panel% [parent drink-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-ice-tea (new horizontal-panel% [parent food-layer-ice-tea]))
(define price-message-ice-tea (new message% [parent message-layer-ice-tea] [min-width 150][label (string-append  "€" (number->string pIce-tea))]))
(define button-layer-ice-tea (new horizontal-panel% [parent food-layer-ice-tea]))
(define plus-button-ice-tea  (new button% [parent button-layer-ice-tea] [label "Ice Tea"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Ice Tea| pIce-tea))]))

(define food-layer-orange-juice (new vertical-panel% [parent drink-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-orange-juice (new horizontal-panel% [parent food-layer-orange-juice]))
(define price-message-orange-juice (new message% [parent message-layer-orange-juice] [min-width 150][label (string-append "€" (number->string pOrange-juice))]))
(define button-layer-orange-juice (new horizontal-panel% [parent food-layer-orange-juice]))
(define plus-button-orange-juice  (new button% [parent button-layer-orange-juice] [label "Orange Juice"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Orange Juice| pOrange-juice))]))

(define food-layer-big-mac (new vertical-panel% [parent burger-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-big-mac (new horizontal-panel% [parent food-layer-big-mac]))
(define price-message-big-mac (new message% [parent message-layer-big-mac] [min-width 150][label (string-append "€" (number->string pBig-mac))]))
(define button-layer-big-mac (new horizontal-panel% [parent food-layer-big-mac]))
(define plus-button-big-mac  (new button% [parent button-layer-big-mac] [label "Big Mac"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Big Mac| pBig-mac))]))

(define food-layer-veggie (new vertical-panel% [parent burger-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-veggie (new horizontal-panel% [parent food-layer-veggie]))
(define price-message-veggie (new message% [parent message-layer-veggie] [min-width 150][label (string-append  "€" (number->string pVeggie))]))
(define button-layer-veggie (new horizontal-panel% [parent food-layer-veggie]))
(define plus-button-veggie  (new button% [parent button-layer-veggie] [label "Veggie"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Veggie pVeggie))]))


(define food-layer-bacon (new vertical-panel% [parent burger-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-bacon (new horizontal-panel% [parent food-layer-bacon]))
(define price-message-bacon (new message% [parent message-layer-bacon] [min-width 150][label (string-append "€" (number->string pBacon))]))
(define button-layer-bacon (new horizontal-panel% [parent food-layer-bacon]))
(define plus-button-bacon  (new button% [parent button-layer-bacon] [label "Bacon"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Bacon pBacon))]))

(define food-layer-chicken (new vertical-panel% [parent burger-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-chicken (new horizontal-panel% [parent food-layer-chicken]))
(define price-message-chicken (new message% [parent message-layer-chicken] [min-width 150][label (string-append "€" (number->string pChicken))]))
(define button-layer-chicken (new horizontal-panel% [parent food-layer-chicken]))
(define plus-button-chicken  (new button% [parent button-layer-chicken] [label "Chicken" ] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Chicken pChicken))]))


(define food-layer-chocolate-ice(new vertical-panel% [parent dessert-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-chocolate-ice(new horizontal-panel% [parent food-layer-chocolate-ice]))
(define price-message-chocolate-ice(new message% [parent message-layer-chocolate-ice] [min-width 150][label (string-append "€" (number->string pChocolate-ice))]))
(define button-layer-chocolate-ice(new horizontal-panel% [parent food-layer-chocolate-ice]))
(define plus-button-chocolate-ice (new button% [parent button-layer-chocolate-ice] [label "Chocolate Ice"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Chocolate Ice| pChocolate-ice))]))

(define food-layer-vanille-ice(new vertical-panel% [parent dessert-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-vanille-ice(new horizontal-panel% [parent food-layer-vanille-ice]))
(define price-message-vanille-ice(new message% [parent message-layer-vanille-ice] [min-width 150][label (string-append "€" (number->string pVanille-ice))]))
(define button-layer-vanille-ice(new horizontal-panel% [parent food-layer-vanille-ice]))
(define plus-button-vanille-ice (new button% [parent button-layer-vanille-ice] [label "Vanille Ice"] [callback (lambda (button event)
                                                                                                                 (detect-menu? '|Vanille Ice| pVanille-ice))]))

(define food-layer-chicken-wings (new vertical-panel% [parent snack-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-chicken-wings (new horizontal-panel% [parent food-layer-chicken-wings]))
(define price-message-chicken-wings(new message% [parent message-layer-chicken-wings] [min-width 150][label (string-append "€" (number->string pChicken-wings))]))
(define button-layer-chicken-wings(new horizontal-panel% [parent food-layer-chicken-wings]))
(define plus-button-chicken-wings (new button% [parent button-layer-chicken-wings] [label "Chicken Wings"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Chicken Wings| pChicken-wings))]))

(define food-layer-chicken-nuggets (new vertical-panel% [parent snack-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-chicken-nuggets (new horizontal-panel% [parent food-layer-chicken-nuggets]))
(define price-message-chicken-nuggets(new message% [parent message-layer-chicken-nuggets] [min-width 150][label (string-append  "€" (number->string pChicken-nuggets))]))
(define button-layer-chicken-nuggets(new horizontal-panel% [parent food-layer-chicken-nuggets]))
(define plus-button-chicken-nuggets (new button% [parent button-layer-chicken-nuggets] [label "Chicken Nuggets"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Chicken Nuggets| pChicken-nuggets))]))

(define food-layer-cheese (new vertical-panel% [parent snack-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-cheese (new horizontal-panel% [parent food-layer-cheese]))
(define price-message-cheese(new message% [parent message-layer-cheese] [min-width 150][label (string-append  "€" (number->string pCheese))]))
(define button-layer-cheese(new horizontal-panel% [parent food-layer-cheese]))
(define plus-button-cheese (new button% [parent button-layer-cheese] [label "Cheese"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Cheese pCheese))]))

(define food-layer-friesB (new vertical-panel% [parent fries-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-friesB (new horizontal-panel% [parent food-layer-friesB]))
(define price-message-friesB(new message% [parent message-layer-friesB] [min-width 150][label (string-append "€" (number->string pFries-big))]))
(define button-layer-friesB(new horizontal-panel% [parent food-layer-friesB]))
(define plus-button-friesB (new button% [parent button-layer-friesB] [label "Fries Big"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Fries Big| pFries-big))]))

(define food-layer-friesS (new vertical-panel% [parent fries-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-friesS (new horizontal-panel% [parent food-layer-friesS]))
(define price-message-friesS(new message% [parent message-layer-friesS] [min-width 150][label (string-append "€" (number->string pFries-small))]))
(define button-layer-friesS(new horizontal-panel% [parent food-layer-friesS]))
(define plus-button-friesS (new button% [parent button-layer-friesS] [label "Fries Small"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Fries Small| pFries-small))]))

(define food-layer-Frit&Fondue (new vertical-panel% [parent fries-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-Frit&Fondue (new horizontal-panel% [parent food-layer-Frit&Fondue]))
(define price-message-Frit&Fondue(new message% [parent message-layer-Frit&Fondue] [min-width 150][label (string-append  "€" (number->string pFrit-fondue))]))
(define button-layer-Frit&Fondue(new horizontal-panel% [parent food-layer-Frit&Fondue]))
(define plus-button-Frit&Fondue (new button% [parent button-layer-Frit&Fondue] [label "Frit&Fondue"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Frit&Fondue pFrit-fondue))]))
(define food-layer-saladeS (new vertical-panel% [parent salade-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-saladeS (new horizontal-panel% [parent food-layer-saladeS]))
(define price-message-saladeS(new message% [parent message-layer-saladeS] [min-width 150][label (string-append "€" (number->string pSalade-small))]))
(define button-layer-saladeS(new horizontal-panel% [parent food-layer-saladeS]))
(define plus-button-saladeS (new button% [parent button-layer-saladeS] [label "Salade Small"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Salade Small| pSalade-small))]))

(define food-layer-saladeB(new vertical-panel% [parent salade-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-saladeB(new horizontal-panel% [parent food-layer-saladeB]))
(define price-message-saladeB(new message% [parent message-layer-saladeB] [min-width 150][label (string-append  "€" (number->string pSalade-big))]))
(define button-layer-saladeB(new horizontal-panel% [parent food-layer-saladeB]))
(define plus-button-saladeB(new button% [parent button-layer-saladeB] [label "Salade Big"] [callback (lambda (button event)
                                                                                                              (detect-menu? '|Salade Big| pSalade-big))]))

(define food-layer-mayo(new vertical-panel% [parent saus-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-mayo(new horizontal-panel% [parent food-layer-mayo]))
(define price-message-mayo(new message% [parent message-layer-mayo] [min-width 150][label (string-append "€" (number->string pMayo))]))
(define button-layer-mayo(new horizontal-panel% [parent food-layer-mayo]))
(define plus-button-mayo(new button% [parent button-layer-mayo] [label "Mayo"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Mayo pMayo))]))

(define food-layer-ketchup(new vertical-panel% [parent saus-layer] [min-width 20] [stretchable-width #f]))
(define message-layer-ketchup(new horizontal-panel% [parent food-layer-ketchup]))
(define price-message-ketchup(new message% [parent message-layer-ketchup] [min-width 150][label (string-append "€" (number->string pKetchup))]))
(define button-layer-ketchup(new horizontal-panel% [parent food-layer-ketchup]))
(define plus-button-ketchup(new button% [parent button-layer-ketchup] [label "Ketchup"] [callback (lambda (button event)
                                                                                                              (detect-menu? 'Ketchup pKetchup))]))



#|ALLERGICS|#
(define allergic-layer  (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define eggs-check-box (new check-box% [label "EGGS: "] [parent allergic-layer]
                            [callback (lambda (check-box event)
                                        (let ((value (not (send check-box get-value))))
                                          (send plus-button-bacon enable value)
                                          (send plus-button-chicken enable value)))]))
                                                                                         
(define milk-check-box (new check-box% [label "MILK: "] [parent allergic-layer]
                            [callback (lambda (check-box event)
                                        (let ((value (not (send check-box get-value))))
                                          (send plus-button-chocolate-ice enable value)
                                          (send plus-button-vanille-ice value)))]))



(define text-fieldC (new text-field% [label "Action Code"] [parent panel-text] [callback (lambda (text control)
                                                                                           (semaphore-wait promo-s)
                                                                                         
                                                                                           (let ((promo (send text-fieldC get-value)))
                                                                                               (when (= (string-length promo) 4)
                                                                                                 (when (check-promoE promo)
                                                                                                   (set! promo #f)
                                                                                                   (set! total (- total 3))
                                                                                                   (send total-message set-label (number->string total))
                                                                                                   (send text set-value ""))))
                                                                                           (semaphore-post promo-s))]))
  

;TODO
(define start-session (new button% [parent start-panel] [label "Start"] [min-width 100] [min-height 20]
                           [callback (lambda (button control)
                                       (send timerC start 180000)
                                       (send plus-button-fanta enable #t)
                                       (send plus-button-ice-tea enable #t)
                                       (send plus-button-cola enable #t)
                                       (send plus-button-orange-juice enable #t)
                                       (send plus-button-big-mac enable #t)
                                       (send plus-button-veggie enable #t)
                                       (send plus-button-bacon enable #t)
                                       (send plus-button-chicken enable #t)
                                       (send plus-button-friesS enable #t)
                                       (send plus-button-friesB enable #t)
                                       (send plus-button-chicken-wings enable #t)
                                       (send plus-button-chicken-nuggets enable #t)
                                       (send plus-button-cheese enable #t)
                                       (send plus-button-Frit&Fondue enable #t)
                                       (send plus-button-saladeB enable #t)
                                       (send plus-button-saladeS enable #t)
                                       (send plus-button-chocolate-ice enable #t)
                                       (send plus-button-vanille-ice enable #t)
                                       (send plus-button-mayo enable #t)
                                       (send plus-button-ketchup enable #t)
                                       (send milk-check-box enable #t)
                                       (send eggs-check-box enable #t)
                                       (send order-list-box enable #t)
                                       (send text-fieldC enable #t)
                                       (send payer-button enable #t)
                                       
                                       
                                       )]))
                                      
                                      
(define reset (lambda (item control) (stop-session)))
(define stop-session (lambda ()
                       (send timerC stop)
                       (drop-table! 'order)
                       (create-table! 'order)
                       (semaphore-wait promo-s)
                       (set! total 0)
                       (set! promo #t)
                       (semaphore-post promo-s)
                       (send total-message set-label "0")
                       (send plus-button-fanta enable #f)
                       (send plus-button-ice-tea enable #f)
                       (send plus-button-cola enable #f)
                       (send plus-button-orange-juice enable #f)
                       (send plus-button-big-mac enable #f)
                       (send plus-button-veggie enable #f)
                       (send plus-button-bacon enable #f)
                       (send plus-button-chicken enable #f)
                       (send plus-button-friesS enable #f)
                       (send plus-button-friesB enable #f)
                       (send plus-button-chicken-wings enable #f)
                       (send plus-button-chicken-nuggets enable #f)
                       (send plus-button-cheese enable #f)
                       (send plus-button-Frit&Fondue enable #f)
                       (send plus-button-mayo enable #f)
                       (send plus-button-ketchup enable #f)
                       (send milk-check-box set-value #f)
                       (send eggs-check-box set-value #f)
                        (send plus-button-saladeB enable #f)
                       (send plus-button-saladeS enable #f)
                       (send plus-button-chocolate-ice enable #f)
                       (send plus-button-vanille-ice enable #f)
                       (send milk-check-box enable #f)
                       (send eggs-check-box enable #f)
                       (send order-list-box clear)
                       (send order-list-box enable #f)
                       (send payer-button enable #f)
                       (send text-fieldC set-value "")
                       
                       (send text-fieldC enable #f)))

  
(define payer-button (new button% [parent end-session] [label "PAYER"][callback reset]))
                                              
  
(define timerC (new timer% [notify-callback stop-session]))



                                                                          
(send timerC start 20)
(send frame show #t)   


(define employee-frame (new frame% [label "Employee menu"] [width 800] [height 800] ))
(define panelE (new vertical-panel%  [alignment (list 'left 'top)] [parent employee-frame][style (list 'auto-vscroll 'auto-hscroll)]))
(new check-box% [label "Client 1"] [parent panelE]
     [callback (lambda (check-box event)
                 (send frame show (not (send check-box get-value))))])

(define text-fieldE (new text-field% [label "Action Code"] [parent panelE] [callback (lambda (text control)
                                                                                       (semaphore-wait promo-s)
                                                                                       (let ((promo (send text-fieldE get-value)))
                                                                                         (when (= (string-length promo) 4)
                                                                                           (add-new-promoE! promo (+ (current-seconds) 7000)))
                                                                                         (semaphore-post promo-s)))]))
  

(define timerE (new timer% [notify-callback (lambda ()
                                             (semaphore-wait promo-s)
                                             (delete-from! 'employee-promo
                                                           (lambda (promo time)
                                                             (> (current-seconds) time)))
                                              (semaphore-post promo-s))
                                           ]))                                                                      


(send timerE start 10000)
(send employee-frame show #t)
