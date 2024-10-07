% *****************************************************************
% * KNIGHT TOUR PROBLEM. Author Panayot Dobrikov
% *****************************************************************

% * DEFINE BOARD SIZE
sizet(6).
size2(T) :- sizet(X), T is X * X.

% *****************************************************************
%  FINDING KNIGHT TOUR 
% *****************************************************************
member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

length([],0).
length([_|T],X) :-
	length(T,L),
	X is L + 1.

xy([[1,2],[-1,2],[1,-2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]).

next_move(_,_,[],[],_).
next_move(X,Y,[[X1,Y1]|T1],[[X2,Y2]|T2],L) :-
	X2 is X1 + X,
	Y2 is Y1 + Y, sizet(Sn),
	X2 > 0, X2 =< Sn, Y2 > 0, Y2 =< Sn, 
	not( member([X2,Y2],L)), !,   
	next_move(X,Y,T1,T2,L).
next_move(X,Y,[_|T1],T2,L) :-
	next_move(X,Y,T1,T2,L).

% Greedy heuristic

knight(L) :- 
      S is 1, 
      printone(1, 1, 1),
      knight2(1, 1, [[1,1]], L, S).

knight2(_, _, L, L, Counter) :- 
      length(L,X), write(X), nl, size2(P), X =:= P.
knight2(X, Y, L, R, Counter) :- 
      Counter2 is Counter + 1,
      printone(X, Y, Counter),
	xy(N),
	next_move(X, Y, N, R1, L),
	greedy(L, R1, X1, Y1),
      knight2(X1, Y1, [[X1,Y1]|L], R, Counter2).

%      knight2(X1, Y1, [[X1,Y1]|L], R, Counter2),
%      printone(X1, Y1, Counter2).

greedy(L,X,X1,Y1) :-
	count_moves(L,X,NX),
	min(NX,[_,X1,Y1]).

count_moves(_,[],[]).
count_moves(L,[[X,Y]|T],[[C,X,Y]|T1]) :-
	xy(N),
	next_move(X,Y,N,R,L),
	length(R,C),
	count_moves(L,T,T1).

min([X],X).
min([[C,X,Y]|T],[C,X,Y]) :-
	min(T,[C1,_,_]),
	C =< C1.
min([[C,_,_]|T],[C1,X1,Y1]) :-
	min(T,[C1,X1,Y1]),
	C1 < C.

% *****************************************************************
%  INTERFACE
% *****************************************************************

?-
  sizet(S), S1 is S * 30 + 30,
  SX is S1 - 18, SY is S1 + 20,
  window( _, _, win_func(_), "Knight tour", 200, 100, SX, SY).

win_func(init) :-
    menu( pop_up, _, _, menu_file(_), "&Game"), 
    menu( normal, _, 1, menu_about(_), "&About"),
    put_buttons.
win_func(close) :- not( yes_no("","Confirm Quit?", ?)).

put_buttons :-
  sizet(S), S1 is S * 30,
  for(X, 0, S1- 1, 30), 
    for(Y, 0, S1- 1, 30), 
      button( _, 1, fail(_), "", X, Y, 30, 30),
      fail.
put_buttons.

menu_file(init) :-
    menu( normal, _, 1, menu_run(_), "&Run"),
    menu( separator, _, 1, fail(_), _),
    menu( normal, _, 1, menu_exit(_), "&Quit").

menu_about(press) :-
    message("About Program", "Knight tour finder, author Panayot Dobrikov, FMI SU ", i).

printone(X, Y, Counter) :- T is print(Counter),
    Xp is X * 30 - 30,
    Yp is Y * 30 - 30,
    button( _, 1,  fail(_), T, Xp, Yp, 30, 30).

writeResult([[Xi, Yi]|T], Counter) :- 
    printone(Xi, Yi, Counter), Counter2 is Counter + 1,
    writeResult(T, Counter2), write(Counter), nl.

menu_run(press) :-
    knight(L), fail.

menu_exit(press) :- close_window(_).
