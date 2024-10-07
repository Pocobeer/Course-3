% This program will generate runtime error

?-
  X is g(f(1)),
  write(X), nl.

R is f(int X):-
  R:=X+1.

R is g(float X):- % change "foat" with "int"
  R:=5*X.
