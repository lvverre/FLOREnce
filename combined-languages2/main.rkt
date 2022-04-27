#lang racket
(require "parse-values.rkt"
         "eval-view.rkt"
         "root-env.rkt"
         "functional/environment.rkt")
(provide initiate)

(define (init-env)
  (define init (new-local-env))
  (for                           ([var '(true false undefined empty)]
                                  [val (list true false undefined empty)])
    (add-to-local-env! var val init))
  init)

(define (initiate-error error-text)
  (error (format "Main -> ~a " error-text)))

(define (initiate args exps root-env)
  (let ((env (init-env))
        (has-duplicate? (check-duplicates args)))
      (when has-duplicate?
        (initiate-error "model has duplicate argument name" ~a))
    (for ([arg args])
      (when (not (symbol? arg))
        (initiate-error "expected symbol as argument in model"))
      (add-to-local-env! arg undefined env))
    (set-root-env-env! root-env (make-env (new-local-env) env))
    (eval-body-main exps root-env)))


(define (eval-body-main exps  root-env)
  (define main-env (new-local-env))
  (for     ([exp exps])
    (eval-body-main-expr exp main-env root-env)))

(define (eval-body-main-expr exp main-env root-env)
  
    (match exp
      [`(view: ,view-name with: (input: ,ins ...) ,exprs ... (output: ,outs ...))
       (eval-view view-name ins outs exprs main-env)]
      [`(init: ,view-name with: (input: ,ins ...) (output: ,outs ... ))
       (eval-init view-name ins outs root-env main-env)]
      [_ (error (format "Main: -> ~a is not a valide expression in the main" exp))]))
   