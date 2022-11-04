#lang racket
 (require racket/contract
          racket/gui/base
          racket/trait
           )




      


;
;FRAME
;






(define m (class object%
            
            (super-new)
             
            (field
             [show 0])))

(define ll (extract-field-trait m))

(define z (new ll ))     


;(define class-frame (class frame%
;                      (super-new)
;                      (
;                      (define/public (number-of-args message)
;                        (match message
;                          ['show
;                           1]
;                          [_ (error (format "Frame cannot deal with ~a event" message))]))
;                      (define/public (update! message value) 
;                        (match message
;                          ['show
;                           (when (not (boolean? value))
;                             (error (format "Window show expected a boolean ~a" value)))
;                           (send this show value)]
;                          [_ (error (format "Window cannot deal with ~a event" message))]))))
                           
