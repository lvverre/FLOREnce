#lang racket
(require ;"compile-interpret.rkt"
         "nodes2.rkt"
         "../environment.rkt"
         "../defmac.rkt"
         ;"../root-env.rkt"
         )

(provide (all-defined-out))
(define (compile-reactors p)
  'n)
;(require (for-syntax syntax/parse))
(require syntax/parse)
(struct reactor (ins dag outs) #:transparent)


(define (topological-sort leaf-nodes root-nodes) 
  (define (permanent? el)
    (>= (dependency-node-idx el) 0))
  (define (temporary? el)
    (= -1 (dependency-node-idx el)))
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
  

  (define (get-predecessors node)
    (match node
      ([root-node idx]
       (list idx))
      (_
       (append-map get-predecessors
                   (internal-node-predecessors node)))))
          
    
  ;;add elements in topological order to list
  (define (visit node)
      (cond
        ;;already visited
        ((permanent? node) (get-predecessors node))
        ;;there is an error
        ((temporary?  node)
         (error "There is a cycle"))
        (else
         (cond
           ((root-node? node)
            (set-dependency-node-idx! node index)
            (add-node! node)
            (list (- index 1)))
            
          
              
                   
           ;;or node encountered
           ((or-node? node)
            (set-dependency-node-idx! node temporary)
            (let* ((predecessors (internal-node-predecessors node))
                   (roots (append-map (lambda (predecessor)
                                        (let ((jump-node (start-jump-node -1 -1))
                                              (jump-index index))
                                          (add-node! jump-node)
                                          (let ((roots (visit predecessor)))
                                            (set-start-jump-node-condition! jump-node roots)
                                            (set-start-jump-node-jump! jump-node
                                                                       (abs (- index
                                                                               jump-index)))
                                            roots)))
                                      predecessors)))
              
              (set-dependency-node-idx! node index)
              ;;add or node to top list
              (add-node! node)
              ;change mark to permanent
              roots))

                
                 
           (else
            ;;not or node or end event node so
            ;;keep goind down the tr
            (set-dependency-node-idx! node temporary)
            (let ((roots (visit (car (internal-node-predecessors node)))))
              (set-dependency-node-idx! node index)
              (add-node!  node)
              roots
              )
            )))))
  
  
  (for-each (lambda (node)
              (set-dependency-node-idx! node index)
              (add-node! node))
            root-nodes)
    ;get topological sort
    (sort leaf-nodes)
  ;;reverse 
    (let ((reverse-sorted (reverse topological-sorted-list)))
    ;;make vector and store in node
      (list->vector reverse-sorted)))



(define (make-root-node! name env)
  (let ((new-node (root-node -2)))
    (add-to-local-env! name new-node env)
    new-node))


 


(define (make-map-node event-name expr env)
  (if (symbol? event-name)
      (let ((predecessor (lookup-local-var-error event-name env)))
        (cond (predecessor
             ;  (display "hier")
               (make-single-function-node  predecessor (list (compile-reactors expr)) event-name))
              (else
               (error (format "~a is not defined" event-name)))))
      (error (format "map: accepts event name as first argument not ~a" event-name))))
           
(define (define-node name node env)
  (cond ((and (symbol? name)
              (node? node))
         (add-to-local-env! name node env))
        ((symbol? name)
         (error (format "def: accepts map: or filter: or or: as second argument not ~a" node)))
        (else
         (error (format "def: accepts event name as first argument not ~a" name)))))


(define (make-filter-node event-name expr env)
  (if (symbol? event-name)
      (let ((predecessor (lookup-local-var-error event-name env)))
        (cond (predecessor
               (filter-node -2 (list predecessor) (compile-reactors expr) event-name))
              (else
               (error (format "~a is not defined" event-name)))))
      (error (format "filter: accepts event names as first argument not ~a" event-name))))


(define (make-or-node event-name-left event-name-right env)
  ;(display env)
  (let ((left-predecessor (lookup-local-var-error event-name-left env))
        (right-predecessor (lookup-local-var-error event-name-right env)))
    (or-node -2 (list left-predecessor right-predecessor))))

(define (interpret-body-def: body env)
  (syntax-parse body
    [((~literal map:) var:id exp:expr)
     (make-map-node (syntax-e #'var)
                    #'exp
                    env)]
    [((~literal filter:) var:id exp:expr)
     (make-filter-node (syntax-e #'var)
                       #'exp
                       env)]
    [((~literal or:) var:id left:id right:id)
     (make-or-node (syntax-e #'var)
                   (syntax-e #'left)
                   (syntax-e #'right)
                   env)]))

     
(define (interpret-body-reactor body env)
  (syntax-parse body
    [((~literal def:) var:id def-body) 
     (let ((node (interpret-body-def: #'def-body env)))
       (define-node (syntax-e #'var) node env))]))



 
(define (interpret-reactor: stx)
  (syntax-parse stx
    [( (~literal reactor:) name:id  ( (~literal in:) (~var ins id) ... ) exprs ... ( (~literal out:) (~var outs id) ...  ))
     (if (env-contains?  (syntax-e #'name) global-env)
         (error (format "Reactor with ~a already defined" (syntax-e #'name)))
         (let* ((node-env (new-local-env)) 
                (in-nodes (map (lambda (name)
                                 (make-root-node! (syntax-e name) node-env))
                               (syntax->list #'(ins ... )))))
           (for-each (lambda (expr)
                       (interpret-body-reactor expr node-env))
                     (syntax->list #'(exprs  ...)))
           (let* ((out-nodes (map (lambda (out-name) (lookup-local-var-error (syntax-e out-name) node-env)) (syntax->list #'(outs ... ))))
                  (sorted (topological-sort out-nodes in-nodes)))
              (for ([node sorted])
                (when (internal-node? node)
                  
                  (set-internal-node-predecessors! node
                                                   (map dependency-node-idx (internal-node-predecessors node)))))
              (displayln (format "REACTOr: ~a"  (reactor
            (list->vector (map dependency-node-idx in-nodes))
            sorted
            (list->vector (map dependency-node-idx out-nodes)))))
              
          (add-to-env!
           'name
           (reactor
            (list->vector (map dependency-node-idx in-nodes))
            sorted
            (list->vector (map dependency-node-idx out-nodes)))
           global-env))))]))



;;
;;ROR
;;
 
(define (get-node-at-idx dag idx)
  (vector-ref dag idx))

(define (copy-dag start-index dag)
  (define new-dag (make-vector (- (vector-length dag) start-index) 'empty))
  (define (copy-node-loop idx)
    (when (< idx (vector-length dag))
      (let ((new-node (match (get-node-at-idx dag idx)
                        [(root-node idx)
                         (root-node idx)]
                        [(filter-node idx predecessors body var)
                         (filter-node idx predecessors body var)]
                        [(single-function-node idx predecessors body var)
                         (single-function-node idx predecessors body var)]
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
          (set-dependency-node-idx! node (- (+ offset index) number-of-ins))
          (set-internal-node-predecessors! node
                                           (map update-idx-node (internal-node-predecessors node))))
        (loop (+ index 1)))))
  (loop (+ offset number-of-ins)))
        

(define (interpret-ror stx)
  (syntax-parse stx
    [((~literal ror:) name:id (~literal with:) reactor-name1:id reactor-name2:id)
     (if (env-contains? (syntax-e #'name) global-env)
         (error (format "Reactor ~a is already defined" 'name)) 
         (let ((reactor1  (lookup-var (syntax-e #'reactor-name1) global-env))
               (reactor2 (lookup-var (syntax-e #'reactor-name2) global-env)))
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
                                   (syntax-e #'reactor-name1)
                                   (vector-length outs-1)
                                   (syntax-e #'reactor-name2)
                                   (vector-length ins-2))))
                (else
                 (update-idx-dag (vector-length dag-1) outs-1 new-dag)
                 (add-to-env! 'name
                              (reactor
                               (vector-copy ins-1)
                               new-dag
                               new-outs)
                              global-env))))))]))



