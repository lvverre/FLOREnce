#lang racket
(require "environment.rkt"
         "../defmac.rkt"
         "reactor.rkt")


(provide (all-defined-out))
(struct logic-connector (logical-cmpts) #:mutable)
(struct deployedR logic-connector (ins dag outs) #:transparent)
(struct functional-event logic-connector (functional-cmpnts ) #:mutable #:transparent)

(struct functional-cmpnt (input-idxs deployedR) #:mutable #:transparent)


(define (register-to-event! event new-deployedR input-idx)
    (let deployment-comparisson-loop
      ((deployments (functional-event-functional-cmpnts event)))
      (cond ((null? deployments)
             (set-functional-event-functional-cmpnts! event
                                     (cons (functional-cmpnt (list input-idx)
                                                        new-deployedR)
                                           (functional-event-functional-cmpnts event))))
            ((eq? (functional-cmpnt-deployedR (car deployments))
                  new-deployedR)
             (set-functional-cmpnt-input-idxs! (car deployments)
                                          (cons input-idx
                                                (functional-cmpnt-input-idxs (car deployments)))))
            (else
             (deployment-comparisson-loop (cdr deployments))))))
             

(defmac (deploy: reactor-name
         with: event-names ...
         as: new-name)
  #:keywords deploy: with: as:
  #:captures functional-environment
  (let* ((reactor (lookup-var 'reactor-name functional-environment))
        (events (map (lambda (name)
                       (let ((event (lookup-var name functional-environment)))
                         (if (functional-event? event)
                             event
                             (error (format "Deploy:with:as: needs event as argument gotten ~a" event)))))
                     '(event-names ...)))
        
        (deployed-reactor     (deployedR
                               '()
                               (reactor-ins reactor)
                               (reactor-dag reactor)
                               (reactor-outs reactor)
                                         )))
  
    (add-to-env! 'new-name deployed-reactor functional-environment)
    (display "ins: ")
        (displayln (reactor-ins reactor))
    (if (= (vector-length (reactor-ins reactor))
           (length events))
        (for/fold ([idx 0])
                  ([event events])
              
          
          (register-to-event! event deployed-reactor idx)
          (+ idx 1))
        (error (format "Reactor needs ~a events given ~a"
                       (vector-length (reactor-ins reactor))
                       (length events))))))




;(define (make-event name)
 ; (add-to-env! name
  ;             (functional-event '() '())
   ;            functional-environment))
        
    
                