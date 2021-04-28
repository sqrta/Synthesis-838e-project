#lang rosette
(require rosette/lib/angelic rosette/lib/destruct)
(require "hole.rkt" "lang.rkt" "util.rkt")
(provide Synth)

(define (interpret prog [reg-stack '()])
  (define (ref index) (stack-ref reg-stack index))
  (if (null? prog) reg-stack
      (interpret
       (cdr prog)
       (destruct (car prog)
            [(plus a b) (push-stack reg-stack (+ (ref a) (ref b)))]
            [(minus a b) (push-stack reg-stack (- (ref a) (ref b)))]
            [(times a b) (push-stack reg-stack (* (ref a) (ref b)))]
            [(ite a b c) (push-stack reg-stack (if (= (ref a) 0) (ref c) (ref b)))]
            [(slt a b) (push-stack reg-stack (if (< (ref a) (ref b)) 1 0))]
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


  

