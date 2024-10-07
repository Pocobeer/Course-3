% demonstrates assert predicates

?- s.

s :-
  yes_no("Think!", "Will you ask?", ?),
  !,
  read(X, "Give me your question"),
  X.
s :-
  yes_no("Well", "Will you say something?", !),
  read(X, "Give me your knowledge"),
  assert_in(X). % or assert(X)

like( john, money).
