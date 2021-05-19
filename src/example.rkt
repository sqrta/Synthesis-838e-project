#lang rosette
(require "synthesis.rkt" "lang.rkt")

#|
This file contains our three examples. The first two demonstrate naive and
straight-line implementations of max(a, b). The third demonstrates synthesis
of a short bitvector program for determining if the Hamming weight of a given
string is less than or equal to 1.
|#

;; This is the specification for the max function. Its behavior
;; is a simple definition of max(.): if x is greater than y, return x,
;; otherwise return y.
(define (max-spec x y)
  (if (> x y) x y))

;; Using less than and if-then-equals, synthesize a program that conforms to max-spec.
;; Note that this isn't identical to max-spec, it uses less-than instead of
;; greather-than, but it still successfully synthesizes the program.
(define insts1 (list slt ite))
(Synth max-spec insts1)

;; Synthesizes a program for max-spec using only ops from: less-than,
;; addition, subtraction, and multiplication. It's less obvious that this can be done!
(define insts2 (list minus plus times slt))
(Synth max-spec insts2)

;; Accumulates the number of set bits
(define (bv-set-length v l)
  (if (< l 0) 0
      (+ (if (equal? (bit l v) (bv #b1 1)) 1 0) (bv-set-length v (- l 1)))))

;; Checks that the number of set bits is at most one, and returns the decision thereof.
(define (Hamming-weight-le1-spec a)
  (if (<= (bv-set-length a 31) 1) (int32 1) (int32 0)))

;; Synthesize Hamming-weight-le1-spec using only: AND, equality, and subtraction.
;; Tricky bitvector solutions can be difficult for even experts to discover!
(define inst3 (list bvAnd bvEq bvSub))
(Synth Hamming-weight-le1-spec inst3 int32?)
