:- dynamic dirty/1.
:- dynamic location/1.

room(a).
room(b).
room(c).

adjacent(a, b).
adjacent(b, a).
adjacent(b, c).
adjacent(c, b).

dirty(a).
dirty(c).

location(a).

action(clean) :-
    location(Room),
    dirty(Room).

action(move(ToRoom)) :-
    location(CurrentRoom),
    adjacent(CurrentRoom, ToRoom),
    (
        dirty(ToRoom)
    ;
        adjacent(ToRoom, DirtyRoom),
        dirty(DirtyRoom)
    ).

action(stop) :-
    \+ dirty(_).

perform(clean) :-
    location(Room),
    retract(dirty(Room)),
    format("Vacuum cleaned room ~w.~n", [Room]).

perform(move(ToRoom)) :-
    retract(location(_)),
    assert(location(ToRoom)),
    format("Vacuum moved to room ~w.~n", [ToRoom]).

perform(stop) :-
    format("All rooms are clean. Stopping...~n", []).

start :-
    \+ dirty(_),
    perform(stop).

start :-
    action(Action),
    Action \= stop,
    perform(Action),
    start.
