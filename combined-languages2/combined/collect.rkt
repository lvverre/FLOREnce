#lang racket
(require "../defmac.rkt"
         "../functional/deployment.rkt"
         "../functional/datastructures.rkt"
        
         "../logical/tokens.rkt"
         "../functional/environment.rkt"
         "../root-env.rkt")
        
(provide (all-defined-out))
(require (for-syntax syntax/parse))

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
    ((connectors (functional-node-connectors logic-connector)))
    (cond ((null? connectors) #f)
          ((eq? (functional-connector-app-info (car connectors))
                collector)
           (car connectors))
          (else (loop (cdr connectors))))))


(define (register-deployedR-to-collector! logic-connector collector)
    
  (set-functional-node-connectors! logic-connector
                                      (cons (func->logic-connector 0 collector)
                                            (functional-node-connectors logic-connector))))
(define (register-events-to-collector! logic-connectors collector)
    (for/fold
        ([idx 0])
        ([logic-connector logic-connectors])
      (let ((existing-connector (contains-collector? collector logic-connector)))
        (cond (existing-connector
             
               (set-functional-connector-input-info! existing-connector
                                            (cons idx
                                                  (functional-connector-input-info existing-connector))))
              (else
               
               (let ((new-connector (func->logic-connector (list idx) collector)))
                 (set-functional-node-connectors! logic-connector
                                                  (cons new-connector
                                                        (functional-node-connectors logic-connector)))
                )))
        (+ idx 1))))
         

(define (check-argument-type logic-connectors fact-name)
  (if   (and
         (not (null? logic-connectors))
         (not (or (for/and ([logic-connector logic-connectors])
                   (event-node? logic-connector))
                 (and (null? (cdr logic-connectors))
                      (deployedR? (car logic-connectors))))))
        (error (format "Wrong type argument for collect* expected events or 1 deployed reactor given ~a"
                       logic-connectors))
        (when (not (symbol? fact-name))
            (error (format (error "Wrong type argument for collect* expected symbol given ~a" fact-name))))))
        
  
(define (collect* logic-connector-names fact-name size collector root-env)
      (let* ((global-env (root-env-env root-env))
             (logic-connectors (map (lambda (var ) (lookup-var-error var (root-env-env root-env)))
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
    


(define-syntax (add-collect1 stx)
  (syntax-parse stx
    [((~literal add-collect1:) logic-connector-names:id ... (~literal as:) fact-name:id (~literal for:) time-interval:number)
     (add-collect* '(logic-connector-names ...) 'fact-name time-interval  1 )]))

(define-syntax (add-collect2 stx)
  (syntax-parse stx
    [((~literal add-collect1:) logic-connector-names:id ... (~literal as:) fact-name:id (~literal for:) time-interval:number)
     (add-collect* '(logic-connector-names ...) 'fact-name time-interval  2 )]))

(define-syntax (add-collect3 stx)
  (syntax-parse stx
    [((~literal add-collect1:) logic-connector-names:id ... (~literal as:) fact-name:id (~literal for:) time-interval:number)
     (add-collect* '(logic-connector-names ...) 'fact-name time-interval  3 )]))
(define-syntax (add-collect4 stx)
  (syntax-parse stx
    [((~literal add-collect1:) logic-connector-names:id ... (~literal as:) fact-name:id (~literal for:) time-interval:number)
     (add-collect* '(logic-connector-names ...) 'fact-name time-interval  4 )]))

(defmac (add-collect2: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect2: as: for:
  #:captures root-env
   (add-collect* '(logic-connector-names ...) 'fact-name time-interval  2 root-env))

(defmac (add-collect3: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect3: as: for:
  #:captures root-env
   (add-collect* '(logic-connector-names ...) 'fact-name time-interval  3 root-env))

(defmac (add-collect4: logic-connector-names ... as: fact-name for: time-interval)
  #:keywords add-collect4: as: for:
  #:captures root-env
   (add-collect* '(logic-connector-names ...) 'fact-name time-interval  4 root-env))


(defmac (remove-collect1: logic-connector-names ... as: fact-name )
  #:keywords remove-collect1: as: 
  #:captures root-env
   (remove-collect* '(logic-connector-names ...) 'fact-name 1 root-env))

(defmac (remove-collect2: logic-connector-names ... as: fact-name )
  #:keywords remove-collect2: as: 
  #:captures root-env
  (remove-collect* '(logic-connector-names ...) 'fact-name 2 root-env))

(defmac (remove-collect3: logic-connector-names ... as: fact-name)
  #:keywords remove-collect3: as: 
  #:captures root-env
  (remove-collect* '(logic-connector-names ...) 'fact-name 3 root-env))

(defmac (remove-collect4: logic-connector-names ... as: fact-name)
  #:keywords remove-collect4: as: 
  #:captures root-env
  (remove-collect* '(logic-connector-names ...) 'fact-name 4 root-env))
  
  