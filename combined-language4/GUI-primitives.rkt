#lang racket
(require "GUI-input-output.rkt")
 (require racket/gui/base
          "combined/propagation.rkt"
          ;"functional/nodes.rkt"
          "functional/datastructures.rkt"
          "combined/propagation2.rkt"
          "variables.rkt"
          )
(provide start-propagation-process)

(provide timerI? timerI-timer timerI-interval timerI-event make-timerI class-frame make-gauge make-button make-text-field make-radio-box make-check-box  make-message make-slider class-panel make-list-box)


(define class-timer (class timer%
                      (super-new)
                      (define/public (number-of-args message)
                        (match message
                          ['start
                           1]
                          ['stop
                           1]
                           
                          [_ (error (format "Timer cannot deal with ~a event" message))]))
                      (define/public (update! message value) 
                        (match message
                          ['start
                           (displayln value)
                           (send this start (* 1000 (car value)))]
                          ['stop
                           (send this stop)]
                          [_ (error (format "Timer cannot deal with ~a event" message))]))))
                        

(define class-frame (class frame%
                      (super-new)
                      (define/public (number-of-args message)
                        (match message
                          ['show
                           1]
                           
                          [_ (error (format "Frame cannot deal with ~a event" message))]))
                      (define/public (update! message value) 
                        (match message
                          ['show
                           (when (not (boolean? value))
                             (error (format "Window show expected a boolean ~a" value)))
                           (send this show value)]
                          [_ (error (format "Window cannot deal with ~a event" message))]))))
                           



                      

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



(define class-text-field
  (class text-field%
    (init co-x co-y)
    (define x co-x)
    (define y co-y) 
    (define/override (get-x)
      x)
    (define/override (get-y)
      y)
    (super-new )
    (define/public (number-of-args message)
      (match message
      ['enabled
         1]
        
        ['clear
         1]
        ['change-value
         1]
        [_ (error (format "Text Field cannot deal with ~a event" message))]))
    (define/public (update! message value) 
      (match message
        ['enabled
         (when (not (boolean? (car value)))
           (error (format "Enabling a button expected a boolean ~a" (car value))))
         (send this enable (car value))]
        ['clear
         (send this set-value "")]
        ['change-value
         (when (not (string? (car value)))
           (error (format "change value for text-field needs to be string")))
         (send this set-value (car value))]
        [_ (error (format "Text Field cannot deal with ~a event" message))]))))


(define class-button (class button%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )
                        (define/public (number-of-args message)
                          (match message
                            ['enabled
                             1]
                            
                            [_ (error (format "Button cannot deal with ~a event" message))]))
                       (define/public (update! message value) 
                         (match message
                           ['enabled
                            (when (not (boolean? (car value)))
                              (error (format "Enabling a button expected a boolean ~a" value)))
                            (send this enable (car value))]
                           [_ (error (format "Button cannot deal with ~a event" message))]))))
                           


(define class-check-box (class check-box%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )
                           (define/public (number-of-args message)
                          (match message
                            ['enabled
                             1]
                            ['change-value
                             1]
                            
                            [_ (error (format "Check box cannot deal with ~a event" message))]))
                          (define/public (update! message value) 
                         (match message
                           ['enabled
                            (when (not (boolean? (car value)))
                              (error (format "Enabling a checkbox expected a boolean ~a" value)))
                            (send this enable (car value))]
                           ['change-value
                            (send this set-value (car value))]
                           [_ (error (format "Checkbox cannot deal with ~a event" message))]))))
  

(define class-list-box (class list-box%
                       (init co-x co-y)
                       (define x co-x)
                       (define y co-y) 
                       (define/override (get-x)
                         x)
                       (define/override (get-y)
                         y)
                       (super-new )
                          (define/public (number-of-args message)
                          (match message
                            ['enabled
                             1]
                            ['add
                             2]
                            ['remove
                             1]
                            ['clear
                             1]
                            
                            [_ (error (format "List box cannot deal with ~a event" message))]))
                         (define/public (update! message value)
                           
                           (match message
                             ['enabled
                              (when (not (boolean? (car value)))
                                (error (format "Enabling a list-box expected a boolean ~a" value)))
                              (send this enable value)]
                             ['add
                              (if (not (string? (car value)))
                                  (error "For adding an item to list-box expects a string")
                                  (send this append (car value) (cadr value)))]
                             ['remove
                              (let ((val (car value)))
                                (let loop ([idx (- (send this  get-number) 1)]
                                           )
                                  (when (>= idx 0)
                                         (when (equal? val (send this get-data idx))
                                           (send this delete idx))
                                         (loop (- idx 1)))))]
                                       
                             ['clear
                              (send this clear )]
                             [_ (error (format "List box cannot deal with ~a event" message))]))))

(define class-radio-box (class radio-box%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )
                           (define/public (number-of-args message)
                          (match message
                            ['enabled
                             1]
                            ['change-selection
                            1]
                            [_ (error (format "Radio box cannot deal with ~a event" message))]))
                          (define/public (update! message value) 
                            (match message
                              ['enabled
                               (when (not (boolean? (car value)))
                                 (error (format "Enabling a radio-box expected a boolean ~a" value)))
                               (send this enable (car value))]
                              ['change-selection
                               (if (number? (car value))
                                   (send this set-selection (car value))
                                   (error "Change of selection value in radio-box expects a number"))]
                              [_ (error (format "Radio-box cannot deal with ~a event" message))]))))
(define class-slider (class slider%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )
                        (define/public (number-of-args message)
                          (match message
                            ['enabled
                             1]
                            ['change-value
                             1]
                            [_ (error (format "Slider cannot deal with ~a event" message))]))
                        (define/public (update! message value) 
                         (match message
                           ['enabled
                            (when (not (boolean? (car value)))
                              (error (format "Enabling a slider expected a boolean ~a" value)))
                            (send this enable (car value))]
                            ['change-value
                             (when (not (number? (car value)))
                               (error "To change value of slider expected a number"))
                             (send this set-value (car value))]
                            [_ (error (format "Slider cannot deal with ~a event" message))]))))

(define class-message (class message%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )
                         (define/public (number-of-args message)
                          (match message
                            ['change-value
                             1]
                            
                            [_ (error (format "Button cannot deal with ~a event" message))]))
                         (define/public (update! message value) 
                         (match message
                           ['change-value
                            (when (not (string? (car value)))
                              (error "To change value of message expected a string"))
                            (send this set-label (car value))]
                           [_ (error (format "Message cannot deal with ~a event" message))]))))

(define class-gauge (class gauge%
                          (init co-x co-y)
                          (define x co-x)
                          (define y co-y) 
                          (define/override (get-x)
                            x)
                          (define/override (get-y)
                            y)
                          (super-new )
                       (define/public (number-of-args message)
                          (match message
                            ['change-value
                             1]
                            
                            [_ (error (format "Button cannot deal with ~a event" message))]))
                       (define/public (update! message value) 
                         (match message
                           ['change-value
                            (when (not (number? (car value)))
                              (error "To change value of gauge expected a number"))
                            (send this set-value (car value))]
                           [_ (error (format "Gauge cannot deal with ~a event" message))]))))
  

(define (start-propagation-process event value)
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
                                         
                                          (thread-send (vector-ref current-process-thread 0) (list event label )))])))
               
               ; (enable (enable-node  button)))
           (list event (sink-node button))))))
                                       
               





(define (make-message parent x y min-width min-height label)
  (cond ((and (number? x)
              (number? y)
              (number? min-width)
              (number? min-height)
              (string? label))
         (let* (
                (message (new class-message   [co-x x] [co-y y][min-height min-height]  [min-width min-width] [auto-resize #t] [label label] [parent parent]
                              ))
         )
            
           (list (sink-node  message))))
        (else (error (format "Wrong type of argument for make-message")))))

(define (make-check-box  parent x y min-width min-height label)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label))
         (let* ((event (event-node '()))
                (check-box (new class-check-box [co-x x][co-y y] [min-width min-width]
                               [min-height min-height] [parent parent]
                               [callback (lambda (check-box control-event)
                                            (thread-send (vector-ref current-process-thread 0) (list event (send check-box get-value))))][label label]))
              )
                ;(enable (enable-node  check-box))
                ;(value (value-node-check-box  check-box)))
           (list event (sink-node check-box))))
        (else  (error (format "Wrong type of argument for make-check-box")))))

(define (make-radio-box  parent x y min-width min-height label choices)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (pair? choices)(andmap (lambda (choice) (string? choice)) choices))
         (let* ((event (event-node '()))
                (radio-box (new class-radio-box [label label]
                                [choices choices] [min-height min-height] [min-width min-width]
                                [co-x x] [co-y y] [parent parent] [callback (lambda (radio-box control-event)
                                                                               (thread-send (vector-ref current-process-thread 0) (list event         
                                                       
                                                                                    (send radio-box
                                                                                          get-item-plain-label
                                                                                          (send radio-box get-selection)))))]))
                )
               ; (enable (enable-node  radio-box))
               ; (selection (value-node-radio-box  radio-box)))
           (list event (sink-node radio-box))))
        (else (error (format "Wrong type of argument for make-radio-box")))))


(define (make-text-field  parent x y min-width min-height label)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label))
         (let* ((event (event-node '()))
                (text-field (new  class-text-field [label label] [min-height min-height] [min-width min-width]
                              [co-x x] [co-y y] [parent parent] [callback (lambda (text-field control-event)
                                                                            (thread-send (vector-ref current-process-thread 0) (list event (send text-field get-value))))]))
               
                )
                                                                                         
              
           (list event (sink-node text-field))))
        (else (error (format "Wrong type of argument for make-text-field")))))


(define (make-slider  parent x y min-width min-height label min max)
   (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (number? min) (number? max))
         (let* ((event (event-node '()))
                (slider (new  class-slider [label label]
                                [min-value min] [max-value max] [min-height min-height] [min-width min-width]
                                [init-value max][co-x x] [co-y y] [parent parent] [callback (lambda (slider control-event)
                                                                                               (thread-send (vector-ref current-process-thread 0) (list event (send slider get-value))))]))
                                                                                            ;(send selection get-selections)))))]        
                                                      
                                                                                             ; (start-propagation  event
                                                                                              ;                    (send slider get-value)))]))
              
                ;(enable (enable-node  slider ))
                ;(value (value-node-slider slider))
                )
                                                                                         
              
           (list event (sink-node slider))))
        (else (error (format "Wrong type of argument for make-slider")))))


(define (make-gauge  parent x y min-width min-height label range)
   (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (number? range) )
         (let* ((event (event-node '()))
                (gauge (new  class-gauge [label label]
                                [range range][min-height min-height] [min-width min-width]
                               [co-x x] [co-y y] [parent parent]))
              
                               )           
           (list (sink-node gauge))))
        (else (error (format "Wrong type of argument for make-gauge")))))


(struct timerI (event timer interval))

(define (make-timerI parent interval)
  (cond ((number? interval)
         (let* ((event (event-node '()))
                (timer (new class-timer [notify-callback (lambda ()
                                                      (displayln "TIMERI")
                                               (thread-send (vector-ref current-process-thread 0) (list event (current-seconds))))])))
           (list (timerI event timer interval) (sink-node timer))))))


(define (make-list-box parent x y min-width min-height label choices)
  (cond ((and (number? x) (number? y) (number? min-width) (number? min-height)
              (string? label) (list? choices) (andmap string? choices))
         (let* ((event (event-node '()))
                (list-box (new class-list-box [choices choices][callback (lambda (selection control-event)
                                                                           (let* ((selections (send selection get-selections))
                                                                                 (data (send selection get-data (car selections))))
                                                                                                                                                 
                                                                             (thread-send (vector-ref current-process-thread 0) (list event  data))))]        
                                                          #| (start-propagation  event
                                                                  (car (send selection get-selections))))]|#
                                                          [co-x x] [co-y y] [min-width min-width] [min-height min-height] [label label] [parent parent] ))
              
               ; (add (add-node-list-box  list-box ))
               ; (remove (delete-node-list-box  list-box ))
               ; (clear (clear-node-list-box  list-box ))
                )
           (list event (sink-node list-box))));add remove clear)))
                
        (else (error (format "Wrong type of argument for make-list")))))
  




                                                                              


