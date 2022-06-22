#lang racket
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
         3.5
         4.2))
   
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
     "Menu-big-mac")])