#lang br/quicklang
(require
  (prefix-in logic: "../logical_reactive_programming/language3.rkt")
  (prefix-in logic: "../logical_reactive_programming/nodes3.rkt")
   (prefix-in logic: "../logical_reactive_programming/variables.rkt")
  (prefix-in func: "../functiona_reactive_programming/nodes.rkt")
  (prefix-in func: "../functiona_reactive_programming/functional_reactive_language_3.rkt")
web-server/private/timer
)





(define-macro (e-if:
               (event-condition EVENT-NAME (ARGS ...) CONDITIONS ...) ...
               THEN-EXPRS 
               ELSE-EXPRS
               OPTIONS ...)
  (with-pattern ([( SLIDING WINDOW)
                  (pattern-case #'(OPTIONS ...)
                                [() #'(logic:sliding logic:time-interval)]
                                [(window: SIZE) #'(logic:sliding SIZE)]
                                [(sliding: SIZE) #'(SIZE logic:time-interval)]
                                [(window: WINDOW-SIZE sliding: SLIDING-SIZE) #'(SLIDING-SIZE WINDOW-SIZE)])]
                 [(COM-ARGS ...) #'(ARGS ... ...)])             
  #'(let* ((alpha-nodes (map (lambda (event-name args conditions)
                                 (logic:event-condition->alpha-node
                                  event-name
                                  args
                                  conditions
                                  SLIDING))
                               '(EVENT-NAME ...)
                               '((ARGS ...) ...)
                               '((CONDITIONS ...) ...)))
                          
                          
                         
           (start-if-node (func:make-start-if-node ))
           (then-node (func:make-multi-function-node (list start-if-node) (lambda (COM-ARGS ...) THEN-EXPRS )))
           (else-node (func:make-multi-function-node (list start-if-node) (lambda () ELSE-EXPRS )))
           (left-end-if-node  (func:make-end-if-node 'L ))
           (right-end-if-node (func:make-end-if-node 'R ))
           (event-node (func:make-event-with-predecessor (list then-node else-node)))
           (order (vector
                   start-if-node
                   then-node
                   left-end-if-node
                   else-node
                   right-end-if-node
                   event-node))
           (time-manager (start-timer-manager)))
      (letrec ((time-function  (lambda ()
                                 (logic:reset-logic-graph alpha-nodes)
                                 (start-timer time-manager WINDOW time-function))))
        (func:set-start-if-node-order! start-if-node order)
        
        (logic:add-rule-to-root! (car alpha-nodes))
        (cond ((null? (cdr alpha-nodes))
             ;then set the successor of the alphanode to the terminal node
             (logic:add-successor-to-node! (car alpha-nodes) start-if-node))
            (else
             ;else convert the other alpha-lists to alpha-nodes and join-nodes
             (let ((last-join-node (logic:combine-to-join-nodes (car alpha-nodes) (cdr alpha-nodes) SLIDING )))
               ;set the last join-node to the terminal-node
               (logic:add-successor-to-node! last-join-node start-if-node))))
      
        (start-timer time-manager WINDOW time-function)
        event-node))))
    

(logic:rule: CyclisteMenu
       where:
       (event-condition side (?typeSide ?customerID)
                                     (or (equal? 'MaxiFries ?typeSide)
                                         (equal? 'SideSalade ?typeSide)
                                         (equal? 'FPB ?typeSide)))
       (event-condition drink (?typeDrink ?customerID))
       (event-condition burger (?typeBurger ?customerID)
                        (equal? ?typeBurger 'cyclist))
       then:
       (add: (fact: cyclisteMenu ?typeBurger ?customerID)))

(logic:add: (logic:fact: side FPB 3))
;(logic:add: (logic:fact: side FPB 4))
(logic:add: (logic:fact: burger cyclist 3))
(logic:add: (logic:fact: drink Fanta 3))
(define if-event (e-if: (event-condition drink-level (?drink ?level) (< ?level 0.3))
                        (event-condition drink-level-2 (?drink2 ?level2) (and (not (equal? ?drink2 ?drink))(< ?level2 0.3)))
        (begin (printf (format "Drink: ~a needs to be filled ~a" ?drink ?drink2))
               ?drink)
        (begin (printf (format "Drink is filled"))
               'allowed-drink)))
(func:add-observer if-event (lambda (x) (display x)))
                                     
                                     
                     
#|
(define test (e-if: (event-condition error (?y) (> ?y 3)) (begin (display "hoho") 3) (begin (display "sad") 1) sliding: 60))
(func:add-observer test (lambda (x) (display 'joepi)))
(sleep 40)
(logic:add: (logic:fact: error-overheating ))
(logic:add: (logic:fact: error-overheating2))|#

      