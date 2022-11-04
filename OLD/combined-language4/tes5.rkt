#lang racket
 (require racket/gui/base)
(define m (new frame% [label "kk"] [height 200] [width 300]))

(define z (new frame% [label "kk"] [height 200][width 300]))
(define v (new horizontal-panel% [parent z] [style (list 'auto-hscroll 'auto-vscroll)]))
(define lm (new message% [label "kkl"][auto-resize #t][parent v] ))
(send z show #t)
