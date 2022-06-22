#lang racket
(provide (all-defined-out)) 

(struct out (widget))
;(struct in-out ())
(struct label-node out ())
(struct enable-node out ())
(struct value-node-gauge out ())
(struct value-node-slider out ())
(struct value-node-check-box out ())
(struct value-node-radio-box out ())
(struct add-node-list-box out ())
(struct delete-node-list-box out ())
(struct clear-node-list-box out ())