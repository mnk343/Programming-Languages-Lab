%
%
%		AUTHOR- MAYANK WADHWNANI (170101038)
%					QUESTION 1 
%					
%		Program that contains clauses for finding halfsister and uncle relationships 
%		in the database as given in question 
%		To find if jatin is the uncle of kattappa or run,
%		we run -> uncle(jatin, kattappa). 
%
%		Similarly to find if avantika is the halfsister of shivkami or not,
%		we run -> halfsister(avantika, shivkami).
%
%

% Listing all the facts as given in the question
% parent(jatin, avantika) means jatin is the parent of avantika
parent(manisha,shivkami). 
parent(bahubali,shivkami). 
parent(jatin,avantika). 
parent(jolly,jatin). 
parent(jolly,katappa). 
parent(manisha,avantika). 

% male(jolly) means that jolly is a male
male(katappa). 
male(jolly). 
male(bahubali).

% female(shivkami) means that shivkami is a female
female(shivkami). 
female(avantika). 

% Implementation of Part 1 (To define uncle clause)
% For X to be the uncle of Y, we must have the following conditions:
% a) X is a male,
% b) Parent of X and Parent of parent of Y must be same, (we assume if one parent is same, then also X qualifies to be the uncle of Y)
uncle(X, Y) :-
	male(X),
	parent(Z, X),
	parent(Z, S),
	parent(S, Y).

% Implementation of Part 2 (To define halfsister clause)
% For X to be the halfsister of Y, we must have the following conditions:
% a) X is a female,
% b) One Parent of X and Parent of Y must be same, 
% c) The other remaining Parent of X and Parent of Y must be different, (if they are same, then X will become the sister of Y)
halfsister(X, Y):-
	female(X),
	%Find common parent
	parent(CommonParent, X),
	parent(UncommonParent_X, X),
	parent(CommonParent, Y),
	parent(UncommonParent_Y, Y),

	% confirm that the UncommonParent_Y is not parent of X and similarly for Y
	\+ (parent(UncommonParent_X, Y)),
	\+ (parent(UncommonParent_Y, X)).

% END OF PROGRAM