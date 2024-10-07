% This program is created by students
% from University of Sofia

?-
  pen(2,rgb(0,0,0)),
  retractall(my(_,_)),
  retractall(your(_,_)),
  set(pos([[y,n,n],[n,n,n],[n,n,n],[n,n,n]],[[n,n,n,n],[n,n,n,n],[n,n,n,n]],0)),
  window(_,_,func(_),"Points",90,90,228,240).

mem3([E,_,_],E,0).
mem3([_,E,_],E,1).
mem3([_,_,E],E,2).
replace3([E,A,B],[_,A,B],E,0).
replace3([A,E,B],[A,_,B],E,1).
replace3([A,B,E],[A,B,_],E,2).

mem4([E,_,_,_],E,0).
mem4([_,E,_,_],E,1).

mem4([_,_,E,_],E,2).
mem4([_,_,_,E],E,3).
replace4([E,A,B,C],[_,A,B,C],E,0).
replace4([A,E,B,C],[A,_,B,C],E,1).
replace4([A,B,E,C],[A,B,_,C],E,2).
replace4([A,B,C,E],[A,B,C,_],E,3).

move(Who,H1,V1,H2,V1,S2,X,Y,add_hsq):-	    %PREDIKAT MOVE, KOITO WZIMA STARATA POZICIA I OPR. NOWATA
	mem4(H1,Row,Y),		    %tarsi prazen red
	mem3(Row,n,X),		    %tarsim prazno miasto, zapiswame go w Y
	replace3(Row2,Row,y,X),
	replace4(H2,H1,Row2,Y),
	S2=0,
	add_hsq2(X,Y,H2,V1,S2).
move(Who,H1,V1,H1,V2,S2,X,Y,add_vsq):-	    %PREDIKAT MOVE, KOITO WZIMA STARATA POZICIA I OPR. NOWATA
	mem3(V1,Row,Y),		    %tarsi prazen red
	mem4(Row,n,X),		    %tarsim prazno miasto, zapiswame go w Y
	replace4(Row2,Row,y,X),
	replace3(V2,V1,Row2,Y),
	S2=0,
	add_vsq2(X,Y,H1,V2,S2).
mem_h(H,W,X,Y):-
	mem4(H,Row,Y),
	mem3(Row,W,X).
mem_v(V,W,X,Y):-
	mem3(V,Row,Y),
	mem4(Row,W,X).
func(paint):-
	brush(rgb(255,0,0)),
	my(I,J),
	X is 50*I+30,
	Y is 50*J+30,
   	X1 is X+50,
   	Y1 is Y+50,
   	rect(X,Y,X1,Y1),
   	fail.
func(paint):-
	brush(rgb(0,0,255)),
	your(I,J),
	X is 50*I+30,
	Y is 50*J+30,
	X1 is X+50,
	Y1 is Y+50,
	rect(X,Y,X1,Y1),
	fail.
func(paint):-
	brush(rgb(0,0,0)),
	for(I,0,3),
	for(J,0,3),
	X is 50*I+27,
	Y is 50*J+27,
	X1 is X+6,
	Y1 is Y+6,
	ellipse(X,Y,X1,Y1),fail.

func(paint):-
  pos(H,_,_),
  mem4(H,Row,J),		    %tarsi prazen red
  mem3(Row,y,I),		    %tarsim prazno miasto, zapiswame go w Y
  X is 50*I+33,
  Y is 50*J+30,
  X1 is X+44,
  line(X,Y,X1,Y),
  fail.

func(paint):-
  pos(_,V,_),
  mem3(V,Row,J),
  mem4(Row,y,I),
  X is 50*I+30,
  Y is 50*J+33,
  Y1 is Y+44,
  line(X,Y,X,Y1),
  fail.

func(mouse_click(X,Y)):-
	X<185,X>25,
	Y<185,Y>25,
 	X1 is (X - 25) mod 50,
 	Y1 is (Y - 25) mod 50,
 	X1>=10,
	X1=<50,
 	Y1=<10,
 	X2 is (X - 25)//50,
 	Y2 is (Y - 25)//50,
 	pos(H1,V,R),
	mem4(H1,Row,Y2),
	mem3(Row,n,X2),
 	replace3(Row2,Row,y,X2),
	replace4(H2,H1,Row2,Y2),
	set(pos(H2,V,R)),
      add_hsq(X2,Y2,my),
      retractall(p(_,_,_)),
	play(H2,V,R),
	update_window(_).

func(mouse_click(X,Y)):-
	X<185,X>25,
	Y<185,Y>25,
	X1 is (X - 25) mod 50,
 	Y1 is (Y - 25) mod 50,
 	Y1>=10,
 	Y1=<50,
 	X1=<10,
 	X2 is (X - 25)//50,
 	Y2 is (Y - 25)//50,
 	pos(H,V1,R),
	mem3(V1,Row,Y2),
	mem4(Row,n,X2),
 	replace4(Row2,Row,y,X2),
	replace3(V2,V1,Row2,Y2),
	set(pos(H,V2,R)),
 	add_vsq(X2,Y2,my),
      retractall(p(_,_,_)),
	play(H,V2,R),
 	update_window(_).
add_hsq(X,Y,T):-
	X1 is X+1,
	Y1 is Y- 1,
	pos(H,V,_),
	mem_v(V,y,X,Y1),
	mem_h(H,y,X,Y1),
	mem_v(V,y,X1,Y1),
	assert(T(X,Y1)),
	fail.
add_hsq(X,Y,T):-
	X1 is X+1,
	Y1 is Y+1,
	pos(H,V,_),
	mem_v(V,y,X,Y),
	mem_h(H,y,X,Y1),
	mem_v(V,y,X1,Y),
	assert(T(X,Y)),
	fail.
add_hsq(X,Y,T).

add_vsq(X,Y,T):-
	X1 is X- 1,
	Y1 is Y+1,
	pos(H,V,_),
	mem_h(H,y,X1,Y),
	mem_v(V,y,X1,Y),
	mem_h(H,y,X1,Y1),
	assert(T(X1,Y)),
	fail.
add_vsq(X,Y,T):-
	X1 is X+1,
	Y1 is Y+1,
	pos(H,V,_),
	mem_h(H,y,X,Y),
	mem_v(V,y,X1,Y),
	mem_h(H,y,X,Y1),
	assert(T(X,Y)),
	fail.
add_vsq(X,Y,T).

add_hsq2(X,Y,H,V,R):-
	X1 is X+1,
	Y1 is Y- 1,
	mem_v(V,y,X,Y1),
	mem_h(H,y,X,Y1),
	mem_v(V,y,X1,Y1),
	R:=R+1,
	fail.
add_hsq2(X,Y,H,V,R):-
	X1 is X+1,
	Y1 is Y+1,
	mem_v(V,y,X,Y),
	mem_h(H,y,X,Y1),
	mem_v(V,y,X1,Y),
	R:=R+1,
	fail.
add_hsq2(X,Y,H,V,R).

add_vsq2(X,Y,H,V,R):-
	X1 is X- 1,
	Y1 is Y+1,
	mem_h(H,y,X1,Y),
	mem_v(V,y,X1,Y),
	mem_h(H,y,X1,Y1),
	R:=R+1,
	fail.
add_vsq2(X,Y,H,V,R):-
	X1 is X+1,
	Y1 is Y+1,
	mem_h(H,y,X,Y),
	mem_v(V,y,X1,Y),
	mem_h(H,y,X,Y1),
	R:=R+1,
	fail.
add_vsq2(X,Y,H,V,R).

play(H1,V1,R1):-%trace,
	Max= -100,
	move(o,H1,V1,H2,V2,R2,X,Y,A),
      R3=100,
      min_max(H2,V2,R2,R3,1),
      R3>Max,
	Max:=R3,
	set(pos(H2,V2,R2)),	%tarsi nai dobria hod i go setwa kato pozicia,kato pochwa ot parwia
	set(p(X,Y,A)),
	fail.
play(H1,V1,R1):-
	p(X,Y,A),!,
      A(X,Y, your).
play(H1,V1,R1).
min_max(H1,V1,R1,Min,0):-!, Min:=R1.
min_max(H1,V1,R1,Min,Deep):-
      Deep1 is Deep - 1,
	move(x,H1,V1,H2,V2,S|_),
      R2 is R1-S,
      R3= -100,
      max_min(H2,V2,R2,R3,Deep1),
      R3<Min,
	Min:=R3,
	fail.
min_max(H1,V1,R1,Min,Deep).

max_min(H1,V1,R1,Max,0):- !, Max:=R1.
max_min(H1,V1,R1,Max,Deep):-
      Deep1 is Deep - 1 ,
	move(x,H1,V1,H2,V2,S|_),
      R2 is R1+S,
      R3=100,
      min_max(H2,V2,R2,R3,Deep1),
      R3>Max,
	Max:=R3,
	fail.
max_min(H1,V1,R1,Max,Deep).
