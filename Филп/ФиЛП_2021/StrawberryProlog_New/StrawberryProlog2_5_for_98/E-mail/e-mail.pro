/******************************************************************************
 If you want to be a politician then you need only of two things:
 1. This program.
 2. List of the citizens with their dates of birth and e-mail addresses.

 What do you have to do?
 It is very simple. First write the list in format:
 p("name", "e-mail", Day/Month/Year, Gender) and
 add it to this program. Second, execute it once a day.

 If you want to try this program you can write your e-mail address everywhere.
 In this way you will receive all letters which will be generated.
 The day and month of the first three persons are free,
 this means that their birthday is every day.
********************************************************************************/

?-   
  logon("Your Profile","Your Password"),
  send,
  logoff.

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
  send_mail(Address, "Happy birthday to you!", Str),
  fail.
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
