#lang racket
(require "defmac.rkt")
(provide (all-defined-out))
(define (z el)
  (- el 1))

(defmac (v p)
  #:keywords v
  (k p))