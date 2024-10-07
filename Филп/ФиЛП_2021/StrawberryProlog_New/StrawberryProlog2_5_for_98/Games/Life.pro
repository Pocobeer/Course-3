% This program is created by the students
% from University of Sofia

?-
  retractall(one(_,_)),
  retractall(two(_,_)),
  G_Pic=one,
  window(_, _, win_func(_), "Life", 100, 100, 350, 350).

win_func(init) :-
    button(_,_,butfunc(_),"Step",250,250,50,20).

%Loop creating the square matrix
win_func(paint) :-
  pen(1,0),
  line(220,20, 220,220),
  line(20,220, 220,220),
  line(20,20, 20,220),
  line(20,20, 220,20),
  pen(0,0),
  brush(rgb(0,0,0)),
  for(I,0,19),
  for(J,0,19),
  (one(I,J);two(I,J)),
  X is 20 + 10*I,
  Y is 20 + 10*J,
  X1 is X + 11,
  Y1 is Y + 11,
  rect(X,Y,X1,Y1),
  fail.

win_func(mouse_click(Xp,Yp)):-
  Xp>=20,
  Yp>=20,
  Xp=<220,
  Yp=<220,
  I is (Xp - 20)//10,
  J is (Yp - 20)//10,
  X is 20 + 10*I,
  Y is 20 + 10*J,
  X1 is X + 11,
  Y1 is Y + 11,
  (G_Pic(I,J)->   %if-then statement
    retract(G_Pic(I,J)), brush(system_color(window))
  else
    assert(G_Pic(I,J)), brush(rgb(0,0,0))
  ),
  rect(X,Y,X1,Y1).


butfunc(press) :-
  make(New,G_Pic),
  do(New),
  retractall(G_Pic(_,_)),
  G_Pic := New,
  update_window(_).

do(New):-
  for(I,0,19),
  for(J,0,19),
  R is f(I+1,J+1) + f(I+1,J) + f(I+1,J- 1) +
       f(I,J+1)  + f(I,J- 1) +
       f(I- 1,J+1) + f(I- 1,J) + f(I- 1,J- 1),  
  (G_Pic(I,J)->
    R > 1, R < 4, assert(New(I,J))
  else
    R=3, assert(New(I,J))
  ),
  fail.

do(_).

%Check
R is f(I,J):-
  G_Pic(I,J), !, R:=1.
R is f(I,J):-
  R:=0.

make(one,two):-!.
make(two,one).
