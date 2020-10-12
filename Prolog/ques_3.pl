startNode('G1').
startNode('G2').
startNode('G3').
startNode('G4').

edge('G1', 'G5', 4).
edge('G2', 'G5', 6).
edge('G3', 'G5', 8).
edge('G4', 'G5', 9).
edge('G1', 'G6', 10).
edge('G2', 'G6', 9).
edge('G3', 'G6', 3).
edge('G4', 'G6', 5).
edge('G5', 'G7', 3).
edge('G5', 'G10', 4).
edge('G5', 'G11', 6).
edge('G5', 'G12', 7).
edge('G5', 'G6', 7).
edge('G5', 'G8', 9).
edge('G6', 'G8', 2).
edge('G6', 'G12', 3).
edge('G6', 'G11',  5).
edge('G6', 'G10', 9).
edge('G6', 'G7', 10).
edge('G7', 'G10', 2).
edge('G7', 'G11', 5).
edge('G7', 'G12', 7).
edge('G7', 'G8', 10).
edge('G8', 'G9', 3).
edge('G8', 'G12', 3).
edge('G8', 'G11', 4).
edge('G8', 'G10', 8).
edge('G10', 'G15', 5).
edge('G10', 'G11', 2).
edge('G10', 'G12', 5).
edge('G11', 'G15', 4).
edge('G11', 'G13', 5).
edge('G11', 'G12', 4).
edge('G12', 'G13', 7).
edge('G12', 'G14', 8).
edge('G15', 'G13', 3).
edge('G13', 'G14', 4).
edge('G14', 'G17', 5).
edge('G14', 'G18', 4).
edge('G17', 'G18', 8).

find_path( Start, End, Route, VisitedNodes, Length ) :-
	edge(Start, End, Length),
	append([], [End] , Route).

find_path( Start, End, Route, VisitedNodes, Length ) :-
	edge( Start, Intermediate, Weight),
	\+ (member(Intermediate, VisitedNodes)),
	find_path( Intermediate, End, IntermediateRoute, [Intermediate|VisitedNodes], TempLength ),
	Length is TempLength + Weight,
	append( [Intermediate], IntermediateRoute, Route ).

print_all_routes([[Head,Length] | []]) :-
	print_route(Head), nl.

print_all_routes([[Head,Length] | Tail]) :-
	print_route(Head), nl,
	print_all_routes( Tail ).

print_route([Head | []]) :-
	format('~w ' , [Head]).

print_route([Head | Tail]) :-
	format('~w -> ' , [Head]),
	print_route(Tail).

find_possible_paths_from_starting_node([ Head | [] ] , SetOfPaths):-

find_possible_paths_from_starting_node([ Head | Tail] , SetOfPaths):-

all_possible_paths:-
	setof(X, startNode(X), SetOfStartingNodes),
	find_possible_paths_from_starting_node(SetOfStartingNodes, SetOfPaths),
	print_all_routes( SetOfPaths ).

all_possible_paths :-
	setof( [Route, Length], find_paths_from_starting_node( Start, 'G17', Route, [Start], Length ), SetOfPaths),
	length(SetOfPaths, X),
	format('~w ', [X]),
	print_all_routes( SetOfPaths ).

optimal(Start) :-
	setof( [Route, Length], find_path( Start, 'G17', Route, [Start], Length ), SetOfPaths),
	print_minimum_set(SetOfPaths, Start).

print_minimum_set( SetOfPaths, Start ) :-
	find_minimum_value( SetOfPaths,MinValue ),
	find_set_with_minimum( SetOfPaths, OptimalRoute, MinValue ),
	format('~w -> ' , [Start]),
	print_set_with_minimum( OptimalRoute ).

find_minimum_value( [[Path,Value] | []],MinValue ) :-
	MinValue is Value.

find_minimum_value( [[Path,Value] | Tail],MinValue ) :-
	find_minimum_value( Tail, IntermediateMinValue ),
	MinValue is min(IntermediateMinValue, Value).

find_set_with_minimum( [[Path,Value] | Tail],OptimalRoute, MinValue ) :-
	Value == MinValue,
	append(Path, [], OptimalRoute).

find_set_with_minimum( [[Path,Value] | Tail], OptimalRoute, MinValue ) :-
	find_set_with_minimum( Tail, OptimalRoute, MinValue ).

print_set_with_minimum( [Head | []] ) :-
	format('~w', [Head]).

print_set_with_minimum( [Head | Tail] ) :-
	format('~w -> ', [Head]),
	print_set_with_minimum( Tail ).





