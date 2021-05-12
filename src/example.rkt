#lang rosette
(require "synthesis.rkt" "lang.rkt")

(define insts1 (list slt ite))
(define insts2 (list minus plus times slt))

(define (max-spec x y)
  (if (> x y) x y))

(Synth max-spec insts1)
(Synth max-spec insts2)

(define (bv-set-length v l)
  (if (< l 0) 0
      (+ (if (equal? (bit l v) (bv #b1 1)) 1 0) (bv-set-length v (- l 1)))))

(define (Hamming-weight-le1-spec a)
  (if (<= (bv-set-length a 31) 1) (int32 1) (int32 0)))

(define inst3 (list bvAnd bvEq bvSub))
(Synth Hamming-weight-le1-spec inst3 int32?)