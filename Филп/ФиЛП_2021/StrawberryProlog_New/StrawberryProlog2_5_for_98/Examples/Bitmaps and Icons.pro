% This program is created by Katia Stanimirova.

?-
   window( _, _, win_func(_), "Bitmaps and Icons", 100, 100, 375, 400).

win_func(init):-
	bitmap(_, _, fail(_), default, 50, 50),
      bitmap(_, _, fail(_), default, 250, 50),
      bitmap(_, _, fail(_), default, 100, 100), 
      bitmap(_, _, fail(_), default, 200, 100),
      bitmap(_, _, fail(_), default, 50, 150),
      bitmap(_, _, fail(_), default, 150, 150), 
      bitmap(_, _, fail(_), default, 250, 150),
      bitmap(_, _, fail(_), default, 100, 200),              
      bitmap(_, _, fail(_), default, 200, 200),
      bitmap(_, _, fail(_), default, 150, 250),
      icon(_, _, fail(_), default, 165, 215),
      icon(_, _, fail(_), default, 165, 115),
      icon(_, _, fail(_), default, 110,70),
      icon(_, _, fail(_), default, 220, 70),
      icon(_, _, fail(_), default, 30,112),
      icon(_, _, fail(_), default, 300,110),
      icon(_, _, fail(_), default, 112,170),
      icon(_, _, fail(_), default, 70,115),
      icon(_, _, fail(_), default, 265,115),
      icon(_, _, fail(_), default, 210,170),
      icon(_, _, fail(_), default, 23,76),
      icon(_, _, fail(_), default, 305,72),
      G_Br=0,      % G_Br is a global variable (it begin with G_)
      menu( normal, _, _, menu_brush(_), "&Brush").

menu_brush(press) :- 
      new_brush(G_Br),
      update_window(_),
      G_Br:= (G_Br+1) mod 5.

new_brush(0) :- window_brush(_, rgb(0, 0, 0), x).
new_brush(1) :- window_brush(_, rgb(255, 0, 255), (/)).
new_brush(2) :- window_brush(_, "res/Wall.bmp").
new_brush(3) :- window_brush(_, rgb(127, 0, 127)).
new_brush(4) :- window_brush(_, _).

