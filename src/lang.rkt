#lang rosette

#| Defines the ops we can use for synthesis. |#

(provide (all-defined-out))
(struct plus (r1 r2) #:transparent)
(struct minus (r1 r2) #:transparent)
(struct times (r1 r2) #:transparent)
(struct slt (r1 r2) #:transparent)
(struct bvAdd (r1 r2) #:transparent)
(struct bvSub (r1 r2) #:transparent)
(struct bvMul (r1 r2) #:transparent)
(struct bvAnd (r1 r2) #:transparent)
(struct bvSlt (r1 r2) #:transparent)
(struct bvEq (r1 r2) #:transparent)
(struct bvSet (r1) #:transparent)
(struct ite (r1 r2 r3) #:transparent)

(struct program (arity instructions) #:transparent)

(define int32? (bitvector 32))
(define-symbolic u v int32?)
(define (int32 i)
  (bv i int32?))
