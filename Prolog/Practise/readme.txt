*****
[db].
halt.

-> [db]. or consult('db.pl').
-> listing.
-> write('hello world'), nl.

Syntax:
loves(romeo, juliet). (loves->predecate and romeo->atom and whole thing is called a clause or a fact or a rule)
loves(romeo, juliet) :- loves(juliet, romeo).

atoms start with lowercase
variable uppercase

loves(romeo , X)
terminal tells X= juliet

male(a).
male(b).
male(c).
male(d).
male(e).

female(f).
female(g).
female(h).
female(i).

male(X), female(Y) -> this works like join (cartesian product)

format('~w ~s grandparent of x', [X , "is the"]).

grand_parents(X, Y) :-
	parent(Z, Y), 
	parent(X, Z).
call this by -> grand_parents(carl , A) (since A uppercase, variable...returns grandchilder of carl)

hello(Other) :-
	Mello is Other - 5, 
	format('~w',[Mello]).

not is same as:-
	\+ (alice = albert)

trace.
used for debugging
notrace.
to shut it off

RECURSION:-

related(X, Y):-
	parent(X, Y)

related(X, Y):-
	parent(X, Z),
	related(Z, Y)

== in C++ is =:= in prolog
!= in C++ is =\= in prolog


read(X) -> read one line
get(X) -> read one character
put(X) -> output single character 

between(low, high)
kind of like a for loop will traverse and take each value from low upto high

LOOPING AND FILE HANDLING-> REFER SCREENSHOTS

assert used to add clauses
retract used to delete clauses
retractall also


retractall( likes(_, dancing))

LISTS->
	write ( [ jello | [alice ,bob ]  )

name used to convert a string to a list

nth0 is used to get an index value in the list
nth0( 0, List, FChar).









