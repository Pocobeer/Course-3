% demonstrates creating of custom function which operates with terms

?-
  write(add_a(bc)), nl.

R is add_a(term(X)):-
  R:=[a|X].

