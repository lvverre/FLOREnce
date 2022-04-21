#lang racket
 (require racket/gui/base)
(define frame (new frame%
                   [label "Example"]
                   [width 300]
                   [height 300]))
(new canvas% [parent frame]
             [paint-callback
              (lambda (canvas dc)
                (send dc set-scale 3 3)
                (send dc set-text-foreground "blue")
                (send dc draw-text "Don't Panic!" 0 0))])

(new check-box% [label "test"][parent frame]
     [callback (lambda (c ce)
                 (sleep 23)
                 (display (send c get-value ))
                 (display ce))])
(send frame show #t)

(new button% [label "rt"] [parent frame] [min-width 
     [callback (lambda (b c)
                 (displayln "button"))])