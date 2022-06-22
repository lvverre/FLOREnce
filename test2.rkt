#lang racket
(require "combined-languages2/defmac.rkt")
(provide maybe )
(defmac (maybe t)
  t)

(defmac  (ll m)
  (+ 1 m))