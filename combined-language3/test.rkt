#lang racket
(require "test2.rkt")
(define-syntax t
  (syntax-rules (t)
    [(t e)
     (syntax-e #'e)]))

(define-syntax main:
  (syntax-rules (main:)
    [(main: args )
     (syntax-e #'args)]))