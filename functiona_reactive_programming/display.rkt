#lang racket
(require racket/port)
(provide displayn)
(define (displayn el)
  (display el)
  (newline))

(port->list   (open-input-string "1234"))



