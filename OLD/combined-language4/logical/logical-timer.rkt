#lang racket

(require  "../combined/logical.rkt" )
(require "../combined/propagation2.rkt")
(require "logical-variables.rkt")
(require  (except-in "nodes.rkt" root))
(require racket/gui/base)
(provide make-timer)
;Makes a timer that will go off to clean up the expired facts
(define (make-timer )
  (let ((lock (root-lock root))); events)
  (new timer% [notify-callback
               (lambda ()
                 
                 
                   
                   (remove-expired-facts  ); events)
                   (propagate!)
                   )])))