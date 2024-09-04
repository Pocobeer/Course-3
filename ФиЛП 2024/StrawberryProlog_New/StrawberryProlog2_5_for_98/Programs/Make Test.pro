% This program is created by Iordanka Tsenova
% from University of Sofia, Facilty of Mathematics and Computer Science

?-
  G_Sum=0,
  G_Num=1,
  G_L:=L,
  question(G_Num,Q|G_L),
  G_Q:=Q,
  window( _, _, win_func(_), "Question " + print(G_Num), 100, 100, 600, 400).

win_func(init):- 
  static(_, _, fail(_), G_Q, 20, 20, 500, 20),
  make_but(G_L,50).

make_but([[A,_]|T],N):-
  button( _, _, but_func(_), A, 20, N, 500, 20),
  N1 is N+40,
  make_but(T,N1).

but_func(press):-
  N is get_text(_),
  add_sum(N, G_L),
  close_window(parent(_)),
  G_Num:=G_Num+1,
  G_L:=L,
  (question(G_Num,Q|G_L)->
    G_Q:=Q,
    window( _, _, win_func(_), "Question " + print(G_Num), 100, 100, 600, 400)
  else
    message("result","Your result is "+print(G_Sum), ! )
  ).

add_sum(N, [[N,P]|_]):-
  G_Sum:=G_Sum+P.
add_sum(N, [_|L]):-
  add_sum(N, L).

question(1,"Who drinks milk?", ["Elephant", 2], ["Cow",5], ["Cat", 10]).
question(2,"Which is the speed of light?", ["300 000 km\\s", 25], ["300 000 km\\h", -10], ["300 000 km\\m", -10]).
question(3,"Which is the capital of Bulgaria?", ["Paris",-10], ["Sofia",10], ["Atina",-5]).
question(4,"Which is the best Prolog compiler?", ["Tomato Prolog",-10], ["Potato Prolog",-20], ["Strawberry Prolog", 30]).

  