# hakank MiniZinc models

The MiniZinc models from Håkan Kjellerstrand's hakank collection
(https://github.com/hakank/hakank), used as a benchmark corpus for the klause
constraint solver (https://github.com/Eignex/klause).

The upstream collection is no longer maintained following its author's passing,
so fixes for models that no longer flatten under current MiniZinc are kept here.

## Layout

Only the MiniZinc models are kept (the minizinc/ subtree from upstream);
non-MiniZinc files (.zinc, .pl, .py, .html) were dropped.

The models live under minizinc/, grouped into one subdirectory per family, so a
model and its variants (for example queens, queens2 and queens_ip) sit together.
A parameterized model has a companion <model>.dzn alongside it.

Files that only define shared constraints/functions and are included by other
models (rather than being problems themselves) live under minizinc/lib/,
including the crossword3.mzn template and its word list, used by the crossword3_*
instances. Add lib/ to the include path to compile a model that uses one, for
example:

    minizinc -I minizinc/lib minizinc/minesweeper/minesweeper_0.mzn

## Changes from upstream

- seating_arrangements, company_competition: replaced the deprecated decreasing_set / increasing_set (dropped from the standard library in 2.6) with decreasing / increasing.
- lex_chain_less, queens_diversity: renamed a locally defined lex_chain_less predicate that now clashes with the standard-library builtin.
- nonogram_create_automaton: restored a show_cond helper.
- queens_viz: removed IDE-only viz(...) visualization annotations.
- debruijn_no_repetition: replaced the obsolete credit/bbs search combinator with complete.
- lights_out: removed a duplicated generator variable.
- curve_fitting3: gave the free var float declarations finite bounds.
- diet2: widened a parameter domain that its own data exceeded.
- sudoku_multi, sudoku_multi2: simplified output that used a var array.
- smullyan_knights_knaves: turned an all-commented-out constraint into a no-op.
- domino: added the standard 28-piece (0..6) instance on a 7x8 board.
- Removed product_test (multiplies 40 variables up to 1000, overflowing 64-bit integers), weights (data only ever hosted on the now-gone upstream site), linear_combinations (a mode-dependent modelling bug), and crossword3_test and nonogram_regular (need bespoke instances).

The original models are MIT licensed; see LICENSE.
