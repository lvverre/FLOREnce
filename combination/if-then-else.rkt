#lang br/quicklang
(require
  "../logical_reactive_programming/defmac.rkt"
   "../logical_reactive_programming/language3.rkt" 
  (prefix-in logic: (except-in "../logical_reactive_programming/nodes3.rkt" root))
  "../logical_reactive_programming/variables.rkt"
   "../functiona_reactive_programming/nodes.rkt" 
  (except-in "../functiona_reactive_programming/functional_reactive_language_3.rkt" program)
web-server/private/timer
)





(defmac (whenever:
               (EVENT-NAME (ARGS ...) CONDITIONS ...) ...
               THEN-EXPRS 
               ELSE-EXPRS)
  #:keywords whenever:
  #:captures root
              ; OPTIONS ...)
 #| (with-pattern ([( SLIDING WINDOW)
                  (pattern-case #'(OPTIONS ...)
                                [() #'(logic:sliding logic:time-interval)]
                                [(window: SIZE) #'(logic:sliding SIZE)]
                                [(sliding: SIZE) #'(SIZE logic:time-interval)]
                                [(window: WINDOW-SIZE sliding: SLIDING-SIZE) #'(SLIDING-SIZE WINDOW-SIZE)])]
                 [(COM-ARGS ...) #'(ARGS ... ...)])|#             
  (let* ((alpha-nodes (map (lambda (event-name args conditions)
                                 (event-condition->alpha-node
                                  event-name
                                  args
                                  conditions
                                  sliding))
                               '(EVENT-NAME ...)
                               '((ARGS ...) ...)
                               '((CONDITIONS ...) ...)))
                          
                          
                         
           (start-if-node (make-start-if-node ))
           (then-node (make-multi-function-node (list start-if-node) (lambda (ARGS ... ...) THEN-EXPRS )))
           (else-node (make-multi-function-node (list start-if-node) (lambda () ELSE-EXPRS )))
           (left-end-if-node  (make-end-if-node 'L ))
           (right-end-if-node (make-end-if-node 'R ))
           (event-node (make-event-with-predecessor (list then-node else-node)))
           (order (vector
                   start-if-node
                   then-node
                   left-end-if-node
                   else-node
                   right-end-if-node
                   event-node))
           (time-manager (start-timer-manager)))
      (letrec ((time-function  (lambda ()
                                 (reset-logic-graph alpha-nodes)
                                 (start-timer time-manager time-interval time-function))))
        (set-start-if-node-order! start-if-node order)
        
        (logic:add-rule-to-root! root (car alpha-nodes))
        (cond ((null? (cdr alpha-nodes))
             ;then set the successor of the alphanode to the terminal node
             (logic:add-successor-to-node! (car alpha-nodes) start-if-node))
            (else
             ;else convert the other alpha-lists to alpha-nodes and join-nodes
             (let ((last-join-node (combine-to-join-nodes (car alpha-nodes) (cdr alpha-nodes) sliding root)))
               ;set the last join-node to the terminal-node
               (logic:add-successor-to-node! last-join-node start-if-node))))
      
        (start-timer time-manager time-interval time-function)
        event-node)))



    
(defmac (program exps ...)
  #:keywords program
   #:captures function-thd thd-fact-loop inside-turn root events
  (begin (define inside-turn (make-parameter #f))
         (define root (logic:make-root))
         (let* ((function-thd (make-functional-event-loop))
               (thd-fact-loop (make-thd-fact-loop function-thd))
               (events (make-event)))
           (begin exps ...))))
(program 
(rule: CyclisteMenu
       where:
       ( side (?typeSide ?customerID)
                                     (or (equal? 'MaxiFries ?typeSide)
                                         (equal? 'SideSalade ?typeSide)
                                         (equal? 'FPB ?typeSide)))
       ( drink (?typeDrink ?customerID))
       ( burger (?typeBurger ?customerID)
                        (equal? ?typeBurger 'cyclist))
       then:
       (add: (fact: cyclisteMenu ?typeBurger ?customerID)))

(add: (fact: side FPB 3))
;(logic:add: (logic:fact: side FPB 4))
(add: (fact: burger cyclist 3))
(add: (fact: drink Fanta 3))
(define if-event (whenever: ( drink-level (?drink ?level) (< ?level 0.3))
                        ( drink-level-2 (?drink2 ?level2) (and (not (equal? ?drink2 ?drink))(< ?level2 0.3)))
        (begin (printf (format "Drink: ~a needs to be filled ~a" ?drink ?drink2))
               ?drink)
        (begin (printf (format "Drink is filled"))
               'allowed-drink)))
(add-observer if-event (lambda (x) (display x)))

(add-observer events (lambda (x) (display "ik zit in events")))
(fire events 5))
                                     


#|
(define test (e-if: (event-condition error (?y) (> ?y 3)) (begin (display "hoho") 3) (begin (display "sad") 1) sliding: 60))
(func:add-observer test (lambda (x) (display 'joepi)))
(sleep 40)
(logic:add: (logic:fact: error-overheating ))
(logic:add: (logic:fact: error-overheating2))|#

      