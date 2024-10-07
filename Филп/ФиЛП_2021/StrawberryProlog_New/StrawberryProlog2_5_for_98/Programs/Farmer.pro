% This program is created by Cvetanka Bojidarova
% from University of Sofia

% Here is decided the famous problem of the farmer who have to cross a river with a boat.
% The farmer carry with him a wolf, a goal and a cabbage.
% The problem is that he can take in the boat only one thing with himself
% and it is a bad idea to leave alone the goal and the wolf or the goal and the cabbage.

?- depth_first_search(AnsPath), nl, write(AnsPath),fail.

depth_first_search(AnsPath) :- 
			initial_state(Init),
			depth_first(Init, AnsPath, []).
depth_first(S, [S], _) :- final_state(S).
depth_first(S, [S|AnsPath], Path) :-
			next_state(S, S1),
			nonmem(S1, [S|Path]),
			depth_first(S1, AnsPath, [S|Path]).
nonmem(_, []).
nonmem(X, [Y|L]) :- X \= Y, nonmem(X, L).

initial_state([n, n, n, n]).

final_state([s, s, s, s]).

next_state(S, S1) :- move(S, S1), safe(S1).

move([F, W, G, C], [F1, W, G, C])  :- cross(F, F1).
move([F, F, G, C], [F1, F1, G, C]) :- cross(F, F1).
move([F, W, F, C], [F1, W, F1, C]) :- cross(F, F1).
move([F, W, G, F], [F1, W, G, F1]) :- cross(F, F1).

safe([F, W, G, C]) :- F = G, !; F = W, F = C.

cross(n, s).
cross(s, n).

member(X, [X|_]).
member(X, [_|L]) :- member(X, L).

reverse([], []).
reverse([X|L], M) :- reverse(L, P), append(P, [X], M).

append([], L, L).
append([X|Y], L, [X|M]) :- append(Y, L, M).

