#lang rosette
(require rosette/lib/angelic rosette/lib/destruct)
(require data/bit-vector)
(require "hole.rkt" "lang.rkt" "util.rkt")
(provide Synth)


#|
This file defines an interpreter for the small language we use and
contains the definition of the synthesis commands.
|#


;; Interpreter for the int and bitvector instructions based on a register stack.
(define (interpret prog [reg-stack '()])
  (define (ref index) (stack-ref reg-stack index))
  (if (null? prog) reg-stack
      (interpret
       (cdr prog)
       (push-stack reg-stack
       (destruct (car prog)
            [(plus a b) (+ (ref a) (ref b))]
            [(minus a b)  (- (ref a) (ref b))]
            [(times a b)  (* (ref a) (ref b))]
            [(ite a b c) (if (= (ref a) 0) (ref c) (ref b))]
            [(slt a b) (if (< (ref a) (ref b)) 1 0)]
            [(bvSlt a b) (if (bvslt (ref a) (ref b)) (int32 1) (int32 0))]
            [(bvAdd a b) (bvadd (ref a) (ref b))]
            [(bvSub a b)  (bvsub (ref a) (ref b))]
            [(bvMul a b)  (bvmul (ref a) (ref b))]
            [(bvAnd a b) (bvand (ref a) (ref b))]
            [(bvEq a b) (if (bveq (ref a) (ref b)) (int32 1) (int32 0))]
            [(bvSet a) (integer->bitvector a (bitvector 32))]
            )
            ))
      ))

;; Runs a program through the interpreter
(define (run prog [init '()])
  (match prog
            [(program arity instructions) (top (interpret instructions init))]
            [_ "Not a program"]))

(define test-prog (program 2 (list (bvSet 2))))

;; Sets the maximum parse tree depth
(define max-line 6)

;; Asserts that the specification and interpreted result are the same
;; on the inputs.
(define (same spec imple init)
  (assert (equal? (apply spec init) (run imple init))))

(define (sum init)
  (apply + init))


;; The synthesis command that demands that the synthesized program and the
;; interpreted program match on all inputs.
(define (synth-one inputs spec prog)
  (synthesize
   #:forall inputs
   #:guarantee (same spec prog inputs)))

(define (search-fix arity spec lines insts type)
  (if (> lines max-line) "No solution"
      (let ([prog (program arity (prog?? lines insts))])
        (let ([sol (synth-one (symbolic-list arity type) spec prog)])
          (if (sat? sol) (evaluate prog sol)
                            (search-fix arity spec (+ lines 1) insts type))))))

(define (Synth spec insts [type integer?])
  (define arity (procedure-arity spec))
  (search-fix arity spec 0 insts type))
