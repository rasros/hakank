%
% Crossword problem 'puzzle14, 10 x 10' in MiniZinc.
%
% (generated Sat Sep 24 08:54:24 2011 by `make_crossword.pl 63 1` ).
%
% This crossword model was 
%
% This is problem 'puzzle14, 10 x 10' from the Gecode crossword example:
%   http://www.gecode.org/doc-latest/reference/crossword_8cpp_source.html
% 
% 
% This MiniZinc model was created by Hakan Kjellerstrand, hakank@bonetmail.com
% See also my MiniZinc page: http://www.hakank.org/minizinc
%

%
% Gecode problem to solve (63): puzzle14, 10 x 10
% 
%   * * * _ _ _ _ * * *
%   * * _ _ _ _ _ * * *
%   * _ _ _ _ _ _ _ * *
%   _ _ _ _ _ * * _ _ _
%   _ _ _ _ * * * _ _ _
%   _ _ _ * * * _ _ _ _
%   _ _ _ * * _ _ _ _ _
%   * * _ _ _ _ _ _ _ *
%   * * * _ _ _ _ _ * *
%   * * * _ _ _ _ * * *



problem_name = "puzzle14, 10 x 10";


% number of letters to assign
N = 62;


% distinct words
require_distinct_words = 1;

constraint
  table([L[1], L[2], L[3], L[4]], words4) 
/\ table([L[5], L[6], L[7], L[8], L[9]], words5) 
/\ table([L[10], L[11], L[12], L[13], L[14], L[15], L[16]], words7) 
/\ table([L[17], L[18], L[19], L[20], L[21]], words5) 
/\ table([L[22], L[23], L[24]], words3) 
/\ table([L[25], L[26], L[27], L[28]], words4) 
/\ table([L[29], L[30], L[31]], words3) 
/\ table([L[32], L[33], L[34]], words3) 
/\ table([L[35], L[36], L[37], L[38]], words4) 
/\ table([L[39], L[40], L[41]], words3) 
/\ table([L[42], L[43], L[44], L[45], L[46]], words5) 
/\ table([L[47], L[48], L[49], L[50], L[51], L[52], L[53]], words7) 
/\ table([L[54], L[55], L[56], L[57], L[58]], words5) 
/\ table([L[59], L[60], L[61], L[62]], words4) 
/\ table([L[17], L[25], L[32], L[39]], words4) 
/\ table([L[10], L[18], L[26], L[33], L[40]], words5) 
/\ table([L[5], L[11], L[19], L[27], L[34], L[41], L[47]], words7) 
/\ table([L[1], L[6], L[12], L[20], L[28]], words5) 
/\ table([L[48], L[54], L[59]], words3) 
/\ table([L[2], L[7], L[13], L[21]], words4) 
/\ table([L[49], L[55], L[60]], words3) 
/\ table([L[3], L[8], L[14]], words3) 
/\ table([L[42], L[50], L[56], L[61]], words4) 
/\ table([L[4], L[9], L[15]], words3) 
/\ table([L[35], L[43], L[51], L[57], L[62]], words5) 
/\ table([L[16], L[22], L[29], L[36], L[44], L[52], L[58]], words7) 
/\ table([L[23], L[30], L[37], L[45], L[53]], words5) 
/\ table([L[24], L[31], L[38], L[46]], words4)
;

% The segments (words)
% (0 for fill outs)
int: max_length = 10;
int: num_segments = 28;
array[1..num_segments, 1..max_length] of int: segments = array2d(1..num_segments, 1..max_length, 
[
1,2,3,4,0,0,0,0,0,0,
5,6,7,8,9,0,0,0,0,0,
10,11,12,13,14,15,16,0,0,0,
17,18,19,20,21,0,0,0,0,0,
22,23,24,0,0,0,0,0,0,0,
25,26,27,28,0,0,0,0,0,0,
29,30,31,0,0,0,0,0,0,0,
32,33,34,0,0,0,0,0,0,0,
35,36,37,38,0,0,0,0,0,0,
39,40,41,0,0,0,0,0,0,0,
42,43,44,45,46,0,0,0,0,0,
47,48,49,50,51,52,53,0,0,0,
54,55,56,57,58,0,0,0,0,0,
59,60,61,62,0,0,0,0,0,0,
17,25,32,39,0,0,0,0,0,0,
10,18,26,33,40,0,0,0,0,0,
5,11,19,27,34,41,47,0,0,0,
1,6,12,20,28,0,0,0,0,0,
48,54,59,0,0,0,0,0,0,0,
2,7,13,21,0,0,0,0,0,0,
49,55,60,0,0,0,0,0,0,0,
3,8,14,0,0,0,0,0,0,0,
42,50,56,61,0,0,0,0,0,0,
4,9,15,0,0,0,0,0,0,0,
35,43,51,57,62,0,0,0,0,0,
16,22,29,36,44,52,58,0,0,0,
23,30,37,45,53,0,0,0,0,0,
24,31,38,46,0,0,0,0,0,0,

]);

% Problem where each cell is assigned a unique index.
% (0 means blocked cell)
int: rows = 10;
int: cols = 10;
array[1..rows, 1..cols] of int: problem = array2d(1..rows, 1..cols,
[
0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 
0, 0, 5, 6, 7, 8, 9, 0, 0, 0, 
0, 10, 11, 12, 13, 14, 15, 16, 0, 0, 
17, 18, 19, 20, 21, 0, 0, 22, 23, 24, 
25, 26, 27, 28, 0, 0, 0, 29, 30, 31, 
32, 33, 34, 0, 0, 0, 35, 36, 37, 38, 
39, 40, 41, 0, 0, 42, 43, 44, 45, 46, 
0, 0, 47, 48, 49, 50, 51, 52, 53, 0, 
0, 0, 0, 54, 55, 56, 57, 58, 0, 0, 
0, 0, 0, 59, 60, 61, 62, 0, 0, 0, 

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
