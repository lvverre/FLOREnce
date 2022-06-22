#lang racket
(require syntax/parse
         "GUI-primitives.rkt"
         (only-in racket/gui/base frame%)
         "environment.rkt")

(define-syntax main:
  (syntax-rules (main: model: view: react:)
    [(main: (model: model-defs ...)
            (view: view-defs ...)
            (react: react-defs))
     (let* ((model-env (eval-model (syntax->list #'(model-defs ...))))
            (view-env (eval-view (syntax->list #'(view-defs ...) ) model-env)))
       view-env)]))


(define ((eval-model-expr env)expr )
  (syntax-parse expr
    [val:number
     (syntax-e #'val)]
    [val:string
     (syntax-e #'val)]
    [((~literal sym) val:id)
     (syntax-e #'val)]
    [val:id
     (lookup-local-var-error (syntax-e #'val) env)]
    [((~literal list) args ...)
     (map (eval-model-expr env)
         (syntax->list #'(args ...)))]))

(define (eval-model defs)
  (let ((environment (new-local-env)))
    (for-each (lambda (def)
                
                (syntax-parse def
                  [((~literal def:) var:id expr)
                   (let ((val ((eval-model-expr environment) #'expr)))
                     (add-to-local-env! (syntax-e #'var) val environment))]))
              defs)
    environment))

(define VIEW-primitives (make-hash (list (cons 'gauge make-gauge)
                                             (cons 'slider make-slider)
                                             (cons 'message make-message)
                                             (cons 'check-box make-check-box)
                                             (cons 'radio-box make-radio-box)
                                             (cons 'button make-button))))
(define ((eval-view-arg env)expr )
  (syntax-parse expr
    [val:number
     (syntax-e #'val)]
    [val:string
     (syntax-e #'val)]
    [((~literal sym) val:id)
     (syntax-e #'val)]
    [val:id
     (lookup-var-error (syntax-e #'val) env)]
    [((~literal list) args ...)
     (map (eval-model-expr env)
         (syntax->list #'(args ...)))]))

(define ((eval-view-expr env parent) expr)
  (syntax-parse expr
    [(op:id args ...)
     (let ((evaluated-op (lookup-var-error (syntax-e #'op) env)))
       (apply evaluated-op (cons "test" (cons parent (map (eval-view-arg env) (syntax->list #'(args ...)))))))]))

(define (check-for-duplicates vars )
  (let ((duplicate? (check-duplicates vars)))
    (when duplicate?
      (error (format "~a is already defined" duplicate?)))))
       



(define (eval-view defs model-env)
  (let* ((environment (make-env model-env VIEW-primitives))
         (frame (new frame% (label "view") (height 300) (width 300)))
         (panel (new class-panel [parent frame])))
        
    (for-each (lambda (def)
                (syntax-parse def
                  [((~literal def:) var:id ... expr)
                   (check-for-duplicates (map syntax-e (syntax->list #'(var ...))))
                   (let ((vars (map syntax-e (syntax->list #'(var ...))))
                         (vals ((eval-view-expr environment panel) #'expr)))
                     (when (not (= (length vars) (length vals)))
                       (error (format "Def: needs the same number as parameters as return values in ~a" def)))
                     (for ([var vars]
                           [val vals])
                       (add-to-local-env! var val model-env)))]))
              defs)
    (send frame show #t)
    environment))



(main: (model: (def: z 3) (def: b (list 7 6)))
       (view: (def: e ena (button 0 0 20 20 "ok")))
       (react: 4))


     

#|(define/syntax-parse (main: arg1 arg2 arg3)
  #'(list 3;(syntax-e #'arg1)
        ;  (syntax-e #'arg2)
          ;(syntax-e #'arg3))
          ))|#
