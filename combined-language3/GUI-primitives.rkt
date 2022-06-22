#lang racket
(require "GUI-input-output.rkt")
 (require racket/gui/base
          ;"functional/nodes.rkt"
          "functional/datastructures.rkt")

(provide make-gauge make-button make-radio-box make-check-box  make-message make-slider class-panel)

(define class-panel (class panel%
                       (super-new )
                      (define/override (place-children info width height)
                        (map (lambda (child info-child )
                               (displayln child)
                               (displayln info-child)
                               ;(send child min-width 35)
                               (list (send child get-x)
                                     (send child get-y)
                                    0;(send child min-width 40)
                                    0;(send child min-height 40)
                                     ))
                             (send this get-children)
                             info))
                     (define/override (container-size info)
                       (values (send this min-width)
                               (send this min-height)))))



(define class-button (class button%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )))
(define class-message (class message%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )))
(define class-check-box (class check-box%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )))

(define class-radio-box (class radio-box%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )))

(define class-slider (class slider%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )))

(define class-gauge (class gauge%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )))

(define (make-button root-env parent x y min-width min-height label)
  (cond ((and (number? x)
              (number? y)
              (number? min-width)
              (number? min-height)
              (string? label))
         (let* ((event (event-node '()))
                (button (new class-button [co-x x]
                             [label label]
                             [co-y y] [min-width min-width]
                             [min-height min-height] [parent parent]
                             [callback (lambda (button control-event)
                                         (fire root-env event 'pushed))]))
                (enable (enable-node button)))
           (list event enable)))))
                                       
               


(define (make-message parent x y min-width min-height label )
  (cond ((and (number? x)
              (number? y)
              (number? min-width)
              (number? min-height)
              (string? label))
         (let ((message (new class-message [co-x x]
                             [co-y y] [min-width min-width]
                             [min-height min-height][label label] [parent parent])))
           (list (label-node message))))
        (else (error (format "Wrong type of argument for make-message")))))

(define (make-check-box env parent x y min-width min-height label)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label))
         (let* ((event (event-node '()))
                (check-box (new class-check-box [co-x x][co-y y] [min-width min-width]
                               [min-height min-height] [parent parent]
                               [callback (lambda (check-box event)
                                           (fire env event (send check-box get-value)))][label label]))
                (enable (enable-node check-box))
                (value (value-node-check-box check-box)))
           (list event enable  value)))
        (else  (error (format "Wrong type of argument for make-check-box")))))

(define (make-radio-box env parent x y min-width min-height label choices)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (pair? choices)(andmap (lambda (choice) (string? choice)) choices))
         (let* ((event (event-node '()))
                (radio-box (new class-radio-box [label label]
                                [choices choices] [min-height min-height] [min-width min-width]
                                [co-x x] [co-y y] [parent parent] [callback (lambda (radio-box event)
                                                                              (fire env event
                                                                                    (send radio-box
                                                                                          get-item-plain-label
                                                                                          (send radio-box get-selection))))]))
                (enable (enable-node radio-box))
                (selection (selection-node radio-box)))
           (list event enable selection)))
        (else (error (format "Wrong type of argument for make-radio-box")))))


(define (make-slider env parent x y min-width min-height label min max)
   (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (number? min) (number? max))
         (let* ((event (event-node '()))
                (slider (new  class-slider [label label]
                                [min-value min] [max-value max] [min-height min-height] [min-width min-width]
                                [init-value max][co-x x] [co-y y] [parent parent] [callback (lambda (slider event)
                                                                                              (fire env event
                                                                                                    (send slider get-value)))]))
                (enable (enable-node slider))
                (value (value-node-slider slider)))
                                                                                         
              
           (list event enable value)))
        (else (error (format "Wrong type of argument for make-slider")))))


(define (make-gauge env parent x y min-width min-height label range)
   (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (number? range) )
         (let* ((event (event-node '()))
                (gauge (new  class-gauge [label label]
                                [range range][min-height min-height] [min-width min-width]
                               [co-x x] [co-y y] [parent parent]))
                (value (value-node-gauge gauge)))           
           (list value)))
        (else (error (format "Wrong type of argument for make-gauge")))))
                                                                              
               
(define (fire env event value)
  (display value))



    
    
    
 #|     
  
(define f (new frame% [label "k" ] [width 200] [height 200]))
(define v (new class-panel [parent f]))
(send f show #t)
(define z (make-button '() v 0 0 20 20 "OK"))
(define m (make-check-box '() v 100 0 30 30 "check"))
(define aa (make-radio-box '() v 0 170 100 100 "test" (list "kk" "kl")))
(define pp (make-slider '() v 0 70 200 30 "sl" 0 100))
(define xc (make-gauge '() v  0 140 200 30 "k" 300))|#