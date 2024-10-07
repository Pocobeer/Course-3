?-
  window(_, _, win_func(_), "Cursor", 200, 100, 400, 300),
  cursor(?), wait(0.5),
  cursor(s), wait(0.5),
  cursor(c), wait(0.5),
  cursor(t), wait(0.5),
  cursor(o), wait(0.5),
  cursor(x), wait(0.5),
  cursor(n), wait(0.5),
  cursor(d), wait(0.5),
  cursor(u), wait(0.5),
  cursor(!), wait(0.5),
  cursor(v), wait(0.5),
  cursor(w), wait(0.5),
  text_out(10, 50, " End of the Test! ").

win_func(init) :-
  window_brush(_, rgb(255, 255, 0)),   % yellow
  color_text(_, rgb(255, 255, 255)),   % white
  color_text_back(_, rgb(0, 0, 255)).  % blue

win_func(paint) :-
  text_out(10, 10, " Look at the cursor! "). 

