#lang racket
(require "../defmac.rkt"
         "../functional/deployment.rkt"
         "../functional/datastructures.rkt"
         (only-in "../functional/compile-interpret.rkt" c-const-value)
         "../logical/tokens.rkt"
         "../functional/environment.rkt")
        
(provide (all-defined-out))


(define (init-fact-collector! collector collection-size fact-collector-size fact-name)
  (set-fact-collector-fact-name! collector fact-name)
  (set-fact-collector-tail! collector fact-collector-size)
  (set-fact-collector-storage! collector
                               (build-vector (+ fact-collector-size 1)
                                    (lambda (n)
                                      (make-vector collection-size 'empty)))))
                      









                   
            
                      
        
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
             
               (set-deployedL-input-places! existing-deployedL
                                            (cons idx
                                                  (deployedL-input-places existing-deployedL))))
              (else
               
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
  
  