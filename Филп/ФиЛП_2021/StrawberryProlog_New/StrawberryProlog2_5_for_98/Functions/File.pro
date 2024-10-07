% Reads and prints itself.

?-
  F is open("File.pro", "r"),
  do(F),
  close(F).

do(F):-
  S := readln(F), % try with readf
  write(S),
  fail.
do(_).

