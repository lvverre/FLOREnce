#lang reader "language-plus-reader.rkt"

(rule: session where: (touch (customerID)) 
(define terminal-1 (make-event))