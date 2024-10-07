% This program is written by Stoyan Mihov

append([],X,X).
append([H|T],X,[H|Y]) :- append(T,X,Y).

list3([1,2,3,4,5,6,7,8,9]).

perm([],[]).
perm([H|T],R) :- perm(T,P), append(X,Y,P), append(X,[H|Y],R).

mag3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33
    ]) :-
  S is A11 + A12 + A13,
  S is A21 + A22 + A23,
  S is A31 + A32 + A33,
  S is A11 + A21 + A31,
  S is A12 + A22 + A32,
  S is A13 + A23 + A33,
  S is A11 + A22 + A33,
  S is A31 + A22 + A13.

pp3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33
    ]) :-
  nl,
  write(A11),write(" "),write(A12),write(" "),write(A13),nl,
  write(A21),write(" "),write(A22),write(" "),write(A23),nl,
  write(A31),write(" "),write(A32),write(" "),write(A33),nl,nl.


go :-
  list3(L),
  perm(L,L1),
  mag3(L1),
  ok(L1),
  pp3(L1),
  fail.
go.


ok(L) :- write("*"), nl, sym3(L,L1), res(L1), !, fail.
ok(L) :- assert(res(L)).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A13,A12,A11,
     A23,A22,A21,
     A33,A32,A31]).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A31,A32,A33,
     A21,A22,A23,
     A11,A12,A13]).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A11,A21,A31,
     A12,A22,A32,
     A13,A23,A33]).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A33,A23,A13,
     A32,A22,A12,
     A31,A21,A11]).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A31,A21,A11,
     A32,A22,A12,
     A33,A23,A13]).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A33,A32,A31,
     A23,A22,A21,
     A13,A12,A11]).

sym3([
     A11,A12,A13,
     A21,A22,A23,
     A31,A32,A33],
    [A13,A23,A33,
     A12,A22,A32,
     A11,A21,A31]).

?-
  write("The magic squares are:"), nl,
  chronometer(_),
  go,
  chronometer(T),
  X is T/1000,
  write(X), write(" seconds."), nl.
