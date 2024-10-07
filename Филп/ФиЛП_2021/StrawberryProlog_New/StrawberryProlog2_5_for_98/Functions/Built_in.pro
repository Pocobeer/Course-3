% demonstrates creating of custom built-in predicate

?-
  read(X, "Give me a term"),
  p(13, X), % try with 13.2 instead of 13
  fail.     % try without fail (use Next Answer)

*** p(int N, nocalc(T)) :- writeq(T).
*** p(int N, nocalc(T)) :- write("=").
*** p(int N, nocalc(T)) :- write(T).
*** p(int N, nocalc(T)) :-
  nl, write("This predicate don't use the value of N."), nl.
