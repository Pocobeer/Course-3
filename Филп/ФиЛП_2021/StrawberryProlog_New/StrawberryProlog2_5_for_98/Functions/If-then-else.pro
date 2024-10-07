% demonstrates "if then else" predicate and function

?-
  (random(2)=:=0 ->
    X is (random(2)=:=0 -> a else b)
  else
    X is (random(2)=:=0 -> c else d)
  ),
  write(X), nl.

