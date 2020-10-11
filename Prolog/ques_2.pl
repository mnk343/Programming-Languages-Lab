bus(123,'Amingaon','Jalukbari',14.5,15,10,10).
bus(756,'Panbazar','Chandmari',16,16.5,7,8).
bus(561,'Jalukbari','Khoka', 16,10.5,3,5).
bus(356,'Khoka','Chandmari', 12,11,9,6).
bus(216,'Khoka','Lokhra', 12,11,9,3).
bus(111,'Amingaon','Khoka',16,16.5,20,8).

print_optimal_route([Head | [] ]) :-
	bus(Head, Start, End, _, _, _, _),
	format('~w,~w -> ~w ', [Start,Head, End]).

print_optimal_route([Head | Tail]) :-
	bus(Head, Start, _, _, _, _, _),
	format('~w,~w -> ', [Start,Head]),
	print_optimal_route(Tail).

find_properties( [BusNumber | []], Distance, Cost, Time) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	Distance is BusDistance,
	Time is ArrivalTime - DeptTime,
	Cost is BusCost.

find_properties( [BusNumber | Tail], Distance, Cost, Time) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	find_properties( Tail, IntermediateDistance, IntermediateCost, IntermediateTime),
	Distance is BusDistance + IntermediateDistance,
	X is ArrivalTime - DeptTime,
	Time is X + IntermediateTime,
	Cost is BusCost + IntermediateCost.

print_properties( OptimalRoute ) :-
	find_properties( OptimalRoute, Distance, Cost, Time),
	format('Distance=~w, Cost=~w, Time=~w ', [Distance, Cost, Time]).

print_optimal_set_with_properties( OptimalRoute ) :-
	print_optimal_route( OptimalRoute ),
	print_properties( OptimalRoute ).

find_minimum_set([[Path,Value] | Tail], OptimalRoute ) :-
	find_minimum_value( [[Path,Value] | Tail],MinValue ),
	find_set_with_minimum( [[Path,Value] | Tail], OptimalRoute, MinValue ).

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

optimal_route_distance(Start, End, RequiredRoute, Distance ):-
	find_route_by_distance(Start, End, RequiredRoute, [Start], Distance ).

find_route_by_distance(Start, End, Route, VisitedBusStops, Distance):-
	bus(BusNumber, Start, End, _, _, Distance, _),
	append([], [BusNumber] ,Route).

find_route_by_distance(Start, End, Route, VisitedBusStops, Distance):-
	bus(BusNumber, Start, Intermediate, _, _, Dist, _),
	\+member(Intermediate,VisitedBusStops),
	find_route_by_distance( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewDistance ),
	Distance is Dist + NewDistance,
	append([BusNumber], IntermediateRoute ,Route).

optimal_route_cost(Start, End, RequiredRoute, Cost ):-
	find_route_by_cost(Start, End, RequiredRoute, [Start], Cost ).

find_route_by_cost(Start, End, Route, VisitedBusStops, Cost):-
	bus(BusNumber, Start, End, _, _, _, Cost),
	append([], [BusNumber] ,Route).

find_route_by_cost(Start, End, Route, VisitedBusStops, Cost):-
	bus(BusNumber, Start, Intermediate, _, _, _, BusCost),
	\+member(Intermediate,VisitedBusStops),
	find_route_by_cost( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewCost ),
	Cost is BusCost + NewCost,
	append([BusNumber], IntermediateRoute ,Route).

optimal_route( Start, End ):-
	setof([Route,Distance], optimal_route_distance(Start,End, Route,Distance),Set_Distance),
	find_minimum_set(Set_Distance, OptimalRoute_Distance ),
	
	write('Optimum Distance: '),nl,
	print_optimal_set_with_properties(OptimalRoute_Distance),

	setof([Route,Cost], optimal_route_cost(Start,End, Route,Cost),Set_Cost),
	find_minimum_set(Set_Cost, OptimalRoute_Cost ),
	
	write('Optimum Cost: '),nl,
	print_optimal_set_with_properties(OptimalRoute_Cost).






% shortest_distance('Amingaon', 'Lokhra', X, Y).
