#lang br/quicklang
(require "nodes.rkt"  "defmac.rkt" )
(provide (all-defined-out))


#|(define (read-syntax path port)
  (define string-tree  (read port))
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
(provide (rename-out [functionalRE3-module-begin #%module-begin]))|#





;;from https://en.wikipedia.org/wiki/Topological_sorting#:~:text=In%20computer%20science%2C%20a%20topological,before%20v%20in%20the%20ordering.
;;Topologisch sorteren
(define (topological-sort node)
  (define permanent-mark 'permanent-mark)
  (define temporary-mark 'temporary-mark)

  ;;resets all predecessors of the node + node to not visited
  (define (reset node)
    (when (node-visited node)
      (set-node-visited! node #f)
      (for-each
       reset
       (node-predecessors node))))
  

              

  (define topological-sorted-list '())
  (define index 0)
  (define (add-node! node)
    (set! topological-sorted-list (cons node topological-sorted-list))
    (set! index (+ index 1)))
  

  ;;for all start-nodes start visit function
  (define (sort start-nodes stop-node)
    (for-each
     (lambda (start-node)
       (visit start-node stop-node))
     start-nodes)
    )
  ;;add elements in topological order to list
  (define (visit node stop-node)
   
    (define (loop node)
      (cond
        ;;already visited
        ((eq? permanent-mark (node-visited node)))
        ;;there is an error
        ((eq? temporary-mark (node-visited node))
         (error "There is a cycle"))
        (else
         (cond
           ;;gotten to stop-node so stop with going further down the tree
           ((or
             (eq? node stop-node)
             (null? (node-predecessors node)))
            (add-node!  node)
            (set-node-visited! node permanent-mark)
            )
          
              
               
           ;;or node encountered
           ((or-node? node)
            (set-node-visited! node temporary-mark)
            (let* ((predecessors (node-predecessors node))
                   (end-jmp-nodes 
                    ;for left and right predecessors do:
                    (map
                     (lambda (predecessor  direction)
                       ;;make jump node and add before other nodes to list
                       ;jump-nodes contains index to spring to
                       (let ((jm (make-start-jump-node #f #f)))
                         (add-node!  jm)
                         ;;add other nodes
                         (loop predecessor)
                         ;;get all end nodes for the conditions in the jump-node
                         (let ((end-nodes (get-end-nodes predecessor)))
                           ;;change the condition in the jump-node:  node is equal to one of the endnodes
                           (set-start-jump-node-condition!
                            jm
                            (lambda (node)
                              (for/or ([end-node end-nodes])
                                (eq? node end-node)))))
                         ;add end jump node to register with the direction of the branch
                         (let ((end-jmp-node (make-end-jump-node direction 0)))
                           (add-node! end-jmp-node)
                           ;;set the correct index to jump to 
                           (set-start-jump-node-jump-to! jm index )
                           end-jmp-node)))
                     
                     predecessors
                     
                     (list 'L 'R))))
              (for-each (lambda (node)
                          (set-end-jump-node-idx! node index))
                        end-jmp-nodes)
              ;;add or node to top list
              (add-node! node)
              ;change mark to permanent
              (set-node-visited! node permanent-mark)))

                
                 
           (else
            ;;not or node or end event node so
            ;;keep goind down the tree
            (set-node-visited! node temporary-mark)
            (loop (car (node-predecessors node)))
            (set-node-visited! node permanent-mark)
            (add-node!  node)
            )))))
    (loop node)
   )


  ;get a list of all end nodes of a node
  (define (get-end-nodes node)
    (if (and (event-node? node)
             (null? (node-predecessors node)))
        (list node)
        (append-map (lambda (node)
                      (get-end-nodes node))
                    (node-predecessors node))))
  

  ;get topological sort
   (sort (event-node-leafs node) node)
  ;;reverse 
  (let ((reverse-sorted (reverse topological-sorted-list)))
    ;;reset all nodes
    (for-each reset (event-node-leafs node))
    ;;make vector and store in node
    (set-event-node-order! node (list->vector reverse-sorted))))
                      
;copies the event-node order to the if-node
(define (copy-order-to-if-node node)
  (display node)
  (let* ((then-node (end-if-then-node node))
         (else-node (end-if-else-node node))
         (start-node (car (node-predecessors then-node)))
         (new-storage (make-vector (+ (graph-size node) 5) 0)))
    (vector-copy! new-storage 0 (start-if-node-order start-node))
    (vector-copy! new-storage 5 (event-node-order node))
    (set-start-if-node-order! start-node new-storage)))

;;remove node from all predecessors nodes   
(define (for-all-event-predecessors-remove node to-remove-node new-leaf-nodes)
   (cond ((event-node? node)
          
         (let* ((leaf-nodes (event-node-leafs node))
                (remove-idx (vector-memq to-remove-node (event-node-order node)))
              
               ;;remove to remove node from leaf-nodes
                (filtered-leaf-nodes
                 (remq to-remove-node leaf-nodes)))
           ;;add predecessors if necessary to leaf nodes
           (set-event-node-leafs! node (append new-leaf-nodes  filtered-leaf-nodes))
           ;;remove node from sorted list
           (let ((new-order (vector-filter-not (lambda (node)
                                                 (eq? node to-remove-node))
                                               (event-node-order node))))
             ;;decrease all start-jump-node idx 1 down
             (for ([node new-order])
               (when (and (start-jump-node? node)
                          (> (start-jump-node-jump-to node)
                             remove-idx))
                 (- (start-jump-node-jump-to node) 1)))
             ;;change to new order
             (set-event-node-order! node new-order))
           ;;look further
           (cond ((event-node-of-if? node)
                  (copy-order-to-if-node node))
                 (else 
                  (for-each
                   (lambda (predecessor)
                     (for-all-event-predecessors-remove predecessor to-remove-node new-leaf-nodes))
                   (node-predecessors node))))))
         (else
          ;;look futher in tree
            (for-each
           (lambda (predecessor)
             (for-all-event-predecessors-remove predecessor to-remove-node new-leaf-nodes))
           (node-predecessors node)))))


(define (event-node-of-if? event-node)

  (and (not (null? (node-predecessors event-node)))
       (for/and ([predecessor (node-predecessors event-node)])
         (display predecessor)
         (multi-function-node? predecessor))))

;;give all event-nodes a sorted list
(define (for-all-event-predecessors-sort node to-add-node)
  (cond ((event-node? node)
         ;;when event node do the following:
         (let* ((leaf-nodes (event-node-leafs node))
               (predecessor-nodes (node-predecessors to-add-node))
               (filtered-leaf-nodes
                ;;remove nodes that are no longer a leaf node
                (filter (lambda (leaf-node)
                          (not (member leaf-node predecessor-nodes)))
                        leaf-nodes)))
           ;;add new node as leaf node
           (set-event-node-leafs! node (cons to-add-node filtered-leaf-nodes))
           ;;sort topological
           (topological-sort node)
           ;;go further down in tree
           (cond ((event-node-of-if? node)
                  (copy-order-to-if-node node))
                 (else 
                  (for-each
                   (lambda (predecessor)
                     (for-all-event-predecessors-sort predecessor to-add-node))
                   (node-predecessors node))))))
        (else
         ;;go further down in tree
         (for-each
          (lambda (predecessor)
            (for-all-event-predecessors-sort predecessor to-add-node))
          (node-predecessors node)))))
        
            



;ADD-observer
(defmac (add-observer predecessor-node new-function)
  #:keywords add-observer
  #:captures events
  ;see if it is an event
  (if (event-node? predecessor-node)
      
      ;make a new node
     (let ((successor-node (make-single-function-node (list predecessor-node) new-function )))
       ;;update all topological lists
       (for-all-event-predecessors-sort successor-node successor-node)
       ;;incease successor number
       (set-event-node-n-successors! predecessor-node (+  (event-node-n-successors predecessor-node) 1))
    ;return fuction node
       successor-node)
     
     (error "wrond type of argument given")))

;REMOVE OBSERVER

(define (remove-observer observer-node)
  ;;check if function-node
  (when (single-function-node? observer-node)
                  
      (let ((predecessor     (car (node-predecessors observer-node))))
        ;;decrease successor node
        (set-event-node-n-successors! predecessor (- (event-node-n-successors predecessor) 1))
        ;;check if predecessors are new leaf nodes
        (let ((new-leaf-nodes (filter (lambda (node) (eq? (event-node-n-successors node) 0)) (node-predecessors observer-node))))

      ;;remove from all top lists in graph
          (for-all-event-predecessors-remove predecessor observer-node new-leaf-nodes)
          
          (set-node-predecessors! observer-node '()))
    ))
  void)

        
       
      
 


;MAP  OBSERVER
;(gives back a new event)

(defmac (event-map event new-function)
  #:keywords event-map
  #:captures events
  ;;check if event-node
  (if (event-node? event)
      ;make 2 nodes 1 for the function and one event node for the result
      (let* ((successor-node (make-single-function-node (list event) new-function))
            (successor-of-successor-node (make-event-with-predecessor (list successor-node))))
        ;;increase successor number
         (set-event-node-n-successors! event (+  (event-node-n-successors event) 1))
        ;;update topological lst in graph
      (for-all-event-predecessors-sort successor-of-successor-node successor-of-successor-node)
        ;;return event-node
        successor-of-successor-node)
      (error "wrong type of argument given")))

;
;Execute a node
;the node to execute
;a branch to indicate for a or node in which branch it needs to look
;start-event-node?: boolean to check if it is a start event or one lower in the graph
;
(define (execute-node node branch start-event-node?)
 
  (match node
  
    [(event-node _ predecessors _ _ _ _ _)
     ;check if it is a start node
     #:when (not start-event-node?)
     ;;if not take value of previous node and store it 
     (let
         ((value (node-value (car predecessors))))
      
      
      (set-node-value! node value))
     void]
    [(start-jump-node _ condition jump-to)
     ;check condition
     (if (condition node)
         ;if true return nothing
         void
         ;if false give back idx to where to jump
         jump-to)]

    [(end-jump-node _ direction jump-to-idx)
     ;;give back direction for or branch later
     (cons  jump-to-idx direction)]
  
    
    ;for a function execute the function on the give value and store result
    [(single-function-node _ predecessors _ _  function)
     
     (let ((value (node-value (car predecessors))))
       (if (eq? 'undefined value)
           ;;in case a filter occurred
           (set-node-value! node 'undefined)
           ;calculate new value and store
           (set-node-value! node (function value))))
     void]
    ;for a function with random number of arguments
    [(multi-function-node _ predecessors _ _  function)
     
     (let ((values (start-if-node-values (car predecessors))))
       ;calculate new value and store
       (set-node-value! node (apply function values)))
     void]
    [(end-if-node direction)
     (cons  5 direction)]
    [(or-node _ predecessors _ _  )
     ;;check branch to see which value it needs to take
      (let ((value (if (eq? 'L branch)
                       ;left
                        (node-value (car predecessors))
                        ;right
                        (node-value (cadr predecessors)))))
              (set-node-value! node value))]
            
    
    [(filter-node _ predecessors _ _  filter)
     
     (let ((value (node-value (car predecessors))))
       ;;if already been filtered out by previous filter or value is not #t by condition
       (if (or (eq? 'undefined value) (not (filter value)))
           (set-node-value! node 'undefined)
           ;;value allowed to pass
           (set-node-value! node value)))
     void]
   
    [else void]   ))   
    
    ;
    ;PROPAGATE-EVENT
    ;
;Send value to node in the list nodes
;;nodes: topological sorted vector of nodes
;;idx: idx in nodes vector
;;start-node to know if start event-node or not
;;branch for or node
(define (propagate-event nodes idx start-node branch)
  (when (> (vector-length nodes) idx)
    (let ((current-node (vector-ref nodes idx)))
      
      ;;execute node
      (let ((return-value
             (execute-node
              current-node
              branch
              (eq? current-node start-node))))
        ;;return value is symbol -> jump-node-end occured so change branch value
        (cond 
              ;;return value is number -> jump-start-node occurred so changed idx to return-value
              ;;for jump
              ((number? return-value)
               (propagate-event nodes return-value start-node branch))
              ((pair? return-value)
                (propagate-event nodes (car return-value) start-node (cdr return-value)))
              (else
               (propagate-event nodes (+ idx 1) start-node branch)))))))
      

;
;CHANGE-EVENT
;
;propagate value
(define (start-propagation event new-value)
  (display event)
  (display new-value)
  (display (event-node-order event))
  (cond ((event-node? event)
         (begin
           ;;change value in start node
           (set-node-value! event new-value)
           ;;execute all other nodes
           (propagate-event (event-node-order event) 0 event 'undefined)))
        ((start-if-node? event)
         (set-start-if-node-values! node new-value)
         (propagate-event (start-if-node-order node) 1 node 'undefined))
      (error "Not given an event")))
;
;EVENT-OR
;
;makes node for when a
(defmac (event-or event-1 event-2)
  #:keywords event-or
  #:captures events
  ;;check it it are event-nodes
  (if (and (event-node? event-1)
           (event-node? event-2))
      ;;make or node and event-node
      (let* ((or-part (make-or-node  event-1 event-2 ))
             (event-part (make-event-with-predecessor (list or-part))))
        ;increase succeessos
        (set-event-node-n-successors! event-1 (+  (event-node-n-successors event-1) 1))
        (set-event-node-n-successors! event-2 (+  (event-node-n-successors event-2) 1))
        ;add new node to successors of both events
       ;return event-node
        event-part)
      (error "wrond type of argument given")))
 
;
;EVENT-AND
;

(defmac (event-filter event filter-function)
  #:keywords event-filter
  #:captures events
  (if (node? event)
      (begin
        ;make node with filter
        ;make node with event
        (let* ((node-filter (make-filter-node (list event) filter-function))
               (node-event (make-event-with-predecessor (list node-filter))))
          ;;increase successor number
          (set-event-node-n-successors! event (+  (event-node-n-successors event) 1))
          ;give back filter node
          node-event))
      (error "wrong type of argument given")))

(defmac (fire event-node value)
  #:keywords fire
  #:captures function-thd 
  (thread-send function-thd (message 'event (cons event-node value))))

(struct message (tag info))

(define (start-set! channel function)
  (function)
  (channel-put channel 'start))

(defmac (e-set! var value)
  #:keywords set!
  #:captures function-thd inside-turn
  (let
      ((channel (make-channel)))
    (cond((not inside-turn)
    
          (thread-send  function-thd (message 'set! (cons channel (lambda ()
                                                                    (set! var value)))))
          (sync channel))
         (else
          (set! var value)))))
 ;   (thread-wait (function-thd))
 ;   (thread-resume (current-thread))))

(defmac (make-functional-event-loop)
  #:keywords make-functional-event-loop
  #:captures inside-turn
  (parameterize ([inside-turn #t])
  (thread
   (lambda ()
     (let loop
       ((event (thread-receive)))
       (match event
         [(message 'event (cons node value))
          
            (start-propagation node
                             value)]
         [(message 'set! (cons channel function))
          (start-set! channel function)])
       (loop (thread-receive)))))))

(defmac (program exp ...)
  #:keywords program
  #:captures function-thd inside-turn
  (begin (define inside-turn (make-parameter #f))
         (let (               (function-thd (make-functional-event-loop)))
           (begin exp ...))))
;(define function-thd (make-parameter (make-functional-event-loop)))


#|(define (functional-event-loop mailbox)
  (lambda ()
    (let ((semaphore-mailbox (mailbox-semaphore mailbox))
          (queue (mailbox-queue mailbox)))
    (let loop
      ()
      (semaphore-wait semaphore-mailbox)
      (let 
          ((event (serve-event! mailbox)))
        (cond ((not event)
              
               (suspend-thread (current-t)))))))))


(provide  add-observer define + make-event lambda fire display event-map event-filter >   newline)|#


#|

(define z (make-event)) ;;1
(define e1 (make-event)) ;;2
;(set-event-node-test! z 1) 
;(set-node-value! z 1)
(define l (add-observer z (lambda (x) (display "z")))) ;;F 3
;(set-function-node-test! l 2) 
(define w (event-map z (lambda (x) 5))) ;F 4 E 5
;(set-event-node-test! w 3) 
(define m (event-map w (lambda (x) 2))) ;F 6 E 7
;(set-event-node-test! m 4) 

(define q (event-filter z (lambda (x) (> x 4)))) ;Fi 8 E9; (lambda (x) (display 'l))))
(define v (add-observer q (lambda (x) (display "y")))) ;F 10
(define p2 (event-or z e1)) ;;JumpOR 11 ;;E 12
(define o1 (add-observer p2 (lambda (x) (display "or")))) ;;OR
;(set-filter-node-test! q 5)
;(remove-observer l)
(display "START")
  (display-order z)|#


(program
 (define p 4)
 (define z (make-event))
 (add-observer z (lambda (x) (e-set! p 9) (display p))) (fire z 3))
