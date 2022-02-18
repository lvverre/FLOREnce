#lang br/quicklang
(provide (all-defined-out))


(struct token (add?))
;ALPHA-token
(struct alpha-token token (id args) #:transparent)
(define (make-alpha-token add? id args)
  (alpha-token add? id args))

;BETA-token
(struct beta-token token (pm owner) #:transparent)


