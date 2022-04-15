#lang racket
(require  "nodes.rkt")
(require racket/hash)
(provide (all-defined-out))



;
;GLOBAL-VARIABLES
;
(define body-global-env (map (lambda (x)
                               x)
                             (list (cons '+ +) (cons '- -) (cons 'display display))))
(define condition-global-env (map (lambda (x)
                                    x)
                                  (list (cons '- -)
                                        (cons '+ +)
                                        (cons 'and (lambda el
                                                     
                                                     ( andmap (lambda (el) el) el))) (cons 'not (lambda (el)
                                                                                     (not el)))(cons 'quote (lambda (el)
                                                       (quote el))) (cons 'or (lambda opnds (ormap (lambda (el) el) opnds))) (cons '= =) (cons '>= >=) (cons '<= <=) (cons '> >) (cons '< <) (cons 'eq? eq?) (cons 'equal? equal?))))


(define (lookup-global-variable env var)
  (let ((val-env-pair (assoc var env)))
    (if val-env-pair
        (cdr val-env-pair)
        (error (format "variable: ~a not found" var)))))

(define (extend-global-env env var val)
  (if (assoc val env)
      #f
      (cons  (cons var val) env)))

;
;PM-variables
;


(struct pm (env ) #:mutable)
(struct alpha-pm pm (expiration-time) #:mutable #:transparent)
(define (make-partial-match-env)
  (make-hash))
(define (lookup-event-variable var env)
  (if (hash-has-key? env var)
      (hash-ref env var)
      #f))
(define (extend-pm-env var val env)
  (hash-set env var val))


(define (partial-match-occurs? env node)
  (let loop ((pms (filter-node-partial-matches node)))
    (cond ((null? pms)
           #f)
          ((equal?  (pm-env (car pms)) env)
           (car pms))
          (else (loop (cdr pms))))))

(define (add-partial-match! pm node)
  (set-filter-node-partial-matches! node
                                    (cons pm 
                                          (filter-node-partial-matches node))))



;check if pm env correspond to other pm-env

      

(define (remove-partial-matches! env node)
  (let* ((partial-matches (filter-node-partial-matches node))
         (filtered-partial-matches
          (filter
           (lambda (partial-match)
             (not (equal? env (pm-env partial-match))))
           partial-matches)))
    (set-filter-node-partial-matches! node filtered-partial-matches)
    (not (= (length partial-matches) (length filtered-partial-matches)))))
    




(define (try-to-combine-env env-1 env-2 )     
    (if (possible-to-combine? env-1 env-2)
        (combine-pm-env env-1 env-2)
        #f))

(define (possible-to-combine? env-1 env-2)
  (andmap (lambda (e)
           e )
          (hash-map
           env-1
          (lambda (key value)
            (if (hash-has-key? env-2 key)
                (equal? value (hash-ref env-2 key))
                #t))
          )))
         
  

(define (combine-pm-env env-1 env-2)
  (hash-union env-1 env-2 #:combine/key (lambda (k v1 v2) v1)))
           



