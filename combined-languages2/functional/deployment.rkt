#lang racket
(require "environment.rkt"
         "../defmac.rkt"
         "reactor.rkt"
         "datastructures.rkt"
         "../root-env.rkt")


(provide (all-defined-out))


(define (register-to-event! event new-deployedR input-idx)
    (let deployment-comparisson-loop
      ((deployments (functional-node-connectors  event)))
      (cond ((null? deployments)
             (set-functional-node-connectors! event
                                     (cons (func->func-connector (list input-idx)
                                                        new-deployedR)
                                           (functional-node-connectors event))))
            ((eq? (functional-connector-app-info (car deployments))
                  new-deployedR)
             (set-functional-connector-input-info! (car deployments)
                                              (cons input-idx
                                                    (functional-connector-input-info (car deployments)))))
            (else
             (deployment-comparisson-loop (cdr deployments))))))
             

(defmac (deploy: reactor-name
         with: event-names ...
         as: new-name)
  #:keywords deploy: with: as:
  #:captures root-env
  (let* ((env (root-env-env root-env))
         (reactor (lookup-var-error 'reactor-name env))
        (events (map (lambda (name)
                       (let ((event (lookup-var-error name env)))
                         (if (event-node? event)
                             event
                             (error (format "Deploy:with:as: needs event as argument gotten ~a" event)))))
                     '(event-names ...))))
    (when (not (reactor? reactor))
      (error (format "Deploy expects name of reactor")))
    (for ([event events])
      (when (not (event-node? event))
        (error (format "Deploye expects name of events"))))
    (let (
      
          
        
        (deployed-reactor     (deployedR
                               '()
                               (reactor-ins reactor)
                               (reactor-dag reactor)
                               (reactor-outs reactor)
                                         )))
   
  
    (add-to-env! 'new-name deployed-reactor env)
  
    (if (= (vector-length (reactor-ins reactor))
           (length events))
        (for/fold ([idx 0])
                  ([event events])
              
          
          (register-to-event! event deployed-reactor idx)
          (+ idx 1))
        (error (format "Reactor needs ~a events given ~a"
                       (vector-length (reactor-ins reactor))
                       (length events)))))))




;(define (make-event name)
 ; (add-to-env! name
  ;             (functional-event '() '())
   ;            functional-environment))
        
    
                