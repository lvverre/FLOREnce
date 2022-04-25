#lang racket
(require ;"testGUI.rkt"
         "functional/environment.rkt"
         "defmac.rkt"
         "functional/datastructures.rkt"
         "parse-values.rkt"
         "testGUI.rkt"
         "eval.rkt"
         "root-env.rkt"
         "update.rkt")


(provide (all-defined-out))

(defmac (view: view-name with:
               (output: outs ...)
               exprs ...)
  #:keywords view: with: output: 
  #:captures root-env
  (let ((env (root-env-env root-env)))
    (when (not (symbol? 'view-name))
      (error (format "view:with: expected a variable")))
    (when (env-contains? 'view-name env)
      (error (format "~a is already defined" 'view-name)))
   (for ([out '(outs ...)])
      (when (not (symbol? out))
        (error (format "view:with:output: expected for out: al variables given ~a" out))))
    (let ((compiled-view (compile-update '(exprs ...))))
      (add-to-env! 'view-name
                   (view '(outs ...) compiled-view)
                   env))))
    
#|
(define (typeOf function-name type type-function arg)
  (when (not (type-function arg))
    (error (format "~a expected an argument of type ~a" function-name type))))

(define (pairOf function-name type type-function first-pair)
  (let loop
    ((current first-pair))
    (cond
      ((and (pair? current-pair)
            (type-function (pair-first current)))
       (loop (pair-last current)))
      ((or (eq? empty current)
               (type-function current))
           #t)
      (else (error (format "~a expected a list of ~a"
                           function-name
                           type))))))

(define-syntax-rule (define/c expr
          
(define gui-native-environment (new-env ))         
(define-syntax-rule (symbols function-name value args ...)
  (let ((function-name |#
;(define gui-native-environment (make-hash (list (cons '+ (lambda (x y) (nmb (+ (nmb-val x) (nmb-val y))))))))
(defmac  (init: view-name as: args ...)
  #:keywords init: as: 
  #:captures root-env
  (let ((env (root-env-env root-env)))
    (for ([arg '(args ...)])
      (when (not (symbol? arg))
        (error (format "Init:as: expected for as: a variable given ~a" arg)))
      (when (env-contains? arg env)
        (error (format "Init:as: -> ~a is already defined" arg))))
    (let* ((view (lookup-var-error 'view-name env))
           (local-env (make-hash)))
      (when (not (= (length (view-output view)) (length '(args ...))))
        (error "Init:as: expects the same number of global-variables as outputted local variables"))
      (eval local-env env  (view-body view)   root-env)
      (for ([new-local-var (view-output view)]
            [new-global-var '(args ...)])
        (let ((val (lookup-var-error new-local-var local-env)))
          (add-to-env! new-global-var val env))))))
  
  

#|
(for-each (lambda (var prim-function)
            (add-to-env! var prim-function view-env-prims ))
          '(make-button make-frame make-h-panel make-v-panel make-gauge update-gauge-value! update-gauge-range! update-enable! get-event)
          '(prim-button prim-frame prim-horizontal-panel prim-vertical-panel prim-gauge prim-gauge-value! prim-gauge-range! prim-enable
|#
#|
(define (eval-view exprs local-env native-env root-env)
  (define (eval-view-argument arg)
    (match arg
      [`(pair ,first ,rest)
       (pair (eval-view-argument first)
             (eval-view-argument rest))]
      [arg
       #:when (number? arg)
       (nmb arg)]
      [arg
       #:when (string? arg)
       (str arg)]
      [`(sym ,variable)
       #:when (symbol? variable)
       (sym variable)]
      [var
       #:when (symbol? var)
       (let loop
         ((environments (list local-env native-env)))
         (cond ((null? environments)
                (error (format "~a is not defined" var)))
               (else
                (let ((var-defined? (lookup-var-false var (car environments))))
                  (displayln (format "Env: ~a" (car environments)))
                  (if var-defined?
                      var-defined?
                      (loop (cdr environments)))))))]
      [_ (eval-if-or-function-call arg)]))

  
  
  (define (eval-if-or-function-call expr)
    (match expr
      [`(,op ,args ...)
       (let ((evaluated-op (lookup-var-error op native-env))
              (evaluated-args (map eval-view-argument args)))
         (apply evaluated-op (cons root-env evaluated-args)))]
      [`(if ,pred ,then-branch ,else-branch)
       (let ((eval-pred (eval-view-argument pred)))
         (cond ((eq? true eval-pred)
                (eval-view-argument then-branch))
               ((eq? false eval-pred)
                (eval-view-argument else-branch))
               (else (error (format "Predicate in if expression needs to evaluate to true or false")))))]
      [_ (error (format "~a not a valide expression" expr))]))
  (define (eval-view-define expr)
    (match expr
      [`(def: ,var ,right-expr)
       (let ((evaluated-right (eval-view-argument right-expr)))
         (add-to-env! var evaluated-right local-env))]
      [_ (eval-if-or-function-call expr)]))
  (displayln exprs)
  (for-each eval-view-define exprs)
  local-env)|#