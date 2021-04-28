# Synthesis-838e-project

This project is to synthesize a program satisfying user's specification

## Requirements
This project is built in the [Rosette](http://homes.cs.washington.edu/~emina/rosette/) solver-aided language, which extends [Racket](http://racket-lang.org). Install the following requirements:

* Racket v8.0 ([download](http://download.racket-lang.org))
* Rosette ([instructions on GitHub](https://github.com/emina/rosette))
  You can install Rosette through

  ```
  raco pkg install rosette
    ```

## Getting started
cd to the "src" directory and run
```
racket example.rkt
```
will get
```racket
(program 2 (list (slt 2 1) (ite 3 1 2)))
(program 2 (list (minus 2 1) (slt 2 1) (times 3 4) (minus 2 5)))
```

## Synthesize a Program

### Program

The result program is in a SSA form, represented with a `program` structure (in `src/lang.rkt`):

```
(struct program (arity instructions))
```
`arity` is the number of input variables of the program and `instructions` is a list of instructions. For example

```racket
(program 2 (list (slt 2 1) (ite 3 1 2)))
```
implements the `max` function. The program takes two inputs. The operands to instructions refer to a group of global registers starting from register 1; the first 2 of these registers (1 and 2) are the two inputs to the program, and the remaining are the outputs of previous instructions. Therefore, this program first stores `y < x` (calculated by `slt 2 1`) in register 3, and then stores `if (r3) then x else y` (calculated by  `ite 3 1 2`) in register 4 (where `r3` is the value of register 3). Programs implicitly return the value of the last assigned register (in this case, register 4).

### Synthesize

The user first needs to give the specification, represented by an arbitrary racket function that uses a list of integers as inputs. For example, a `max` function
```
(define (max-spec x y)
  (if (> x y) x y))
```
Then the user specifies a list of instructions `insts` can be used to synthesize the target function and run
```
(Synth max-spec insts)
```
We will synthesize a program equivalent with the specified function using allowed instructions as few as possible. For example, if we are allowed to use the `if-then-else` instruction `ite`, the synthesis is easy

```racket
(define insts1 (list slt ite))
(Synth max-spec insts1)
; (program 2 (list (slt 2 1) (ite 3 1 2)))  means
; => if (y<x) then x else y
```
However, how can we synthesize a `max` function without the `if-then-else` instruction `ite`? Suppose we can only use `+, -, *, <` operations where `<` returns 1 if true else 0. Our project figures out a program with 4 instructions.
```racket
(define insts2 (list minus plus times slt))
(Synth max-spec insts2)
; (program 2 (list (minus 2 1) (slt 2 1) (times 3 4) (minus 2 5))) 
; =>  y - (y - x) * (y < x)
```
This program is useful when running `if-then-else` instruction brings higher cost.