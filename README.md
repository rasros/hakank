# hakank MiniZinc models

The MiniZinc models from Håkan Kjellerstrand's hakank collection
(https://github.com/hakank/hakank), used as a benchmark corpus for the klause
constraint solver (https://github.com/Eignex/klause).

The upstream collection is no longer maintained following its author's passing,
so fixes for models that no longer flatten under current MiniZinc are kept here.

## Layout

The models live under minizinc/, grouped into one subdirectory per family, so a
model and its variants (for example queens, queens2 and queens_ip) sit together.

Files that only define shared constraints/functions and are included by other
models (rather than being problems themselves) live under minizinc/lib/. Add it
to the include path to compile a model that uses one, for example:

    minizinc -I minizinc/lib minizinc/minesweeper/minesweeper_0.mzn

## Changes from upstream

Structure:

- Reduced to the MiniZinc models only (the minizinc/ subtree); non-MiniZinc
  files (.zinc, .pl, .py, .html) were dropped.
- Grouped one subdirectory per model family, and moved shared include-only
  files under minizinc/lib/.
- Added companion .dzn data files so parameterized models compile on their own.

Model fixes so models flatten under current MiniZinc:

- seating_arrangements, company_competition: replaced the deprecated
  decreasing_set / increasing_set (dropped from the standard library in 2.6)
  with decreasing / increasing.
- lex_chain_less, queens_diversity: renamed a locally defined lex_chain_less
  predicate that now clashes with the standard-library builtin.
- nonogram_regular, nonogram_create_automaton: restored a show_cond helper.
- queens_viz: removed IDE-only viz(...) visualization annotations.
- debruijn_no_repetition: replaced the obsolete credit/bbs search combinator
  with complete.
- lights_out: removed a duplicated generator variable.
- curve_fitting3: gave the free var float declarations finite bounds.
- diet2: widened a parameter domain that its own data exceeded.
- sudoku_multi, sudoku_multi2: simplified output that used a var array.
- smullyan_knights_knaves: turned an all-commented-out constraint into a no-op.

The original models are MIT licensed; see LICENSE.
