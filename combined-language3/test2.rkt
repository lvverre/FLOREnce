#lang racket
(require syntax/parse)
(provide klm v)
(define-syntax p
  (syntax-rules (p)
    [(p  e)
     (+ (syntax-e e) 1)]))

(define-syntax v
  (syntax-rules ()
    [(v z ...)
    (begin z ...)]))

(define (klm a)
  (syntax-parse a [q (syntax-e #'(begin q))]))


