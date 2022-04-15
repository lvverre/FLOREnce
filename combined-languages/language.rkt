#lang racket
(require "defmac.rkt")
(require "functional/functional.rkt"
         (only-in "logic/tokens.rkt" fact? add-fact? remove-fact? get-fact-name get-fact-arguments alpha-token-args)

         "logic/nodes.rkt" 
         "logic/logic-language.rkt"
         "combination/forall.rkt")
(provide define + - lambda set! display > < >= <= = equal? eq?
         add: remove: fact: rule: 
         forall:
         fact? add-fact? remove-fact? get-fact-name get-fact-arguments alpha-token-args
         fire make-event add-observer remove-observer event-map event-filter event-or
         (rename-out [new-module-begin #%module-begin])
         #%app #%datum #%top-interaction
         )


(defmac (new-module-begin exps ...)
  #:keywords new-module-begin
  #:captures root events graph-lock timer eternity
  (#%module-begin
   (define root (make-root))
   (define graph-lock (make-semaphore 1))
   (define events (make-event))
   (define eternity -1)
   (define timer (make-timer root graph-lock events))
   
   exps ...))
