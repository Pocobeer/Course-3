% demonstrates creating of custom function

?-
  write(f(f(0))),
  nl, fail.

R is f(int X):- R:=X+1.
R is f(int X):- R:=X+2.
