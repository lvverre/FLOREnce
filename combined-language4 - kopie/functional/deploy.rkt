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

    (let ((reactor (lookup-local-var-error 'reactor-name global-env)))
      (when (not (reactor? reactor))
        (error (format "Deploy expects name of reactor")))
      (let*-values ([(events rest) (let loop ([events '()]
                                            [names '(event-names ...)])
                                    (if (null? names)
                                        (values events names)
                                        (let ((event (lookup-local-var-error (car names) global-env)))
                                          (cond ((event-node? event)
                                                 (loop (append events (list event )) (cdr names)))
                                                (else
                                                 (values events names))))))]
                                                 
                                          
                  [ (model-vars) (let loop ([model-vars '()]
                                            [names rest])
                                        (cond ((null? names)
                                               (values model-vars))
                                              (else 
                                               (let ((model-var (lookup-local-var-error (car names) global-env)))
                                                 (cond  ((model-var? model-var)
                                                         (loop (append model-vars (list model-var))
                                                               (cdr names)))
                                                        (else
                                                       
                                                         (error (format "Deploy:with:as: needs model-var as argument gotten ~a" model-var))))))))])
        (displayln 'reactor-name)
                   
      (when (not (and (= (vector-length (reactor-ins reactor))
                         (length events))
                      (= (length (reactor-model-vars reactor))
                         (length model-vars))))
               
        (error "deploy got wrong combination ~a \n ~a" events model-vars))
                               
    
    (let ( (deployed-reactor     (deployedR
                                  '()
                                (reactor-ins reactor)
                                  (reactor-dag reactor)
                                  (reactor-outs reactor)
                                  (make-immutable-hash (map (lambda (var val)
                                                              (cons var val))
                                                            (reactor-model-vars reactor)
                                                            model-vars
                                                            ))
                                  )))

      (add-to-local-env! 'new-name deployed-reactor global-env)
        (for/fold ([idx 0])
                  ([event events])
          (register-to-event! event deployed-reactor idx)
          (+ idx 1))
       
      )))]))