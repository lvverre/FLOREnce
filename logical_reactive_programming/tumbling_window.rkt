#lang br/quicklang




(provide (all-defined-out))
(require "e-environment.rkt" )

(struct window (tail partial-matches  start-time) #:mutable #:transparent)
(define (make-window size)
  (window 0 (make-vector size 0 )  (current-seconds)))

(define (empty? window)
  (eq? (window-tail window) 0))

;;LOCKING SYSTEM FOR THREADS USED IN WINDOW
(define lock-logic-graph (make-semaphore 1))
(define (get-lock-logic-graph)
  (semaphore-wait lock-logic-graph))
(define (release-lock-logic-graph)
  (semaphore-post lock-logic-graph))


(define (for-all-partial-matches function window)
  (define end-idx (window-tail window))
  (define pms (window-partial-matches window))
  (define (loop idx)
    (when (< idx end-idx)
      (function (vector-ref pms idx))
      (loop (+ idx 1))))
  (loop 0))


(define size-of-window vector-length)

;;adds element to a window
(define (add-partial-match! pm window)
  (let ((idx (window-tail window))
        (partial-matches (window-partial-matches window)))
    (cond
      
      ((>= idx (- (size-of-window partial-matches) 1))
           ;;in case of no more place
       (error-window-overflowing)
       ;give back #t when sucessors other also need to be updates
       #t)
      ; (set-window-tail! window 1))
       ;    (error-window-overflowing))
      ;;add element to window
      (else 
       (vector-set! partial-matches idx pm)
       (set-window-tail! window (+ idx 1))
       ;give back #f when sucessors does not need to be updates
       #f))))

(define (remove-from-window! function)
  (lambda (element window)
    (let* ((pms (window-partial-matches window))
           ;filter out pm
           (filtered-pms
            (vector-filter-not
             (lambda (pm-in-window)
               (or
                (number? pm-in-window)
               
                (function element pm-in-window)))
             pms)))
    ;copy filtered pms to old pms
    (vector-copy! pms 0 filtered-pms)
    ;adjust the tail 
    (set-window-tail! window (vector-length filtered-pms)))))

;remove partial match
(define remove-partial-match! (remove-from-window! pm-contains-pm?))

;remove tokens
(define remove-partial-matches! (remove-from-window! pm-contains-token?))
  
   
   

(define (get-start-time-window current-start-time current-time interval)
  (if (and (< current-start-time current-time)
           (< current-time (+ current-start-time interval)))
      current-start-time
      (get-start-time-window
       (+ current-start-time interval)
       current-time
       interval)))

;;reset window back to an empty window
(define (reset-window window)
  (set-window-tail! window 0)
  (set-window-partial-matches!
   window
   (make-vector (size-of-window (window-partial-matches window)) 0))
  (set-window-start-time! window (current-seconds)))
  

;;WINDOW OVERFLOW
(define window-overflow-handlers '())
;hulp function to add handler for overflowing window to list
(define (add-overflow-handler handler)
  (set!
     window-overflow-handlers 
     (cons
      handler
      window-overflow-handlers)))
;macro to add exprs as lambda to list of handlers
(define-macro (window-overflow-handler EXPRS ...)
  #'(add-overflow-handler (lambda () EXPRS ...)))
;executing handlers that are registered
(define (error-window-overflowing)
  (for-each
   (lambda (proc)
     (proc))
   window-overflow-handlers))


     