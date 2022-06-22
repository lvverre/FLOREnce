#lang racket
 (require racket/gui/base)
(define frame (new frame% [label "test"] [width 300][height 400]))
(define class-panel (class panel%
                       (super-new )
                      (define/override (place-children info width height)
                        (map (lambda (child info-child )
                               (list (send child get-x)
                                     (send child get-y)
                                     20
                                     20))
                             (send this get-children)
                             info))
                     (define/override (container-size info)
                       (values 300 300))))

(define class-button (class button%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )))



                       
                      
(define panel (new class-panel [parent frame]))
;(define button (new button-class [co-x 0] [co-y 0][label "test"]  [parent panel] [min-width 40] [min-height 50]))
;(define button2 (new button-class [co-x 0] [co-y 30] [label "test2"] [parent panel] [min-width 40] [min-height 50]))
 (define message (new message% [label "p\ne"] [parent panel]))
;(send panel place-children (list (list 20 30 #t #t) (list 100 100 #t #t )) 100 100)
(send panel container-flow-modified)
(send frame show #t)







                       

 