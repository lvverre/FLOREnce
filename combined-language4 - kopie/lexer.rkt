#lang racket
(require brag/support)
(provide make-tokenizer )
(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define-lex-abbrev vars (:+ (char-set "azertyuiopqsdfghjklmwxcvbn-1234567890!")))
(define (make-tokenizer port)
  (define (next-token)
    (define basic-lexer
      (lexer
       ;[whitespace void]
       ;["\n" void]
       ;[(:seq #\'  (:+ any-char) )
       ;       (token 'SYMBOL (string->symbol (substring lexeme 1)))]
       ["(" 
       (token 'LEFT '|(|)]
       [")"
        (token 'RIGHT '|)|)]
       [(eof) (void)]
       [(:or ;"(" ")"
         "model:"
         "with:"
         "reactor:"
         "def:"
         "in:"
         "out:"
         "main:"
         "view:"
         "deploy:") (string->symbol lexeme)]
       [(:or digits
             (:seq (:+ digits)
                   "."
                   (:+ digits)))(token 'INTEGER (string->number lexeme))]
       [vars (token 'VAR  (string->symbol lexeme))]
       [any-char (next-token)]))
    (basic-lexer port))
  next-token)
          


#|
(define (make-tokenizer port)
  (define (next-token) (basic-lexer port))
  next-token) |#