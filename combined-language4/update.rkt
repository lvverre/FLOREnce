#lang racket
(require (for-syntax syntax/parse))
(provide update:)
(require "environment.rkt")

(require "functional/datastructures.rkt")
(require "functional/reactor.rkt"
         "functional/deploy.rkt"
         "GUI-input-output.rkt")


(begin-for-syntax 
  (define-syntax-class output
    (pattern ((~literal fact:) window:id output:id factID:id)
             #:attr place #''window
              #:attr var #''output
              #:attr fact-id #''factID)
    
    (pattern output:id
             #:attr place  #''model
             #:attr var #''output
             #:attr fact-id #''none)))


(define-syntax (update: stx)
  (syntax-parse stx
    [((~literal update:) args:output ... (~literal with:) deploy-name:id)
     #'(let ((deployment (lookup-local-var-error 'deploy-name 'react global-env))
             
           (arguments (map (lambda (place var fact-id)
                             
                             (let ((val (lookup-local-var-error var place global-env)))
                               (when (or (reactor? val)
                                         (deployedR? val)
                                         (event-node? val))
                                   (error (format "Update cannot take argument that has the type of deployed-reactor reactor or input-node ~a" var)))
                               (cond ((sink-node? val)
                                      (sink-fact-node fact-id (sink-node-widget val)))
                                     ((model-var? val)
                                      val)
                                     (else
                                      (error (format "Update needs output stream or model-var ~a" val))))))
                                   
                          (list args.place ...)
                          (list args.var ...)
                          (list args.fact-id ...))))
        
       (when (not(deployedR? deployment))
         (error (format "Update expects deployed reactor as second argument")))
         (when (not (= (vector-length (deployedR-outs deployment)) (length arguments)))
           (error (format "Update: number of output of deployedReactor must be equal to update args")))
       (set-functional-node-connectors! deployment
                                        (cons (external-connector arguments)
                                              (functional-node-connectors deployment))))]))
       
           