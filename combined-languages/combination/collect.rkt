#lang racket
(require "../defmac.rkt"
         "datastructures.rkt"
         "../functional/deployment.rkt"
         (only-in "../functional/compile-interpret.rkt" c-const-value)
         "../logic/tokens.rkt"
         "../functional/environment.rkt")
        
(provide (all-defined-out))


(define (init-fact-collector! collector collection-size fact-collector-size fact-name)
  (set-fact-collector-fact-name! collector fact-name)
  (set-fact-collector-tail! collector fact-collector-size)
  (set-fact-collector-storage! collector
                               (build-vector (+ fact-collector-size 1)
                                    (lambda (n)
                                      (make-vector collection-size 'empty)))))
                      




(define (empty-place? collection idx)
  (displayln  (get-collection collection idx)) 
  (eq? 'empty (get-collection collection idx)))

(define (full? collection)
  
  (for/and ([value collection])
    (not (equal? 'empty value))))


(define (propagate-to-logic-graph collector full-collection root root-lock timer)
  (let ((token (if (add-fact-collector? collector)
                   (make-alpha-token-add (fact-collector-fact-name collector)
                                         (map c-const-value (vector->list full-collection))
                                         (add-fact-collector-time-interval collector))
                   (make-alpha-token-remove (fact-collector-fact-name collector)
                                            (vector->list full-collection)))))
    (start-propagation token  root-lock root timer)))

(define (put-in-collector-from-event! deployedL value root root-lock timer)
  (let ((idxs-to-update (deployedL-input-places deployedL))
        (collector (deployedL-collector deployedL)))
    (for ([idx idxs-to-update])
      (let ((full-collection (put-in-collector!  collector value idx)))
        (when full-collection
          (propagate-to-logic-graph collector full-collection
                                    root root-lock timer))))))
          

(define (put-in-collector-from-deployedR! collector values root root-lock timer)
  (displayln "VALUES:")
  (displayln values)
  (let loop-put-in-colletor
    ([idx 0])
 
    (when (< idx (vector-length values))
      (let ((value (vector-ref values idx)))
        (if (not (eq? 'empty value))
            
            (let ((full-collection (put-in-collector! collector
                                                      value
                                                      idx)))
              
              (when full-collection
              (propagate-to-logic-graph collector full-collection
                                        root root-lock timer)))
            (displayln "NO VALUE"))
          (loop-put-in-colletor (+ idx 1)))))
        )
            
    

(define (put-in-collector! fact-collector value idx-collection )
  (define collections (fact-collector-storage fact-collector))
  (define size (vector-length collections))
  (define (move!)
    (let ((new-collection  (make-collection (size-collection
                                             (vector-ref (fact-collector-storage fact-collector)
                                                         (fact-collector-head fact-collector)))
                                            'empty))
         
          (old-head (fact-collector-head fact-collector)))
          
      (vector-set! collections
                   (fact-collector-tail fact-collector) 
                   new-collection)
      
      ;(put-collection! new-collection idx-collection value)
     
      (set-fact-collector-tail! fact-collector (modulo (+ (fact-collector-tail fact-collector) 1)
                                                       size))
                                                          
      (set-fact-collector-head! fact-collector (modulo (+ old-head 1) size))
      
      (vector-ref collections old-head)))
 
  (let loop-for-place
    ((idx-fact-collector (fact-collector-head fact-collector)))
    
    (cond ((= idx-fact-collector (fact-collector-tail fact-collector))
        
           (move!)
           (put-collection! (get-collection collections idx-fact-collector)
                            idx-collection
                            value)
          
           #f)          
          ((empty-place? (vector-ref collections  idx-fact-collector) idx-collection)
           (let ((collection (vector-ref collections idx-fact-collector)))
            
             (put-collection! collection idx-collection value)
            
             (if (full? collection)
                 (begin 
                        (move!))
                 #f)))
          (else
           (loop-for-place (modulo (+ idx-fact-collector 1) size))))))
                   
            
                      
        
(define (calculate-collection-size logic-connectors)
  (if (deployedR? (car logic-connectors))
      (vector-length (deployedR-ins (car logic-connectors)))
      (length logic-connectors)))
 




(define (contains-collector? collector logic-connector)
  (let loop
    ((deployedLs (logic-connector-logical-cmpts logic-connector)))
    (cond ((null? deployedLs) #f)
          ((eq? (deployedL-collector (car deployedLs))
                collector)
           (car deployedLs))
          (else (loop (cdr deployedLs))))))


(define (register-deployedR-to-collector! logic-connector collector)
    
  (set-logic-connector-logical-cmpts! logic-connector
                                      (cons collector
                                            (logic-connector-logical-cmpts logic-connector))))
(define (register-events-to-collector! logic-connectors collector)
    (for/fold
        ([idx 0])
        ([logic-connector logic-connectors])
      (let ((existing-deployedL (contains-collector? collector logic-connector)))
        (cond (existing-deployedL
               (displayln "Exsiting")
               (set-deployedL-input-places! existing-deployedL
                                            (cons idx
                                                  (deployedL-input-places existing-deployedL))))
              (else
               (displayln "New")
              
               (let ((new-deployedL (deployedL (list idx) collector)))
                 (set-logic-connector-logical-cmpts! logic-connector
                                                  (cons new-deployedL
                                                        (logic-connector-logical-cmpts logic-connector)))
                )))
        (+ idx 1))))
         

(define (check-argument-type logic-connectors fact-name)
  (if   (and
         (not (null? logic-connectors))
         (not (or (for/and ([logic-connector logic-connectors])
                   (functional-event? logic-connector))
                 (and (null? (cdr logic-connectors))
                      (deployedR? (car logic-connectors))))))
        (error (format "Wrong type argument for collect* expected events or 1 deployed reactor given ~a"
                       logic-connectors))
        (when (not (symbol? fact-name))
            (error (format (error "Wrong type argument for collect* expected symbol given ~a" fact-name))))))
        
  
(define (collect* logic-connector-names fact-name size collector functional-environment)
      (let ((logic-connectors (map (lambda (var ) (lookup-var var functional-environment))
                                    logic-connector-names )))
        (check-argument-type logic-connectors fact-name)
        (let ((collection-size (calculate-collection-size logic-connectors)))
          (init-fact-collector! collector collection-size size fact-name)
          (if (deployedR? (car logic-connectors))
              (register-deployedR-to-collector! (car logic-connectors) collector)
              (register-events-to-collector! logic-connectors collector)))))
          
      

(define (add-collect* logic-connector-names fact-name time-interval size env)

  (if (number? time-interval)
      (collect* logic-connector-names 
                fact-name
                size
                (add-fact-collector 0 -1 -1 -1 time-interval)
                env)
      (error (format "Wrong type argument for add-collect* expected number given ~a" time-interval))))

(define (remove-collect* logic-connector-names   fact-name size env)
  (collect* logic-connector-names fact-name
            size (remove-fact-collector 0 -1 -1 -1 )
            env))
    


(defmac (add-collect1: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect1: as: for:
  #:captures functional-environment
  (add-collect* '(logic-connector-names ...) 'fact-name time-interval  1 functional-environment))

(defmac (add-collect2: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect2: as: for:
  #:captures functional-environment
   (add-collect* '(logic-connector-names ...) 'fact-name time-interval  2 functional-environment))

(defmac (add-collect3: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect3: as: for:
  #:captures functional-environment
   (add-collect* '(logic-connector-names ...) 'fact-name time-interval  3 functional-environment))

(defmac (add-collect4: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect4: as: for:
  #:captures functional-environment
   (add-collect* '(logic-connector-names ...) 'fact-name time-interval  4 functional-environment))


(defmac (remove-collect1: logic-connector-names ... as: fact-name )
  #:keywords remove-collect1: as: 
  #:captures functional-environment
   (remove-collect* '(logic-connector-names ...) 'fact-name 1 functional-environment))

(defmac (remove-collect2: logic-connector-names ... as: fact-name )
  #:keywords remove-collect2: as: 
  #:captures functional-environment
  (remove-collect* '(logic-connector-names ...) 'fact-name 2 functional-environment))

(defmac (remove-collect3: logic-connector-names ... as: fact-name)
  #:keywords remove-collect3: as: 
  #:captures functional-environment
  (remove-collect* '(logic-connector-names ...) 'fact-name 3 functional-environment))

(defmac (remove-collect4: logic-connector-names ... as: fact-name)
  #:keywords remove-collect4: as: 
  #:captures functional-environment
  (remove-collect* '(logic-connector-names ...) 'fact-name 4 functional-environment))
  
  