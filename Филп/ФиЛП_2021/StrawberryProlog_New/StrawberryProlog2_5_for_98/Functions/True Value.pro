% demonstrates "true_value" function

?-
  X is true_value(a=a)
     + true_value(a?=a)
     + true_value(a=b)
     + true_value(a=B),
  write(X), nl.


