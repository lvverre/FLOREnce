#lang racket
(require "../defmac.rkt"
         "nodes.rkt"
         "compile-interpret.rkt"
         "deployment.rkt"
         "environment.rkt"
         (only-in "collect.rkt" put-in-collector-from-event! put-in-collector-from-deployedR!)
          racket/local)

(provide (all-defined-out))



(define (functional-propagate nodes node-values start-idx)
  (define (loop idx )
    
    (when (> (vector-length nodes) idx)
      (let ((current-node (vector-ref nodes idx)))
        ;(displayln node-values)
        ;(displayln current-node)
        (match current-node
        
          
          [(start-jump-node roots jump-add)
           ;check condition
           (let* ((condition (for/or ([root-idx roots])
                           (not (eq? (vector-ref node-values root-idx) 'empty)))))
          ;   (display "condition:" )
          ;   (displayln condition)
             
             (if condition 
                 ;if true return nothing
                 (loop (+ idx 1)  )
               ;if false give back idx to where to jump
                 (loop (+ jump-add idx) )))]
          
          
          
          
          ;for a function execute the function on the give value and store result
          [(single-function-node idx predecessor function)
           (let ((predecessor-value (vector-ref node-values (car predecessor))))
           ;  (displayln predecessor-value)
             (cond ((eq? 'empty predecessor-value)
                    ;;in case a filter occurred
                    (vector-set! node-values idx 'empty))
                   (else 
                    ;calculate new value and store
                    (vector-set! node-values idx (interpret function predecessor-value)))))
             (loop  (+ idx 1)  )]
          
          ;for a function with random number of arguments
         ; [(multi-function-node idx predecessor function)
         ;  (let ((args (cdr (vector-ref node-values (car predecessor)))))
         ;    ;calculate new value and store
         ;    (vector-set! node-values idx (apply function args))
         ;    (loop  (+ idx 1) branch ))]
  
          [(or-node  idx predecessors )
           
           ;;check branch to see which value it needs to take
           (let* ((left-predecessor-idx (car predecessors))
                  (right-predecessor-idx (cadr predecessors))
                  (value (if (not (eq? (vector-ref node-values left-predecessor-idx) 'empty))
                                 ;left
                             (vector-ref node-values left-predecessor-idx)
                             ;right
                             (vector-ref node-values right-predecessor-idx))))
            ; (displayln value)
             (vector-set! node-values idx value)
             (loop  (+ idx 1)  ))]
            
    
          [(filter-node idx predecessor filter)
           
           (let ((value (vector-ref node-values (car predecessor))))
             ;(displayln value)
             ;;if already been filtered out by previous filter or value is not #t by condition
             (if (or (eq? 'empty value) (not (interpret filter value)))
                 (vector-set! node-values idx 'empty)
                 ;;value allowed to pass
                 (vector-set! node-values idx value))
             (loop  (+ idx 1)  ))]
         
          
          ))))
  
  (loop start-idx ))


(define (execute-turn deployedr input root root-lock timer)
  (define nodes (deployedR-dag deployedr))
  (define outs (deployedR-outs deployedr))
  (define values (make-vector (vector-length nodes) 'empty))
  (if (not (= (vector-length ins) (vector-length input)))
      (error (format "Wrong number of inputs expected ~a given ~a"
                     (vector-length ins)
                     (vector-length input)))
      (for ([idx ins]
            [value input])
        (display idx)
        (vector-set! values idx value)))
  ;(display values)
  (functional-propagate  nodes values (vector-length ins))
  (let ((output  (for/vector ([idx outs])
                   (vector-ref values idx)))) 
    (for ([collector (logic-connector-logical-cmpts deployedr)])
      (put-in-collector-from-deployedR! collector output root root-lock timer))))
  
              
;(define (turn: deployedr  input)
; #:keywords turn: with:
;  (execute-turn deployedr
;                           input))


(defmac (fire name value)
  #:keywords fire
  #:captures root-lock timer root functional-environment
  (let ((event (lookup-var 'name functional-environment)))
    (for ([deployement (functional-event-functional-cmpnts event)])
      (let* ((deployedr (functional-cmpnt-deployedR deployement))
             (input (make-vector (vector-length (deployedR-ins deployedr))
                                'empty)))
        (for ([input-idx (functional-cmpnt-input-idxs deployement)])
          (vector-set! input input-idx value))
        (displayln input)
        (display (execute-turn deployedr input root root-lock timer))))
    (for ([logical-cmpnt (logic-connector-logical-cmpts event)])
      (put-in-collector-from-event! logical-cmpnt value root root-lock timer))))
          
        
    