#lang racket
(require "model.rkt")
(require "view.rkt")
(require "functional/deploy.rkt")
(require "functional/reactor.rkt")
(require "combined/collect.rkt")
(require racket/gui/base
          "GUI-primitives.rkt"
          "functional/datastructures.rkt")
(require "environment.rkt")
(require "update.rkt")
(require "combined/logical.rkt")
(require "combined/propagation.rkt")
(require "compile-interpret.rkt")
(require "combined/forall.rkt")
(require "combined/propagation2.rkt")
(require "logical/logical-timer.rkt")
(require (for-syntax syntax/parse))


(provide  (rename-out [new-module-begin #%module-begin])
         #%app #%datum #%top-interaction
         
         deploy:
         reactor:
         ror:
         update:
         fact:
         add:
         remove:
         rule:
         forall:
         add-collect1: add-collect2: add-collect3: add-collect4:
         remove-collect1: remove-collect2: remove-collect3: remove-collect4:
         list)



(define-syntax (new-module-begin stx)

  (syntax-parse stx
   [ (_ ((~literal main:)
         ((~literal model:) model-exprs:def-model ...)
         ((~literal view:) view-exprs:def-view ...)
         ((~literal react:) react-exprs ...)))
   #'(#%module-begin
       (define timer (make-timer))
      (send timer start 1000)
      (map (lambda (var val)
             
             (add-to-local-env! var 
                                (model-var (eval-reactor-body val global-env))
                                global-env))
           '(model-exprs.variable ...)
           (list model-exprs.value ...))
      (let* ((frame (new frame% [width 800] [height 800] [label "view"]))
             (parent (new class-panel [parent frame][style (list 'vscroll 'hscroll)])))
        (map (lambda (vars operator vals)
               (interpret-view-widget vars operator vals parent))
             '(view-exprs.variables ...)
             '(view-exprs.widget-operator ...)
             (list view-exprs.arguments ...))
      
        
          react-exprs ...
          (send frame show #t)
      
      (propagate!)))]))
     
      ;#'(view-exprs ...)
      ;#'(react-exprs ...))
     