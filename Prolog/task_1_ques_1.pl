parent(jatin,avantika). 
parent(jolly,jatin). 
parent(jolly,kattappa). 
parent(manisha,avantika). 
parent(manisha,shivkami). 
parent(bahubali,shivkami). 

male(kattappa). 
male(jolly). 
male(bahubali).

female(shivkami). 
female(avantika). 

uncle(X, Y) :-
	male(X),
	parent(Z, X),
	parent(Z, S),
	parent(S, Y).

