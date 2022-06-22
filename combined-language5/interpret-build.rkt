#lang racket
(provide var-exp const-exp app-exp def-exp if-exp)
(struct var-exp (var))
(struct if-exp (pred then else))
(struct const-exp (val))
(struct app-exp (op args))
(struct def-exp (def-vars body))