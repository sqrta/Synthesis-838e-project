#lang rosette
(require "synthesis.rkt" "lang.rkt")

(define insts1 (list minus plus times lt ite))
(define insts2 (list minus plus times lt))

(define (max-spec x y)
  (if (> x y) x y))

(Synth max-spec insts1)
;(Synth max-spec insts2)