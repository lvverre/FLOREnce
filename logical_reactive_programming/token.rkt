#lang br/quicklang
(provide (all-defined-out))


(struct token (add? ) #:mutable #:transparent)
;ALPHA-token
(struct alpha-token token (id args) #:transparent #:mutable)
(define (make-alpha-token add? id args)
  (alpha-token add? id args))

;BETA-token
(struct beta-token token (pm owner) #:transparent)




