#lang racket
(require "defmac.rkt"
         "parse-values.rkt"
         "functional/environment.rkt"
         "testGUI.rkt"
         "functional/datastructures.rkt"
         "root-env.rkt")
(provide (all-defined-out))




(define (error-wrong-syntax place syntax)
  (error (format "~a is not allowed in ~a" syntax place)))



(defmac (update: update-name with: (input: ins ...) exprs ...)
  #:keywords update: with: input;
  #:captures root-env
  (let ((env (root-env-env root-env)))
    (when (env-contains? 'update-name env)
      (error (format "~a is already defined" 'update-name)))
     (let ((duplicates? (check-duplicates '(ins ...))))
      (when duplicates?
        (error (format "updat:with:input: -> in: expects unique variables given multiple times" ~a)))
    (let ((compiled-body (compile-update '(exprs ...))))
      (add-to-env! 'update-name
                   (update '(ins ...) compiled-body)
                   env)))))

(defmac (connect: deploy-name with: update-name)
  #:keywords connect: with: as:
  #:captures root-env
  (let (
        (env (root-env-env root-env)))
    (when (not (symbol? 'deploy-name))
      (error (format "Connect:with:as: expects deploy reactor name as first argument given ~a" 'deploy-name)))
    (when (not (symbol? 'update-name))
      (error (format "Connect:with:as: expects update name as second argument given ~a" 'update-name)))
   #| (for ([arg arguments])
      (let ((arg-already-defined? (or (lookup-var-false arg native-gui-environment)
                                      (lookup-var-false arg env))))
        (when arg-already-defined?
          (error (format "Connect:with:as: -> ~a is already defined" arg))))) |#
      (let* ((deployed-reactor (lookup-var-error 'deploy-name env))
             (update (lookup-var-false 'update-name env))
             (body (update-body update))
             (arguments (update-input update))
             (new-world-connector (external-connector arguments body)))
        (when (not (= (length arguments) (vector-length (deployedR-outs deployed-reactor))))
          (error (format "Connect:in:out: -> Number of outputs of reactor is not equal to the number of in: arguments")))
        (set-functional-node-connectors! deployed-reactor (cons new-world-connector (functional-node-connectors deployed-reactor))))))   
    
    

#|
(defmac (connect: deploy-name (in: args ...) (out: expr ...))
  #:keywords connect:
  #:captures root-env
  (let ((arguments '(args ...))
        (env (root-env-env root-env)))
    (when (not (symbol? 'deploy-name))
      (error (format "Connect:in:out: expects deploy reactor name as first argument given ~a" 'deploy-name)))
    (when (not (andmap  (lambda (arg) (symbol? arg)) arguments))
      (error (format "Connect:in:out: expects variables as argument of in: given ~a" arguments)))
    (for ([arg arguments])
      (let ((arg-already-defined? (or (lookup-var-false arg native-gui-environment)
                                      (lookup-var-false arg env))))
        (when arg-already-defined?
          (error (format "Connect:in:out -> ~a is already defined" arg)))))
       
    (let ((duplicates? (check-duplicates arguments)))
      (when duplicates?
        (error (format "Connect:in:out: -> in: expects unique variables given multiple times" ~a)))
      (let* ((deployed-reactor (lookup-var-error 'deploy-name env))
             (body (compile-update '(expr ...)))
             (new-world-connector (external-connector arguments body)))
        (when (not (= (length arguments) (vector-length (deployedR-outs deployed-reactor))))
          (error (format "Connect:in:out: -> Number of outputs of reactor is not equal to the number of in: arguments")))
        (set-functional-node-connectors! deployed-reactor (cons new-world-connector (functional-node-connectors deployed-reactor)))))))
   |#     
          
      
      


(define (compile-update exprs) 
  (define (compile-update-function-call op args)
    (let ((compiled-op (if (symbol? op)
                         (lookup-var-error op native-gui-environment)
                         (error-wrong-syntax "operator function call" op)))
          (compiled-args (map compile-update-argument args)))
      (app compiled-op compiled-args)))
  (define (compile-update-argument arg )
    (match arg
      [`(sym arg)
       (when (not (symbol? arg))
         (error-wrong-syntax "Inside sym" arg))
       (sym arg)]
      [arg
       #:when (number? arg)
       (nmb arg)]
      [arg
       #:when (string? arg)
       (str arg)]
      [`(pair ,first ,rest)
       (pair (compile-update-argument first )
             (compile-update-argument rest ))]
      [arg
       #:when (symbol? arg)
       (var-exp arg)]
      [`(,op ,args ...)
       (compile-update-function-call op args)]
      [_ (error-wrong-syntax "argument inside functional call" arg)]))
  
       
  (define (compile-update-body-expr expr)
    (match expr
      [`(def: ,def-var ,expr)
       (let ((compiled-var (if (symbol? def-var)
                               (var-exp def-var)
                               (error-wrong-syntax  "first argument in def:" def-var)))
             (compiled-expr (compile-update-argument expr)))
         (def compiled-var compiled-expr))
         ]
      [`(set: ,set-var ,expr)
       (let ((compiled-var (if (symbol? set-var)
                               set-var
                               (error-wrong-syntax "first argument in set:" set-var)))
             (compiled-expr (compile-update-argument expr)))
         (set compiled-var compiled-expr))]
      [`(,op ,args ...)
       (compile-update-function-call op args)]
      [_ (error-wrong-syntax "body connect:as:in:" expr)]))
  (map compile-update-body-expr exprs))



#|
 (define w (prim-frame "test" 400 200))
 (define a (prim-gauge "Test gauge: " 300 w 200 200))
 (define env (make-hash (list (cons 'p (deployedR '() (make-vector 3 4) '() (make-vector 2 3))) (cons 'gauge a))))
(connect: p (in: r t) (out: (def: z r) (change-gauge-value! gauge z)))
 (eval (make-hash (list (cons 'r (nmb 100)))) env native-gui-environment (functional-connector-app-info (car (functional-node-connectors (hash-ref env 'p)))))|#
