%%% by Kaloyan Chapkanov from Sofia University %%%
%%% kalata@debian.fmi.uni-sofia.bg %%%

% It works for numbers from 0 to 9999
% don't put "s" on "thousand" and "hundred"
% don't use "and"

?- 
  read(Num, "Give me a number which to read: ", s),
  makeList(Num, L, 0),
  go( L ).

makeList(Num, [H|T], Pos):-
  H is scan(split(Num, " ", Pos)), !,
  Pos2 is Pos + 1,
  makeList(Num, T, Pos2).
makeList(Num, [], Pos).

cifra( zero ):- write( 0 ).
cifra( one ):- write( 1 ).
cifra( two ):- write( 2 ).
cifra( three ):- write( 3 ).
cifra( four ):- write( 4 ).
cifra( five ):- write( 5 ).
cifra( six ):- write( 6 ).
cifra( seven ):- write( 7 ).
cifra( eight ):- write( 8 ).
cifra( nine ):- write( 9 ).

chislo( one ).
chislo( two ).
chislo( three ).
chislo( four ).
chislo( five ).
chislo( six ).
chislo( seven ).
chislo( eight ).
chislo( nine ).

chislos( ten, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
					  add( Stack2, zero, 4, Stack1 ).
chislos( eleven, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						add( Stack2, one, 4, Stack1 ).
chislos( twelve, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						add( Stack2, two, 4, Stack1 ).
chislos( thirteen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						 add( Stack2, three, 4, Stack1 ).
chislos( fourteen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						 add( Stack2, four, 4, Stack1 ).
chislos( fifteen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						add( Stack2, five, 4, Stack1 ).
chislos( sixteen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						add( Stack2, six, 4, Stack1 ).
chislos( seventeen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						  add( Stack2, seven, 4, Stack1 ).
chislos( eighteen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						 add( Stack2, eight, 4, Stack1 ).
chislos( nineteen, Stack, Stack1 ):- add( Stack, one, 3, Stack2 ),
						 add( Stack2, nine, 4, Stack1 ).

chislosp( twenty, Stack, Stack1 ):- add( Stack, two, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( thirty, Stack, Stack1 ):- add( Stack, three, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( fourty, Stack, Stack1 ):- add( Stack, four, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( fifty, Stack, Stack1 ):- add( Stack, five, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( sixty, Stack, Stack1 ):- add( Stack, six, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( seventy, Stack, Stack1 ):- add( Stack, seven, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( eighty, Stack, Stack1 ):- add( Stack, eight, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).
chislosp( ninety, Stack, Stack1 ):- add( Stack, nine, 3, Stack2 ),
						add( Stack2, zero, 4, Stack1 ).


add( [ X | L ], Y, 1, [ Y | L ] ).
add( [ X | L ], Y, 2, [ X | K ] ):- add( L, Y, 1, K ).
add( [ X | L ], Y, 3, [ X | K ] ):- add( L, Y, 2, K ).
add( [ X | L ], Y, 4, [ X | K ] ):- add( L, Y, 3, K ).

isnumb( [], X, X ).
isnumb( [ zero ], _, _ ):- !.
isnumb( [ X, Y | L ], Stack, Stack1 ):- chislo( X ), Y = thousand,
				 add( Stack, X, 1, Stack2 ),
                         isnumb( L, Stack2, Stack1 ).
isnumb( [ X, Y | L ], Stack, Stack1 ):- chislo( X ), Y = hundred,
                         add( Stack, X, 2, Stack2 ),
				 isnumb( L, Stack2, Stack1 ).
isnumb( [ X, Y ], Stack, Stack1 ):- chislosp( X, Stack, Stack2 ),
						chislo( Y ),
						add( Stack2, Y, 4, Stack1 ).
isnumb( [ X ], Stack, Stack1 ):- chislosp( X, Stack, Stack1 ).
isnumb( [ X ], Stack, Stack1 ):- chislos( X, Stack, Stack1 ).
isnumb( [ X ], Stack, Stack1 ):- chislo( X ), add( Stack, X, 4, Stack1 ).

pri( [] ):- nl.
pri( [ X | L ] ):- cifra( X ), pri( L ).
prn( [ zero, zero, zero, zero ] ):- !, write( 0 ), nl.
prn( [ X | L ] ):- X = zero, prn( L ).
prn( [ X | L ] ):- X \= zero, cifra( X ), pri( L ).

go( L ):- Stack = [ zero, zero, zero, zero ], isnumb( L, Stack, Stack1 ),
		prn( Stack1 ).


