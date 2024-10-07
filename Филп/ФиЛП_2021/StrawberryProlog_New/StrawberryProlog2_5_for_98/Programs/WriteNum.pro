%%% by Kaloyan Chapkanov from Sofia University %%%
%%% kalata@debian.fmi.uni-sofia.bg %%%

% It works for numbers from 0 to 9999

?- read(N, "Give me a number which to write: "),go( N ).

getnum( 0, zero ).
getnum( 1, one ).
getnum( 2, two ).
getnum( 3, three ).
getnum( 4, four ).
getnum( 5, five ).
getnum( 6, six ).
getnum( 7, seven ).
getnum( 8, eight ).
getnum( 9, nine ).

trans( zero, [ ten ] ).
trans( one, [ eleven ] ).
trans( two, [ twelve ] ).
trans( three, [ thirteen ] ).
trans( four, [ fourteen ] ).
trans( five, [ fifteen ] ).
trans( six, [ sixteen ] ).
trans( seven, [ seventeen ] ).
trans( eight, [ eighteen ] ).
trans( nine, [ nineteen ] ).

convert( [], [] ).
convert( [ X | L ], [ Y | L1 ] ):- getnum( X, Y ), convert( L, L1 ).

translate( [ zero, zero, zero, zero ], [ zero ] ):- !.
translate( [ zero, B, C, D ], L ):- !, translate( [ B, C, D ], L ).
translate( [ A, B, C, D ], [ A, thousand | L ] ):- translate( [ B, C, D ], L ).
translate( [ zero, C, D ], L ):- !, translate( [ C, D ], L ).
translate( [ B, C, D ], [ B, hundred | L ] ):- translate( [ C, D ], L ).
translate( [ zero, zero ], [] ):- !.
translate( [ zero, D ], [ D ] ).
translate( [ one, D ], L ):- !, trans( D, L ).
translate( [ two, zero ], [ twenty ] ):- !.
translate( [ two, D ], [ twenty, D ] ).
translate( [ three, zero ], [ thirty ] ):- !.
translate( [ three, D ], [ thirty, D ] ).
translate( [ four, zero ], [ fourty ] ):- !.
translate( [ four, D ], [ fourty, D ] ).
translate( [ five, zero ], [ fifty ] ):- !.
translate( [ five, D ], [ fifty, D ] ).
translate( [ six, zero ], [ sixty ] ):- !.
translate( [ six, D ], [ sixty, D ] ).
translate( [ seven, zero ], [ seventy ] ):- !.
translate( [ seven, D ], [ seventy, D ] ).
translate( [ eight, zero ], [ eighty ] ):- !.
translate( [ eight, D ], [ eighty, D ] ).
translate( [ nine, zero ], [ ninety ] ):- !.
translate( [ nine, D ], [ ninety, D ] ).

prn( [] ):- nl.
prn( [ X | L ] ):- write( X ), write( " " ), prn( L ).

go( X ):- D:= X mod 10, C:= ( X // 10 ) mod 10, B:= ( X // 100 ) mod 10, A:= ( X // 1000 ),
		convert( [ A, B, C, D ], L1 ), translate( L1, L ), prn( L ).
