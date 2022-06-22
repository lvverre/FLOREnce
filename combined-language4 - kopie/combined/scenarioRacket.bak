#lang racket


#|
Interface plus min underneath word
|#


 (require racket/gui/base)

 (require racket/generic)

(define-generics food
  (price food)
  (equal-food? food arg-food)
  (print food))
  
;(struct drink (small?)
(struct fanta  ()
  #:methods gen:food
  [(define (price d) (displayln 3.1) 3.1)
   (define (equal-food? food1 food2)
     (fanta? food2))
   (define (print food)
     "Fanta")])
(struct coca-cola  ()
   #:methods gen:food
  [(define (price d) 3.1)
   (define (equal-food? food1 food2)
     (coca-cola? food2))
   (define (print food)
     "Coca-cola")])
(struct ice-tea  ()
   #:methods gen:food
  [(define (price d) 3.1)
   (define (equal-food? food1 food2)
     (ice-tea? food2))
   (define (print food)
     "Ice-tea")])
(struct orange-juice  ()
   #:methods gen:food
  [(define (price d) 2.2)
   (define (equal-food? food1 food2)
     (orange-juice? food2))
   (define (print food)
     "Orange Juice")])
(struct fries (small?)
   #:methods gen:food
  [(define (price food)
      (if (fries-small? food)
         (begin (displayln 3.5) 3.5)
         (begin (displayln 4.2) 4.2)))
   
   (define (equal-food? food1 food2)
     (and (fries? food2) (equal? (fries-small? food1)
                                 (fries-small? food2))))
   (define (print food)
     (if (fries-small? food)
         "Small fries"
         "Big fries"))])
(struct frit-fondue  ()
   #:methods gen:food
  [(define (price food) 4.5)
   (define (equal-food? food1 food2)
     (frit-fondue? food2))
   (define (print food)
     "Frit-fondue")])
(struct salade (small?)
  #:methods gen:food
  [(define (price food)
     
     (if (salade-small? food)
         (begin (displayln 3.5) 3.5)
         (begin (displayln 6.5) 6.5)))
    (define (equal-food? food1 food2)
     (and (salade? food2) (equal? (salade-small? food1)
                                  (salade-small? food2))))
   (define (print food)
     (if (salade-small? food)
         "Small salade"
         "Big salade"))])
(struct big-mac-burger ()
    #:methods gen:food
  [(define (price food)
     (displayln 7.2) 7.2)
   (define (equal-food? food1 food2)
     
     (big-mac-burger? food2))
   (define (print food)
     "Big Mac")])

(struct veggie-burger ()
    #:methods gen:food
  [(define (price food) 5.1)
   (define (equal-food? food1 food2)
     (veggie-burger food2))
   (define (print food)
     "Veggie")])
(struct bacon-burger ()
    #:methods gen:food
  [(define (price food) 6.5)
   (define (equal-food? food1 food2)
     (bacon-burger?  food2))
   (define (print food)
     "Bacon")])
(struct chicken-burger ()
    #:methods gen:food
  [(define (price food) 7.1)
   (define (equal-food? food1 food2)
     (chicken-burger?  food2))
   (define (print food)
     "Chicken")])
(struct chocolate-ice ()
    #:methods gen:food
  [(define (price food) 2.2)
   (define (equal-food? food1 food2)
     (chocolate-ice? food2))
   (define (print food)
     "Chocolate ice")])
(struct vanille-ice ()
    #:methods gen:food
  [(define (price food) 2.2)
   (define (equal-food? food1 food2)
     (vanille-ice? food2))
   (define (print food)
     "Vanille ice")])
(struct vanille-ice-nuts ()
    #:methods gen:food
  [(define (price food) 2.7)
   (define (equal-food? food1 food2)
     (vanille-ice-nuts? food2))
   (define (print food)
     "Vanille ice with nuts")])
(struct chicken-nuggets ()
    #:methods gen:food
  [(define (price food) 4.7)
   (define (equal-food? food1 food2)
     (chicken-nuggets? food2))
   (define (print food)
     "Chicken Nuggets")])
(struct chicken-wings ()
    #:methods gen:food
  [(define (price food) 4.7)
   (define (equal-food? food1 food2)
     (chicken-wings?  food2))
   (define (print food)
     "Chicken Wings")])
(struct mayo ()
    #:methods gen:food
  [(define (price food) 1.5)
   (define (equal-food? food1 food2)
     (mayo? food2))
   (define (print food)
     "Mayonnaise")])
(struct ketchup ()
    #:methods gen:food
  [(define (price food) 1.5)
   (define (equal-food? food1 food2)
     (ketchup? food2))
   (define (print food)
     "Ketchup")])
(struct menu-big-mac ( fries drink)
  #:transparent
    #:methods gen:food
  [(define (price food)
     (display food)
     (match food
       [(menu-big-mac (fries #t) _)
        11.5]
       [(menu-big-mac (fries #f) _)
        12.5]))
   (define (equal-food? food1 food2)
     (equal? food1 food2))
   (define (print food)
     (display food)
     (string-append "Menu-big-mac"))])
      
(struct storage (items) #:mutable)
(define order-storage (storage '()))


(define total 0)

(define (soft-drink? item)
  (or (fanta? item)
      (coca-cola? item)
      (ice-tea? item)))


  


(define (update-storage! add-events remove-events)
  (let ((new-storage-items (remove* remove-events (storage-items order-storage))))
    (set-storage-items! order-storage (append add-events new-storage-items))))

 
                                                   
(define (detect-menu-big-mac event)
  (define (soft-drink? item)
    (or (fanta? item)
        (coca-cola? item)
        (ice-tea? item)))
  (define drinks '())
  (define burgers '())
  (define packs-of-fries '())
  (let ((stored-items (storage-items order-storage)))
    (cond ((fries? event)
           (set! burgers (filter big-mac-burger?  stored-items))
           (set! drinks (filter soft-drink? stored-items))
           
           (set! packs-of-fries (list event)))
          ((big-mac-burger? event)
           (set! packs-of-fries (filter fries? stored-items))
           (set! drinks (filter soft-drink?  stored-items))
           (set! burgers (list event)))
          ((soft-drink? event)
           (set! packs-of-fries (filter fries?  stored-items))
           (set! drinks (list event))
           (set! burgers (filter big-mac-burger? stored-items)))))
  (cond ((ormap null? (list drinks burgers packs-of-fries))
         #f)
        (else
         
         (let ((menu (menu-big-mac (car packs-of-fries) (car drinks))))
         
           (update-storage! (list menu) (list (car packs-of-fries) (car drinks) (car burgers)))
           (set! total (+ total (price menu)))
           (display total)
           (cond  ((fries? event)
                   (set! total (- total (price (car burgers))
                                  (price (car drinks)))))
                  ((big-mac-burger? event)
                   (set! total (- total (price (car packs-of-fries)) (price (car drinks)))))
                  ((soft-drink? event)
                   (set! total (- total (price (car burgers))
                                  (price (car packs-of-fries))))))
           
           #t))))


(define (detect-menu-veggie event)
  (define (soft-drink? item)
    (or (fanta? item)
        (coca-cola? item)
        (ice-tea? item)))
  (let ((stored-items (storage-items order-storage)))
    (let-values ([(drink burger pack-of-fries)
                  (cond ((fries? event)
                         (set! burgers (filter big-mac-burger?  stored-items))
                         (set! drinks (filter soft-drink? stored-items))
           
                         (set! packs-of-fries (list event)))
                        ((big-mac-burger? event)
                         (set! packs-of-fries (filter fries? stored-items))
                         (set! drinks (filter soft-drink?  stored-items))
                         (set! burgers (list event)))
                        ((soft-drink? event)
                         (set! packs-of-fries (filter fries?  stored-items))
                         (set! drinks (list event))
                         (set! burgers (filter big-mac-burger? stored-items))))])
  (cond ((ormap null? (list drinks burgers packs-of-fries))
         #f)
        (else
         
         (let ((menu (menu-big-mac (car packs-of-fries) (car drinks))))
         
           (update-storage! (list menu) (list (car packs-of-fries) (car drinks) (car burgers)))
           (set! total (+ total (price menu)))
           (display total)
           (cond  ((fries? event)
                   (set! total (- total (price (car burgers))
                                  (price (car drinks)))))
                  ((big-mac-burger? event)
                   (set! total (- total (price (car packs-of-fries)) (price (car drinks)))))
                  ((soft-drink? event)
                   (set! total (- total (price (car burgers))
                                  (price (car packs-of-fries))))))
           
           #t))))
              

(define (rule-Menu-big-mac-remove? event)
  (let* ((stored-items (filter (lambda (item) (not (menu-big-mac? item)))(storage-items order-storage)))
        (match-existing (cond ((fries? event)
                               (for/or ([menu stored-items])
                                 (cond ((equal? (fries-small? (menu-big-mac-fries menu))
                                                (fries-small? menu))
                                        (update-storage! (list (menu-big-mac-drink menu) (big-mac-burger)) (list event))
                                        (set! total (+ total 7.2 3.1))
                                        menu)
                                       (else #f))))
                              ((soft-drink? event)
                               (for/or ([menu stored-items])
                                 (cond ((equal? (menu-big-mac-drink menu) event)
                                        (update-storage! (list (menu-big-mac-fries menu) (big-mac-burger)) (list event))
                                        (set! total (+ total 7.2 3.5 ))
                                        menu)
                                       (else #f))))
                              (else (cond ((null? stored-items)
                                           #f)
                                          (else
                                           (update-storage! (list (menu-big-mac-fries (car stored-items)) (menu-big-mac-drink (car stored-items))) (list event))
                                           (set! total (+ 3.1 3.5 ))
                                           (car stored-items)))))))
    (cond (match-existing
           (set! total (- total 11.5))
           #t)
          (else #f))))
                      
    
    





(define (add-item! new-event)
  (set! total (+ (price new-event) total))
  (update-storage! (list new-event) '())
  #t
    )





(define (make-process-event! type patterns)
  (lambda (button event)
    (send timer start 10000)
    (let ((new-event (type)))
      (for/or ([pattern patterns])
        (pattern new-event)))
    (update!)))

(define (make-process-event-with-size! type size patterns)
  (lambda (button event)
    (send timer start 10000)
    (let ((new-event (type size)))
      (for/or ([pattern patterns])
        (pattern new-event)))
    (update!)))

(define (add-primitive-event! new-event)
  (set! total (+ (price new-event) total))
  (update-storage! (list new-event) '()))

(define (remove-primitive-event! event)
    (let ((match-found (for/or ([storage-item (storage-items order-storage)])
                         (if (equal-food? event storage-item)
                             storage-item
                             #f))))
      (cond (match-found
             (set! total (-  total (price match-found)))
             (update-storage! '() (list match-found))
             #t)
            (else #f))))


    




(define customerID 0)

  

  (define event-id 0)
  
  (define frame (new frame% [label "Electronic menu"] [width 800] [height 800] ))
  (define panel (new vertical-panel%  [parent frame][style (list 'auto-vscroll 'auto-hscroll)]))
(define button-panel (new vertical-panel%  [parent panel][min-height 500][style (list 'auto-vscroll 'auto-hscroll) ]))
  #|Layers|#
(define drink-layer (new horizontal-panel% [parent button-panel]  	[border 10] [style (list 'auto-hscroll)]))
(define burger-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define dessert-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define snack-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define salade-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define saus-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define fries-layer (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define order-layer (new vertical-panel% [parent panel] [min-width 400][style (list 'auto-vscroll)]))

(define order-message (new message% [label "Order:"] [parent order-layer] ))
(define total-layer (new horizontal-panel% [parent panel]))
(define message (new message% [label "Total: "] [parent total-layer] ))
(define total-message (new message% [label "0.0000"] [parent total-layer]))

(define timer 0)

(define (update!)
  (display total)
 (let ((children (send order-layer get-children)))
   (for-each (lambda (child) (send order-layer delete-child child)) children)
   (new message% [label "Order:"] [parent order-layer])
   (for-each (lambda (food)
               (new message% [label (print food)] [parent order-layer]))
             (storage-items order-storage)))
  (send total-layer delete-child total-message)
  (set! total-message (new message% [label (number->string total)] [stretchable-width #f][parent total-layer])))
 
  

  (define (make-food parent-layer food-type price callback-plus callback-min)
    (define food-layer (new vertical-panel% [parent parent-layer] [min-width 20] [stretchable-width #f]))
    (define message-layer (new horizontal-panel% [parent food-layer]))
    (define price-message (new message% [parent message-layer] [label (string-append food-type ": €" (number->string price))]))
    (define button-layer (new horizontal-panel% [parent food-layer]))
    (define plus-button  (new button% [parent button-layer] [label "+"] [callback callback-plus]))
    (define min-button  (new button% [parent button-layer] [label "-"] [callback callback-min]))
    
    (values plus-button min-button))

(define-values (fanta-plus fanta-min)
  (make-food drink-layer  "Fanta" 3.1
             (make-process-event! fanta (list rule-Menu-big-mac-add? add-primitive-event!))
             (make-process-event! fanta (list remove-primitive-event!))))
                           
(define-values (cola-plus cola-min)
  (make-food drink-layer  "Coca Cola" 3.1
             (make-process-event! coca-cola (list rule-Menu-big-mac-add? add-primitive-event!))
             (make-process-event! coca-cola (list remove-primitive-event!))))

(define-values (icetea-plus icetea-min)
  (make-food drink-layer  "Ice Tea" 3.1
             (make-process-event! ice-tea (list rule-Menu-big-mac-add? add-primitive-event!))
             (make-process-event! ice-tea (list remove-primitive-event!))))

(define-values (orange-juice-plus orange-juice-min)
  (make-food drink-layer  "Orange Juice" 2.1
             (make-process-event! orange-juice (list add-primitive-event!))
             (make-process-event! orange-juice (list remove-primitive-event!))))

(define-values (burger-bic-mac-plus burger-bic-mac-min)
  (make-food burger-layer  "Big Mac" 7.2
             (make-process-event! big-mac-burger (list rule-Menu-big-mac-add? add-primitive-event!))
             (make-process-event! big-mac-burger (list remove-primitive-event!))))
  
(define-values (burger-veggie-plus burger-veggie-min)
  (make-food burger-layer  "Veggie Burger" 5.2
             (make-process-event! veggie-burger (list  add-primitive-event!))
             (make-process-event! veggie-burger (list remove-primitive-event!))))

(define-values (burger-bacon-plus burger-bacon-min)
  (make-food burger-layer  "Bacon Burger" 6.5
             (make-process-event! bacon-burger (list  add-primitive-event!))
             (make-process-event! bacon-burger (list remove-primitive-event!))))

(define-values (burger-chicken-plus burger-chicken-min)
  (make-food burger-layer  "Chicken burger" 7.1
             (make-process-event! chicken-burger (list  add-primitive-event!))
             (make-process-event! chicken-burger (list remove-primitive-event!))))

(define-values (chocolate-ice-plus chocolate-ice-min)
  (make-food dessert-layer  "Chocolate Ice" 2.2
             (make-process-event! chocolate-ice (list  add-primitive-event!))
             (make-process-event! chocolate-ice (list remove-primitive-event!))))

(define-values (vanille-ice-plus vanille-ice-min)
  (make-food dessert-layer  "Vanille Ice" 2.2
             (make-process-event! vanille-ice (list  add-primitive-event!))
             (make-process-event! vanille-ice (list remove-primitive-event!))))

(define-values (vanille-nuts-plus vanille-nuts-min)
  (make-food dessert-layer  "Vanille Nutts Ice" 2.7
             (make-process-event! vanille-ice-nuts (list  add-primitive-event!))
             (make-process-event! vanille-ice-nuts (list remove-primitive-event!))))

(define-values (chicken-nuggets-plus  chicken-nuggets-min)
  (make-food snack-layer  "Chicken Nuggets" 4.7
             (make-process-event! chicken-nuggets (list  add-primitive-event!))
             (make-process-event! chicken-nuggets (list remove-primitive-event!))))

(define-values (chicken-wings-plus chicken-wings-min)
  (make-food snack-layer  "Chicken Wings" 4.7
             (make-process-event! chicken-wings (list  add-primitive-event!))
             (make-process-event! chicken-wings (list remove-primitive-event!))))

(define-values (salade-small-plus salade-small-min)
  (make-food salade-layer  "Salade Small" 3.5
             (make-process-event-with-size! salade #t (list  add-primitive-event!))
             (make-process-event-with-size! salade #t (list remove-primitive-event!))))

(define-values (salade-big-plus salade-big-min)
  (make-food salade-layer  "Salade Big" 6.5
             (make-process-event-with-size! salade #f (list  add-primitive-event!))
             (make-process-event-with-size! salade #f (list remove-primitive-event!))))
 
(define-values (fries-small-plus  fries-small-min)
  (make-food fries-layer  "Fries Small" 3.5
             (make-process-event-with-size! fries #t (list  rule-Menu-big-mac-add? add-primitive-event!))
             (make-process-event-with-size! fries #t (list remove-primitive-event!))))
                                 
(define-values (fries-big-plus fries-big-min)
  (make-food fries-layer  "Fries Big" 4.2
             (make-process-event-with-size! fries #f (list  rule-Menu-big-mac-add? add-primitive-event!))
             (make-process-event-with-size! fries #f (list remove-primitive-event!))))

(define-values (frit-fondue-plus frit-fondue-min)
  (make-food fries-layer "Frit&Fondue" 4.5
             (make-process-event! frit-fondue (list   add-primitive-event!))
             (make-process-event! frit-fondue (list remove-primitive-event!))))

(define-values (mayo-plus mayo-min)
  (make-food saus-layer "Mayonaise" 1.5
             (make-process-event! mayo (list   add-primitive-event!))
             (make-process-event! mayo (list remove-primitive-event!))))

(define-values (ketchup-plus ketchup-min)
  (make-food saus-layer "Ketchup" 1.5
             (make-process-event! ketchup (list   add-primitive-event!))
             (make-process-event! ketchup (list remove-primitive-event!))))
  

#|ALLERGICS|#
(define allergic-layer  (new horizontal-panel% [parent button-panel] [style (list 'auto-hscroll)]))
(define (make-check-box name buttons-to-effect index)
  (new check-box% [label name] [parent allergic-layer]
       [callback (lambda (check-box event)
                   (send timer start 10000)
                   (let ((allergic-on? (send check-box get-value)))
                     (for-each (lambda (button-counter)
                                 (let* ((count (vector-ref button-counter 1)))
                                   (display count)
                                   (display allergic-on?)
                                   (cond (allergic-on?
                                          (display "hier")
                                          (vector-set! button-counter 1 (+ count 1))
                                          (when (> (+ count 1) 0)
                                            
                                            (send (vector-ref button-counter 0)
                                                  enable #f)))
                                         (else
                                          (vector-set! button-counter 1 (- count 1))
                                          (when (<= (- count 1) 0)
                                            
                                            (send (vector-ref button-counter 0)
                                                  enable #t))))))
                                         
                               buttons-to-effect)))]))


(define food-buttons (list burger-veggie-plus
                           burger-veggie-min
                           burger-bic-mac-min
                           burger-bic-mac-plus
                           burger-bacon-plus
                           burger-bacon-min
                           burger-chicken-plus
                           burger-chicken-min
                           chocolate-ice-plus
                           chocolate-ice-min
                           vanille-ice-plus
                           vanille-ice-min
                           vanille-nuts-plus
                           vanille-nuts-min
                           ketchup-plus
                           ketchup-min
                           mayo-plus
                           mayo-min
                           frit-fondue-plus
                           frit-fondue-min
                           fries-big-plus
                           fries-big-min
                           fries-small-plus
                           fries-small-min
                           salade-big-plus
                           salade-big-min
                           salade-small-plus
                           salade-small-min
                           chicken-wings-plus
                           chicken-wings-min
                           chicken-nuggets-plus
                           chicken-nuggets-min
                           orange-juice-plus orange-juice-min
                           icetea-plus icetea-min
                           cola-plus cola-min
                           fanta-plus fanta-min))

(define allergic-counters (map (lambda (button) (vector button 0))
                               food-buttons))
(define (get-allergic-counters lst)
  (map (lambda (button)
         (findf (lambda (counter)
                  (eq? (vector-ref counter 0) button))
                allergic-counters))
       lst))

(define check-box-milk (make-check-box "MILK: "
                                       (get-allergic-counters
                                            (list burger-veggie-plus
                                             burger-veggie-min
                                             burger-bic-mac-min
                                             burger-bic-mac-plus
                                             burger-bacon-plus
                                             burger-bacon-min
                                             burger-chicken-plus
                                             burger-chicken-min
                                             chocolate-ice-plus
                                             chocolate-ice-min
                                             vanille-ice-plus
                                             vanille-ice-min
                                             vanille-nuts-plus
                                             vanille-nuts-min))
                                       0))

(define check-box-eggs (make-check-box "EGG: "
                                        (get-allergic-counters
                                            (list burger-bacon-plus
                                             burger-bacon-min
                                             burger-chicken-plus
                                             burger-chicken-min))
                                       1))

(define check-box-nuts (make-check-box "Nuts: "
                                        (get-allergic-counters
                                            (list vanille-nuts-plus
                                                  vanille-nuts-min))
                                       2))
                    
(define check-boxes (list check-box-milk check-box-nuts check-box-eggs))
  
  
  
  (set! timer (new timer% [notify-callback (lambda ()
                                        (set-storage-items! order-storage '())
                                        (set! total 0)
                                        (for-each (lambda (button)
                                                    (send button enable #t))
                                                  food-buttons)
                                        (for-each (lambda (check-box)
                                                    (send check-box set-value #f))
                                                  check-boxes)
                                        (update!))]))
                                        
                                        
  (send timer start  10000)
  (send frame show #t)



;fries, burger, ice cream, 