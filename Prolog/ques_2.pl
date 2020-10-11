bus(123,'Amingaon','Jalukbari',14.5,15,10,10).
bus(756,'Panbazar','Chandmari',16,16.5,7,8).
bus(561,'Jalukbari','Khoka', 16,10.5,3,5).
bus(356,'Khoka','Chandmari', 12,11,9,6).
bus(216,'Khoka','Lokhra', 12,11,9,3).
bus(111,'Amingaon','Khokha',16,16.5,20,8).

optimum_route(StartingPoint, EndPoint) :-
	MinDistance is -1,
	Dist is 0,
	ListOfStops= [],
	MinimumDistListOfStops = [],
	optimum_route_distance(StartingPoint, EndPoint, Dist, MinDistance,StartingPoint, EndPoint, ListOfStops, MinimumDistListOfStops),
	format('MinDistance is ~w', [MinDistance]).

optimum_route_distance(StartingPoint, EndPoint, Z, MinDistance,InitialStartingPoint, InitialEndPoint, ListOfStops, MinimumDistListOfStops) :-
	bus(_, StartingPoint, EndPoint, _, _, Dist, _),
	Total_distance is Z + Dist,
	MinDistance =\= -1,
	append(ListOfStops,[Intermediate] , X ),
	MinDistance is min(Total_distance, MinDistance),
	format('Total distance travelled is ~w', [MinDistance]).
	% optimum_route_distance(StartingPoint, EndPoint,Z,MinDistance, InitialStartingPoint, InitialEndPoint, X, MinimumDistListOfStops).


optimum_route_distance(StartingPoint, EndPoint, Z, MinDistance,InitialStartingPoint, InitialEndPoint, ListOfStops, MinimumDistListOfStops) :-
	bus(_, StartingPoint, EndPoint, _, _, Dist, _),
	Total_distance is Z + Dist,
	MinDistance =:= -1,
	append(ListOfStops,[Intermediate] , X ),
	MinDistance is Total_distance,
	format('Total distance travelled is ~w', [MinDistance]).
	% optimum_route_distance(StartingPoint, EndPoint,Z,MinDistance, InitialStartingPoint, InitialEndPoint, X, MinimumDistListOfStops).

optimum_route_distance(StartingPoint, EndPoint, Z, MinDistance,InitialStartingPoint, InitialEndPoint, ListOfStops, MinimumDistListOfStops) :-
	bus(_, StartingPoint, Intermediate, _, _, Dist, _),
	format('~w', [Intermediate]),
	Intermediate_Distance is Z+ Dist,
	format('~w' ,[len(ListOfStops)]),
	append([Intermediate], ListOfStops,X ),
	optimum_route_distance(Intermediate, EndPoint, Intermediate_Distance, MinDistance,IntialStartingPoint, IntialEndPoint, X, MinimumDistListOfStops).
	