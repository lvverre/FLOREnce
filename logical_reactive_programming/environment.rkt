#lang br/quicklang
(provide (all-defined-out))
;(provide global-env-formal global-env-actual get-prim-variable-at make-local-env get-event-variable-at get-prim-variable-idx get-event-variable-idx)
(define global-env-formal (vector '+ '- '> '< '= 'eq? 'equal?))
(define global-env-actual (vector + - > < = eq? equal?))


(define action-env-formal (vector  '+ '- '> '< '= 'eq? 'equal? 'display))
(define action-env-actual  (vector + - > < = eq? equal? display))

(define get-prim-variable-at vector-ref)
(define get-prim-variable-idx vector-member)

(define make-local-env vector)
(define get-condition-variable-at vector-ref)
(define get-condition-variable-idx vector-member)

(define (get-body-variable-at env idx-pair)
  (vector-ref (vector-ref env (car idx-pair)) (cdr idx-pair)))
(define (get-body-variable-idx variable env)
  (let loop
    ((idx-event 0))
    (let ((idx-variable (vector-ref env idx-event)))
      (if idx-variable
          (cons idx-event idx-variable)
          (loop (+ idx-event 1))))))