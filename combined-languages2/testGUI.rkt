#lang racket
 (require racket/gui/base
          ;(only-in "functional/nodes.rkt" root-node)
          (only-in "functional/datastructures.rkt" event-node)
          "parse-values.rkt"
          (only-in "combined/propagation.rkt" fire)
          "primitives.rkt"
          )


(provide native-gui-environment)




(struct widget (val))
(struct parent widget ())
(struct frame parent ())
(struct h-panel parent ())
(struct v-panel parent ())
(struct event-widget widget())
(struct button event-widget ())
(struct gauge widget ())
(struct message widget ())
(struct radio-box event-widget ())






(define (prim-horizontal-panel env parent style alignment)
  (new horizontal-panel% (paren  parent)
       (style style) (alignment alignment)))

(define (prim-vertical-panel env parent style alignment )
  (if (parent? parent)
      (new vertical-panel% (parent parent) (style style) (alignment alignment))
      (error "wrong arguments")))

(define (prim-frame env label width height)
  (let ((frame (frame (new frame% (label (str-val label)) (width (nmb-val width)) (height (nmb-val height))))))
    (send (widget-val frame) show #t)
    frame))


    
(define button-class (class button%
                       (init event env-root)
                       (define button-event event)
                       (define/public (get-event)
                         button-event)
                       (super-new (callback
                                   (lambda (button control-event)
                                     (fire env-root event (sym 'pushed))))))) 
(define (prim-button env-root  label parent min-width min-height)
  (let* ((event (event-node '()))
         (new-button (button (new button-class
                                 (event event)(env-root env-root)(label (str-val label)) (parent (widget-val parent))
                                 (min-width (nmb-val min-width)) (min-height (nmb-val min-height))))))    
    new-button))

(define (prim-enable env-root widget value)
  (let ((enable? (true-struct? value)))
    (display value)
    (displayln enable?)
                                          
  (send (widget-val widget) enable enable?)))




(define (prim-gauge env-root label range parent min-width min-height)
  (let ((gauge (gauge (new gauge% (label label) (range range) (parent (widget-val parent)) (min-width min-width) (min-height min-height)))))
    (send (widget-val gauge) set-value 0)
    gauge))

(define (prim-gauge-value! env-root gauge value)
  (if (and (nmb? value) (gauge? gauge))
      (send (widget-val gauge) set-value (nmb-val value))
      (error (format "Primitive to set gauge value has wrong arguments: ~a and ~a" value gauge ))))
(define (prim-gauge-range! env-root gauge range)
  (if (and (gauge? gauge)(nmb? range))
      (send (widget-val gauge) set-range (nmb-val range))
      (error "Primitive to change range gauge has wrong arguments")))


(define (get-event env val)
  (send (widget-val val) get-event))


(define (prim-message env label parent)
  (if (and (str? label)
           (parent? parent))
      (let ((message (message (new message% (label (str-val label)) (parent (widget-val parent))))))
        message)
      (error "Primitive message takes as arguments a label and a parent")))
        
(define (list-of-string? choices)
  (if (pair? choices)
      (let loop
        ((choices choices))
        (display "STRING?")
        (cond ((pair? choices)
               (cond ((str? (pair-first choices))
                      (loop (pair-last choices)))
                     (else (error (format "expected list of strings given ~a" (pair-first choices))))))
              (else
               (when (not (str? choices))
                 (error (format "expected list of strings given ~a" choices))))))
      (error (format "expected list of strings given ~a" choices))))

(define (pairstr->racket-list-of-string transforme)
  (let loop
    ((transforme transforme))
    (display "TOLIST")
      (cond ((pair? transforme)
             (append (list (str-val (pair-first transforme)))
                     (loop (pair-last transforme))))
            (else (list (str-val transforme))))))



 (define radio-box-class (class radio-box%
                           (init event env-root)
                           (define radio-box-event event)
                         (define/public (get-event)
                           radio-box-event)
                         
                            
                         (super-new (selection 0)
                                    (callback
                                     (lambda (radio-box control-event)
                                       (display "FIRE")
                                       (fire env-root event
                                             (str (send radio-box get-item-label (send radio-box get-selection)))))))))



(define (prim-radio-box env label choices parent)
  (if (and (str? label)
           (parent? parent)
           (list-of-string? choices))
      (let* ((event (event-node '())))
        (radio-box (new radio-box-class (event event) (env-root env) (label (str-val label))
                        (choices (pairstr->racket-list-of-string choices))
                        (parent (widget-val parent)))))
      (error (format "Radio box expects label choices and parent"))))


        
      

(define native-gui-environment (make-hash (list
                                           (cons 'make-radio-box prim-radio-box)
                                           (cons 'make-message 'prim-message)
                                           (cons 'change-gauge-value! prim-gauge-value!)
                                           (cons 'change-gauge-range! prim-gauge-range!)
                                           (cons 'make-gauge prim-gauge)
                                           (cons 'change-enable prim-enable)
                                           (cons 'make-button prim-button)
                                           (cons 'make-frame prim-frame)
                                           (cons 'make-h-panel 'prim-h-panel)
                                           (cons 'make-v-panel 'prim-v-panel)
                                           (cons 'get-event get-event)
                                           (cons 'true true)
                                           (cons 'false false)
                                           (cons 'empty empty)
                                           (cons '+ prim-add))))


 
