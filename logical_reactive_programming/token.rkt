#lang br/quicklang
(provide (all-defined-out))



(struct token (id args))
;ALPHA-token
(struct alpha-token  (id args) #:transparent #:mutable)

(struct alpha-token-add alpha-token (time))
(define (make-alpha-token-add  id args )
  (alpha-token-add  id args (current-seconds)))

(struct alpha-token-remove alpha-token ())
(define (make-alpha-token-remove  id args)
  (alpha-token-remove  id args))
;BETA-token
(struct beta-token  (pm owner) #:transparent)

(struct beta-token-add beta-token  (time) #:transparent)
(define (make-beta-token-add  pm owner )
  (beta-token-add  pm owner (current-seconds)))

(struct beta-token-remove beta-token  () #:transparent)
(define (make-beta-token-remove pm owner )
  (beta-token-remove  pm owner ))

;;Add-token?

(define (add-token? token)
  (or (alpha-token-add? token)
      (beta-token-add? token)))

(define (get-time token)
  (match token
    [(alpha-token-add _ _ time)
     time]
    [(beta-token-add _ _ time)
     time]
    [_ #f]))



         