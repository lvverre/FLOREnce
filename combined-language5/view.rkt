#lang racket
(require syntax/parse)
(provide interpret-view)
(require "environment.rkt"
         racket/gui/base
         "GUI-primitives.rkt"
         "functional/datastructures.rkt"
         "primitives..rkt"
         )

(define view-argument-primitive (make-hash  (list (cons '+ prim-add)
                                                  (cons '- prim-sub)
                                                  (cons '* prim-mul)
                                                  (cons '/ prim-div)
                                                  (cons 'equal? prim-equal?)
                                                  (cons '> prim-greater-then?)
                                                  (cons '< prim-smaller-then?)
                                                  (cons '<= prim-smaller-equal-then?)
                                                  (cons '>= prim-greater-equal-then?)
                                                  (cons 'not prim-not)
                                                  (cons 'and prim-and)
                                                  (cons 'true  #t)
                                                  (cons 'false #f)
                                                  (cons 'number->string prim-number->string)
                                                  (cons 'string->number prim-string->number)
                                                  (cons 'or prim-or))))
(define GUI-primitives (make-hash (list (cons 'gauge make-gauge)
                                       (cons  'slider make-slider)
                                       (cons  'button make-button)
                                       (cons  'radio-box make-radio-box)
                                       (cons  'check-box make-check-box)
                                       (cons  'message make-message)
                                       (cons  'slider make-slider)
                                       (cons 'list-box make-list-box)
                                       )))



(define (parse-view-def stx env)
  (syntax-parse stx
    [val:number
     (syntax-e #'val)]
    [val:string
     (display "string")
     (syntax-e #'val)]
    [((~literal sym) val:id)
     (display "symbol")
     (syntax-e #'val)]
    [val:id
     (display "lookup")
     (let ((val (lookup-var-error (syntax-e #'val) env)))
       (if (model-var? val)
           (model-var-val val)
           val))]
    [((~literal list) args ...)
     (display "list")
     (map (lambda (arg) (interpret-argument arg env)) (syntax->list #'(args ...)))]
    [(op args ...)
     (display "apply")
     (let ((eval-op (lookup-var-error (syntax-e #'op) env))
             (eval-args (map (lambda (name) (interpret-argument name env)) (syntax->list #'(args ...)))))
         (display eval-args)
         (apply eval-op eval-args))]))

(define (interpret-view-widget stx parent)
  (syntax-parse stx
    [(op:id args ...)
     (apply (lookup-local-var-error (syntax-e #'op) GUI-primitives)
            (cons parent (map (lambda (arg)
                   (interpret-argument arg (make-env view-argument-primitive global-env)))
                 (syntax->list #'(args ...)))))]))

(define (interpret-view stx)
  (syntax-parse stx
    [(((~literal def:) var:id ... body:expr) ...)
     (let* (
            (frame (new frame% [width 800] [height 800] [label "view"]))
            (parent (new class-panel [parent frame][style (list 'vscroll 'hscroll)])))
       (for-each (lambda (vars body)
                   (let ((evaluated-vals (interpret-view-widget body parent))
                         (evaluated-vars (map syntax-e (syntax->list vars))))
                     (when (not (= (length evaluated-vals)
                                   (length evaluated-vars)))
                       (error "Number of given formal parameters is not equal to number of actual parameters given"))
                     (for ([var evaluated-vars]
                           [val evaluated-vals])
                       (add-to-local-env! var val global-env))))
                 (syntax->list #'((var ...) ...))
                 (syntax->list #'(body ...)))
       (send frame show #t))
     ]))