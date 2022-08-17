#lang racket
(provide (all-defined-out))



(struct token (id args ))
;ALPHA-token
(struct alpha-token  (id args) #:transparent #:mutable)

(struct alpha-token-add alpha-token (expiration-time) #:transparent #:mutable)

(define (set-expiration-time! token)
  (when (>= (alpha-token-add-expiration-time token) 0)
    (set-alpha-token-add-expiration-time! token (+ (current-seconds)
                                                   (alpha-token-add-expiration-time token)))))
      
(define (make-alpha-token-add  id args alive-interval)
   (+ (current-seconds) alive-interval)
  (if (<= alive-interval 0)
      (alpha-token-add id args -1)
      (alpha-token-add  id args (+ (current-seconds) alive-interval))))

(struct alpha-token-remove alpha-token ())
(define (make-alpha-token-remove  id args)
  (alpha-token-remove  id args))
;BETA-token
(struct beta-token  (pm owner) #:transparent)

(struct beta-token-add beta-token  () #:transparent)
(define (make-beta-token-add  pm owner )
  (beta-token-add  pm owner ))

(struct beta-token-remove beta-token  () #:transparent)
(define (make-beta-token-remove pm owner )
  (beta-token-remove  pm owner ))

;;Add-token?

(define (add-token? token)
  (or (alpha-token-add? token)
      (beta-token-add? token)))




