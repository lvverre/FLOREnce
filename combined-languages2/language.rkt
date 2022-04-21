#lang racket
(require "defmac.rkt")
(require "combined/propagation.rkt"
         (only-in "combined/collect.rkt"
                  remove-collect4: remove-collect3: remove-collect2: remove-collect1:
                  add-collect4: add-collect3: add-collect2: add-collect1:)
         (only-in "functional/reactor.rkt" reactor:)
         (only-in "functional/deployment.rkt" deploy:)
         (only-in "functional/compile-interpret.rkt" c-const)
         (only-in "combined/forall.rkt" forall:)
         "functional/environment.rkt"
         (only-in "functional/datastructures.rkt" functional-event)
         ;(only-in "logic/tokens.rkt" fact? add-fact? remove-fact? get-fact-name get-fact-arguments alpha-token-args)

         "logical/nodes.rkt" 
         )
      
         
(provide 
         add: remove: fact: rule: 
         forall:
         c-const
         
         fire; make-event add-observer remove-observer event-map event-filter event-or
         remove-collect4: remove-collect3: remove-collect2: remove-collect1:
         add-collect4: add-collect3: add-collect2: add-collect1:
         reactor: deploy: 
         (rename-out [new-module-begin #%module-begin])
         #%app #%datum #%top-interaction
         )


(defmac (new-module-begin exps ...)
  #:keywords new-module-begin
  #:captures root events root-lock timer  functional-environment
  (#%module-begin
   (define root (make-root))
   (define root-lock (make-semaphore 1))
;   (define events (make-event))
;   (define eternity -1)
   (define timer (make-timer root root-lock ))
   (define functional-environment (new-env))
   (send timer start 1000)
   
   (add-to-env!  'e1 (functional-event '() '()) functional-environment)
   (add-to-env! 'e2 (functional-event '() '()) functional-environment)
   (add-to-env! 'e3 (functional-event '() '()) functional-environment)
   
   exps ...))
