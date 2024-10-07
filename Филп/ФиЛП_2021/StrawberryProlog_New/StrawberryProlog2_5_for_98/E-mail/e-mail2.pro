/*******************************************************
 This is a variant of e-mail.pro
 where the letters which are generated are not sent
 but are written in Output Window.
********************************************************/

?- send.

send :-
  get_date(Day/Month/This_Year),
  p(Name, Address, Day/Month/Year_of_birth, Gender),
  Str is "Dear " + Name + ",

This morning when I had breakfast with my cat Tom,
It suddenly occurrred to me that you have a birthday and I hurried to send you my birthday greetings.
I wish you to be happy in this year. " + addition(Gender, This_Year-Year_of_birth)
   + "

 Sincerely yours,
 Billy - the politician

 PS Don't forget to vote for me in the next elections.",
  write(Str), nl, nl, fail.
send.

Return is addition(Gender, Age) :-
  Gender=female,
  Return is "I don't know your age but this is not important because flowers have no age. ".
Return is addition(Gender, Age) :-
  Gender=male,
  Return is "I think that " + Age
  + " is the best age a man can have.".

p("Mary", "Mary@dobrev.com", Day/Month/1978, female).
p("Jimmy", "Jimmy@dobrev.com", Day/Month/1971, male).
p("William Shakespeare", "Shakespeare@dobrev.com", Day/Month/1564, male).
p("Dimiter Dobrev", "Dimiter@dobrev.com", 25/4/1966, male).
