%
% Another set_cvering problem in Minizinc
% 
% Problem from 
% Katta G. Murty: "Optimization Models for Decision Making", page 302f
% http://ioe.engin.umich.edu/people/fac/books/murty/opti_model/junior-7.pdf
% 
% 10 senators making a committee, where there must at least be one 
% representative from each group:
% group:        senators:
% southern      1 2 3 4 5
% northern      6 7 8 9 10
% liberals      2 3 8 9 10
% conservative  1 5 6 7
% democrats     3 4 5 6 7 9
% republicans   1 2 8 10
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%



%
% data;
%
num_groups = 6;
num_senators = 10;

% what group does a senator belong to
belongs =
array2d(1..num_groups, 1..num_senators, 
[
  1, 1, 1, 1, 1, 0, 0, 0, 0, 0,   % 1 southern
  0, 0, 0, 0, 0, 1, 1, 1, 1, 1,   % 2 northern
  0, 1, 1, 0, 0, 0, 0, 1, 1, 1,   % 3 liberals
  1, 0, 0, 0, 1, 1, 1, 0, 0, 0,   % 4 conservative
  0, 0, 1, 1, 1, 1, 1, 0, 1, 0,   % 5 democrats
  1, 1, 0, 0, 0, 0, 0, 1, 0, 1    % 6 republicans
]);


output [
  "Senator " ++ show(i) ++ ": " ++ show(x[i]) ++ "\n" 
  | i in 1..num_senators
];

%
% Set covering in MiniZinc.
%
% This is just the model, see set_covering3.mod for data.
%
% Model created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

int: num_senators;
int: num_groups;
% array[1..num_senators] of int: senators;
% array[1..num_groups] of int: group;

% decision variable: should this senator belong to the committe
array[1..num_senators] of var 0..1: x;
array[1..num_groups, 1..num_senators] of 0..1:  belongs; % matrix for which group a senator belongs

var int: numNeeded;

%
%  set_covering3
%      mat: an incidence (1/0) matrix of n_group x n_senators, 1 is a senator
%         belongs to the group, else 0
%      assign: the array of assignment of senators,  1 if this senator is assigned, else 0
%      n_groups: number of groups
%      n_senators: number of senators
%      numNeeded: (result) number of senators needed
%
predicate set_covering3(array[int, int] of int: mat, array[int] of var int: assign, int: n_groups, int: n_senators, var int: numNeeded) =
           forall(i in 1..n_groups) (
              sum(j in 1..n_senators) (assign[j]*mat[i,j]) >= 1
           ) /\
           numNeeded = sum(i in 1..num_senators) (x[i])
;

% solve minimize sum(i in 1..num_senators) (x[i]);
solve satisfy;

constraint sum(i in 1..num_senators) (x[i]) = 2;


constraint
  set_covering3(belongs, x, num_groups, num_senators, numNeeded)
;
