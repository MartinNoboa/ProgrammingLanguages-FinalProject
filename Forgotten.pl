/*
 * Programming Languages
 * Final Project
 * @author: Martin Noboa - A01704052
 * @lastEdited: November 15th,2021
 * @editedBy: MN
 */
use_module(library(persistency)).

%%%%% Rules for game control --------------------------------------------
loop:-  
  repeat,
  write('Enter command (end to exit): '),
  read(X),
  write(X), nl,
  X = end.

%%%%% KB and basic rules --------------------------------------------
% Describe locations
location(road).
location(forest).
location('deep forest').
location(cave).
location('deep cave').
location(swamp).
location(stable).
location(castle).
location(staircase).
location(basement).
location('wine cellar').
location('second floor hall').
location(hallway).
location(library).
location('living room').

% Describe connections between locations
connection(road,forest).
connection(forest, 'deep forest').
connection('deep forest',swamp).
connection('deep forest',cave).
connection(cave, 'deep cave').
connection(swamp,stable).
connection('deep forest',castle).
connection(stable,castle).
connection(castle, 'castle hall').
connection('castle hall',staircase).
connection(staircase, basement).
connection(staircase,'second floor hall').
connection('second floor hall', hallway).
connection(basement,'wine cellar').
connection(hallway,library).
connection(hallway,'living room').

% Rules for making connection reciprocate
connect(X,Y):- 
    connection(X,Y).
connect(X,Y):- 
    connection(Y,X).




% Rules to get conections of location
list_connections(Location) :-
	connect(X, Location),
	write(X),
	nl,
    false.
list_connections(_).


% Describe items in each location
% We must declare the predicate as dynamic if the object is "takable"
% deep forest
%:-dynamic item/1.
item(branch,'deep forest').
% stable
item(locker,stable).
item('torch',locker).
% castle
item(lamp, castle).
% deep cave
item(bell,'deep cave').
% castle hall
item('shelve','castle hall').
item('oil lamp','shelve').
% basement
item('key rack',basement).
item(key,'key rack').
% wine cellar
item(storage,'wine cellar').
item(wine,storage).
% library
item(book,library).
% living room
item(table,'living room').
item('old man','living room').
item(recorder,'old man').

% initial state of items
closed('deep cave').
closed(library).
closed(basement).
closed(castle).
unarmed('oil-soaked cloth',branch).
unarmed(branch,'oil-soaked cloth').
off('oil lamp').
% Initial state of item ownership

% initial location
:-dynamic here/1.
here(forest).
:- discontiguous have/2.
:-dynamic haveRecorder/2.
haveRecorder(recorder,false).
:-dynamic haveTorch/3.
haveTorch(torch,false).
:-dynamic haveBell/4.
haveBell(bell,false).
:-dynamic haveKey/5.
haveKey(key,false).
:-dynamic haveWine/6.
haveWine(wine,false).
:-dynamic haveBook/7.
haveBook(book,false).
:-dynamic haveLamp/8.
haveLamp('oil lamp',false).




%% Rules to get items from location

list_items(Location) :-
	item(X, Location),
	write(X),
	nl,
    false.
list_items(_).

% Rule to get all information of current location
info :-
	here(Location),
	write('You are in the '), write(Location),write(.), nl,
	write('The available things are:'), nl,
	list_items(Location),
	write('You can move to:'), nl,
	list_connections(Location).

%%%%% Main rules

% Move from here(_) to new location
go(Location):-  
    puzzle(go(Location)),
	canGo(Location),
	move(Location),
	info.
% Verify there is a connection to new location
canGo(Location):- 
    here(X),
    (
    	connect(X, Location) -> write('You moved from '),
        write(X),
        write('.'),
        nl;
    	write('You can not get there from here.'),
        nl,
        false
    ).
% Retract dynamic predicate and assert it with new value
move(Location):-
    retract(here(_)),
    asserta(here(Location)).

% Take item into invertory
take(X):-  
	canTake(X).
	%takeItem(X).
canTake(Item) :-
  	here(Location),
    (item(Item, Location) ->  
    write('Taken '), 
    write(Item),
  	write(' into inventory.'),nl;
    write('Can not find '), 
    write(Item),
  	write(' in here.'),
  	nl, fail
    ).
%review function
takeItem(X):-  
  	retract(item(X,_)),
    retract(have(X,_)),
  	asserta(have(X,true)).

%%%%% Rules for locked locations
puzzle(_).
% road -> must get the recorder before leaving
puzzle(go(road)):-
    (
    	haveRecorder(recorder,true) ->  
  		!;
    	write('I can not leave, I need the recorder...'),
  		!, fail
    ).
  	
% deep cave -> must get the torch before entering
puzzle(go('deep cave')):-
    (
    	haveTorch(bell,true) ->  
  		!;
    	 write('I can not enter, its too dark...'),
  		!, fail
    ).
% castle hall -> must get the bell before leaving
puzzle(go('castle hall')):-
    (
    	haveBell(bell,true) ->  
  		!;
    	 write('Seems like I need to ring to be let it...'),
  		!, fail
    ).
% basement -> must get the oil lamp before going down

% library -> must get the key to enter
puzzle(go(library)):-
    (
    	haveKey(key,true) ->  
  		!;
    	 write('Its locked, I need to find the key...'),
  		!, fail
    ).
% living room -> must get the recorder before leaving // review funtion
puzzle(go('living room')):-
    (
    	haveWine(wine,true)->
  		!;
    	write('I need the book and the wine...'),
  		!, fail
    ).





%%%%% Rules for list manipulation
% Substitute
substitute(_,_,[],[]).
substitute(Prev, New, [Prev|T], [New|R]):-
    substitute(Prev, New, T,R).
substitute(Prev, New, [H|T],[H|R]):-
    substitute(Prev,New,T,R).











