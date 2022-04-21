#lang racket

(require "../functional/environment.rkt"
         "../functional/datastructures.rkt"
         "../logical/compiler.rkt"
         "../logical/nodes.rkt"
         "../functional/reactor.rkt"
         "../defmac.rkt")
(provide (all-defined-out))
(struct functional-connector (deployedR-add deployedR-remove) #:transparent) 

 

(defmac (forall: (event-name (args ...) constraints ...)
                 (add-deploy: reactor-name-add as: deployedR-add-name)
                 (remove-deploy: reactor-name-remove as: deployedR-remove-name))
  #:keywords forall: on-add: on-remove: as:
  #:captures root root-lock functional-environment
  (begin 
    (for-each (lambda (name)
                (when (not (symbol? name))
                  (error (format "Forall expects symbol gotten ~a" name))))
              '(reactor-name-add deployedR-add-name reactor-name-remove deployedR-remove-name))
                               
    (let* ((alpha-node (make-alpha-node 'event-name '(args ...) (map (lambda (condition) (compile condition #t)) '(constraints ...))))
           (reactor-add (lookup-var 'reactor-name-add functional-environment))
           (reactor-remove (lookup-var 'reactor-name-remove functional-environment)))
      (for-each (lambda (reactor reactor-name )
                  (display reactor)
                  (when (not (reactor? reactor))
                    (error (format "~a needs to be an reactor, but is ~a"
                                   reactor-name
                                   reactor))))
                 (list reactor-add reactor-remove)
                '(reactor-name-add reactor-name-remove)
               )
      (let* ((deployedR-add (deployedR
                             '()
                             (reactor-ins reactor-add)
                             (reactor-dag reactor-add)
                             (reactor-outs reactor-add)))
             (deployedR-remove (deployedR
                                '()
                                (reactor-ins reactor-remove)
                                (reactor-dag reactor-remove)
                                (reactor-outs reactor-remove)))
             (functional-connector (functional-connector deployedR-add deployedR-remove)))
        (add-to-env! 'deployedR-add-name deployedR-add functional-environment)
        (add-to-env! 'deployedR-remove-name deployedR-remove functional-environment)
        (set-filter-node-successor! alpha-node functional-connector)
        (register-to-root! alpha-node root)))))