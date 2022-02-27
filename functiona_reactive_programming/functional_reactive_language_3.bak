#lang br/quicklang
(require "nodes.rkt")
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

(define permanent-mark 'permanent-mark)
(define temporary-mark 'temporary-mark)



;;from https://en.wikipedia.org/wiki/Topological_sorting#:~:text=In%20computer%20science%2C%20a%20topological,before%20v%20in%20the%20ordering.
(define (topological-sort start-node)
  (define (get-event-nodes start-node)
    (define (loop node)
      (cond ((and (event-node? node) (null? (node-predecessors node)))
             (display (event-node-test node))
             (newline)
             (list node))
            ((event-node? node)
                   (display (event-node-test node))
             (append (append-map loop (node-predecessors node)) (list node)))
            (else 
             (append-map
              loop
              (node-predecessors node)))))
    (append-map loop (node-predecessors start-node)))
  (define (get-inputless-nodes node)
    (if (null? (node-successors node))
        (list node)
        (append-map
         (lambda (successor-node)
           (get-inputless-nodes successor-node))
         (node-successors node))))
;(filter
    ; (lambda (node)
    ;   (null? (node-successors node)))
    ; list-nodes))

  (define (calculate-topologic-sort event-node)
    (let* ((sinks (get-inputless-nodes event-node)); (event-node-order event-node)))
           (order (topologic-sort2 sinks event-node)))
      
   ;   (display "TOP: ")
   ;   (display sinks)
   ;   (newline)
    
      (set-event-node-order! event-node  order)))
      
    (define (reset node)
      (when (node-visited node)
        (set-node-visited! node #f)
        (for-each
         reset
         (node-successors node))))

  (define (remove-first-duplicates list-order)
    ;(display list-order)
    (define (loop discard rest)
      (cond
        ((null? rest)
         '())
        ((foldl
              (lambda ( el acc)
                (or acc el))
             
              #f
              
              (map null? rest))
           
             (cons (append discard (car rest)) (cdr rest)))
            ((foldl
              (lambda (el acc)
                (and (eq? (car (car rest)) el) acc))
              #t
              (map car rest))
            
             (loop (append discard (list (car (car rest)))) (map cdr rest)))
            (else
            
             (cons (append discard (car rest)) (cdr rest)))))
    
    
    (map  reverse (loop '() (map reverse list-order))))
              
              

  (define (topologic-sort2 start-nodes stop-node)
    (display "start nodes")
    (for-each display-id start-nodes)
    (display "stop start nodes")
    (append-map
      (lambda (start-node)
        (let ((r        (append-map reverse (visit start-node stop-node))))
          (display "r: ")
          (display r)
          (newline)
          r))
     start-nodes))
  (define (visit  start-node stop-node)
    (define (loop node)
      (cond ((eq? permanent-mark (node-visited node)) (display "not stop node")'())
            ((eq? temporary-mark (node-visited node))
             (error "There is a cycle"))
            (else
             (cond ((and
                     (not (eq? stop-node node))
                     
                     (null? (node-predecessors node)))
                    (set-node-visited! node permanent-mark)
                    (display "fault node")
                      (list #f))
                   ((eq? stop-node node)
                    (set-node-visited! node permanent-mark)

                    (display "stop node")
                     (list (list node)))
                  
           
                  
                 ((or-node? node)
                  (set-node-visited! node temporary-mark)
                  (let* ((list-orders
                          
                         (filter
                          (lambda (el)
                            el)
                          (map
                           loop
                           (node-predecessors node)
                           )))
                         
                         (new-orders
                          (append (remove-first-duplicates (map car list-orders)) (map cdr list-orders))
                         ))
                    (set-node-visited! node permanent-mark)
                        (if (null? new-orders)
                            (list (list node))
                            
                        (map (lambda (new-order)
                               (cons node new-order))
                             new-orders))
                    
                    
                    
                    ))
                 (else
                  (let* ((list-orders (loop (car (node-predecessors node))))
                        (new-orders     (if
                                            (null? list-orders)
                                            (list (list node))
                                            (map (lambda (new-order)
                                                   (cons node new-order))
                                                 list-orders))))
                    (display "k: ")
                    (display new-orders)
                    (newline)
                    new-orders)
                        
                  )))))
    (loop start-node))
  (let ((event-nodes (get-event-nodes start-node)))
  
    (for-each calculate-topologic-sort event-nodes)
   (for-each reset event-nodes)
  ))
  
  
           


;:=
;(define (:= var val env)
 ; (environment var val env))

;ADD-observer
(define (add-observer predecessor-node new-function)
;  (display predecessor-node)
  ;see if it is an event
  (if (node? predecessor-node)
      
      ;make a new node
     (let ((successor-node (make-function-node predecessor-node new-function)))
       (set-node-successors! predecessor-node (cons successor-node (node-successors predecessor-node)))
       (topological-sort successor-node)
       successor-node)
       
      (error "wrond type of argument given")))

;REMOVE OBSERVER
;;TODO recalculate sort
(define (remove-observer observer-node)
  (if (function-node? observer-node)
            ;remove node from successors
      (let ((predecessor     (car (node-predecessors observer-node))))
        (set-node-successors!
         predecessor
         (remq observer-node (node-successors predecessor)))
        (topological-sort predecessor))
        
       
      
                                
      (error "wrong type of argument")))

;
;MAP  OBSERVER
;(gives back a new event)

(define (event-map event new-function)
 ; (display event)
  (if (event-node? event)
      ;make 2 nodes 1 for the function and one to send the result to
      (let* ((successor-node (make-function-node (list event) new-function))
            (successor-of-successor-node (make-map-event (list successor-node))))
        ;add function node to event successors
      ;add node for result to successors of function node
       (set-node-successors! event (cons successor-node (node-successors event)))
        (set-node-successors! successor-node (cons successor-of-successor-node '()))
        (topological-sort successor-of-successor-node)
  ;      (newline)
  ;      (display  successor-of-successor-node)
  ;      (newline)
       ; give back the node for the result
        successor-of-successor-node)
      (error "wrong type of argument given")))

;
;Execute a node
;
(define (execute-node node )
 
  (match node
    [(event-node '() _ _ _ _  _)
     void]
    [(event-node predecessors _ _ _ _ _)
     (let
         ((value (node-value (car predecessors))))
       
       (if (eq? 'undefined value)
           (set-node-value! node 'undefined)
           (set-node-value! node value)))] 
    ;for an event node just propagate the give result to its successors
    
    ;for a function execute the function on the give value en send result to successors
    [(function-node predecessors _ _ _  function _)
     (let ((value (node-value (car predecessors))))
       (if (eq? 'undefined value)
           (set-node-value! node 'undefined)
           (set-node-value! node (function value))))]
    [(or-node predecessors _ _ _ _ function _)
     ;filter node first apply filter on value when #t then propagate result to successors
     (let ((value-left (node-value (car predecessors)))
           (value-right (node-value (cdar predecessors))))
       (cond ((and (eq? 'undefined value-left)
                   (eq? 'undefined value-right))
              
              (set-node-value! node 'undefined))
             ((eq? 'undefined value-left)
              
              (set-node-value! node (function value-left))
              (set-node-value! (car predecessors) 'undefined))
             (else
              
              (set-node-value! node (function value-right))
              (set-node-value! (cdar predecessors) 'undefined))))]
                    
    [(filter-node predecessors _ _ _ filter function _)
     (let ((value (node-value (car predecessors))))
       (if (eq? 'undefined value)
           (set-node-value! node 'undefined)
           (if (filter value)
               (set-node-value! node (function value))
               (set-node-value! node 'undefined))))]
    [else void]   ))   
    
    ;
    ;PROPAGATE-EVENT
    ;
;Send value to all successors of the node
(define (propagate-event node)
  (for-each (lambda (node)
              (execute-node node))
            (event-node-order node)))
  ;(for-each (lambda (successor)
   ;           
    ;          (execute-node successor value))
     ;       (node-successors node)
      ;      ))
;
;CHANGE-EVENT
;
;propagate value
(define (change-event event new-value)
  (if (event-node? event)
      (begin
        (set-node-value! event new-value)
        (propagate-event event))
      (error "Not given an event")))
;
;EVENT-OR
;

;makes node for when a
(define (event-or event-1 event-2)
  (if (and (event-node? event-1)
           (event-node? event-2))
      (let ((successor-node (make-or-node  event-1 event-2 )))
        ;add new node to successors of both events
        (set-node-successors! event-1 (cons successor-node (node-successors event-1)))
        (set-node-successors! event-2 (cons successor-node (node-successors event-2)))
        (topological-sort successor-node)
        successor-node)
      (error "wrond type of argument given")))
 
;
;EVENT-AND
;

(define (event-filter event filter-function)
  (if (node? event)
      (begin
        ;make node with filter
        (let* ((node-filter (make-filter-node (list event) filter-function))) 
               ;add new node to successors
          (set-node-successors! event (cons node-filter (node-successors event)))
          (topological-sort node-filter)
          ;give back filter node
          node-filter))
      (error "wrong type of argument given")))


(define (display-id node)
     (match node
       [(event-node _ _ _ _ _ _)
        (display "event-node: ")
        (display (event-node-test node))
        (newline)]
        [(filter-node _ _ _ _ _ _ _)
        (display "filter-node: ")
        (display (filter-node-test node))
        (newline)]
         [(or-node _ _ _ _ _ _ _ )
        (display "or-node: ")
        (display (or-node-test node))
        (newline)]
        [(function-node _ _ _ _ _ _)
        (display "function-node: ")
        (display (function-node-test node))
        (newline)]
       [else
        (for-each display-id node)]))
(define (display-order node)
  (for-each
   display-id
   (event-node-order node)))


(provide event-or add-observer define + make-event lambda change-event display event-map event-filter > remove-observer display-order newline)




(define z (make-event))
;(set-event-node-test! z 1) 
(set-node-value! z 1)
(define l (add-observer z (lambda (x) (display "z"))))
;(set-function-node-test! l 2) 
(define w (event-map z (lambda (x) 5)))
;(set-event-node-test! w 3) 
(define m (event-map w (lambda (x) 2)))
;(set-event-node-test! m 4) 

(define q (event-filter z (lambda (x) #f) (lambda (x) (display 'l))))
;(set-filter-node-test! q 5)
;(remove-observer l)
(display "START")
  (display-order z)


