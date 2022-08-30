#lang racket
(require (for-syntax syntax/parse))
(provide update:)
(require "environment.rkt")

(require "functional/datastructures.rkt")
(require "functional/reactor.rkt"
         "functional/deploy.rkt")

(define-syntax (update: stx)
  (syntax-parse stx
    [((~literal update:) args:id ... (~literal with:) deploy-name:id)
     #'(let ((deployment (lookup-local-var-error 'deploy-name global-env))
             
           (arguments (map (lambda (arg)
                             (display global-env)
                             (let ((val (lookup-local-var-error arg global-env)))
                               (if (or (reactor? val)
                                       (deployedR? val)
                                       (event-node? val))
                                   (error (format "Update cannot take argument that has the type of deployed-reactor reactor or input-node ~a" arg))
                                   val)))
                          '(args ...))))
         
       (when (not(deployedR? deployment))
         (error (format "Update expects deployed reactor as second argument")))
         (when (not (= (vector-length (deployedR-outs deployment)) (length arguments)))
           (error (format "Update: number of output of deployedReactor must be equal to update args")))
       (set-functional-node-connectors! deployment
                                        (cons (external-connector arguments)
                                              (functional-node-connectors deployment))))]))
       
           