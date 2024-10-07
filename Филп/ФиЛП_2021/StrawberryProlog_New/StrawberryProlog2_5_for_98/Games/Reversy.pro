% This program is created by Hristo Ganchev
% from University of Sofia

?-
   set(sit([[n,n,n,n,n,n,n,n],[n,n,n,n,n,n,n,n],[n,n,n,n,n,n,n,n],[n,n,n,b,w,n,n,n],[n,n,n,w,b,n,n,n],[n,n,n,n,n,n,n,n],[n,n,n,n,n,n,n,n],[n,n,n,n,n,n,n,n]])),
   pen(2,rgb(0,0,0)),   
   window(_,_,win_func(_),"Game2",100,50,508,528).
	
 win_func(paint):-
     brush(rgb(0,250,0)),
     rect(50,50,450,450),
     for(I,0,9),
     X is I * 50 + 50,
     line(X,50,X,450),
     line(50,X,450,X),
     fail.

 win_func(paint):-     
     brush(rgb(0,0,0)),
     sit(H),
     for(J,0,8),
     for(I,0,8),
     take(H,Line,J),
     take(Line,b,I),
     X is I*50 + 55,
     Y is J*50 + 55,
     X1 is X + 40,
     Y1 is Y + 40,
     ellipse(X,Y,X1,Y1),
     fail.

 win_func(paint):-     
     brush(rgb(250,250,250)),
     sit(H),
     for(J,0,8),
     for(I,0,8),
     take(H,Line,J),
     take(Line,w,I),
     X is I*50 + 55,
     Y is J*50 + 55,
     X1 is X + 40,
     Y1 is Y + 40,
     ellipse(X,Y,X1,Y1),
     fail.
win_func(paint).

win_func(mouse_click(X,Y)):-
  X1 is (X - 40) // 50, 
  Y1 is (Y - 40) // 50,
  X1 >= 0,
  X1 =< 7,
  Y1 >= 0,
  Y1 =< 7,
  sit(Sit1),
  insert(X1,Y1,w),
  sit(Sit2),
  not(Sit1=Sit2),
  win_func(paint),
  wait(1), 
  take3(Sit2,n,X2,Y2),
  insert(X2,Y2,b),
  sit(Sit3),
  not(Sit2=Sit3),
  win_func(paint). 

insert(X,Y,Who):-%trace,
  sit(Sit),
  take2(Sit,n,X,Y),
  opposit(Who,NewWho),
  for(WayX,-1,1),
  for(WayY,-1,1),
  sit(Sit2),
  neighbour(NewWho,X,Y,Sit2,WayX,WayY),
  jump(NewWho,X,Y,Sit2,WayX,WayY,NewX,NewY),
  replace3(Result,Sit2,Who,X,Y,NewX,NewY,WayX,WayY),
  set(sit(Result)),
  fail.
insert(X,Y,Who).

neighbour(Who,X,Y,Sit,WayX,WayY):-
     X1 is X+ WayX,
     Y1 is Y+ WayY,
     take2(Sit,Who,X1,Y1).

jump(Who,X,Y,Sit,WayX,WayY,X2,Y2):-
   X1 is X+ WayX,
   Y1 is Y+ WayY,
   opposit(Who,NewWho),
   neighbour(NewWho,X1,Y1,Sit,WayX,WayY),
   X2 is X1+ WayX,
   Y2 is Y1+ WayY.	

jump(Who,X,Y,Sit,WayX,WayY,NewX,NewY):-
   X1 is X+ WayX,
   Y1 is Y+ WayY,
   neighbour(Who,X1,Y1,Sit,WayX,WayY),
   jump(Who,X1,Y1,Sit,WayX,WayY,NewX,NewY).	

take3(Sit,El,0,0):-
  take2(Sit,El,0,0).

take3(Sit,El,0,7):-
  take2(Sit,El,0,7).

take3(Sit,El,7,0):-
  take2(Sit,El,7,0).

take3(Sit,El,7,7):-
  take2(Sit,El,7,7).

take3(Sit,El,X,Y):-
  take2(Sit,El,X,Y).

take2(Sit,El,X,Y):-
    take(Sit,Row,Y),
    take(Row,El,X).

replace2(Result,Sit,El,X,Y):-
    take(Sit,Line,Y),
    replace(NewLine,Line,El,X),
    replace(Result,Sit,NewLine,Y).

replace3(Result,Result,Who,X,Y,X,Y,WayX,WayY).
replace3(Result,Sit,Who,X,Y,ToX,ToY,WayX,WayY):-
    replace2(ResultP,Sit,Who,X,Y),
    X1 is X + WayX,
    Y1 is Y + WayY,
    replace3(Result,ResultP,Who,X1,Y1,ToX,ToY,WayX,WayY).

replace([New,B,C,D,E,F,G,H],[_,B,C,D,E,F,G,H],New,0).
replace([A,New,C,D,E,F,G,H],[A,_,C,D,E,F,G,H],New,1).
replace([A,B,New,D,E,F,G,H],[A,B,_,D,E,F,G,H],New,2).
replace([A,B,C,New,E,F,G,H],[A,B,C,_,E,F,G,H],New,3).
replace([A,B,C,D,New,F,G,H],[A,B,C,D,_,F,G,H],New,4).
replace([A,B,C,D,E,New,G,H],[A,B,C,D,E,_,G,H],New,5).
replace([A,B,C,D,E,F,New,H],[A,B,C,D,E,F,_,H],New,6).
replace([A,B,C,D,E,F,G,New],[A,B,C,D,E,F,G,_],New,7).


take([El,_,_,_,_,_,_,_],El,0).
take([_,El,_,_,_,_,_,_],El,1).
take([_,_,El,_,_,_,_,_],El,2).
take([_,_,_,El,_,_,_,_],El,3).
take([_,_,_,_,El,_,_,_],El,4).
take([_,_,_,_,_,El,_,_],El,5).
take([_,_,_,_,_,_,El,_],El,6).
take([_,_,_,_,_,_,_,El],El,7).


opposit(b,w).
opposit(w,b).
