#lang racket

(require "../environment.rkt"
         "../defmac.rkt"
         "reactor.rkt"
         "datastructures.rkt"
         )

(provide (all-defined-out))
(require syntax/parse)

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


(define (interpret-deploy stx)
  (syntax-parse stx
    [((~literal deploy:) reactor-name:id
         (~literal with:) event-names:id ...
         (~literal as:) new-name:id)
     (let* ((reactor (lookup-var-error (syntax-e #'reactor-name) global-env))
            (events (map (lambda (name)
                           (let ((event (lookup-var-error (syntax-e #'name) global-env)))
                             (if (event-node? event)
                                 event
                                 (error (format "Deploy:with:as: needs event as argument gotten ~a" event)))))
                         (syntax->list #'(event-names ...)))))
       (when (not (reactor? reactor))
         (error (format "Deploy expects name of reactor")))
       (for ([event events])
         (when (not (event-node? event))
           (error (format "Deploy expects name of events"))))
       (let ((deployed-reactor     (deployedR
                                    '()
                                    (reactor-ins reactor)
                                    (reactor-dag reactor)
                                    (reactor-outs reactor)
                                    )))
         (add-to-env! (syntax-e #'new-name) deployed-reactor global-env)
         (if (= (vector-length (reactor-ins reactor))
                (length events))
             (for/fold ([idx 0])
                       ([event events])          
               (register-to-event! event deployed-reactor idx)
               (+ idx 1))
             (error (format "Reactor needs ~a events given ~a"
                            (vector-length (reactor-ins reactor))
                            (length events))))))]))
