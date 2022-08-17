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



(struct food (id price) #:mutable #:transparent)

(define employee-promo '())
(define customer-promo '())
(define total  0)
(define total-message '())

(define  promo-s (make-semaphore 1))


(define (check-new-customer-promo promo)
  (define (loop promos)
    (when (not (null? promos))
      (displayln (caar promos))
      (displayln promo)
      (displayln "new")
                 
      (if (equal? promo (caar promos ))
          (begin (set! total (- total 3))
                 (displayln "jk")
                 (send total-message set-label (number->string total)))
          (loop (cdr promos)))))
  (loop employee-promo))

  (define (check-new-employee-promo promo)
  (when (member promo customer-promo )
    (set! total (- total 3))
    (displayln "kkk")
    (send total-message set-label (number->string total))))

(define (electronic-menu-board-client)
   
(define order '())


  

(define (remove-at-index-order index)
  (let loop
    ((before '())
     (after order)
     (idx 0))
    (cond ((= idx index)
           (set! order (append before (cdr after)))
           index)
          (else (loop
                 (append before (list (car after)))
                 (cdr after)
                 (+ idx 1))))))



(define (remove-items! items)
  (filter (lambda (id) id)
          (map (lambda (item)
              (let ((index (index-of order item)))
                (set! order (remove item order))
                index))
            items)))


 
 

(define (soft-drink?  food)
  (or (equal? (food-id food) 'Fanta)
      (equal? (food-id food) '|Coca Cola|)
      (equal? (food-id food) '|Ice Tea|)))

(define (fries? food)
  (or (equal? (food-id food) '|Fries Small| )
      (equal? (food-id food) '|Fries Big|)
      (equal? (food-id food) 'Frit&Fondue)))
     

 (define (veggie? food)
    (equal? 'Veggie (food-id food)))
  
  (define (nuggets? event)
    (equal? (food-id event) '|Chicken Nuggets|))

  (define (ice? event)
    (or (equal? (food-id event) '|Chocolate Ice|)
        (equal? (food-id event) '|Vanille Ice|)))


(define fries-small? (lambda (item) (equal? (food-id item) '|Fries Small|)))



(define (get-first l)
  (if (null? l)
      #f
      (car l)))

      

(define (find-event constraint?)
  (get-first (filter constraint? order)))

(define (make-three-menu-function food-1? food-2? food-3? reduction name)
  (lambda (event)
    (let-values (([food-1 food-2 food-3]
                  (cond ((food-1? event)
                         (values event (find-event food-2?) (find-event food-3?)))
                        ((food-2? event)
                         (values (find-event food-1?) event (find-event food-3?)))
                        ((food-3? event)
                         (values (find-event food-1?) (find-event food-2?) event))
                        (else
                         (values #f #f #f)))))
      (cond ((not (and food-1 food-2 food-3))
             (values #f #f #f))
            (else
             
             (values (list food-1 food-2 food-3)
                     reduction
                     (string->symbol
                      (foldl (lambda (item acc)
                                (string-append acc " " (symbol->string (food-id item))))
                              (string-append (symbol->string name) ":")
                              (list food-1 food-2 food-3)))))))))

  (define (make-two-menu-function food-1? food-2? reduction name)
    (lambda (event)
      (let-values (([food-1 food-2]
                    (cond ((food-1? event)
                           (values event (find-event food-2?)))
                          ((food-2? event)
                           (values (find-event food-1?) event))
                          (else
                           (values #f #f )))))
        (cond ((not (and food-1 food-2))
               (values #f #f #f))
              (else
               
               (values (list food-1 food-2)
                       reduction
                       (string->symbol
                        (foldl (lambda (item acc)
                                 (string-append acc " " (symbol->string (food-id item))))
                               (string-append name ":")
                               (list food-1 food-2)))))))))
    

  (define saus-menu?
    (make-two-menu-function fries-small?
                      (lambda (item) (or (equal? (food-id item) 'Mayo)
                                         (equal? (food-id item) 'Ketchup)))
                    0.33
                    '|Saus Menu|))

  (define menu-veggie?
    (make-three-menu-function (lambda (item) (equal? (food-id item) '|Fries Big|))
                      soft-drink?
                      (lambda (item)  (equal? (food-id item) 'Veggie))
                      0.40
                      '|Veggie Menu|))

  (define menu-big-mac?
   (make-three-menu-function fries?
                     soft-drink?
                    (lambda (item)  (equal? (food-id item) '|Big Mac|))
                    0.43
                    '|Big Mac Menu|))
  
  (define menu-chicken-bacon?
     (make-three-menu-function (lambda (item) (equal? (food-id item) '|Big Salade|))
                     soft-drink?
                    (lambda (item)  (or (equal? (food-id item) 'Chicken)
                                        (equal? (food-id item) 'Bacon)))
                    0.25
                    '|Chicken or Bacon Mac Menu|))

  

  


(define menus? (list menu-big-mac? saus-menu? menu-veggie? menu-chicken-bacon?))


(define (add-food food remove-index)
  (set! order (append order (list food)))
 
  (for/fold ([number-item 0])
            ([item-index remove-index])
    (send order-list-box delete (+  item-index ))
    (+ number-item 1))
            
  (send order-list-box append (symbol->string (food-id food)))
  (send total-message set-label (number->string total)))

  
(define (detect-menu? event)
  (semaphore-wait promo-s)
  (set! total (+ total (food-price event)))
  (let loop ((current-menus? menus?))
    
    (if (not (null? current-menus?))
        (let-values (([events reduction menu-name] ((car current-menus?) event)))
          
          (cond ((not events)
                 
                 (loop (cdr current-menus?)))
                (else
                 
                 (let* ((individual-price (foldl (lambda (event acc) (+ acc (food-price event))) 0 events))
                        (reduction-price (* reduction individual-price))
                        (menu (food menu-name (* (- 1 reduction) individual-price))) 
                        (remove-indexes (remove-items! events)))
                     (set! total (- total reduction-price))
                  
                   (add-food menu remove-indexes)
                   
                   
                   #t))))
        
               (add-food event '())))
  (semaphore-post promo-s))
  




     

(define customerID 0)

  

(define event-id 0)

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


(define current-selected-index #f)
(define (select-remove-order list-box event)
  (let ((indexs (send list-box get-selections)))
    (set! current-selected-index (car indexs))))
(define order-list-box (new list-box% [parent panel] [min-width 200] [min-height 200] [choices '()][label "ORDER"] [callback
                                                                                                                    (lambda (item control)
                                                                                                                      (let ((indexs (send item get-selections)))
                                                                                                                        (when (not (null? indexs))
                                                                                                                          (displayln (car indexs))
                                                                                                                          (set! current-selected-index (car indexs)))))]))

(define (remove-from-order button event)
  (when current-selected-index
    
    (send order-list-box delete current-selected-index)
   
    (let ((remove-item (list-ref order current-selected-index)))
      
     
      (remove-at-index-order current-selected-index)
      (semaphore-wait promo-s)
      (set! total (- total (food-price remove-item)))
      
      (send total-message set-label (number->string total))
      (semaphore-wait promo-s))))

(define remove-button (new button% [parent panel] [label "REMOVE"][callback remove-from-order]))
  (define panel-text (new horizontal-panel%   [parent panel]))
  (define total-panel (new horizontal-panel% [parent panel] ))
  
  (define message (new message% [label "Total: "] [parent total-panel] ))
(set! total-message (new message% [label "0"] [auto-resize #t] [parent total-panel]))
(define end-session (new horizontal-panel% [parent panel] ))



(define (make-food-buttons labels prices layer)
  (define (make-button type price)
    (define food-layer (new vertical-panel% [parent layer] [min-width 20] [stretchable-width #f]))
    (define message-layer (new horizontal-panel% [parent food-layer]))
    (define price-message (new message% [parent message-layer] [min-width 150][label (string-append (symbol->string type) ": €" (number->string price))]))
    (define button-layer (new horizontal-panel% [parent food-layer]))
    (define plus-button  (new button% [parent button-layer] [label (symbol->string type)] [callback (lambda (button event)
                                                                                                      (detect-menu? (food type price))
                                                                                                      )]))
    plus-button )
  (map make-button labels prices))

(define drink-buttons (make-food-buttons '(Fanta |Coca Cola| |Ice Tea| |Orange Juice|)
                                         (list pFanta pCoca-cola pIce-tea pOrange-juice)
                                         drink-layer))
(define burgers-buttons-without-eggs (make-food-buttons '(|Big Mac| Veggie)
                                         (list pBig-mac pVeggie)
                                         burger-layer))
(define burgers-buttons-with-eggs (make-food-buttons '( Bacon Chicken)
                                             (list  pBacon pChicken)
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
                        (list  dessert-buttons burgers-buttons-with-eggs)))


(define start-session (new button% [parent start-panel] [label "Start"] [min-width 100] [min-height 20]
                           [callback (lambda (button control)
                                       (map (lambda (item)
                                              (send item enable #t))
                                            (append dessert-buttons snack-buttons salade-buttons saus-buttons fries-buttons drink-buttons burgers-buttons-without-eggs burgers-buttons-with-eggs)
                                            ))]))
                                      
                                      
(define reset (lambda (item control) (stop-session)))
(define stop-session (lambda ()
                       (set! order '())
                       (semaphore-wait promo-s)
                       (set! total 0)
                       (semaphore-wait promo-s)
                       (for-each (lambda (button)
                                   (send button enable #f))
                                 (append dessert-buttons
                                         drink-buttons
                                         snack-buttons
                                         fries-buttons
                                         saus-buttons
                                         burgers-buttons-without-eggs
                                         burgers-buttons-with-eggs
                                         ))
                       (for-each (lambda (check-box)
                                   (send check-box set-value #f))
                                 check-boxes)
                       (send order-list-box clear)))

  
(define payer-button (new button% [parent end-session] [label "PAYER"][callback reset]))


                                               
  
(define timer (new timer% [notify-callback stop-session]))









(define text-field (new text-field% [label "Action Code"] [parent panel-text]))
(define button (new button% [label "ADD"] [parent panel-text] [callback (lambda (button control)
                                                                              (semaphore-wait promo-s)
                                                                              (let ((promo (send text-field get-value)))
                                                                                (check-new-customer-promo promo)
                                                                                (set! customer-promo (cons  promo customer-promo))
                                                                                (send text-field set-value "")
                                                                          (semaphore-post promo-s)))]))
     (send frame show #t)   
frame
  )


(define client-window (electronic-menu-board-client))
(define frame (new frame% [label "Employee menu"] [width 800] [height 800] ))
(define panel (new vertical-panel%  [alignment (list 'left 'top)] [parent frame][style (list 'auto-vscroll 'auto-hscroll)]))
(new check-box% [label "Client 1"] [parent panel]
     [callback (lambda (check-box event)
                 (send client-window show (not (send check-box get-value))))])

(define text-field (new text-field% [label "Action Code"] [parent panel]))
(define button (new button% [label "ADD"] [parent panel] [callback (lambda (button control)
                                                                     (semaphore-wait promo-s)
                                                                     (let ((promo (send text-field get-value)))
                                                                      (set! employee-promo (cons (list promo (+ (current-seconds) 7000)) employee-promo))
                                                                       (send text-field set-value "")
                                                                       (semaphore-post promo-s)))]))


(define timer (new timer% [notify-callback (lambda ()
                                             (semaphore-wait promo-s)
                                             (set! employee-promo
                                                   (filter (lambda (promo)
                                                             (> (current-seconds) (cadr promo)))
                                                           employee-promo))
                                             (semaphore-post promo-s))
                                                     ]))                                                                      
 


(send frame show #t)
