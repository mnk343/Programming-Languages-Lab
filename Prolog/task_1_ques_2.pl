parent(jatin,avantika). 
parent(jolly,jatin). 
parent(jolly,kattappa). 
parent(manisha,avantika). 
parent(manisha,shivkami). 
parent(bahubali,shivkami). 
male(kattappa). 
male(jolly). 
female(shivkami). 
female(avantika). 
male(bahubali).

halfsister(X, Y):-
	female(X),
	parent(CommonParent, X),
	parent(UncommonParent_X, X),
	parent(CommonParent, Y),
	parent(UncommonParent_Y, Y),

	\+ (parent(UncommonParent_X, Y)),
	\+ (parent(UncommonParent_Y, X)).






