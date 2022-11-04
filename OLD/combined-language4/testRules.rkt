#lang racket
(require "eval-rules-bodies.rkt")


(require (for-syntax syntax/parse))

(define-syntax (rp p)
  (syntax-parse p
    [pv #'4]))

(define-syntax (pm z)
  (syntax-parse z
    [(pm (pv vjkl)) vjkl]))

