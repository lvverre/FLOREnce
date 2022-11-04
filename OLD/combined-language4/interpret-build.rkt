#lang racket
(provide (all-defined-out))

(struct var-exp (var) #:transparent)
(struct if-exp (pred then else) #:transparent)
(struct const-exp (val) #:transparent)
(struct app-exp (op args) #:transparent)
(struct and-exp (args) #:transparent)
(struct or-exp (args) #:transparent)
(struct def-exp (def-vars body) #:transparent)