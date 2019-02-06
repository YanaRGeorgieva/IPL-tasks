countClauses(Tokens, NewTokens) :-
    length(Tokens, N),
    range(1, N, R),
    countClauses(R, Tokens, NewTokens).


countClauses(_, [], [], _) :- !.

countClauses([Num|RestNum], [[ListOfInfo, TokenLine]|T], [[NewL, TokenLine]|R], P) :-
    (   TokenLine=[[tcomment1, _], [execNL, "\n"]]
    ;   TokenLine=[[tcomment2, _], [execNL, "\n"]]
    ),
    append(ListOfInfo, [comment], NewL), !,
    % write([ListOfInfo, TokenLine]),nl,
    countClauses([Num|RestNum], T, R, P).

countClauses([Num|RestNum], [[ListOfInfo, TokenLine]|T], [[NewL, TokenLine]|R], P) :-
    allWhiteSpaces(TokenLine),
    append(ListOfInfo, [blank], NewL), !,
    % write([ListOfInfo, TokenLine]),nl,
    countClauses([Num|RestNum], T, R, P).

countClauses([Num|RestNum], [[ListOfInfo, TokenLine]|T], [[NewL, TokenLine]|R]) :-
    not(member([tdot, "."], TokenLine)),
    append(ListOfInfo, [Num], NewL), !,
    % write([ListOfInfo, TokenLine]),nl,
    countClauses([Num|RestNum], T, R).

countClauses([Num|RestNum], [[ListOfInfo, TokenLine]|T], [[NewL, TokenLine]|R]) :-
    not(member([tdot, "."], TokenLine)),
    append(ListOfInfo, [Num], NewL), !,
    % write([ListOfInfo, TokenLine]),nl,
    countClauses([Num|RestNum], T, R).

countClauses([Num|RestNum], [[ListOfInfo, TokenLine]|T], [[NewL, TokenLine]|R]) :-
    member([tdot, "."], TokenLine),
    append(ListOfInfo, [Num], NewL), !,
    % write([ListOfInfo, TokenLine]),nl,
    countClauses(RestNum, T, R).
