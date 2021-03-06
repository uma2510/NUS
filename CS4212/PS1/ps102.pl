% Benjamin Tan Wei Hao
% U077129N

/*
	Problem 2 [1 mark]
	
	Write a Prolog program that counts the number of assignment statements of a program written 
	in the toy language defined in Lecture 2.
*/

:- op(1099,yf,;).
:- op(960,fx,while).
:- op(959,xfx,do).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(961,xfx,else).
:- op(960,fx,for).
:- op(960,fx,switch).
:- op(959,xfx,of).
:- op(959,xfx,::).
:- op(959,xfx,=).

% A program is made up of more than one statements. The number of assignment statements is the
% sum of assignment statements gathered from the first statement, and the rest of the statements.
count_assign(S;Ss, N) :- count_assign(S, N1), count_assign(Ss, N2), N is N1+N2.

% The test for assignment statements. If the statement is indeed an assignment statement, increment
% N by 1.
count_assign(X=E;Ss, N) :- !, count_assign(Ss, N1), (isAssign(X=E) -> N is N1+1 ; N is N1).

% Base case.
count_assign(X=E;, N) :- !, (isAssign(X=E) -> N is 1 ; N is 0).

% Handle statements with curly braces.
count_assign({S}, N) :- count_assign(S, N).

% while statements.
count_assign(while _X do Y;, N) :- count_assign(Y, N), !.
count_assign(while _X do Y, N) :- count_assign(Y, N), !.
	
% if statements	
count_assign(if _X then Y;, N) :- count_assign(Y, N), !.
count_assign(if _X then Y, N) :- count_assign(Y, N), !.

count_assign(if _X then Y else Z;, N) :- count_assign(Y, N1), count_assign(Z, N2), N is N1+N2, !.
count_assign(if _X then Y else Z, N) :- count_assign(Y, N1), count_assign(Z, N2), N is N1+N2, !.

% switch statements
count_assign(switch _X of Y;, N) :- count_assign(Y, N).
count_assign(switch _X of Y, N) :- count_assign(Y, N).

% cas statements
count_assign(_X :: Y;, N) :- count_assign(Y, N), !.
count_assign(_X :: Y, N) :- count_assign(Y, N), !.

% base case. 
count_assign(_;,0) :- !.

% helper prediates
isAssign(X=E) :- identifier(X), isExpr(E), !.

isExpr(X) :- 
	X =.. [F,A,B], 
	member(F, [+,-,*,/, >, <, >=, =<, mod, and, or, /\, \/, <<, >>, xor]), !, 
	isExpr(A), isExpr(B).
	
isExpr(X) :- identifier(X), ! ; value(X).

identifier(X) :- atom(X),!.
value(X) :- number(X),!.

/*

Example invocation:

Code = (
	while (x>0) do {
  		switch (y+z) of {
			0 :: { if (x<10) then { a = 1 ; } else { a = 2; }; }; 1 ::{ if (y\=1) then {a=2; b=3;};}; default :: { a = 0 ; } ;
		};
		a=a+1; 
	};),

count_assign( Code, N), 
writeln('====================================='),
write('The total number of assignments is '),
writeln(N),
writeln('=====================================').
.

*/
