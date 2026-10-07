% 
% Wolf, goat, and cabbage problem, linear programming version in MiniZinc.
% 
% A.k.a. river crossing problem. 
%
% Problem formulation from MiniZinc's example wolf_goat_cabbage.mzn 
% which uses a constraint programming approach.
% """"
% A farmer has to take a wolf, goat and cabbage across a bridge
% He can only take one thing at a time
% The wolf and goat can't be left together alone (without the farmer)
% The goat and cabbage can't be left alone together
% """
%
% This version use a linear programming version. Compare with e.g.
% http://www.hakank.org/minizinc/3_jugs2.mzn
% 
%
% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%
include "globals.mzn";

% For minimizing total_cost
% include "shortest_path_model.mzn";

% For showing all the solutions with total_cost <= 7


n = 10; % 10 states
start = 1;
end = 8;
M = 999;

int: all = 1;

%
% data
%
d =
 % 1  2  3  4  5  6  7  8  8  10 
 [|M, 1, M, M, M, M, M, M, M, M,   % 1
  |1, M, 1, M, M, M, M, M, M, M,   % 2
  |M, 1, M, 1, M, M, M, M, M, 1,   % 3
  |M, M, 1, M, 1, M, M, M, M, M,   % 4
  |M, M, M, 1, M, 1, M, M, M, M,   % 5
  |M, M, M, M, 1, M, 1, M, 1, M,   % 6
  |M, M, M, M, M, 1, M, 1, M, M,   % 7
  |M, M, M, M, M, M, 1, M, 1, M,   % 8
  |M, M, M, M, M, 1, M, M, M, 1,   % 9
  |M, M, 1, M, M, M, M, M, 1, M,   % 10
|]
;

constraint total_cost <= 7 ;

% This works when using the minizinc solver, but not with other solvers.
output [
       if i = 1 /\ j = 1 then 
         "total_cost: " ++ show(total_cost) ++ "\n" ++
         "inFlow:  " ++ show(inFlow) ++ "\n" ++ "outFlow: " ++ show(outFlow) ++ "\n" ++
         "      1  2  3  4  5  6  7  8  9  0\n" 
       else "" endif ++
       if j = 1 then show_int(2, i) ++ " : " else "" endif ++
       show_int(2, x[i,j]) ++ if j = n then "\n" else " " endif
       | i in 1..n, j in 1..n
]
;

%
% Model for shortest path in Minizinc.
%
% Model from
% Taha "Introduction to Operations Research", page 245f .
%
% Used by
%    http://www.hakank.org/minizinc/3-jugs2.mzn
%    http://www.hakank.org/minizinc/shortest_path2.mzn.
%    http://www.hakank.org/minizinc/wolf_goat_cabbage_lp_all.mzn
%
% This is a derivative of
%   http://www.hakank.org/minizinc/shortest_path_model.mzn
% but here we show all solutions.
% Note: We assume that the calling model handle the appropriate
%       contraint of total_cost.
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

int: n;     % number of nodes in the matrix
int: start; % start node
int: end;   % end node
int: M;     % large number

array[1..n, 1..n] of 0..M: d; % distance matrix

% objective to minimize
var int: total_cost = sum(i in 1..n, j in 1..n where d[i,j] < M) ( d[i,j]*x[i,j] );

array[1..n] of var -1..1: rhs;  % indicating start/end nodes
array[1..n, 1..n] of var 0..1: x; % the resulting connection matrix
array[1..n] of var 0..1: outFlow; % out flow array
array[1..n] of var 0..1: inFlow;  % in flow array

constraint
     % set rhs for start/end nodes
     forall(i in 1..n) (
       if i = start then
         rhs[i] = 1
       elseif i = end then
         rhs[i] = -1
       else
         rhs[i] = 0
       endif
    )
    /\ % assert that all x values is >= 0
   forall(i in 1..n, j in 1..n where d[i,j] < M) (
         x[i,j] >= 0
   )
   /\ % calculate out flow
   forall(i in 1..n) (
      outFlow[i] = sum(j in 1..n where d[i,j] < M) (x[i,j])
   )
   /\ % calculate in flow
  forall(j in 1..n) (
    inFlow[j]  = sum(i in 1..n where d[i,j] < M) (x[i,j])
  )
  /\ % outflow = inflow
  forall(i in 1..n) (outFlow[i] - inFlow[i] = rhs[i])
  /\ % do not loops
  forall(i in 1..n) (
     x[i,i] = 0
  )

  /\ % sanity: there can be no connection in x if there is not
     % connection in d
  forall(i,j in 1..n) (
     if d[i,j] = M then
        x[i,j] = 0
     else
        true
     endif
  )

;

solve satisfy;
% solve minimize total_cost;
% alternative solve statement
% solve :: int_search([ x[i,j] | i,j in 1..n], "first_fail", "indomain", "complete") minimize total_cost;
