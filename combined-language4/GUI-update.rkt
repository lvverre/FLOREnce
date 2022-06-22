#lang racket
(provide update-view)
(require "GUI-input-output.rkt")
(define (update-view node value)
  
  (match node
    [(value-node-gauge widget)
     (when (not (number? value))
       (error "To change value of gauge expected a number"))
     (send widget set-value value)]
    [(value-node-slider widget)
      (when (not (number? value))
       (error "To change value of slider expected a number"))
     (send widget set-value value)]
    [(value-node-check-box widget)
     (send widget set-value value)]
    [(enable-node widget)
     (when (not (boolean? value))
       (error (format "Enabling expected a boolean ~a" value)))
     (send widget enable value)]
    [(label-node widget)
     (when (not (string? value))
       (error "Change of label expected a string"))
     (send widget set-label value)]
    [(value-node-radio-box widget)
     (if (number? value)
         (send widget set-selection value)
         (error "Change of selection value in radio-box expects a number"))]
    [(add-node-list-box widget)
     (displayln "added to node list")
     (if (not (string? value))
         (error "For adding an item to list-box expects a string")
         (send widget append value))]
    [(delete-node-list-box widget)
     (display value)
     (if (not (number? value))
         (error "For removing an item of a list-box a number is expected")
         (send widget delete value))]
    [(clear-node-list-box widget)
     (send widget clear)]
              
     ))