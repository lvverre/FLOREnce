#lang racket
(require "defmac.rkt")
(require "combined/propagation.rkt"
         (prefix-in set-up: "root-env.rkt")
         (only-in "combined/collect.rkt"
                  remove-collect4: remove-collect3: remove-collect2: remove-collect1:
                  add-collect4: add-collect3: add-collect2: add-collect1:)
         (only-in "functional/reactor.rkt" reactor:)
         (only-in "functional/deployment.rkt" deploy:)
        ; (only-in "functional/compile-interpret.rkt" c-const)
         (only-in "combined/forall.rkt" forall:)
         (only-in "update.rkt" connect: update:)
         (only-in "eval-view.rkt" init: view:)
         "functional/environment.rkt"
      ;   (only-in "functional/datastructures.rkt" functional-event)
         ;(only-in "logic/tokens.rkt" fact? add-fact? remove-fact? get-fact-name get-fact-arguments alpha-token-args)

         "logical/nodes.rkt" 
         )
      
         
(provide 
         add: remove: fact: rule: 
         forall:
         init: view:
         connect: update:
         fire; make-event add-observer remove-observer event-map event-filter event-or
         remove-collect4: remove-collect3: remove-collect2: remove-collect1:
         add-collect4: add-collect3: add-collect2: add-collect1:
         reactor: deploy: 
         (rename-out [new-module-begin #%module-begin])
         #%app #%datum #%top-interaction
         )


(defmac (new-module-begin exps ...)
  #:keywords new-module-begin
  #:captures root-env
  (#%module-begin
   (define root (make-root))
  (define env (new-env))
   (define root-env (set-up:root-env root env))
;   (define events (make-event))
;   (define eternity -1)
   (define timer (make-timer root-env  ))
   (send timer start 1000)
   
  
   
   exps ...))
