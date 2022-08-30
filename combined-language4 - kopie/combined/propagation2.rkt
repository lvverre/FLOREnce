#lang racket
(require (except-in "../logical/nodes.rkt" root)
         "logical.rkt"
         "../logical/logical-variables.rkt"
         "../logical/tokens.rkt"
         "queue-datastructure.rkt"
       ;  "../compile-interpret.rkt"
          "../functional/datastructures.rkt"
          "propagation.rkt"
          "forall.rkt"
         data/heap)
(provide propagate!)
(define (make-current-priority node value)
  (pn-pair node value))
(define (propagate!)
  (let loop
    ()
    (display "loop")
    
    (when (not (empty? priority-queue))
      (displayln (car priority-queue))
      (match (pn-pair-val (serve-priority-queue!))
        [(vnt-pair value node turn)
         #:when (deployedR? node)
         (displayln "deployedR")
         (execute-turn node  value turn)]
        [(vnt-pair value node turn)
         #:when (logic-connector? node)
         (displayln "logic-connector")
         (execute-logic-connector node value turn)]
        [(vnt-pair token 'root turn)
         (display 'root)
         (displayln token)
         (cond ((add-token? token)
                (display "add propagation")
                (set-expiration-time! token)
                (start-propagation token turn))
               (else (display "remove propagation")(start-propagation token  turn)))]
        [(vnt-pair token node turn)
         #:when (emit-node? node)
         (displayln "EMIT")
         (execute-production-node node token #t  turn)]
        [(vnt-pair token node turn)
         #:when (retract-node? node)
         (displayln "RETRACT")
         (execute-production-node node token #f turn)]
       #| [(vnt-pair token 'remove-root turn)
         
         (start-propagation token  turn)]
        [(vnt-pair token'add-root turn)
         (set-expiration-time! token)
         (start-propagation token turn)]|#
)
      (loop))))



  
      
  
  