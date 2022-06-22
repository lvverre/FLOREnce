#lang racket
(require syntax/parse)
(require "../environment.rkt"
         "../functional/datastructures.rkt"
      ;   "../logical/compiler.rkt"
         "../logical/nodes.rkt"
         "../functional/reactor.rkt"
         "../defmac.rkt"
         ;"../root-env.rkt"
         )
(provide (all-defined-out))
(struct logic-connector (deployedR-add deployedR-remove) #:transparent) 

 

(define (interpret-forall stx)
  (syntax-parse stx
    [((~literal forall:) (event-name:id (args ...) constraints ...)
                         ((~literal add-deploy:) reactor-name-add:id (~literal as:) deployedR-add-name:id)
                         ((~literal remove-deploy:) reactor-name-remove:id (~literal as:) deployedR-remove-name:id))
           
     (let*
         (
          (alpha-node (make-alpha-node (syntax-e #'event-name) (map syntax-e (syntax->list #'(args ...)))  #'(constraints ...) ));(map (lambda (condition) (compile condition #t)) '(constraints ...))))
          (reactor-add (lookup-var-error (syntax-e #'reactor-name-add) global-env))
          (reactor-remove (lookup-var-error (syntax-e #'reactor-name-remove) global-env)))
      (for-each (lambda (reactor reactor-name )
                 
                  (when (not (reactor? reactor))
                    (error (format "~a needs to be an reactor, but is ~a"
                                   reactor-name
                                   reactor))))
                 (list reactor-add reactor-remove)
                (map syntax-e (syntax->list #'(reactor-name-add reactor-name-remove)))
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
        (add-to-env! (syntax-e #'deployedR-add-name) deployedR-add global-env)
        (add-to-env! (syntax-e #'deployedR-remove-name) deployedR-remove global-env)
        (set-filter-node-successor! alpha-node logic-connector)
        (register-to-root! alpha-node root)))]))