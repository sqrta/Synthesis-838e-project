#lang rosette
(require rosette/lib/angelic rosette/lib/destruct)
(require "hole.rkt" "lang.rkt" "util.rkt")
(provide Synth)

(define (interpret prog [acc '()])
  (if (null? prog) acc
      (interpret
       (cdr prog)
       (destruct (car prog)
            [(plus a b) (cons (+ (stack-ref acc a) (stack-ref acc b)) acc)]
            [(minus a b) (cons (- (stack-ref acc a) (stack-ref acc b)) acc)]
            [(times a b) (cons (* (stack-ref acc a) (stack-ref acc b)) acc)]
            [(ite a b c) (cons (if (= (stack-ref acc a) 0) (stack-ref acc c) (stack-ref acc b)) acc)]
            [(slt a b) (cons (if (< (stack-ref acc a) (stack-ref acc b)) 1 0) acc)]
            ))
      ))

(define (run prog [init '()])
  (match prog
            [(program arity instructions) (top (interpret instructions init))]
            [_ "Not a program"])
  )

;(define test-prog (program
;                   2
;                   (list
;                   (lt 1 2) (ite 3 2 1))))
;
;(run test-prog (list 7 8))



                 
(define max-line 10)

(define (same spec imple init)
  (assert (= (apply spec init) (run imple init))))
(define (sum init)
  (apply + init))

(define (synth-one inputs spec prog)
  (synthesize
   #:forall inputs
   #:guarantee (same spec prog inputs)))

(define (search-fix arity spec lines insts)
  (if (> lines max-line) "No solution"
      (let ([prog (program arity (prog?? lines insts))])
        (let ([sol (synth-one (symbolic-list arity) spec prog)])
          (if (sat? sol) (evaluate prog sol)
                            (search-fix arity spec (+ lines 1) insts))))))

(define (Synth spec insts)
  (define arity (procedure-arity spec))
  (search-fix arity spec 0 insts))


  

