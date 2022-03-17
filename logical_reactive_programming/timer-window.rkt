#lang br/quicklang
(require (prefix-in t: "tumbling_window.rkt")
         (prefix-in func: "../functiona_reactive_programming/nodes.rkt")
         (prefix-in func: "../functiona_reactive_programming/functional_reactive_language_3.rkt")
         "language3.rkt"
         "nodes3.rkt")

(define (reset-logic-graph)
  (define (reset-node node)
    (when (filter-node? node)
      (for-each
       (lambda (successor-node)
         (match successor-node
           [(func:start-if-node values order)
            (when (t:empty? (filter-node-partial-matches node))
              (func:set-start-if-node-values! successor-node '())
              (func:propagate-event (func:start-if-node-order successor-node) 3 node 'undefined))]
           [_ (reset-node successor-node)]))
       (filter-node-successors node))
       (t:reset-window (filter-node-partial-matches node))))
  
       
  (for-each 
   reset-node
   root))

(define (make-timer lambda 
(thread
 (lambda ()
   (define (window-timing-loop)
     (display "timer started")
     (t:get-lock-logic-graph)
     (reset-logic-graph)
     (display "reset")
     (t:release-lock-logic-graph)
     (sleep 60)
     (window-timing-loop)) 
   (window-timing-loop)))