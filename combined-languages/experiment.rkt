#lang racket
(require "defmac.rkt")
(provide (all-defined-out))
(define (k el)
  (+ el 1))


(define (m e)
  (p e))
(define (p e)
  (k e))
(defmac (hello p)
  #:keywords hello
  #:captures z
  (k p))