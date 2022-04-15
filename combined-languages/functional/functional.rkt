#lang racket
(require "../defmac.rkt"
         "nodes.rkt"
         
         "../combination/forall.rkt"
         (only-in "../combination/forall.rkt" multi-function-node)
         "../have-lock.rkt")
(provide add-observer remove-observer event-map event-filter event-or fire make-event root-event-node functional-propagate fire-from-logic-graph)


(define (get-root-nodes node)
  
  (cond ((root-event-node? node)
         (list node))
        ((pair? (node-predecessors node))
         (append-map get-root-nodes (node-predecessors node)))
        (else
         (get-root-nodes (node-predecessors node)))))

;;from https://en.wikipedia.org/wiki/Topological_sorting#:~:text=In%20computer%20science%2C%20a%20topological,before%20v%20in%20the%20ordering.


;;from https://en.wikipedia.org/wiki/Topological_sorting#:~:text=In%20computer%20science%2C%20a%20topological,before%20v%20in%20the%20ordering.
;;Topologisch sorteren
(define (topological-sort root-node)
  
  (define (get-leaf-nodes node)
    (if (null? (node-successors node))
        (list node)
        (append-map get-leaf-nodes (node-successors node))))
  (define permanent-mark 'permanent-mark)
  (define temporary-mark 'temporary-mark)

  ;;resets all predecessors of the node + node to not visited
  (define (reset node)
    (when (node-visited node)
      (set-node-visited! node #f)
      (cond ((pair? (node-predecessors node))
             (for-each
              reset
              (node-predecessors node)))
            ((null? (node-predecessors node)))
            (else (reset (node-predecessors node))))))
  

              

  (define topological-sorted-list '())
  (define index 0)
  (define (add-node! node)
    (set! topological-sorted-list (cons node topological-sorted-list))
    (set! index (+ index 1)))
  

  ;;for all start-nodes start visit function
  (define (sort start-nodes)
    (for-each
     visit
     start-nodes)
    )
  ;;add elements in topological order to list
  (define (visit node)
      (cond
        ;;already visited
        ((eq? permanent-mark (node-visited node)))
        ;;there is an error
        ((eq? temporary-mark (node-visited node))
         (error "There is a cycle"))
        (else
         (cond
           ((forall-or-node? node)
          
            
            (let* ((predecessors  (node-predecessors node))
                   (add-node (car predecessors))
                   (remove-node (cadr predecessors))
                   (root (node-predecessors remove-node))
                   (start-jump-node (make-start-jump-node
                                     (lambda (node)
                                       (car (node-value node))
                                       )))                         
                   (end-add-node  (make-end-jump-node 'L 3))
                   (end-remove-node (make-end-jump-node 'R 1)))
              (set-start-jump-node-jump-to! start-jump-node 3)
              (add-node! root)
              (add-node! start-jump-node)
              (add-node! add-node)
              (add-node! end-add-node)
              (add-node! remove-node)
              (add-node! end-remove-node)
              (set-node-visited! node permanent-mark)
              (add-node! node)))
              
                   
           ;;or node encountered
           ((or-node? node)
            (set-node-visited! node temporary-mark)
            (let* ((predecessors (node-predecessors node))
                   (condition (lambda (node)
                                (for/or ([root-node (get-root-nodes (car predecessors))])
                                  (eq? node root-node))))
                   (start-jmp-node (make-start-jump-node condition ))
                   (start-index index))
              (add-node! start-jmp-node)
              (let ((end-jmp-nodes 
                    ;for left and right predecessors do:
                    (map
                     (lambda (predecessor  direction)    
                         ;;add other nodes
                       (visit predecessor)
                         
                       ;add end jump node to register with the direction of the branch
                       (let ((end-jmp-node (make-end-jump-node direction 0))
                             (end-index index))
                         (add-node! end-jmp-node)
                         
                         (cons  end-index end-jmp-node)))
                     
                     predecessors
                     
                     (list 'L 'R))))
              (set-start-jump-node-jump-to! start-jmp-node
                                            (abs (- (+ (caar end-jmp-nodes) 1)
                                                    start-index)))
              (for-each (lambda (index-node)
                          (set-end-jump-node-idx! (cdr index-node)
                                                  (abs (- (car index-node)
                                                               index))))
                          
                        end-jmp-nodes)
              ;;add or node to top list
              (add-node! node)
              ;change mark to permanent
              (set-node-visited! node permanent-mark))))

                
                 
           (else
            ;;not or node or end event node so
            ;;keep goind down the tree
           
            (when (not (null? (node-predecessors node)))
              (set-node-visited! node temporary-mark)
              (visit (node-predecessors node)))
           
            (set-node-visited! node permanent-mark)
            (add-node!  node)
            )))))
  
  
  (let ((leaf-nodes (get-leaf-nodes root-node)))
    ;get topological sort
    (sort leaf-nodes)
  ;;reverse 
    (let ((reverse-sorted (reverse topological-sorted-list)))
      
      ;;reset all nodes
      (for-each reset leaf-nodes)
    ;;make vector and store in node
      (set-root-event-node-order! root-node (list->vector reverse-sorted)))))




        
            



;ADD-observer
(define (add-observer predecessor-node new-function)

  ;see if it is an event
  (if (event-node? predecessor-node)
      
      ;make a new node
     (let ((function-node (make-single-function-node  predecessor-node new-function ))
           (roots (get-root-nodes predecessor-node)))
       ;register node in graph
       (set-node-successors! predecessor-node (cons function-node (node-successors predecessor-node)))
       ;resort graph
       (for-each topological-sort roots)
       function-node)
     
     (error "wrond type of argument given")))

;REMOVE OBSERVER

(define (remove-observer observer-node)
  ;;check if function-node
  (when (single-function-node? observer-node)                 
    (let ((predecessor  (node-predecessors observer-node))
          (roots (get-root-nodes observer-node)))
      (set-node-successors! predecessor
                            (remove observer-node (node-predecessors predecessor)))
      (for-each topological-sort roots)
      (set-node-predecessors! observer-node '()))
    )
  void)

   

;MAP  OBSERVER
;(gives back a new event)

(define (event-map predecessor new-function)
  ;;check if event-node
  (if (event-node? predecessor)
      ;make 2 nodes 1 for the function and one event node for the result
      (let* ((function-node (make-single-function-node  predecessor new-function))
             (intermediate-event-node (make-intermediate-event function-node))
             (roots (get-root-nodes predecessor)))
        (set-node-successors! function-node (cons intermediate-event-node (node-successors function-node)))
        (set-node-successors! predecessor (cons function-node (node-successors predecessor)))
        (for-each topological-sort roots)
        ;;return event-node
        intermediate-event-node)
      (error "wrong type of argument given")))



;
;EVENT-OR
;
;makes node for when a
(define (event-or predecessor-1 predecessor-2)
  ;;check it it are event-nodes
  (if (and (event-node? predecessor-1)
           (event-node? predecessor-2))
      ;;make or node and event-node
      (let* ((or-node (make-or-node  predecessor-1 predecessor-2 ))
             (roots (remove-duplicates
                     (append (get-root-nodes predecessor-1)
                             (get-root-nodes predecessor-2)))))
        (set-node-successors! predecessor-1 (cons or-node (node-successors predecessor-1)))
        (set-node-successors! predecessor-2 (cons or-node (node-successors predecessor-2)))
        (for-each topological-sort roots)
        or-node)
      (error "wrond type of argument given")))
 
;
;EVENT-AND
;

(define (event-filter predecessor filter-function)
  (if (node? predecessor)
      ;make node with filter
      ;make node with event
      (let* ((node-filter (make-filter-node predecessor filter-function))
             (roots (get-root-nodes predecessor)))
        (set-node-successors! predecessor (cons node-filter (node-successors predecessor)))
        (for-each topological-sort roots)
        node-filter)
              
      (error "wrong type of argument given")))

;
;MAKE-EVENT
;
(define make-event make-root-event)


;
;CHANGE-EVENT
;
;propagate value
(defmac (fire event value)
  #:keywords fire
  #:captures graph-lock events
  (if (event-node? event)
      
        (cond ((have-lock?)
               (start-propagation events event value))
              (else 
               (semaphore-wait graph-lock)
               (parameterize ([have-lock? #t])
                 (start-propagation events event value))
               (semaphore-post graph-lock)))
      (error "Not given an event")))

(define (start-propagation events event value)
  (set-node-value! event value)
  (functional-propagate (root-event-node-order event) 0 'NO-BRANCH event)
  (when (not (eq? events event))
    (set-node-value! events value)
    (functional-propagate (root-event-node-order events) 0 'NO-BRANCH events)))

(define (fire-from-logic-graph event value)
  (set-node-value! event value)
  (functional-propagate (root-event-node-order event) 0 'NO-BRANCH event))

;
;Execute a node
;the node to execute
;a branch to indicate for a or node in which branch it needs to look
;start-event-node?: boolean to check if it is a start event or one lower in the graph
;
(define (functional-propagate nodes idx branch start-node)
  (define (loop idx branch)
    
    (when (> (vector-length nodes) idx)
      (let ((current-node (vector-ref nodes idx)))
       
        (match current-node
        
          
          [(start-jump-node condition jump-add)
           ;check condition
          
           (if (condition start-node)
               ;if true return nothing
               (loop (+ idx 1) branch )
               ;if false give back idx to where to jump
               (loop (+ jump-add idx) branch ))]
          
          [(end-jump-node direction jump-add)
          
           ;;give back direction for or branch later
           (loop  (+ jump-add idx) direction )]
          
          
          ;for a function execute the function on the give value and store result
          [(single-function-node predecessor _ _ _  function)
           (let ((value (node-value predecessor)))
             (cond ((eq? 'undefined value)
                    ;;in case a filter occurred
                    (set-node-value! current-node 'undefined))
                   (else 
                    ;calculate new value and store
                    (set-node-value! current-node (function value))))
             (loop  (+ idx 1) branch ))]
          
          ;for a function with random number of arguments
          [(multi-function-node predecessor _ _ _  function)
           (let ((args (cdr (node-value  predecessor))))
             ;calculate new value and store
             (set-node-value! current-node (apply function args))
             (loop  (+ idx 1) branch ))]
  
          [(or-node  predecessors _ _ _  )
           
           ;;check branch to see which value it needs to take
           (let ((value (if (eq? 'L branch)
                            ;left
                            (node-value (car predecessors))
                            ;right
                            (node-value (cadr predecessors)))))
             (set-node-value! current-node value)
             (loop  (+ idx 1) branch ))]
            
    
          [(filter-node predecessor _ _ _  filter)
           
           (let ((value (node-value  predecessor)))
             ;;if already been filtered out by previous filter or value is not #t by condition
             (if (or (eq? 'undefined value) (not (filter value)))
                 (set-node-value! current-node 'undefined)
                 ;;value allowed to pass
                 (set-node-value! current-node value))
             (loop  (+ idx 1) branch ))]
          [(event-node predecessor _ _ _ )
           (when (not (null? predecessor))
             
             (let* ((value (node-value predecessor)))
               (set-node-value! current-node value)))
           (loop  (+ idx 1) branch)]
          
          ))))
  #|( "propagate functional")
  (for ([e nodes])
    ( e))
  ( "STOP")|#
  
  (loop idx branch))



        
    
 
      

