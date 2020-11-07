startNode('G1').
startNode('G2').
startNode('G3').
startNode('G4').

directed_edge('G1', 'G5', 4).
directed_edge('G2', 'G5', 6).
directed_edge('G3', 'G5', 8).
directed_edge('G4', 'G5', 9).
directed_edge('G1', 'G6', 10).
directed_edge('G2', 'G6', 9).
directed_edge('G3', 'G6', 3).
directed_edge('G4', 'G6', 5).
directed_edge('G5', 'G7', 3).
directed_edge('G5', 'G10', 4).
directed_edge('G5', 'G11', 6).
directed_edge('G5', 'G12', 7).
directed_edge('G5', 'G6', 7).
directed_edge('G5', 'G8', 9).
directed_edge('G6', 'G8', 2).
directed_edge('G6', 'G12', 3).
directed_edge('G6', 'G11',  5).
directed_edge('G6', 'G10', 9).
directed_edge('G6', 'G7', 10).
directed_edge('G7', 'G10', 2).
directed_edge('G7', 'G11', 5).
directed_edge('G7', 'G12', 7).
directed_edge('G7', 'G8', 10).
directed_edge('G8', 'G9', 3).
directed_edge('G8', 'G12', 3).
directed_edge('G8', 'G11', 4).
directed_edge('G8', 'G10', 8).
directed_edge('G10', 'G15', 5).
directed_edge('G10', 'G11', 2).
directed_edge('G10', 'G12', 5).
directed_edge('G11', 'G15', 4).
directed_edge('G11', 'G13', 5).
directed_edge('G11', 'G12', 4).
directed_edge('G12', 'G13', 7).
directed_edge('G12', 'G14', 8).
directed_edge('G15', 'G13', 3).
directed_edge('G13', 'G14', 4).
directed_edge('G14', 'G17', 5).
directed_edge('G14', 'G18', 4).
directed_edge('G17', 'G18', 8).

edge(X, Y, Length) :-
	directed_edge( X, Y, Length).

edge(X, Y, Length) :-
	directed_edge( Y, X, Length).

find_path( Start, End, Route, VisitedNodes, Length ) :-
	edge(Start, End, Length),
	append([], [End] , Route).

find_path( Start, End, Route, VisitedNodes, Length ) :-
	edge( Start, Intermediate, Weight),
	Intermediate\==End,
	\+ (member(Intermediate, VisitedNodes)),
	find_path( Intermediate, End, IntermediateRoute, [Intermediate|VisitedNodes], TempLength ),
	Length is TempLength + Weight,
	append( [Intermediate], IntermediateRoute, Route ).

find_path_from_start_vertex( Start, End, Route, VisitedNodes, Length ) :-
	find_path( Start, End, RouteWithoutStart, VisitedNodes, Length ),
	append( [Start] , RouteWithoutStart , Route).

print_all_routes_in_file([[Head,Length] | []] , Stream) :-
	print_route(Head,Stream), write(Stream,'\n').

print_all_routes_in_file([[Head,Length] | Tail] , Stream) :-
	print_route(Head,Stream), write(Stream,'\n'),
	print_all_routes_in_file( Tail,Stream ).

print_route([Head | []] , Stream) :-
%	format('~w ' , [Head]).
	write(Stream, Head),
	write(Stream, '\n').


print_route([Head | Tail] , Stream) :-
	% format('~w -> ' , [Head]),
	write(Stream, Head),
	write( Stream, ' -> '),
	print_route(Tail, Stream).

find_possible_paths_from_starting_node([ Start | [] ] , TotalSetOfPaths):-
	setof( [Route, Length], find_path_from_start_vertex( Start, 'G17', Route, [Start], Length ), SetOfPaths),
	append( SetOfPaths,[], TotalSetOfPaths).

find_possible_paths_from_starting_node([ Start | Tail] , TotalSetOfPaths):-
	find_possible_paths_from_starting_node( Tail , IntermediateSetOfPaths),
	setof( [Route, Length], find_path_from_start_vertex( Start, 'G17', Route, [Start], Length ), SetOfPaths),
	append( SetOfPaths , IntermediateSetOfPaths , TotalSetOfPaths ).

all_possible_paths:-
	setof(X, startNode(X), SetOfStartingNodes),
	find_possible_paths_from_starting_node(SetOfStartingNodes, TotalSetOfPaths),
	open('file.txt', write, Stream),
	print_all_routes_in_file( TotalSetOfPaths, Stream ),
	close(Stream),
	length( TotalSetOfPaths, X),
	format( '~w' , [X]).

optimal(RequiredRoute) :-
	setof(X, startNode(X), SetOfStartingNodes),
	find_possible_paths_from_starting_node(SetOfStartingNodes, TotalSetOfPaths),
	print_minimum_set(TotalSetOfPaths,RequiredRoute).

check_valid( ['G17' | [] ], Output) :-
	Output = 'True'.
	
check_valid( [Node1 | [] ], Output) :-
	Output = 'False'.

check_valid( [Node1, 'G17' | [] ], Output) :-
	edge(Node1, 'G17' , _ ),
	Output = 'True'.

check_valid( [Node1, Node2 | [] ], Output) :-
	Output ='False'.

check_valid( [Node1 , Node2 | Tail], Output) :-
	edge(Node1, Node2 , _),
	check_valid( [Node2 | Tail] , Output).

check_valid( [Node1 , Node2 | Tail], Output) :-
	\+edge(Node1, Node2 , _),
	Output = 'False'.	

valid(Route) :-
	check_valid(Route, Output), 
	format('~w', [Output]).

print_minimum_set( SetOfPaths,OptimalRoute ) :-
	find_minimum_value( SetOfPaths,MinValue ),
	find_set_with_minimum( SetOfPaths, OptimalRoute, MinValue ),
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
