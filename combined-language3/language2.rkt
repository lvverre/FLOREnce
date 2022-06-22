#lang racket
(require "defmac.rkt")
(defmac  (bf-module-begin parse-tree)
  #:keywords bf-module-begin
  (#%module-begin
     'parse-tree))

(provide (rename-out [bf-module-begin #%module-begin])) 