#lang racket

(require "environment.rkt")
(provide (all-defined-out))

(define native-map-env (new-env))
(define native-filter-env (new-env))

(struct c-const (value) #:transparent)
(struct c-event ())
(define compiled-event (c-event))
(struct c-fun-apl (operator operands) #:transparent)


(define (set-up-native-map)
  (map (lambda (var val) (add-to-env! var (c-const val) native-map-env))
       '(+ - / *)
       (list + - / *)))
(define (set-up-native-filter)
  (map (lambda (var val) (add-to-env! var (c-const val) native-filter-env))
       '(< > equal? eq? <= >=  = not and or )
       (list < > equal? eq? <= >= = (lambda (value)
                                      (not value))
             (lambda (el1 el2)
               (and el1 el2))
             (lambda (el1 el2)
               (or el1 el2)))))

(set-up-native-map)
(set-up-native-filter)






  
(define ((compile env event-name) exp )
;  (display event-name)
  (displayln exp)
  (match exp
    [value
     #:when (or (number? value) (string? value))
     (c-const value)]
    
    [`(,op ,opands ...)
     (let ((c-operator (c-const-value (lookup-var op env)))
           (c-opands (map (compile env event-name) opands)))
       (c-fun-apl
        c-operator
        c-opands))]
    [event
     #:when (equal? event event-name)
     compiled-event]
    [value
     #:when (symbol? value)
     (lookup-var value env)]
    [_ (error (format "~a is not allowed in body-part" exp))]))

(define (interpret exp event-value)
  (define (process-loop exp)
    (match exp
      [(c-fun-apl operator opands)
       (let ((evaluated-opands (map (lambda (opand)
                                       (c-const-value (process-loop opand)))
                                    opands)))
         (c-const (apply operator evaluated-opands)))]
      [(c-event) event-value]
      [value value]))
  (process-loop exp))