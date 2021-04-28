#lang rosette
(provide (all-defined-out))

(define (stack-ref st ref)
  (if (or (> ref (length st)) (< ref 1))
  (assert #f)
  (list-ref st (- (length st) ref))))

(define (top stack)
  (list-ref stack 0))

(define (symbolic-list n)
  (if (<= n 0) '()
      (local [(define-symbolic* new-one integer?)]
       (cons new-one (symbolic-list (- n 1))))))