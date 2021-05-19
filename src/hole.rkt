#lang rosette
(require rosette/lib/synthax)
(require rosette/lib/angelic)

(provide prog??)

;; Conforming to the Villain spec, defines holes for instruction
;; symbols by instruction arity.
(define (inst?? insts)
 (define-symbolic* r1 r2 r3 integer?)
 (apply choose*
        (for/list ([constructor insts])
          (case (procedure-arity constructor)
            [(1) (constructor r1)]
            [(2) (constructor r1 r2)]
            [(3) (constructor r1 r2 r3)]))))

(define (prog?? n insts)
 (if (<= n 0)
     (list)
     (cons (inst?? insts) (prog?? (- n 1) insts))))