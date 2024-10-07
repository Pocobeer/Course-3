?-
  det(D, [[1,1,4],[3,1,5],[4,2,1]]),
  write("The determinant of this matrix is "),
  write(D),nl.

det(X,[[X]]):- !.
det(X,[Row|T]):-
  X:= 0,
  el(Row,El,N),
  take_out2(T,N,T2),
  det(D,T2),
  X:=X+ El*D* (-1)** N,
  fail.
det(X,_).

el([H|T],H,0).
el([H|T],El,N):-
  el(T,El,N1),
  N is N1+1.

take_out([H|T],0,T).
take_out([H|T],N,[H|T1]):-
  N1 is N- 1,
  take_out(T,N1,T1).

take_out2([],N,[]).
take_out2([H|T],N,[H2|T2]):-
  take_out(H,N,H2),
  take_out2(T,N,T2).

