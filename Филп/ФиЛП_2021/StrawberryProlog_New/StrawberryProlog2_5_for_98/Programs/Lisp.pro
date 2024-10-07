% This program is made by Dimiter Gelev

member(Y, [Y | _]).
member(Y, [_ | Z]) :- member(Y, Z).
unary(X) :- member(X,[car,cdr,atom,number,null,neg,com,
		      print,strlen,explode,implode,length]).
binary(X) :- member(X,[cons,eq,equal,rplaca,rplacd,reverse,
		       memdisp,append,assoc,leq,add,sub,mul,
		       div,md,and,or,(xor),concat,substr]).
reserved_word(X) :- member(X,[car,cdr,atom,number,null,neg,com,
			      print,strlen,explode,implode,length,
			      cons,eq,equal,rplaca,rplacd,reverse,
			      memdisp,append,assoc,leq,add,sub,mul,
			      div,md,and,or,(xor),
		     concat,substr,if,list,let,letrec,do,lambda,setq,quote]).
variable(V,[N|_]) :- member(V,N).
variable(V,[_|T]) :- variable(V,T).
id([_|_]) :- !, fail.
id(N) :- const(N).
l_list([],C).
l_list([H|T],C) :- l_expr(H,C), l_list(T,C).
n_list([]).
n_list([N|T]) :- id(N), n_list(T).
ass_list([],_).
ass_list([[N,E]|T],C) :- id(N), l_expr(E,C), ass_list(T,C).
names_of([],[]).
names_of([[N,_]|T],[N|Nt]) :- id(N), names_of(T,Nt).
l_expr([],_).
l_expr(X,C) :- id(X), reserved_word(X), !, fail.
l_expr(X,C) :- id(X), variable(X,C).
l_expr(X,_) :- number(X).
l_expr(quote(X),_).
l_expr(Unary(X),C) :- unary(Unary), !, l_expr(X,C).
l_expr(Binary(X,Y),C) :- binary(Binary), !, l_expr(X,C), l_expr(Y,C).
l_expr(if(X,Y,Z),C) :- !, l_expr(X,C), l_expr(Y,C), l_expr(Z,C).
l_expr(list(|X),C) :- !, l_list(X,C).
l_expr(let(E|A),C) :- !, names_of(A,N), l_expr(E,[N|C]), ass_list(N,C).
l_expr(letrec(E|A),C) :- !, names_of(A,N), l_expr(E,[N|C]), ass_list(A,[N|C]).
l_expr(do(L),C) :- !, l_list(L,C).
l_expr(lambda(N,E),C) :- !, n_list(N), l_expr(E,[N|C]).
l_expr(Func(|Args),C) :- l_expr(Func,C), l_list(Args,C).
l_expr([Func|Args],C) :- l_expr(Func,C), l_list(Args,C).
value(E,[LNumber|_],V,P) :- member([LNumber|L],P),local_value(E,L,V), !.
value(E,[_|T],V,P) :- value(E,T,V,P).
local_value(E,[[E,V]|_],V).
local_value(E,[_|T],V) :- local_value(E,T,V).
apply_bin(eq,V,V,t) :- !.
apply_bin(eq,_,_,[]).
apply_bin(equal,V,V,t) :- !.
apply_bin(leq,V1,V2,t) :- number(V1), number(V2), !, V1 =< V2.
apply_bin(leq,V1,V2,[]) :- number(V1), number(V2), !,  V2 < V1.
apply_bin(add,V1,V2,R) :- number(V1), number(V2), !, R is V1 + V2.
apply_bin(sub,V1,V2,R) :- number(V1), number(V2), !, R is V1 - V2.
apply_bin(mul,V1,V2,R) :- number(V1), number(V2), !, R is V1 * V2.
apply_bin(div,V1,V2,R) :- number(V1), number(V2), !, R is V1 / V2.
apply_bin(md,V1,V2,R) :- number(V1), number(V2), !, R is V1 mod V2.
apply_bin(cons,V1,V2,[V1|V2]).
apply_bin(Bin,V1,V2,[Bin,V1,V2]) :- write(["Error: cannot perform operation ",[Bin,V1,V2]]).
apply_un(car,[V1|V2],V1).
apply_un(cdr,[V1|V2],V2).
apply_un(atom,[_|_],[]) :- !.
apply_un(atom,_,t) :- !.
apply_un(number,N,t) :- number(N), !.
apply_un(number,_,[]).
apply_un(null,[],t) :- ! .
apply_un(null,_,[]).
apply_un(Un,V,[Un,V]) :- write(["Error: cannot perform operation ",[Un,V]]).
compute(E,Env,V,P,P) :- id(E), value(E,Env,V,P).
compute(E,_,E,P,P) :- number(E).
compute([],_,[],P,P).
compute(quote(E),_,E,P,P).
compute(Unary(E),Env,Value,P,Q) :- unary(Unary), compute(E,Env,V,P,R), apply_un(Unary,V,Value,R,Q).
compute(Binary(E1,E2),Env,Value,P,Q) :- binary(Binary), compute(E1,Env,V1,P,R), compute(E2,Env,V2,R,Q),
                                                     apply_bin(Binary,V1,V2,Value).
compute(if(X,Y,Z),Env,Value,P,Q) :- compute(X,Env,Cond,P,R), compute_if(Cond,Env,Y,Z,Value,R,Q).
compute(list(|X),Env,Value,P,Q) :- compute_list(X,Env,Value,P,Q).
compute(let(E|A),Env,Value,P,Q) :- compute_ass_list(A,Env,Ass,P,[N|R]),
				    N1 is N + 1, 
				    compute(E,[N|Env],Value,[N1,[N|Ass]|R],Q).
compute(letrec(E|A),Env,Value,[N|T],Q) :- 
	N1 is N + 1,
	compute_ass_list(A,[N|Env],Ass,[N1|T],[N2|R]), compute(E,[N|Env],Value,[N2,[N|Ass]|R],Q).
compute(do(E,E1|T),Env,Value,P,Q) :- compute(E,Env,_,P,R), compute(do(E1|T),Env,Value,R,Q).
compute(do(E),Env,Value,P,Q) :- compute(E,Env,Value,P,Q).
compute(lambda(N,E),Env,[N,E,Env],P,P).
compute([Func|Args],Env,Value,P,Q) :- compute(Func,Env,[N,E,Env_of_f],P,R), 
				  compute_arg_list(Args,N,Env,Arg_list,R,[Num|S]),
				  Num1 is Num + 1,
				  compute(E,[Num|Env_of_f],Value,[Num1,[Num|Arg_list]|S],Q).
compute(Func(Args),Env,Value,P,Q) :- compute(Func,Env,[N,E,Env_of_f],P,R), 
				  compute_arg_list([Args],N,Env,Arg_list,R,[Num|S]),
				  Num1 is Num + 1,
				  compute(E,[Num|Env_of_f],Value,[Num1,[Num|Arg_list]|S],Q).
compute_if([],Env,_,Z,Value,P,Q) :- !, compute(Z,Env,Value,P,Q).
compute_if(_,Env,Y,_,Value,P,Q) :- compute(Y,Env,Value,P,Q).
compute_list([],_,[],P,P).
compute_list([Car|Cdr],Env,[Car_value|Cdr_Value],P,Q) :- compute(Car,Env,Car_value,P,R), 
                                                compute_list(Cdr,Env,Cdr_value,R,Q).
compute_ass_list([],_,[],P,P).
compute_ass_list([[V,E]|T],Env,[[V,Value]|Tv],P,Q) :- compute(E,Env,Value,P,R), compute_ass_list(T,Env,Tv,R,Q).
compute_arg_list([],[],_,[],P,P).
compute_arg_list([A|Ta],[N|Tn],Env,[[N,V]|Tb],P,Q) :- compute(A,Env,V,P,R), compute_arg_list(Ta,Tn,Env,Tb,R,Q).
eval(Expr,Value) :- l_expr(Expr,[]), compute(Expr,[],Value,[0],_).
?- 	eval(letrec(c(7),
		     [c,lambda([x],
				if(eq(x,0),
				   1,
				   mul(x,c(sub(x,1)))
				  )
			      )]),
		Value), write(Value), nl.
