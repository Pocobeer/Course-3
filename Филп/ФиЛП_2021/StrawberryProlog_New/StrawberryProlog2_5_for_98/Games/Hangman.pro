% This program is created by
% Stanislav Mihailov and Milko Boiadjiev
% from New Bulgarian University

?- window(_,_,win_func(_),"Hangman",100,100,400,300).


win_func(init):-
  G_Masked := "",
  G_HangNo := 0,
  choose_word,
  static(_,_,fail(_),"Type a letter:",10,20,100,20),
  edit(G_E,_,fail(_),"",110,15,30,30),
  button(_,_,butt_func(_),"Try it!",150,15,50,30),
%  static(_,_,fail(_),"The word is:",10,100,100,20),
  static(G_S,_,fail(_),"",10,120,180,20),
  mask_word.
  
win_func(paint):-
  for(I, 1, G_HangNo),
  hang_me(I),
  fail.
	

butt_func(press) :-
  Letter is get_text(G_E),
  New_Mask := "",
  check_mask(New_Mask, Letter),
  check_masks(New_Mask),
  set_text("", G_E),
  (G_HangNo=7 ->
    hanged
  else
    display_masked,
    (G_Masked = G_Word -> win)
  ).


check_masks(New_Mask) :-
  G_Masked = New_Mask ->
    hang
  else
    G_Masked := New_Mask.


check_mask(New_Mask, Letter):- 
  for(I, 0, str_length(G_Word)- 1),
  sub_string(Let, G_Word, I, 1),
  check_sub_mask(New_Mask, Let, Letter, I),
  fail.
check_mask(New_Mask, Letter).



check_sub_mask(Mask, Let, Letter, Pos) :-
  Let = Letter ->
    Mask := Mask + Let
  else
    sub_string(Sub, G_Masked, Pos, 1),
    Mask := Mask + Sub.
check_sub_mask(Mask, Let, Letter, Pos).


choose_word :-
  Wrd_Num is random(17),
  word(Wrd_Num, Word),
  G_Word:=Word.

mask_word :-
  G_Masked := "",
  for(I, 0, str_length(G_Word)- 1),
  G_Masked := G_Masked + "_",
  display_masked,
  fail.
mask_word.


display_masked :-
  Display_Mask := "",
  for(I, 0, str_length(G_Masked)- 1),
  sub_string(Sub, G_Masked, I, 1),
  Display_Mask := Display_Mask + Sub + "  ",  
  set_text(Display_Mask, G_S),
  fail.
display_masked.


hang :-
  G_HangNo := G_HangNo + 1,
  hang_me(G_HangNo).


hang_me(1) :- pen(10, rgb(150, 130, 105)), line(200,250,200,80).
hang_me(2) :- pen(10, rgb(150, 130, 105)), line(200,80,300,80).
hang_me(3) :- pen(2, rgb(150, 130, 105)), line(300,80,300,110).
hang_me(4) :- pen(1, rgb(100, 100, 100)), ellipse(285, 110, 315, 140).
hang_me(5) :- pen(1, rgb(100, 100, 100)), line(300,140,300,190).
hang_me(6) :- pen(1, rgb(100, 100, 100)), line(300,190,280,220), line(300,190,320,220).
hang_me(7) :- pen(1, rgb(100, 100, 100)), line(300,140,280,170), line(300,140,320,170).

hanged :- 
  G_Masked := G_Word, display_masked, 
  G_Masked := "", 
  message("Game Over!", "You lose. If you feel smart, try again.", !). 

win :- message("Game Over!", "HEY! You win :)))", i).

word(0, "sofia").
word(1, "london").
word(2, "paris").
word(3, "vien").
word(4, "moskow").
word(5, "berlin").
word(6, "athens").
word(7, "roma").
word(8, "budapest").
word(9, "amsterdam").
word(10, "stockholm").
word(11, "madrid").
word(12, "helsinki").
word(13, "bucharest").
word(14, "oslo").
word(15, "warsaw").
word(16, "lisbon").
