#lang racket
(require "GUI-input-output.rkt")
(provide (all-defined-out))

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
       (error "Enabling expected a boolean"))
     (send widget enable value)]
    [(label-node widget)
     (when (not (string? value))
       (error "Change of label expected a string"))
     (send widget set-label value)]
    [(selection-node widget)
     (when (not (number? value))
       (error "Change of selection place is expected to be a number"))
     (send widget set-selection value)]))