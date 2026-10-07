%
% Crossword problem 'puzzle07, 6 x 6' in MiniZinc.
%
% (generated Sat Sep 24 08:54:24 2011 by `make_crossword.pl 56 1` ).
%
% This crossword model was 
%
% This is problem 'puzzle07, 6 x 6' from the Gecode crossword example:
%   http://www.gecode.org/doc-latest/reference/crossword_8cpp_source.html
% 
% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

%
% Gecode problem to solve (56): puzzle07, 6 x 6
% 
%   _ _ _ _ _ *
%   _ * _ _ _ _
%   _ _ _ * _ _
%   _ _ * _ _ _
%   _ _ _ _ * _
%   * _ _ _ _ _



problem_name = "puzzle07, 6 x 6";


% number of letters to assign
N = 30;


% distinct words
require_distinct_words = 1;

constraint
  table([L[1], L[2], L[3], L[4], L[5]], words5) 
/\ table([L[6]], words1) 
/\ table([L[7], L[8], L[9], L[10]], words4) 
/\ table([L[11], L[12], L[13]], words3) 
/\ table([L[14], L[15]], words2) 
/\ table([L[16], L[17]], words2) 
/\ table([L[18], L[19], L[20]], words3) 
/\ table([L[21], L[22], L[23], L[24]], words4) 
/\ table([L[25]], words1) 
/\ table([L[26], L[27], L[28], L[29], L[30]], words5) 
/\ table([L[1], L[6], L[11], L[16], L[21]], words5) 
/\ table([L[2]], words1) 
/\ table([L[12], L[17], L[22], L[26]], words4) 
/\ table([L[3], L[7], L[13]], words3) 
/\ table([L[23], L[27]], words2) 
/\ table([L[4], L[8]], words2) 
/\ table([L[18], L[24], L[28]], words3) 
/\ table([L[5], L[9], L[14], L[19]], words4) 
/\ table([L[29]], words1) 
/\ table([L[10], L[15], L[20], L[25], L[30]], words5)
;

% The segments (words)
% (0 for fill outs)
int: max_length = 6;
int: num_segments = 20;
array[1..num_segments, 1..max_length] of int: segments = array2d(1..num_segments, 1..max_length, 
[
1,2,3,4,5,0,
6,0,0,0,0,0,
7,8,9,10,0,0,
11,12,13,0,0,0,
14,15,0,0,0,0,
16,17,0,0,0,0,
18,19,20,0,0,0,
21,22,23,24,0,0,
25,0,0,0,0,0,
26,27,28,29,30,0,
1,6,11,16,21,0,
2,0,0,0,0,0,
12,17,22,26,0,0,
3,7,13,0,0,0,
23,27,0,0,0,0,
4,8,0,0,0,0,
18,24,28,0,0,0,
5,9,14,19,0,0,
29,0,0,0,0,0,
10,15,20,25,30,0,

]);

% Problem where each cell is assigned a unique index.
% (0 means blocked cell)
int: rows = 6;
int: cols = 6;
array[1..rows, 1..cols] of int: problem = array2d(1..rows, 1..cols,
[
1, 2, 3, 4, 5, 0, 
6, 0, 7, 8, 9, 10, 
11, 12, 13, 0, 14, 15, 
16, 17, 0, 18, 19, 20, 
21, 22, 23, 24, 0, 25, 
0, 26, 27, 28, 29, 30, 

]);

%
% Crossword model in MiniZinc.
%
% This is the common model for crossword3_*.mzn
%

%
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

include "globals.mzn";
include "../lib/crossword3_words_all.dzn";
% include "crossword3_words_gecode.dzn";
% include "crossword3_words_swe.dzn";

int: a =  1; int: b =  2; int: c =  3; int: d =  4; int: e =  5; int: f =  6;
int: g =  7; int: h =  8; int: i =  9; int: j = 10; int: k = 11; int: l = 12;
int: m = 13; int: n = 14; int: o = 15; int: p = 16; int: q = 17; int: r = 18;
int: s = 19; int: t = 20; int: u = 21; int: v = 22; int: w = 23; int: x = 24;
int: y = 25; int: z = 26;
% Swedish
% int: aa = 27; int: ae = 28; int: oe = 29; % å, ä, and ö


int: num_letters = 26;
% int: num_letters = 29; % Swedish

array[1..num_letters] of string: letters =
       ["a","b","c","d","e","f","g","h","i","j","k","l","m",
        "n","o","p","q","r","s","t","u","v","w","x","y","z"
       % , "å", "ä", "ö" % Swedish
    ];

% number of letters to assign
int: N;

% decision variables
array[0..N] of var 1..num_letters: L;


string: problem_name;

% solve satisfy;
% ann: var_select;
% ann: val_select;
solve :: int_search(
        L,
        first_fail,
        indomain_min,
        complete)
    satisfy;


% distinct words
int: require_distinct_words;

% dummy variable
constraint L[0] = 1;

constraint
   forall(I,J in 1..num_segments where I < J) (
      % 1-letter words must be able to be the same across and down
      if sum(K in 1..max_length) ( bool2int(segments[I,K] > 0 ) ) = 1 /\
         segments[I,1] = segments[J,1]
       then
         true
      else
        not(forall(K in 1..max_length) (
           L[segments[I,K]] = L[segments[J,K]]
         ))
       endif
   )
;


output [
  "\n" ++ problem_name ++ "\n" ++
  "L:" ++ show(L) ++ "\n"
]
++
[
  if problem[i,j] = 0 then
      "*"
  else
     show(letters[fix(L[problem[i,j]])])
  endif
  ++ if j = cols then "\n" else "" endif
  | i in 1..rows, j in 1..cols
]
++ ["\n"]
;
