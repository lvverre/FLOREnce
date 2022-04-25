#lang racket
(require "parse-values.rkt")
(provide (all-defined-out))



(define (number-operation procedure name)
  (lambda (env first second)
    (if (and (nmb? first) (nmb? second))
        (nmb (procedure (nmb-val first) (nmb-val second)))
        (error (format "~a expected two numbers" name)))))

(define prim-add (number-operation + '+))
(define prim-div (number-operation / '/))
(define prim-sub (number-operation - '-))
(define prim-mul (number-operation * '*))

(define (prim-equal? env first second)
  (displayln "EQUAL?")
  (display (equal? first second))
  (display first)
  (display second)
  (if (equal? first second)
      true
      false))


(define (number-comparison procedure name)
  (lambda (env first second)
    (let ((result 
    (if (and (nmb? first) (nmb? second))
        (if (procedure (nmb-val first) (nmb-val second))
            true
            false)
        (error (format "~a expected two numbers name" name)))))
      (display (format "RESULT: ~a" result))
      result)))

(define prim-smaller-then? (number-comparison < 'Smallerthen))
(define prim-greater-then? (number-comparison > 'Greatherthen))
(define prim-smaller-equal-then? (number-comparison <= 'SmallerEqthen))
(define prim-greater-equal-then? (number-comparison >= 'GreaterEqthen))


(define (prim-not first)
  (cond ((eq? true first)
         false)
        ((eq? false first)
         true)
        (else (error (format "Not expected boolean given ~a" first)))))

(define (prim-and env first second)
  (if (and (bool? first)
           (bool? second))
      (cond ((and (eq? true first)
                  (eq? true second))
             true)
            (else false))
      (error (format "And expects two booleans"))))

(define (prim-or env first second)
  (if (and (bool? first)
           (bool? second))
      (cond ((or (eq? true first)
                 (eq? true second))
             true)
            (else false))
      (error (format "Or expects two booleans"))))

      
