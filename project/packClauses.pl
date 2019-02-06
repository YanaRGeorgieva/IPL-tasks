enumerateLines(Count, Source, Res) :-
    range(1, Count, L),
    enumerateLinesH(L, Source, [], Res).

enumerateLinesH(_, [], [], []).
enumerateLinesH([CH|_], [], Buff, [[[CH], Buff]]) :-
    Buff\=[].
enumerateLinesH([CH|CT], [[Token, Com]|T], [], Res) :-
    member(Token, [tcomment1, tcomment2]),
    anyNewLines(Com, N),
    append(M, Numbers, CT),
    length(M, N),
    % write(Numbers),
    append([], [[Token, Com]], NewBuff),
    enumerateLinesH([CH|Numbers], T, NewBuff, Res).
enumerateLinesH([CH|CT], [[Token, Com]|T], Buff, Res) :-
    member(Token, [tcomment1, tcomment2]),
    Buff\=[],
    anyNewLines(Com, N),
    append(M, Numbers, CT),
    length(M, N),
    % write(Numbers),
    append(Buff, [[Token, Com]], NewBuff),
    enumerateLinesH([CH|Numbers], T, NewBuff, Res).
enumerateLinesH([CH|CT], [[execNL, NL]|T], Buff, Result) :-
    append(Buff, [[execNL, NL]], NewBuff),
    append([[tlineNumber, CH]], NewBuff, Buf),
    append(Buf, Res, Result),
    % write([[CH], NewBuff]),nl,
    enumerateLinesH(CT, T, [], Res).
enumerateLinesH([CH|CT], [[Token, Lexeme]|T], Buff, Res) :-
    not(member(Token, [tcomment1, tcomment2, execNL])),
    append(Buff, [[Token, Lexeme]], NewBuff),
    enumerateLinesH([CH|CT], T, NewBuff, Res).

anyNewLines(Com, N) :-
    string_codes(Com, Codes),
    count(Codes, 10, N).

newLinesInComment([], 0).
newLinesInComment([[tcomment1, Com]|T], N) :-
    newLinesInComment(T, M),
    anyNewLines(Com, N1),
    N is M+N1.
newLinesInComment([[tcomment2, Com]|T], N) :-
    newLinesInComment(T, M),
    anyNewLines(Com, N1),
    N is M+N1.
newLinesInComment([[Token, _]|T], N) :-
    not(member(Token, [tcomment1, tcomment2])),
    newLinesInComment(T, N).



removeAllTillPredicateName([[tpredicate, M]|T], [[tpredicate, M]|T]) :- !.
removeAllTillPredicateName([[H, _]|T], R) :-
    \+ member(H, [tpredicate, tdot, tneck, tdcg, tgoal]), !,
    removeAllTillPredicateName(T, R).

parseClauseNameFactRule([H|T], Name, fact) :-
    removeAllTillPredicateName([H|T], L),
    L=[[tpredicate, Name]|R],
    member([tdot, "."], R),
    \+ member([tneck, ":-"], R),
    \+ member([tdcg, "-->"], R), !,
    parseDeclaration(R).
parseClauseNameFactRule([H|T], Name, rule) :-
    removeAllTillPredicateName([H|T], L),
    L=[[tpredicate, Name]|R],
    member([tdot, "."], R),
    (   member([tneck, ":-"], R)
    ;   member([tdcg, "-->"], R)
    ), !,
    parseDeclaration(R).
parseClauseNameFactRule([H|T], directive, rule) :-
    removeAllWhites([H|T], L),
    L=[[tneck, _]|_],
    member([tdot, "."], L), !.

parseDeclaration([[tleftParen, _]|R]) :- !,
    parseTillEndArg(R).
parseDeclaration([[Token, _]|R]) :-
    member(Token, [tlineNumber, execTAB, execSpace, execNL]), !,
    parseTillEndNoArg(R).

parseTillEndArg([[trightParen, _]|R]) :- !,
    parseTillEndNoArg(R).
parseTillEndArg([[Token, _]|R]) :-
    Token\=trightParen,
    parseTillEndArg(R).

parseTillEndNoArg(L) :-
    removeAllWhites(L, P),
    P=[[H, _]|_],
    member(H, [tneck, tdot, tdcg]).

parseClauseNames(Tokens, NamedTokens) :-
    parse(Tokens, NamedTokens).

parse([], []) :- !.
parse([H|T], Result) :-
    H=[Info, Clause],
    \+ parseClauseNameFactRule(Clause, _, _),
    append(Info, [noname, none], NewInfo),
    append([[NewInfo, Clause]], Res, Result), !,
    parse(T, Res).
parse([H|T], Result) :-
    H=[Info, Clause],
    parseClauseNameFactRule(Clause, Name, Type),
    append(Info, [Name, Type], NewInfo),
    append([[NewInfo, Clause]], Res, Result), !,
    parse(T, Res).

packClauses(Count, Source, Res) :-
    range(1, Count, L),
    packClausesHelper(L, Source, [], Res).

packClausesHelper(_, [], [], []).
packClausesHelper([CH|_], [], Buff, [[[CH], Buff]]) :-
    Buff\=[].

packClausesHelper([CH|CT], [[tdot, "."], M|T], Buff, [[[CH], NewBuff]|Res]) :-
    M\=[execNL, "\n"],
    append(Buff, [[tdot, "."]], NewBuff),
    % write([[CH], NewBuff]),nl,
    packClausesHelper(CT, [M|T], [], Res).

packClausesHelper([CH|CT], [[tdot, "."], [execNL, "\n"]|T], Buff, [[[CH], NewBuff]|Res]) :-
    append(Buff, [[tdot, "."], [execNL, "\n"]], NewBuff),
    % write([[CH], NewBuff]),nl,
    packClausesHelper(CT, T, [], Res).

packClausesHelper([CH|CT], [[Token, Lexeme]|T], Buff, Res) :-
    Token\=tdot,
    append(Buff, [[Token, Lexeme]], NewBuff),
    packClausesHelper([CH|CT], T, NewBuff, Res).
