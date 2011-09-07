/* Benjamin Tan U077129N */

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


statement(S;Ss) :- statement(S), rest_statements(Ss),!.

% remove redundant braces.
statement({S;}) :- nl, statement(S;), !.


statement({S;Ss}) :- writeln(' {' ), statement(S;Ss), writeln('}' ).

statement(while X do Y;) :- 
	write('while '), isExpr(X), statement(Y), !.

statement(while X do Y) :- 
	write('while '), isExpr(X), statement(Y), !.
	
statement(if X then Y;) :- 
	write('if '), isExpr(X), statement(Y), !.	

statement(if X then Y) :- 
	write('if '), isExpr(X), statement(Y), !.

statement(if X then Y else Z;) :- 
	write('if '), isExpr(X), statement(Y), write('else '), statement(Z), !.

statement(if X then Y else Z) :- 
	write('if '), isExpr(X), statement(Y), write('else '), statement(Z), !.

statement(switch X of Y;) :- write('switch '), isExpr(X),  statement(Y).
statement(switch X of Y) :- write('switch '), isExpr(X),  statement(Y).


statement(X :: {Y};) :-
	write('case '), write(X), writeln(' :' ), statement(Y), writeln('break ;'), !.

statement(X :: {Y}) :-
	write('case '), write(X), write(' : ' ), statement(Y), writeln('break ;'), !.


statement(S;) :- writeln(S;).
statement(S)  :- writeln(S;). 

% helper predicates
isExpr(X) :- 
	X =.. [F,A,B], 
	member(F, [+,-,*,/, >, <, >=, \=, =<, mod, and, or, /\, \/, <<, >>, xor]), !, isExpr(A), isExpr(B), 
	write('('), write(A), 
	write(F), 
	write(B), write(')').
	
isExpr(X) :- identifier(X), ! ; value(X).

identifier(X) :- atom(X),!.
value(X) :- number(X),!.


rest_statements(S;Ss) :- statement(S;), rest_statements(Ss).
rest_statements(S;) :- statement(S;).

rest_statements(S)    :- statement(S).
rest_statements       :- true.


/*

Cast Statement:

statement( 0 :: { b=a; }; 1 :: { b=c; }; ).


while (x>0) do {
  switch (y+z) of {
0 :: { if (x<10) then { a = 1 ; } else { a = 2; }; }; 1 ::{if(y\=1)then{a=2; b=3;};}; default :: { a = 0 ; } ;
};
a=a+1; };


while (x>0) {
   switch (y+z) {
   case 0 : { if (x<0) { a = 1 ; } else { a = 2 ; } }
            break ;
   case 1 : { if (y!=1) { a = 2 ; b = 3 ; } }
            break ;
   default: { a = 0 ; }
			break ; 
   }
   a = a+1 ; }

Test Cases for overall:

Code = (
	while (x<1) do { y=2; };
	while (x>0) do {
	  switch (y+z) of {
		0 :: { if (x<10) then { a = 1 ; if (y\=1) then {a=2; b=3; if (y\=1) then {a=2; b=3;};}; if (y\=1) then {a=2; b=3;}; } else { if (y\=1) then {a=2; b=3;}; a = 2; }; }; 
		1 :: { if (y\=1) then {a=2; b=3;}; while (x>1) do {yah=2;};}; 
		default :: { a = 0 ; } ;
	};
	a=a+1; };
),
statement( Code ).

Code = (
	if (x<10) then { a = 1 ; if (x<10) then { a = 1 ; } else { a = 2; };} else { a = 2; };
),
statement( Code ).


Test Cases for case:

statement( 0 :: { if (x<10) then { a = 1 ; } else { a = 2; }; }; ).
statement( 0 :: { b=a; }; 1 :: { b=c; }; 2:: { z=b; }; ).
statement( default :: { if (x<10) then { a = 1 ; } else { a = 2; }; }; ).
statement( 0 :: { a=b; }; 1 ::{ b=3; }; 2 :: { a=0; }; ).



Test Cases for if:

statement( if (z\=0) then { x=a; while (a\=0) do { b=a; if (z\=0) then { x=a; } else { b\=a; };}; }; ).


Test Cases for while:

statement( while (a\=0) do { b=a; }; ).
statement( while (a<0) do { b=a; a=c; b=d; }; ).
statement( while (a<0) do { while (a<0) do { b=a; }; a=c; b=d; }; ).
statement( while (a<0) do { while (a<0) do { while (a<0) do { b=a; }; }; while (a<0) do { b=a; }; while (a<0) do { b=a; }; }; ).
statement( a=b; while (a<0) do { while (a<0) do { while (a<0) do { b=a; }; }; while (a<0) do { b=a; }; while (a<0) do { b=a; }; }; ).
statement( a=b; while (a<0) do { while (a<0) do { b=a; }; a=c; b=d; }; a=b; b=c; while (a<0) do { b=a; }; b=c;).


*/