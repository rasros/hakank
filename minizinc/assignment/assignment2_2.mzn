%
% Assignment problem in Minizinc.
% 
% Swimming team example.
%
% Same problem as assignment2.mzn (which see), but used the general
% model file assignment_model.mzn.
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc




rows = 4;
cols = 10;

% added some columns, the original has 4 columns.
cost =
[|54, 54, 51, 53,   50,60,70,80,90,100, 
 |51, 57, 52, 52,   40,50,60,70,80, 90,
 |50, 53, 54, 56,   40,50,60,80,93, 69,
 |56, 54, 55, 53,   60,80,40,60,50,100
|]
;

output [
   if i = 1 /\ j = 1 then 
     "\nsumma: " ++ show(summax)
   else "" endif ++
   if j = 1 then "\n" else " " endif ++
   show(x[i,j]) 
   | i in 1..rows, j in 1..cols

];

%
% Assignment problem in MiniZinc.
%
% General model of assigments. Used by assignment2.mzn .
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc


predicate assignment(array[int, int] of var 0..1: x,
                     array[int, int] of int: cost,
                     var int: summa
                 ) =
   forall(i in index_set_1of2(x)) (sum(j in index_set_2of2(x)) (x[i,j]) = 1) /\
   if card(index_set_1of2(x)) = card(index_set_2of2(x)) then
       forall(j in index_set_2of2(x)) (sum(i in index_set_1of2(x)) (x[i,j]) = 1)
   else
       forall(j in index_set_2of2(x)) (sum(i in index_set_1of2(x)) (x[i,j]) <= 1)
   endif
   /\
   summa = sum(i in index_set_1of2(x), j in index_set_2of2(x)) (x[i,j]*cost[i,j])
;

int: rows;
int: cols;
array[1..rows, 1..cols] of var 0..1: x;
array[1..rows, 1..cols] of int: cost;
var int: summax;

% Minimize the cost
solve :: int_search([x[i,j] | i in 1..rows, j in 1..cols], first_fail, indomain_min, complete)  minimize summax;
% solve satisfy;


constraint
           assignment(x, cost, summax)
;
