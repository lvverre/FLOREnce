#lang br/quicklang
(require
  (prefix-in logic: "../logical_reactive_programming/language3.rkt")
  (prefix-in logic: "../logical_reactive_programming/nodes3.rkt")
  (prefix-in func: "../functiona_reactive_programming/nodes.rkt")
  (prefix-in func: "../functiona_reactive_programming/functional_reactive_language_3.rkt"))





(define-macro (if:
               (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...)
               then: THEN-EXPRS ...
               else: ELSE-EXPRS ...)
  #'(let* ((alpha-node (logic:event-condition->alpha-node
                             (quote EVENT-NAME)
                             '(ARGS ...)
                             '(CONDITIONS ...)))
           (start-if-node (func:make-start-if-node ))
           (then-node (func:make-multi-function-node (list start-if-node) (lambda (ARGS ...) THEN-EXPRS ...)))
           (else-node (func:make-multi-function-node (list start-if-node) (lambda () ELSE-EXPRS ...)))
           (left-end-if-node  (func:make-end-if-node 'L ))
           (right-end-if-node (func:make-end-if-node 'R ))
           (event-node (func:make-event-with-predecessor (list then-node else-node)))
           (order (vector
                   start-if-node
                   then-node
                   left-end-if-node
                   else-node
                   right-end-if-node
                   event-node)))
      (func:set-start-if-node-order! start-if-node order)
      (logic:add-rule-to-root! alpha-node)
      (logic:add-successor-to-node! alpha-node start-if-node)
      event-node))


(define test (if: (event-condition error (?y) (> ?y 3)) then: (display "hoho") else: (display "sad")))
(func:add-observer test (lambda (x) (display 'joepi)))
      
      