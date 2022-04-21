#lang racket
(require "../defmac.rkt"
        
        (only-in "../logic/compiler.rkt" compile)
         (only-in "../logic/nodes.rkt" register-to-root! make-root register-successor! make-alpha-node)
         "../functional/nodes.rkt"
         )
(provide (all-defined-out))

(struct multi-function-node function-node () #:mutable)

(define (make-multi-function-node predecessor function )
   (multi-function-node predecessor '() #f 'undefined  function ))

(struct forall-or-node or-node () #:mutable #:transparent)

(define (make-forall-or-node add remove)
  (forall-or-node (list add remove) '() #f 'undefined ))


(defmac (forall: (event-name (args ...) constraints ...)
                 on-add: add-expr
                 on-remove: remove-expr)
   #:keywords forall: on-add: on-remove:
  #:captures root
 
  (let* ((alpha-node (make-alpha-node 'event-name '(args ...) (map (lambda (condition) (compile condition #t)) '(constraints ...))))
         (forall-root-node (make-root-event))
         (start-jump-node (make-start-jump-node
                           (lambda (node)
                             (car (node-value node))
                             
                           )))                         
         (add-node (make-multi-function-node  forall-root-node (lambda (args ...) add-expr )))
         (remove-node (make-multi-function-node forall-root-node (lambda (args ...) remove-expr )))
         (end-add-node  (make-end-jump-node 'L 3))
         (end-remove-node (make-end-jump-node 'R 1))
         (event-node (make-forall-or-node  add-node remove-node))
         (order (vector
                 forall-root-node
                 start-jump-node
                 add-node
                 end-add-node
                 remove-node
                 end-remove-node
                 event-node)))
 
    (set-start-jump-node-jump-to! start-jump-node 3)

    (set-node-successors! add-node (list event-node))
    (set-node-successors! remove-node (list event-node))
    (set-node-successors! forall-root-node (list add-node remove-node))
    (set-root-event-node-order! forall-root-node order)
    (register-to-root! alpha-node root)
        #|(cond ((null? (cdr alpha-nodes))
             ;then set the successor of the alphanode to the terminal node
             (logic:add-successor-to-node! (car alpha-nodes) start-if-node))
            (else
             ;else convert the other alpha-lists to alpha-nodes and join-nodes
             (let ((last-join-node (logic:combine-to-join-nodes (car alpha-nodes) (cdr alpha-nodes) SLIDING )))
               ;set the last join-node to the terminal-node
               (logic:add-successor-to-node! last-join-node start-if-node))))|#
    (register-successor! alpha-node forall-root-node)
    event-node))
      
       