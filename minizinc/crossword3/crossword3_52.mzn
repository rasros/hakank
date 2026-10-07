%
% Crossword problem 'puzzle03, 4 x 4' in MiniZinc.
%
% (generated Sat Sep 24 08:54:24 2011 by `make_crossword.pl 52 1` ).
%
% This crossword model was 
%
% This is problem 'puzzle03, 4 x 4' from the Gecode crossword example:
%   http://www.gecode.org/doc-latest/reference/crossword_8cpp_source.html
% 
% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

%
% Gecode problem to solve (52): puzzle03, 4 x 4
% 
%   _ _ _ *
%   _ _ _ _
%   _ _ _ _
%   * _ _ _



problem_name = "puzzle03, 4 x 4";


% number of letters to assign
N = 14;


% distinct words
require_distinct_words = 1;

constraint
  table([L[1], L[2], L[3]], words3) 
/\ table([L[4], L[5], L[6], L[7]], words4) 
/\ table([L[8], L[9], L[10], L[11]], words4) 
/\ table([L[12], L[13], L[14]], words3) 
/\ table([L[1], L[4], L[8]], words3) 
/\ table([L[2], L[5], L[9], L[12]], words4) 
/\ table([L[3], L[6], L[10], L[13]], words4) 
/\ table([L[7], L[11], L[14]], words3)
;

% The segments (words)
% (0 for fill outs)
int: max_length = 4;
int: num_segments = 8;
array[1..num_segments, 1..max_length] of int: segments = array2d(1..num_segments, 1..max_length, 
[
1,2,3,0,
4,5,6,7,
8,9,10,11,
12,13,14,0,
1,4,8,0,
2,5,9,12,
3,6,10,13,
7,11,14,0,

]);

% Problem where each cell is assigned a unique index.
% (0 means blocked cell)
int: rows = 4;
int: cols = 4;
array[1..rows, 1..cols] of int: problem = array2d(1..rows, 1..cols,
[
1, 2, 3, 0, 
4, 5, 6, 7, 
8, 9, 10, 11, 
0, 12, 13, 14, 

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
