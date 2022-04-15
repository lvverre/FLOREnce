#lang racket
(require "../defmac.rkt"
         "nodes.rkt"
          racket/local)
(define (new-env)
  (make-hash))
(define (env-contains? var env)
  (hash-has-key? env var))
(define (add-to-env! var val env)
  (hash-set! env var val))
      

(define (lookup-var var env)
  (displayln var)
  (displayln env)
   (if (hash-has-key? env var)
       (hash-ref env var)
       (error (format "~a is not defined" var))))



(struct const (value) #:transparent)
(struct event ())
(define compiled-event (event))
(struct fun-apl (operator operands) #:transparent)
(struct if-exp (pred then else) #:transparent)

(define reactor-env (new-env))
(define native-map-env (new-env))
(define native-filter-env (new-env))

(define (set-up-native-map)
  (map (lambda (var val) (add-to-env! var (const val) native-map-env))
       '(+ - / *)
       (list + - / *)))
(define (set-up-native-filter)
  (map (lambda (var val) (add-to-env! var (const val) native-filter-env))
       '(< > equal? eq? <= >=  = not and or )
       (list < > equal? eq? <= >= = (lambda (value)
                                      (not value))
             (lambda (el1 el2)
               (and el1 el2))
             (lambda (el1 el2)
               (or el1 el2)))))
(set-up-native-map)
(set-up-native-filter)


(define (topological-sort leaf-nodes root-nodes)
  
  
  (define (permanent? el)
    (>= (dependency-node-idxval el) 0))
  (define (temporary? el)
    (= -1 (dependency-node-idxval el)))
  (define temporary -1)
  

              

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
  (define (get-predecessors-idx node)
    (match node
      [(root-node idxval)
       (list idxval)]
      [_ (append-map get-predecessors-idx (internal-node-predecessors node))]))

  (define (visit-or-branch predecessor direction)
    (let ((start-node (start-jump-node -1 -1))
          (start-index index))
      (add-node! start-node)
      (let ((roots (visit predecessor)))
        (set-start-jump-node-condition! start-node roots)
        (let ((end-node (end-jump-node direction -1))
              (end-index index))
          (add-node! end-node)
          (set-start-jump-node-jump! start-node
                                     (abs (- (+ end-index 1)
                                             start-index)))
          (cons end-index end-node)))))
          
    
  ;;add elements in topological order to list
  (define (visit node)
      (cond
        ;;already visited
        ((permanent? node) (get-predecessors-idx node))
        ;;there is an error
        ((temporary?  node)
         (error "There is a cycle"))
        (else
         (cond
           ((root-node? node)
            (set-dependency-node-idxval! node index)
            (add-node! node)
            (list (dependency-node-idxval node)))
            
           #|((forall-or-node? node)            
            (let* ((predecessors  (node-predecessors node))
                   (add-node (car predecessors))
                   (remove-node (cadr predecessors))
                   (root (internal-node-predecessors remove-node))
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
              (set-dependency-node-idxval! node index)
              (add-node! node)))|#
              
                   
           ;;or node encountered
           ((or-node? node)
            (set-dependency-node-idxval! node temporary)
            (let* ((predecessors (internal-node-predecessors node))
                   (pair-idx-end-node (map visit-or-branch predecessors (list 'L 'R))))
              (for-each (lambda (index-node)
                          (set-end-jump-node-idx! (cdr index-node)
                                                  (abs (- (car index-node)
                                                          index))))
                        
                        pair-idx-end-node)
              (set-dependency-node-idxval! node index)
              ;;add or node to top list
              (add-node! node)
              ;change mark to permanent
              ))

                
                 
           (else
            ;;not or node or end event node so
            ;;keep goind down the tr
            (set-dependency-node-idxval! node temporary)
            (let ((roots (visit (car (internal-node-predecessors node)))))
              (set-dependency-node-idxval! node index)
              (add-node!  node)
              roots)
            )))))
  
  
  (for-each (lambda (node)
              (set-dependency-node-idxval! node index)
              (add-node! node))
            root-nodes)
    ;get topological sort
    (sort leaf-nodes)
  ;;reverse 
    (let ((reverse-sorted (reverse topological-sorted-list)))
    ;;make vector and store in node
      (list->vector reverse-sorted)))






(struct reactor (ins dag outs) #:transparent)



  
(define ((compile env event-name) exp )
  (display event-name)
  (match exp
    [`(if ,pred ,then-branch ,else-branch)
     (if-exp
      ((compile env event-name) pred )
      ((compile env event-name)then-branch )
      ((compile env event-name) else-branch ))]
    [value
     #:when (or (number? value) (string? value))
     (const value)]
    
    [`(,op ,opands ...)
     (let ((c-operator (const-value (lookup-var op env)))
           (c-opands (map (compile env event-name) opands)))
       (fun-apl
        c-operator
        c-opands))]
    [event
     #:when (equal? event event-name)
     compiled-event]
    [value
     #:when (symbol? value)
     (lookup-var value env)]
    [_ (error (format "~a is not allowed in body-part" exp))]))

(define (interpret exp event-value)
  (define (process-loop exp)
    (match exp
      [(fun-apl operator opands)
       (let ((evaluated-opands (map (lambda (opand)
                                      (const-value (process-loop opand)))
                                    opands)))
         (const (apply operator evaluated-opands)))]
      [(event) event-value]
      [value value]))
  (process-loop exp))
  
  
  
  
(define (make-root-node! name env)
  (let ((new-node (root-node -2)))
    (add-to-env! name new-node env)
    new-node))

(define (make-map-node event-name expr env)
  (if (symbol? event-name)
      (let ((predecessor (lookup-var event-name env)))
        (cond (predecessor
               (display "hier")
               (make-single-function-node  predecessor ((compile native-map-env event-name) expr)))
              (else
               (error (format "~a is not defined" event-name)))))
      (error (format "map: accepts event name as first argument not ~a" event-name))))
           
(define (define-node name node env)
  (cond ((and (symbol? name)
              (node? node))
         (add-to-env! name node env))
        ((symbol? name)
         (error (format "def: accepts map: or filter: or or: as second argument not ~a" node)))
        (else
         (error (format "def: accepts event name as first argument not ~a" name)))))


(define (make-filter-node event-name expr env)
  (if (symbol? event-name)
      (let ((predecessor (lookup-var event-name env)))
        (cond (predecessor
               (filter-node -2 (list predecessor) ((compile native-filter-env event-name) expr)))
              (else
               (error (format "~a is not defined" event-name)))))
      (error (format "filter: accepts event names as first argument not ~a" event-name))))


(define (make-or-node event-name-left event-name-right env)
  (display env)
  (let ((left-predecessor (lookup-var event-name-left env))
        (right-predecessor (lookup-var event-name-right env)))
    (or-node -2 (list left-predecessor right-predecessor))))
         
  
(defmac (reactor: name  (in: ins ...) (out: outs ...) r: exprs ...  )
  #:keywords reactor: in: r: out:
  #:captures reactor-env map: filter: or: def:
  (if (env-contains?  'name reactor-env)
      (error (format "Reactor with ~a already defined" 'name))
      (let* ((node-env (new-env)) 
             (in-nodes (map (lambda (name)
                              (make-root-node! name node-env))
                            '(ins ...))))
        (local [(defmac (def: event-name node)
                  #:keywords def:
                  #:captures map: filter: or:
                  (local [(defmac (or: name-left name-right)
                            #:keywords or:
                            (make-or-node 'name-left 'name-right node-env))
                          (defmac (map: name expr )
                            #:keywords map:
                            (make-map-node 'name 'expr node-env))
                          (defmac (filter: name expr)
                            #:keywords filter:
                            (make-filter-node 'name 'expr node-env))]
                    (define-node 'event-name node node-env)))]
          (begin
            exprs ...
            (let* ((out-nodes (map (lambda (out-name) (lookup-var out-name node-env)) '(outs ... )))
                   (sorted (topological-sort out-nodes in-nodes)))
              (for ([node sorted])
                (when (internal-node? node)
                  
                  (set-internal-node-predecessors! node
                                                   (map dependency-node-idxval (internal-node-predecessors node)))))
          (add-to-env!
           'name
           (reactor
            (list->vector (map dependency-node-idxval in-nodes))
            sorted
            (list->vector (map dependency-node-idxval out-nodes)))
           reactor-env)))))))
(define (get-node-at-idx dag idx)
  (vector-ref dag idx))

(define (copy-dag start-index dag)
  (define new-dag (make-vector (- (vector-length dag) start-index) 'empty))
  (define (copy-node-loop idx)
    (when (< idx (vector-length dag))
      (let ((new-node (match (get-node-at-idx dag idx)
                        [(root-node idx)
                         (root-node idx)]
                        [(filter-node idx predecessors body)
                         (filter-node idx predecessors body)]
                        [(single-function-node idx predecessors body)
                         (single-function-node idx predecessors body)]
                        [(or-node idx predecessors)
                         (or-node idx predecessors)]
                        [(start-jump-node condition jump)
                         (start-jump-node condition jump)]
                        [(end-jump-node direction jump)
                         (end-jump-node direction jump)])))
        (vector-set! new-dag (- idx start-index) new-node)
        (copy-node-loop (+ idx 1)))))
  (copy-node-loop start-index)
  new-dag)


(define (update-idx-dag offset new-ins dag)
  (define number-of-ins (vector-length new-ins))
  (define (update-idx-node predecessor-idx)
    (if (< predecessor-idx number-of-ins)
        (vector-ref new-ins predecessor-idx)
        (+ offset predecessor-idx)))
  (define (loop index)
    (when (< index (vector-length dag))
      (let ((node (get-node-at-idx dag index)))
        (when (dependency-node? node)
          (set-dependency-node-idxval! node (- (+ offset index) number-of-ins))
          (set-internal-node-predecessors! node
                                           (map update-idx-node (internal-node-predecessors node))))
        (loop (+ index 1)))))
  (loop (+ offset number-of-ins)))
        

(defmac (ror: name with: reactor-name1 reactor-name2)
  #:keywords ror: with:
  (if (env-contains? 'name reactor-env)
      (error (format "Reactor ~a is already defined" 'name)) 
      (let ((reactor1  (lookup-var 'reactor-name1 reactor-env))
            (reactor2 (lookup-var 'reactor-name2 reactor-env)))
        (let* ((ins-1 (reactor-ins reactor1))
               (dag-1 (reactor-dag reactor1))
               (outs-1 (reactor-outs reactor1))
               (ins-2 (reactor-ins reactor2))
               (dag-2 (reactor-dag reactor2))
               (outs-2 (reactor-outs reactor2))
               (new-dag (vector-append
                     (copy-dag 0 dag-1)
                     (copy-dag (vector-length ins-2) dag-2)))
               (new-outs (for/vector ([old-out outs-2 ])
                           (- (+ (vector-length dag-1) old-out)(vector-length ins-2)))))
          (cond ((not (= (vector-length outs-1) (vector-length ins-2)))
             (error (format "Number of outputs in ~a (~a) is not equal to number of inputs ~a (~a)"
                            'reactor-name1
                            (vector-length outs-1)
                            'reactor-name2
                            (vector-length ins-2))))
                (else
                 (update-idx-dag (vector-length dag-1) outs-1 new-dag)
                 (add-to-env! 'name
                              (reactor
                               (vector-copy ins-1)
                               new-dag
                               new-outs)
                              reactor-env)))))))



(define (execute-turn reactor input)
  (define dag (v
(defmac (turn: deployed-name            
      