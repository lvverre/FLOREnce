#lang racket
(require "model.rkt")
(require "view.rkt")
(require "functional/deploy.rkt")
(require "functional/reactor.rkt")
(require "GUI-update.rkt")
(require "combined/collect.rkt")
(require racket/gui/base
          "GUI-primitives.rkt"
          "functional/datastructures.rkt")
(require "environment.rkt")
(require "update.rkt")
(require "variables.rkt")
(require "combined/logical.rkt")
(require "combined/propagation.rkt")
(require "compile-interpret.rkt")
(require "combined/forall.rkt")
(require "combined/propagation2.rkt")
(require "logical/logical-timer.rkt")
(require "GUI-primitives.rkt")
(require "GUI-input-output.rkt")
(require (for-syntax syntax/parse))


(provide  (rename-out [new-module-begin #%module-begin])
         #%app #%datum #%top-interaction
         
         deploy:
         reactor:
         ror:
         update:
         
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
         view-exprs:def-view;((~literal view:) view-exprs:def-view ...)
         ((~literal react:) react-exprs ...)))
   #'(#%module-begin
       (define timer (make-timer))
      (send timer start 1000)
      (create-new-subenv! global-env 'model)
      (map (lambda (var val)
             
             (add-to-local-env! var
                                'model
                                (eval-reactor-body val (get-sub-env global-env 'model))
                                global-env))
           '(model-exprs.variable ...)
           (list model-exprs.value ...))
      (define-values (frames timerIs)
      
        (for/fold ([frames '()]
                   [timerIs '()])
                  ([id   'view-exprs.ids]
                   [list-list-variables 'view-exprs.variables]
                   [list-operators 'view-exprs.operators]
                   [list-list-arguments view-exprs.arguments])
          (let* ((frame (new class-frame [width 800] [height 800] [label (symbol->string id)]))
                 (parent (new class-panel [parent frame][style (list 'vscroll 'hscroll)])))
            (create-new-subenv! global-env id)
            (add-to-local-env! id id (sink-node frame) global-env)
            
            (values
             (cons frame frames)
             (append
                     (append-map (lambda (variables operator arguments)
                           
                           (interpret-view-widget variables
                                                  operator
                                                  arguments
                                                  parent
                                          id))
                         list-list-variables
                         list-operators
                         list-list-arguments)
                     timerIs)
                    
                          )
                        
                          )))
                             
                             
                       
             
           
                    
                  
      
         (create-new-subenv! global-env 'react)
          react-exprs ...
          (for-each (lambda (frame) (send frame show #t)) frames)
      
      (vector-set! current-process-thread 0 (thread (lambda ()
                  
                                           (let loop ()
                                             (propagate!)
                                             (match (thread-receive)
                                               [(list event-node arg)
                                                (displayln "propagation")
                                                (start-propagation-process  event-node arg)
                                                (loop)
                                                ])))))
      (displayln timerIs)
      (for-each (lambda (timerI)
                  (send (timerI-timer timerI) start (* (timerI-interval timerI) 1000 )))
                timerIs))]))
     
      ;#'(view-exprs ...)
      ;#'(react-exprs ...))
     
