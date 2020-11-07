%
%
%		AUTHOR- MAYANK WADHWNANI (170101038)
%					QUESTION 3
%					
%		Program that contains clauses for finding all paths for the prisoner to escape and to check if a given path is valid
%		To find all the paths that help the prisoner to escape
%		we run -> all_possible_paths().
%		NOTE-> Since the number of paths is too large, we print all of them in a file 'all_paths.txt'
%		
%		To find the optimal route from any start node to escape,
%		we run -> optimal(X).
%
%		To find if a given route is valid,
%		we run -> valid(['G1' , 'G2' , 'G3']). (ie. we give a list as an input )
%
%

% We populate the data with the given facts

% These four will serve as the starting nodes to find all paths
startNode('G1').
startNode('G2').
startNode('G3').
startNode('G4').

% directed_edge(X, Y, len) means that there is a directed edge between X and Y
% with a weight of len (we have taken the weight to be the distance between the two points)
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

% we use this clause to check if an undirected edge exists between 2 points X and Y

% an edge will exist if either there is either a directed edge between X and Y
edge(X, Y, Length) :-
	directed_edge( X, Y, Length).

% or there is a directed edge between Y and X
edge(X, Y, Length) :-
	directed_edge( Y, X, Length).

% The base case to find a path between Start and End,
% if there is edge between Start and End, we simply append end to the end of the list of route
% and also assign Total Length equal to length between Start and End
find_path( Start, End, Route, VisitedNodes, Length ) :-
	edge(Start, End, Length),
	append([], [End] , Route).

% The recursion case to find a path between Start and End,
% if there is no edge between Start and End, 
% then we simply take some node connected to the Start and check if it has not been visited so far
% and then find a path from this Intermediate node to the end node 
% and finally add the Length between Start and Intermediate to the final length
find_path( Start, End, Route, VisitedNodes, Length ) :-
	edge( Start, Intermediate, Weight),
	Intermediate\==End,
	\+ (member(Intermediate, VisitedNodes)),
	find_path( Intermediate, End, IntermediateRoute, [Intermediate|VisitedNodes], TempLength ),
	Length is TempLength + Weight,
	append( [Intermediate], IntermediateRoute, Route ).

% This clause is used to find a path given a start node
find_path_from_start_vertex( Start, End, Route, VisitedNodes, Length ) :-
	find_path( Start, End, RouteWithoutStart, VisitedNodes, Length ),
	append( [Start] , RouteWithoutStart , Route).

% This clause represents the base case to print a given route in the file given the File Stream as input
print_all_routes_in_file([[Head,Length] | []] , Stream) :-
	print_route(Head,Stream), write(Stream,'\n').

% This clause represents the recursion case to print a given route in the file given the File Stream as input
% We first print the given route in the file and then recurse over the remaining routes
print_all_routes_in_file([[Head,Length] | Tail] , Stream) :-
	print_route(Head,Stream), write(Stream,'\n'),
	print_all_routes_in_file( Tail,Stream ).

% The base case to print the route in the file 
% if there is only one element remaining, we print it into the file
print_route([Head | []] , Stream) :-
	write(Stream, Head).

% The recursive case to print the route in the file
% if there is more than 1 elements, we print the current one and recurse
print_route([Head | Tail] , Stream) :-
	% format('~w -> ' , [Head]),
	write(Stream, Head),
	write( Stream, ' -> '),
	print_route(Tail, Stream).

% This base case finds all possible paths from a given starting node to the end node 'G17'
% We finally get a set of paths 
find_possible_paths_from_starting_node([ Start | [] ] , TotalSetOfPaths):-
	setof( [Route, Length], find_path_from_start_vertex( Start, 'G17', Route, [Start], Length ), SetOfPaths),
	append( SetOfPaths,[], TotalSetOfPaths).

% This recursive case finds all possible paths from a given starting node to the end node 'G17'
% We first find all possible paths from the remaining Start nodes and then find paths from the given start node
find_possible_paths_from_starting_node([ Start | Tail] , TotalSetOfPaths):-
	find_possible_paths_from_starting_node( Tail , IntermediateSetOfPaths),
	setof( [Route, Length], find_path_from_start_vertex( Start, 'G17', Route, [Start], Length ), SetOfPaths),
	append( SetOfPaths , IntermediateSetOfPaths , TotalSetOfPaths ).

% This clause is the main clause which is used to find and print all possible paths using which the prisoner can escape
% We first find the set of all starting nodes, 
% then find all possible paths from starting nodes of this list
% we finally print these paths by opening a File Stream 
all_possible_paths:-
	setof(X, startNode(X), SetOfStartingNodes),
	find_possible_paths_from_starting_node(SetOfStartingNodes, TotalSetOfPaths),
	open('all_paths.txt', write, Stream),
	print_all_routes_in_file( TotalSetOfPaths, Stream ),
	close(Stream),
	length( TotalSetOfPaths, X),
	format( '~w' , [X]).

% This clause is used to find the optimal path that can be taken by the prisoner
% We first find all possible paths and find the one with the minimum length
optimal(RequiredRoute) :-
	setof(X, startNode(X), SetOfStartingNodes),
	find_possible_paths_from_starting_node(SetOfStartingNodes, TotalSetOfPaths),
	print_minimum_set(TotalSetOfPaths,RequiredRoute).

% If we have reached the G17 node and there are no more elements to be traversed
% we have successfully escaped the prison
check_valid( ['G17' | [] ], Output) :-
	Output = 'True'.

% For all other cases where there is no more element in the route and the node is not 'G17'
% we have failed to escape the prison
check_valid( [Node1 | [] ], Output) :-
	Output = 'False'.

% If we have reached a node which connects G17 and the next element is G17 and there is no more nodes left other than these two,
% we have successfully escaped the prison
check_valid( [Node1, 'G17' | [] ], Output) :-
	edge(Node1, 'G17' , _ ),
	Output = 'True'.

% For all the other cases,
% we have failed escaped the prison
check_valid( [Node1, Node2 | [] ], Output) :-
	Output ='False'.

% If there are more nodes in the path, we just check that node 1 and node 2 must be connected and recurse
check_valid( [Node1 , Node2 | Tail], Output) :-
	edge(Node1, Node2 , _),
	check_valid( [Node2 | Tail] , Output).

% If node 1 and node 2 does not have an edge between them, this means that we have failed to escape since the given route is not valid
check_valid( [Node1 , Node2 | Tail], Output) :-
	\+edge(Node1, Node2 , _),
	Output = 'False'.	

% The clause which checks if a given path is valid or not
valid(Route) :-
	check_valid(Route, Output), 
	format('~w', [Output]).

% The clause which finds the route with the minimum distance between them
% we first find the minimum value 
% and then find the route with this value
print_minimum_set( SetOfPaths,OptimalRoute ) :-
	find_minimum_value( SetOfPaths,MinValue ),
	find_set_with_minimum( SetOfPaths, OptimalRoute, MinValue ),
	print_set_with_minimum( OptimalRoute ).

% The base case, when there is no more element left,
% we assign the min value to be the value of this path
find_minimum_value( [[Path,Value] | []],MinValue ) :-
	MinValue is Value.

% The recursive case, when there are more elements left,
% we find the minimum of this path length and minimum of paths after this path
find_minimum_value( [[Path,Value] | Tail],MinValue ) :-
	find_minimum_value( Tail, IntermediateMinValue ),
	MinValue is min(IntermediateMinValue, Value).

% Given the minimum value, we find the set with this value
% if the value of this path is equal to min value, we have found the path
find_set_with_minimum( [[Path,Value] | Tail],OptimalRoute, MinValue ) :-
	Value == MinValue,
	append(Path, [], OptimalRoute).

% if we have still not found the path with the min value, we keep looking by recursion
find_set_with_minimum( [[Path,Value] | Tail], OptimalRoute, MinValue ) :-
	find_set_with_minimum( Tail, OptimalRoute, MinValue ).

% Base case to print a path, if there are no more elements left, we print this element and return
print_set_with_minimum( [Head | []] ) :-
	format('~w', [Head]).

% Recursive case to print a path, if there are multiple elements left, we print this element and recurse
print_set_with_minimum( [Head | Tail] ) :-
	format('~w -> ', [Head]),
	print_set_with_minimum( Tail ).

% END OF PROGRAM