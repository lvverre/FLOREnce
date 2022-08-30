#lang racket
(require "GUI-input-output.rkt")
 (require racket/gui/base
          "combined/propagation.rkt"
          ;"functional/nodes.rkt"
          "functional/datastructures.rkt"
          "combined/propagation2.rkt"
          )

(provide make-gauge make-button make-radio-box make-check-box  make-message make-slider class-panel make-list-box)

(define class-panel (class panel%
                       (super-new )
                      (define/override (place-children info width height)
                        (map (lambda (child info-child )
                               (list (send child get-x)
                                     (send child get-y)
                                    0
                                    0
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


(define class-check-box (class check-box%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )))

(define class-list-box (class list-box%
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

(define class-message (class message%
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

(define (start-propagation event value)
  (fire event value)
  (propagate!))



(define (make-button  parent x y min-width min-height label)
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
                                         (start-propagation  event 'pushed))]))
                (enable (enable-node button)))
           (list event enable)))))
                                       
               





(define (make-message parent x y min-width min-height label)
  (cond ((and (number? x)
              (number? y)
              (number? min-width)
              (number? min-height)
              (string? label))
         (let* (
                (message (new class-message   [co-x x] [co-y y][min-height min-height]  [min-width min-width] [auto-resize #t] [label label] [parent parent]
                              )))
           (list (label-node message))))
        (else (error (format "Wrong type of argument for make-message")))))

(define (make-check-box  parent x y min-width min-height label)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label))
         (let* ((event (event-node '()))
                (check-box (new class-check-box [co-x x][co-y y] [min-width min-width]
                               [min-height min-height] [parent parent]
                               [callback (lambda (check-box control-event)
                                           (start-propagation  event (send check-box get-value)))][label label]))
                (enable (enable-node check-box))
                (value (value-node-check-box check-box)))
           (list event enable  value)))
        (else  (error (format "Wrong type of argument for make-check-box")))))

(define (make-radio-box  parent x y min-width min-height label choices)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (pair? choices)(andmap (lambda (choice) (string? choice)) choices))
         (let* ((event (event-node '()))
                (radio-box (new class-radio-box [label label]
                                [choices choices] [min-height min-height] [min-width min-width]
                                [co-x x] [co-y y] [parent parent] [callback (lambda (radio-box control-event)
                                                                              (start-propagation  event
                                                                                    (send radio-box
                                                                                          get-item-plain-label
                                                                                          (send radio-box get-selection))))]))
                (enable (enable-node radio-box))
                (selection (value-node-radio-box radio-box)))
           (list event enable selection)))
        (else (error (format "Wrong type of argument for make-radio-box")))))


(define (make-slider  parent x y min-width min-height label min max)
   (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (number? min) (number? max))
         (let* ((event (event-node '()))
                (slider (new  class-slider [label label]
                                [min-value min] [max-value max] [min-height min-height] [min-width min-width]
                                [init-value max][co-x x] [co-y y] [parent parent] [callback (lambda (slider control-event)
                                                                                              (start-propagation  event
                                                                                                    (send slider get-value)))]))
                (enable (enable-node slider))
                (value (value-node-slider slider)))
                                                                                         
              
           (list event enable value)))
        (else (error (format "Wrong type of argument for make-slider")))))


(define (make-gauge  parent x y min-width min-height label range)
   (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (number? range) )
         (let* ((event (event-node '()))
                (gauge (new  class-gauge [label label]
                                [range range][min-height min-height] [min-width min-width]
                               [co-x x] [co-y y] [parent parent]))
                (value (value-node-gauge gauge)))           
           (list value)))
        (else (error (format "Wrong type of argument for make-gauge")))))


(define (make-list-box parent x y min-width min-height label choices)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (list? choices) (andmap string? choices))
         (let* ((event (event-node '()))
                (list-box (new class-list-box [choices choices][callback (lambda (selection control-event)
                                                           (start-propagation  event
                                                                  (car (send selection get-selections))))]
                                                          [co-x x] [co-y y] [min-width min-width] [min-height min-height] [label label] [parent parent] ))
                (add (add-node-list-box list-box))
                (remove (delete-node-list-box list-box))
                (clear (clear-node-list-box list-box)))
           (list event add remove clear)))
                
        (else (error (format "Wrong type of argument for make-list")))))
  




                                                                              

