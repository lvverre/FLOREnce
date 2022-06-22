#lang racket 
(require "parser.rkt" "lexer.rkt")



(define (read-syntax path port)
  (define tokens (make-tokenizer port))
  (display tokens)
  (define parse-tree (parse path tokens))
   (displayln `,parse-tree)
   (define module-datum `(module bf-mod "language2.rkt"
                          ,parse-tree))
  (displayln module-datum)
  (datum->syntax #f module-datum))

(provide read-syntax read)



