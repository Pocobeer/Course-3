% demonstrates "of" function

?-
  X is A of fact(A(2)),
  write(X), nl, nl,

  Y is B of p(B),
  write(Y), nl, nl,

  Z is C of p(|C),
  write(Z), nl,

  fail.

fact(f1(1)).
fact(f2(2)).

p().
p(a).
p(a,b).
p(a,b,c).

