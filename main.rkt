#lang racket/gui

(require drracket/check-syntax
         syntax/modread)

(define annotations%
  (class (annotations-mixin object%)
         (init-field src)
         (super-new)
         (define/override (syncheck:add-jump-to-definition source-obj
                                                           start
                                                           end
                                                           id
                                                           filename
                                                           submods)
           (printf "~s\n" filename)
           (super syncheck:add-jump-to-definition source-obj
                  start end id filename submods))
         (define/override (syncheck:find-source-object stx)
           (and (equal? src (syntax-source stx))
                src))
         ))

(define path "/Users/linzizhuan/dannypsnl/reproduce/b.rkt")
(define-values (src-dir file dir?)
  (split-path path))
(define text (new text%))
(send text load-file path)
(define collector (new annotations% [src path]))
(define ns (make-base-namespace))
(define in (open-input-string (send text get-text)))
  (define-values (add-syntax done)
    (make-traversal ns src-dir))
(parameterize ([current-annotations collector]
               [current-namespace ns]
               [current-load-relative-directory src-dir])
  (define stx (expand (with-module-reading-parameterization
                        (λ () (read-syntax path in)))))
  (add-syntax stx))
