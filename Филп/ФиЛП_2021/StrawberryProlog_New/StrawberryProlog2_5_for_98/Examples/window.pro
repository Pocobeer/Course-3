?-
  pen(3,rgb(255,0,0)),
  window_n( _, _, win_func, "Window", 200, 100, 400, 440,
  !, "C:\\WINDOWS\\CURSORS\\Globe.ani", rgb(0,0,0)), 
  0 =:= random(2),
  X = [20,120,20+100, 20],
  line(|X).

win_func(init) :- beep.
win_func(paint) :-
  X is 20, Y is 20, W is 100, H is 100,
  line(X, Y, X+W, Y, X+W, Y+H, X, Y+H, X, Y),
  line(20,20, 120, 120).

