#lang racket
(require "../environment.rkt"
        
         "reactor.rkt"
         "datastructures.rkt"
         )

(require (for-syntax syntax/parse))
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
             

(define-syntax (deploy: stx)
  (syntax-parse stx 
    [((~literal deploy:) reactor-name:id (~literal with:) event-names:id ...+  (~literal as:) new-name:id)
  
  #'

    (let*-values ([
                   (reactor) (lookup-local-var-error 'reactor-name global-env)]
                  [ (events model-vars ignore) (for/fold ([events '()]
                                                   [model-vars '()]
                                                   [name-model-vars (reactor-model-vars reactor)])
                                                  ([name '(event-names ...)]
                                                   )

                                          (display global-env)
                                          (let ((event (lookup-local-var-error name global-env)))
                                            (display name)
                                            (cond ((event-node? event)
                                                   (values (append events (list event )) model-vars name-model-vars))
                                                  ((model-var? event)
                                                   (when (null? name-model-vars)
                                                     (displayln name-model-vars)
                                                     (error "the number model arguments is not equal to the number of model vars in the reactor"))
                                                  (values  events
                                                            (append (list (cons (car name-model-vars) event)) model-vars)
                                                            (cdr name-model-vars)))
                                                  (else 
                                                   (error (format "Deploy:with:as: needs event as argument gotten ~a" event))))))])
      (when (or (null? events)
                (and  (reactor? (car events)) (null? (cdr events))))
        (error "deploy got wrong combination"))
                    (when (not (reactor? reactor))
      (error (format "Deploy expects name of reactor")))
    
    (let ( (deployed-reactor     (deployedR
                                  '()
                                (reactor-ins reactor)
                                  (reactor-dag reactor)
                                  (reactor-outs reactor)
                                  (make-immutable-hash model-vars)
                                  )))

      (displayln deployed-reactor)
    (add-to-local-env! 'new-name deployed-reactor global-env)
  
    (if (= (+ (vector-length (reactor-ins reactor)) (length (reactor-model-vars reactor)))
           (+ (length events) (length model-vars)))
        (for/fold ([idx 0])
                  ([event events])
              
          
          (register-to-event! event deployed-reactor idx)
          (+ idx 1))
        (error (format "Reactor needs ~a events given ~a"
                       (vector-length (reactor-ins reactor))
                       (length events)))))
    )]))
