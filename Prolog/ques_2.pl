%
%
%		AUTHOR- MAYANK WADHWNANI (170101038)
%					QUESTION 2
%					
%		Program that contains clauses for finding the opimal paths between two given
%		points to minimize on the distance, cost and time respectively
%		To find the optimal path between say Amingaon and Lokhra, 
%		we run -> route( 'Amingaon' , 'Lokhra').
%
%

% Populating the database with buses
% An entry bus(123,'Amingaon','Jalukbari',14.5,15,10,10).
% means there is a bus going from Amingaon to Jalukbari with bus number 123
% departure time being 14.5 and arrival time 15 
% that will travel a distance of 10 units and will charge a total of 10 ruppees 

bus(123,'Amingaon','Jalukbari',14.5,15,10,10).
bus(561,'Jalukbari','Khoka', 15,23,3,5).
bus(216,'Khoka','Lokhra', 15,11,9,3).
bus(756,'Panbazar','Chandmari',16,16.5,7,8).
bus(356,'Khoka','Chandmari', 12,11,9,6).
bus(111,'Amingaon','Khoka',16,15.5,20,8).

% This clause is the base case for recursion in printing the optimal path,
% Given the only element in the array, we print the required Start and End bus stops
print_optimal_route([Head | [] ]) :-
	bus(Head, Start, End, _, _, _, _),
	format('~w,~w -> ~w ', [Start,Head, End]).

% This clause is the recursive case for recursion in printing the optimal path,
% Given the array, we print the required Start and End bus stops and then call 
% the same function for recursion
print_optimal_route([Head | Tail]) :-
	bus(Head, Start, _, _, _, _, _),
	format('~w,~w -> ', [Start,Head]),
	print_optimal_route(Tail).

% The following clauses will serve as the base case to find the properties 
% for a given path 

% Base Case-1
% If there is only 1 element left in route,
% and the arrival time is greater than the departure time
% which means we will reach the destination on the same day,
% so we simply add ArrivalTime-DeptTime to the total time 
% Distance and Cost is also calculated based on the bus number

find_properties( [BusNumber | []], Distance, Cost, Time, StartTimeOfNextBus) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	ArrivalTime >= DeptTime,
	Distance is BusDistance,
	Time is ArrivalTime - DeptTime,
	Cost is BusCost,
	StartTimeOfNextBus is DeptTime.

% Base Case-2
% If there is only 1 element left in route,
% and the arrival time is less than the departure time
% which means we will reach the destination on the next day,
% so we simply add DeptTime-ArrivalTime to 24 and then add the resulting sum to the total time 
% Distance and Cost is also calculated based on the bus number

find_properties( [BusNumber | []], Distance, Cost, Time, StartTimeOfNextBus) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	ArrivalTime < DeptTime,
	Distance is BusDistance,
	X is DeptTime - ArrivalTime,
	Time is 24 - X,
	Cost is BusCost,
	StartTimeOfNextBus is DeptTime.

% Recursive Case-1
% If there are multiple elements left in route,
% and the arrival time is greater than the departure time
% and the departure time of next bus is greater than the arrival time of our bus
% which means we will reach the destination on the same day,
% and the next bus will also on the very same day,
% so we simply add ArrivalTime-DeptTime and ArrivalTime(of next bus) - DeptTime(of our bus) to the total time 
% Distance and Cost is also calculated based on the bus numberfind_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 

find_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	ArrivalTime >= DeptTime,
	find_properties( Tail, IntermediateDistance, IntermediateCost, IntermediateTime, IntermediateStartTimeOfNextBus),
	IntermediateStartTimeOfNextBus >= ArrivalTime,
	Distance is BusDistance + IntermediateDistance,
	X is ArrivalTime - DeptTime,
	Time_For_This_Trip is X + IntermediateTime,
	Y is  IntermediateStartTimeOfNextBus-ArrivalTime,
	Time is Time_For_This_Trip + Y,
	Cost is BusCost + IntermediateCost,
	StartTimeOfNextBus is DeptTime.

% Recursive Case-2
% If there are multiple elements left in route,
% and the arrival time is greater than the departure time
% but the departure time of next bus is less than the arrival time of our bus
% which means we will reach the destination on the same day,
% but the next bus will start on the next day,
% so we add ArrivalTime-DeptTime and 24 - (DeptTime(of our bus) - ArrivalTime(of next bus) )to the total time 
% Distance and Cost is also calculated based on the bus numberfind_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 

find_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	ArrivalTime >= DeptTime,
	find_properties( Tail, IntermediateDistance, IntermediateCost, IntermediateTime, IntermediateStartTimeOfNextBus),
	IntermediateStartTimeOfNextBus < ArrivalTime,
	Distance is BusDistance + IntermediateDistance,
	X is ArrivalTime - DeptTime,
	Time_For_This_Trip is X + IntermediateTime,
	Temp is ArrivalTime-IntermediateStartTimeOfNextBus,
	Y is 24 - Temp,
	Time is Time_For_This_Trip + Y,
	Cost is BusCost + IntermediateCost,
	StartTimeOfNextBus is DeptTime.

% Recursive Case-3
% If there are multiple elements left in route,
% and the arrival time is less than the departure time
% and the departure time of next bus is greater than the arrival time of our bus
% which means we will reach the destination on the next day,
% and the next bus will also reach on the next day ( the same day as the reaching of this bus),
% so we add 24-(DeptTime-ArrivalTime) and ArrivalTime(of next bus) - DeptTime(of our bus) to the total time 
% Distance and Cost is also calculated based on the bus numberfind_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 

find_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	ArrivalTime < DeptTime,
	find_properties( Tail, IntermediateDistance, IntermediateCost, IntermediateTime, IntermediateStartTimeOfNextBus),
	IntermediateStartTimeOfNextBus >= ArrivalTime,
	Distance is BusDistance + IntermediateDistance,
	Temp is DeptTime - ArrivalTime ,
	X is 24 - Temp,
	Time_For_This_Trip is X + IntermediateTime,
	Temp_2 is IntermediateStartTimeOfNextBus - ArrivalTime,
	Time is Temp_2 + Time_For_This_Trip,
	Cost is BusCost + IntermediateCost,
	StartTimeOfNextBus is DeptTime.

% Recursive Case-4
% If there are multiple elements left in route,
% and the arrival time is less than the departure time
% and the departure time of next bus is less than the arrival time of our bus
% which means we will reach the destination on the next day,
% and the next bus will start on the next to next day from today,
% so we add 24-(DeptTime-ArrivalTime) and 24 - (DeptTime(of our bus) - ArrivalTime(of next bus) )to the total time 
% Distance and Cost is also calculated based on the bus numberfind_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 

find_properties( [BusNumber | Tail], Distance, Cost, Time, StartTimeOfNextBus) :- 
	bus(BusNumber, Start, End, DeptTime, ArrivalTime, BusDistance, BusCost),
	ArrivalTime < DeptTime,
	find_properties( Tail, IntermediateDistance, IntermediateCost, IntermediateTime, IntermediateStartTimeOfNextBus),
	IntermediateStartTimeOfNextBus < ArrivalTime,
	Distance is BusDistance + IntermediateDistance,
	Temp is DeptTime - ArrivalTime ,
	X is 24 - Temp,
	Time_For_This_Trip is X + IntermediateTime,
	Temp_2 is ArrivalTime - IntermediateStartTimeOfNextBus ,
	Temp_3 is 24 - Temp_2,
	Time is Temp_3 +Time_For_This_Trip, 
	Cost is BusCost + IntermediateCost,
	StartTimeOfNextBus is DeptTime.

% The helper function to find and print the properties of a given route
print_properties( OptimalRoute ) :-
	find_properties( OptimalRoute, Distance, Cost, Time, StartTimeOfNextBus),
	format('Distance=~w, Cost=~w, Time=~w ', [Distance, Cost, Time]).

% The helper function to print the route and then the properties of a given route
print_optimal_set_with_properties( OptimalRoute ) :-
	print_optimal_route( OptimalRoute ),nl,
	print_properties( OptimalRoute ).

% The helper function to find the set with the minimal value of some parameter passed with the route
% Works by finding the minimal value in the array 
% and then finding the element with this minimal value
find_minimum_set([[Path,Value] | Tail], OptimalRoute ) :-
	find_minimum_value( [[Path,Value] | Tail],MinValue ),
	find_set_with_minimum( [[Path,Value] | Tail], OptimalRoute, MinValue ).

% The base case to find the minimal value in a set, which sets the value to be current minimal value
% (in simple words, if there is only one element in the set, then the min value will be the value itself)
find_minimum_value( [[Path,Value] | []],MinValue ) :-
	MinValue is Value.

% The recursion case to find the minimum, works by finding the minimum element in the later part of the array
% and then finding the min of the current value and the min of later array
find_minimum_value( [[Path,Value] | Tail],MinValue ) :-
	find_minimum_value( Tail, IntermediateMinValue ),
	MinValue is min(IntermediateMinValue, Value).

% The case where if the value is equal to the min value, we have found our optimal route
% and we return
find_set_with_minimum( [[Path,Value] | Tail],OptimalRoute, MinValue ) :-
	Value == MinValue,
	append(Path, [], OptimalRoute).

% If we have still not found the route min value, we recurse on the remaining elements
find_set_with_minimum( [[Path,Value] | Tail], OptimalRoute, MinValue ) :-
	find_set_with_minimum( Tail, OptimalRoute, MinValue ).

% The helper function to find a route along with the distance travelled in this route
optimal_route_distance(Start, End, RequiredRoute, Distance ):-
	find_route_by_distance(Start, End, RequiredRoute, [Start], Distance ).

% The base case in finding route by distance,
% If we have found a bus from the starting and ending point, 
% we return the distance travelled in this path
find_route_by_distance(Start, End, Route, VisitedBusStops, Distance):-
	bus(BusNumber, Start, End, _, _, Distance, _),
	append([], [BusNumber] ,Route).

% The recursion case in finding route by distance,
% If there is no bus between the start and end point,
% we find some bus from the starting point,
% confirm that it has not yet been visited, 
% add it to the visited nodes
% and compute the route from this Intermediate node,
% and finally we return the distance travelled in this path + later path (from the Intermediate to the End node)
find_route_by_distance(Start, End, Route, VisitedBusStops, Distance):-
	bus(BusNumber, Start, Intermediate, _, _, Dist, _),
	Intermediate\==End,
	\+member(Intermediate,VisitedBusStops),
	find_route_by_distance( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewDistance ),
	Distance is Dist + NewDistance,
	append([BusNumber], IntermediateRoute ,Route).

% The helper function to find a route along with the cost travelled in this route
optimal_route_cost(Start, End, RequiredRoute, Cost ):-
	find_route_by_cost(Start, End, RequiredRoute, [Start], Cost ).

% The base case in finding route by cost,
% If we have found a bus from the starting and ending point, 
% we return the cost we have to pay to take this bus
find_route_by_cost(Start, End, Route, VisitedBusStops, Cost):-
	bus(BusNumber, Start, End, _, _, _, Cost),
	append([], [BusNumber] ,Route).

% The recursion case in finding route by cost,
% If there is no bus between the start and end point,
% we find some bus from the starting point,
% confirm that it has not yet been visited, 
% add it to the visited nodes
% and compute the route from this Intermediate node,
% and finally we return the cost incurred in this path + later path (from the Intermediate to the End node)
find_route_by_cost(Start, End, Route, VisitedBusStops, Cost):-
	bus(BusNumber, Start, Intermediate, _, _, _, BusCost),
	Intermediate\==End,
	\+member(Intermediate,VisitedBusStops),
	find_route_by_cost( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewCost ),
	Cost is BusCost + NewCost,
	append([BusNumber], IntermediateRoute ,Route).

% The helper function to find a route along with the time it takes to travel this path
optimal_route_time(Start, End, RequiredRoute, Time ):-
	find_route_by_time(Start, End, RequiredRoute, [Start], Time, StartTimeOfNextBus ).

% Base case-1 in finding route by time,
% If we have found a bus from the starting and ending point, 
% such that endtime is greater than the start time
% this means that bus will reach on the same day
% we return the time we have to travel on this bus (EndTime - StartTime)
find_route_by_time(Start, End, Route, VisitedBusStops, Time, StartTimeOfNextBus):-
	bus(BusNumber, Start, End, StartTime, EndTime, _, _),
	EndTime >= StartTime,
	Time is EndTime - StartTime,
	append([], [BusNumber] ,Route),
	StartTimeOfNextBus is StartTime.

% Base case-2 in finding route by time,
% If we have found a bus from the starting and ending point, 
% such that endtime is less than the start time
% this means that bus will reach on the next day
% we return the time we have to travel on this bus 24 - ( StartTime - EndTime )
find_route_by_time(Start, End, Route, VisitedBusStops, Time, StartTimeOfNextBus):-
	bus(BusNumber, Start, End, StartTime, EndTime, _, _),
	EndTime < StartTime,
	X is StartTime - EndTime,
	Time is 24 - X,
	append([], [BusNumber] ,Route),
	StartTimeOfNextBus is StartTime.

% Recursive case-1 in finding route by time,
% If we have found a bus from the starting and ending point, 
% such that endtime is greater than the start time,
% and the departure time of next bus is greater than our bus
% this means that bus will reach on the same day and the next bus will also leave on the same day
% we return the time we have to travel on this bus (EndTime-StartTime) + (NextBus departure time - ThisBus arrival time)
find_route_by_time(Start, End, Route, VisitedBusStops, Time, StartTimeOfNextBus):-
	bus(BusNumber, Start, Intermediate, StartTime, EndTime, _, _),
	Intermediate\==End,
	EndTime >= StartTime,
	\+member(Intermediate,VisitedBusStops),
	find_route_by_time( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewTime, IntermediateStartTimeOfNextBus ),
	IntermediateStartTimeOfNextBus >= EndTime,
	X is EndTime - StartTime,
	Time_For_This_Trip is NewTime + X ,
	Y is IntermediateStartTimeOfNextBus - EndTime,
	Time is Time_For_This_Trip + Y,
	append([BusNumber], IntermediateRoute ,Route),
	StartTimeOfNextBus is StartTime.

% Recursive case-2 in finding route by time,
% If we have found a bus from the starting and ending point, 
% such that endtime is greater than the start time,
% but the departure time of next bus is less than our bus
% this means that bus will reach on the same day and the next bus will leave on the next day
% we return the time we have to travel on this bus (EndTime-StartTime) + 24 - (ThisBus arrival time - NextBus departure time )
find_route_by_time(Start, End, Route, VisitedBusStops, Time, StartTimeOfNextBus):-
	bus(BusNumber, Start, Intermediate, StartTime, EndTime, _, _),
	Intermediate\==End,
	EndTime >= StartTime,
	\+member(Intermediate,VisitedBusStops),
	find_route_by_time( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewTime, IntermediateStartTimeOfNextBus ),
	IntermediateStartTimeOfNextBus < EndTime,
	X is EndTime - StartTime,
	Time_For_This_Trip is NewTime + X ,
	Temp is EndTime - IntermediateStartTimeOfNextBus,
	Temp_2 is 24 - Temp,
	Time is Time_For_This_Trip + Temp_2,
	append([BusNumber], IntermediateRoute ,Route),
	StartTimeOfNextBus is StartTime.

% Recursive case-3 in finding route by time,
% If we have found a bus from the starting and ending point, 
% such that endtime is less than the start time,
% but the departure time of next bus is greater than our bus
% this means that bus will reach on the next day and the next bus will leave on the very next day (the same day this bus reaches)
% we return the time we have to travel on this bus 24 - (StartTime-EndTime) + (NextBus departure time - ThisBus arrival time  )
find_route_by_time(Start, End, Route, VisitedBusStops, Time, StartTimeOfNextBus):-
	bus(BusNumber, Start, Intermediate, StartTime, EndTime, _, _),
	Intermediate\==End,
	EndTime < StartTime,
	\+member(Intermediate,VisitedBusStops),
	find_route_by_time( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewTime, IntermediateStartTimeOfNextBus),
	IntermediateStartTimeOfNextBus >= EndTime,
	X is StartTime - EndTime,
	Y is 24 - X,
	Time_For_This_Trip is NewTime + Y,
	Temp is IntermediateStartTimeOfNextBus - EndTime,
	Time is Temp + Time_For_This_Trip,
	append([BusNumber], IntermediateRoute ,Route),
	StartTimeOfNextBus is StartTime.

% Recursive case-4 in finding route by time,
% If we have found a bus from the starting and ending point, 
% such that endtime is less than the start time,
% and the departure time of next bus is less than our bus
% this means that bus will reach on the next day and the next bus will leave on the next to next day (the next day this bus reaches)
% we return the time we have to travel on this bus 24 - (StartTime-EndTime) + 24 - ( ThisBus arrival time  - NextBus departure time)
find_route_by_time(Start, End, Route, VisitedBusStops, Time, StartTimeOfNextBus):-
	bus(BusNumber, Start, Intermediate, StartTime, EndTime, _, _),
	Intermediate\==End,
	EndTime < StartTime,
	\+member(Intermediate,VisitedBusStops),
	find_route_by_time( Intermediate, End, IntermediateRoute, [Intermediate|VisitedBusStops], NewTime, IntermediateStartTimeOfNextBus),
	IntermediateStartTimeOfNextBus < EndTime,
	X is StartTime - EndTime,
	Y is 24 - X,
	Time_For_This_Trip is NewTime + Y,
	Temp is EndTime - IntermediateStartTimeOfNextBus,
	Temp_2 is 24 - Temp,
	Time is Time_For_This_Trip + Temp_2,
	append([BusNumber], IntermediateRoute ,Route),
	StartTimeOfNextBus is StartTime.

% The function which the user will invoke
route( Start, End ):-
	% We first find all the possible paths along with the distance of each path between the start and the end node
	setof([Route,Distance], optimal_route_distance(Start,End, Route,Distance),Set_Distance),

	% We then find the path with the minimal distance in our set and 
	% print it along with the distance, time and cost for this minimal path
	find_minimum_set(Set_Distance, OptimalRoute_Distance ),
	nl,nl,write('Optimum Distance: '),nl,
	print_optimal_set_with_properties(OptimalRoute_Distance),

	% We now find all the possible paths along with the cost of each path between the start and the end node
	setof([Route,Cost], optimal_route_cost(Start,End, Route,Cost),Set_Cost),
	
	% We then find the path with the minimal cost in our set and 
	% print it along with the distance, time and cost for this minimal path
	find_minimum_set(Set_Cost, OptimalRoute_Cost ),
	nl,nl,write('Optimum Cost: '),nl,
	print_optimal_set_with_properties(OptimalRoute_Cost),

	% We now find all the possible paths along with the time of each path between the start and the end node
	setof([Route,Time], optimal_route_time(Start,End, Route,Time),Set_Time),

	% We then find the path with the minimal time in our set and 
	% print it along with the distance, time and cost for this minimal path
	find_minimum_set(Set_Time, OptimalRoute_Time),
	nl,nl,write('Optimum Time: '),nl,
	print_optimal_set_with_properties(OptimalRoute_Time).

% END OF PROGRAM