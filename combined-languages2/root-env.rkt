#lang racket
(provide (all-defined-out))

(define model 1)
(define reactive 0)
(struct root-env (root env) #:mutable #:transparent)