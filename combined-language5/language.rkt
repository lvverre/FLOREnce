#lang racket
(require "model.rkt")
(require "view.rkt")
(require "functional/deploy.rkt")
(require "functional/reactor.rkt")
(require "combined/collect.rkt")
(require "update.rkt")
(require "combined/propagation.rkt")
(require "combined/forall.rkt")

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
(define-syntax new-module-begin
  (syntax-rules (main: view: model: react:)
    [(_ (main: (model: model-exprs ...)
            (view: view-exprs ...)
            (react: react-exprs ...)))
     (#%module-begin
      (interpret-model #'(model-exprs ...))
      (interpret-view #'(view-exprs ...))
      
    
      react-exprs ...
      (define timer (make-timer))
      (send timer start 1000)
      )]))
      ;#'(view-exprs ...)
      ;#'(react-exprs ...))
     