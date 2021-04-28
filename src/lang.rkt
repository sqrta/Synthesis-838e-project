#lang rosette
(provide (all-defined-out))
(struct plus (r1 r2) #:transparent)
(struct minus (r1 r2) #:transparent)
(struct times (r1 r2) #:transparent)
(struct slt (r1 r2) #:transparent)
(struct ite (r1 r2 r3) #:transparent)

(struct program (arity instructions) #:transparent)