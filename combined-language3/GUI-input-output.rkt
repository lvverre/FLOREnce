#lang racket
(provide (all-defined-out)) 

(struct out (widget))
;(struct in-out ())
(struct label-node out ())
(struct enable-node out ())
(struct value-node-gauge out ())
(struct value-node-slider out ())
(struct value-node-check-box out ())
(struct selection-node out ())