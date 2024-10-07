% demonstrates the message box predicates

?- 
   ask.

ask :-
   yes_no( "That is the question",
     "To be or not to be.", ?),
   !,
   message("Yes", "OK why not!", !).

ask :-
   message("No", "Wrong, try again.", s),
   ask.
