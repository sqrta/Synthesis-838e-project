#lang rosette
(provide (all-defined-out))


;; Variables in Rosette are available as 'registers' in a
;; growing stack. These utility functions reflect that.
(define (stack-ref st ref)
  (if (or (> ref (length st)) (< ref 1))
  (assert #f)
  (list-ref st (- (length st) ref))))

(define (top stack)
  (list-ref stack 0))

(define (symbolic-list n [type integer?])
  (if (<= n 0) '()
      (local [(define-symbolic* new-one type)]
       (cons new-one (symbolic-list (- n 1))))))

(define (push-stack stack item)
  (cons item stack))
