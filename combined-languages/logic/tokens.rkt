#lang racket
(provide (all-defined-out))



(struct token (id args ))
;ALPHA-token
(struct alpha-token  (id args) #:transparent #:mutable)

(struct alpha-token-add alpha-token (expiration-time) #:transparent)
(define (make-alpha-token-add  id args alive-interval)
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


(define fact? alpha-token?)
(define add-fact? alpha-token-add?)
(define remove-fact? alpha-token-remove?) 
(define get-fact-name alpha-token-id)
(define get-fact-arguments alpha-token-args)
