#lang br/quicklang
(define (read-syntax path port)
  (define string-tree  (port->lines port))
;  (display string-tree)
;  (define parse-tree (quote string-tree))
  ;(display string-tree)
  (define parse-tree (format-datums '~a string-tree))
  (define module-datum `(module functionalRE3-mod "functional_reactive_language_3.rkt"
                          ,@parse-tree))
;  (display module-datum)
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (functionalRE3-module-begin PARSE-TREE ...)
  #'(#%module-begin
     (begin 
        PARSE-TREE ...)))
(provide (rename-out [functionalRE3-module-begin #%module-begin]))


;MAKE-EVENT
(struct node (successors) #:mutable)
(struct event-node node ())
(struct function-node node (function) )
(struct filter-node node (filter function) )
;(struct event (observers) #:mutable)
(define (make-event)
  (event-node '()))
(define (make-function-node function)
  (function-node '() function))

(define (make-filter-node filter function)
  (filter-node '() filter function))

;:=
;(define (:= var val env)
 ; (environment var val env))

;ADD-observer
(define (add-observer predecessor-node new-function)
  ;see if it is an event
  (if (node? predecessor-node)
      ;make a new node
      (let ((successor-node (make-function-node new-function)))
        ;add new node to successors of old
        (set-node-successors! predecessor-node (cons successor-node (node-successors predecessor-node)))
        ;return new node
        successor-node)
      (error "wrond type of argument given")))

;REMOVE OBSERVER
(define (remove-observer predecessor-node observer-node)
  (if (node? predecessor-node)
      (if (node? observer-node)
          ;remove node from successors
          (set-node-successors!
           predecessor-node
           (remq observer-node (node-successors predecessor-node)))
          (error "wrong type of second argument"))
                                
      (error "wrong type of first argument")))

;
;MAP  OBSERVER
;(gives back a new event)

(define (map new-function event)
  (if (node? event)
      ;make 2 nodes 1 for the function and one to send the result to
      (let ((successor-node (make-function-node new-function))
            (successor-of-successor-node (make-event)))
        ;add function node to event successors
        ;add node for result to successors of function node
        (set-node-successors! event (cons successor-node (node-successors event)))
        (set-node-successors! successor-node (cons successor-of-successor-node '()))
        ;give back the node for the result
        successor-of-successor-node)
      (error "wrong type of argument given")))

;
;Execute a node
;
(define (execute-node node value)
  (match node
    ;for an event node just propagate the give result to its successors
    [(event-node _ )
     (propagate-event node value)]
    ;for a function execute the function on the give value en send result to successors
    [(function-node _ function)
     (propagate-event node (function value))]
    ;filter node first apply filter on value when #t then propagate result to successors
    [(filter-node _ filter function)
     
     (when (filter value)
      
       (propagate-event node (function value)))]))

;
;PROPAGATE-EVENT
;
;Send value to all successors of the node
(define (propagate-event node value)
  (for-each (lambda (successor)
              
              (execute-node successor value))
            (node-successors node)
            ))
;
;CHANGE-EVENT
;
;propagate value
(define (change-event event new-value)
  (if (event-node? event)
      (propagate-event event new-value)
      (error "Not given an event")))
;
;EVENT-OR
;

;makes node for when a
(define (event-or event-1 event-2 new-function)
  (if (and (node? event-1)
           (node? event-2))
      (let ((successor-node (make-function-node new-function)))
        ;add new node to successors of both events
        (set-node-successors! event-1 (cons successor-node (node-successors event-1)))
        (set-node-successors! event-2 (cons successor-node (node-successors event-2)))
        successor-node)
      (error "wrond type of argument given")))

;
;EVENT-AND
;

(define (event-and event filter-function observer-function)
  (if (node? event)
      (begin
        ;make node with filter
        (let* ((node-filter (make-filter-node filter-function observer-function))) 
               ;add new node to successors
          (set-node-successors! event (cons node-filter (node-successors event)))
          ;give back filter node
          node-filter))
      (error "wrong type of argument given")))


(provide event-or add-observer define + make-event lambda change-event display map event-and > remove-observer)




