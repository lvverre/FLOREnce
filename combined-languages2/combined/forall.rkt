#lang racket

(require "../functional/environment.rkt"
         "../functional/datastructures.rkt"
         "../logical/compiler.rkt"
         "../logical/nodes.rkt"
         "../functional/reactor.rkt"
         "../defmac.rkt"
         "../root-env.rkt")
(provide (all-defined-out))
(struct logic-connector (deployedR-add deployedR-remove) #:transparent) 

 

(defmac (forall: (event-name (args ...) constraints ...)
                 (add-deploy: reactor-name-add as: deployedR-add-name)
                 (remove-deploy: reactor-name-remove as: deployedR-remove-name))
  #:keywords forall: on-add: on-remove: as:
  #:captures root-env 
  (begin 
    (for-each (lambda (name)
                (when (not (symbol? name))
                  (error (format "Forall expects symbol gotten ~a" name))))
              '(reactor-name-add deployedR-add-name reactor-name-remove deployedR-remove-name))
                               
    (let*
        ((global-env (root-env-env root-env))
         (root (root-env-root root-env))
         (alpha-node (make-alpha-node 'event-name '(args ...) (compile-multiple-in-one '(constraints ...) #t)));(map (lambda (condition) (compile condition #t)) '(constraints ...))))
           (reactor-add (lookup-var-error 'reactor-name-add global-env))
           (reactor-remove (lookup-var-error 'reactor-name-remove global-env)))
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
             (logic-connector (logic-connector deployedR-add deployedR-remove)))
        (add-to-env! 'deployedR-add-name deployedR-add global-env)
        (add-to-env! 'deployedR-remove-name deployedR-remove global-env)
        (set-filter-node-successor! alpha-node logic-connector)
        (register-to-root! alpha-node root)))))