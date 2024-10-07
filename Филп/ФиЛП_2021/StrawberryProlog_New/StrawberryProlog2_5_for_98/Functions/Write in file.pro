?- file_list("Filename.txt",p(|X)).


file_list(Filename,Name(|L)):-
  Handle is open(Filename, "a"),
  file_list2(Name(|L), Handle),
  close(Handle).

file_list2(Name(|L), Handle):-
  Name(|L),
  writef(Handle, print(Name(|L))),
  writef(Handle, ". "),
  fail.
file_list2(Name(|L), Handle).

p(a,b).
p(c).
p(c,d).
