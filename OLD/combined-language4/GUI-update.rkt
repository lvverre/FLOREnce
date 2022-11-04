#lang racket
(provide update-view )
(require "GUI-input-output.rkt")




     

(define (update-view widget message value)
  (send   widget update! message value))