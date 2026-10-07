%
% Shortest path (transshipment) problem in Minizinc.
%
% From Winston "Operations Research", page 414 and 417.
%
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%


n = 6;
start = 1;
end= 6;
M = 9999;

d =
array2d(1..n, 1..n, [
 0, 4, 3, M, M, M,
 M, 0, M, 3, 2, M,
 M, M, 0, M, 3, M,
 M, M, M, 0, M, 2,
 M, M, M, M, 0, 2,
 M, M, M, M, M, 0
]);

output [
       if i = 1 /\ j = 1 then
         "total_cost: " ++ show(total_cost) ++ "\n" ++
         "inFlow:  " ++ show(inFlow) ++ "\n" ++ "outFlow: " ++ show(outFlow) ++ "\n" ++
         "    1 2 3 4 5 6\n" 
       else "" endif ++
       if j = 1 then show(i) ++ " : " else "" endif ++
       show_int(4,x[i,j]) ++ if j = n then "\n" else " " endif
       | i in 1..n, j in 1..n
];

%
% Model for shortest path in Minizinc.
%
%
% Model from
% Taha "Introduction to Operations Research", page 245f .
%
% Used by 3-jugs2.mzn and shortest_path2.mzn.
%
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

% solve satisfy;
solve minimize total_cost;
% alternative solve statement
% solve :: int_search([ x[i,j] | i,j in 1..n], "first_fail", "indomain", "complete") minimize total_cost;
