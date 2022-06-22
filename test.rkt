#lang racket
(require "combined-languages2/defmac.rkt"
         "test2.rkt"
         "test3.rkt")
(defmac (v o)
             (+ o 1))
(defmac (test p ...)
    (begin p ...))