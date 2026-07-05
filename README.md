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

- seating_arrangements and company_competition: replaced the deprecated
  decreasing_set and increasing_set (dropped from the MiniZinc standard library
  in version 2.6) with decreasing and increasing.

The original models are MIT licensed; see LICENSE.
