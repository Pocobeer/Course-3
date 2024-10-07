?-
  logon("Your Profile","Your Password"),
  read_all,
  logoff.

read_all :-
  repeat,
  read_new_mail(From, Subject, Mail),
  write("From: "), write(From), nl,
  write("Subject: "), write(Subject), nl,
  write(Mail), nl, nl,
  fail.
