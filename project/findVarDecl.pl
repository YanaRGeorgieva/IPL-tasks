whereIsXDefinedVariable(Tokens) :-
    write("Enter name of variable: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NameCode),
    findDefinitionVariable(NameCode, Tokens).

findDefinitionVariable(_, []) :-
    write("Done search!\n"), !.

findDefinitionVariable(NameCode, [H|T]) :-
    \+ findFirstEncounterOfVariable(NameCode,
                                    H,
                                    _,
                                    _), !,
    findDefinitionVariable(NameCode, T).

findDefinitionVariable(NameCode, [H|T]) :-
    findFirstEncounterOfVariable(NameCode, H, Line, PredicateName),
    write("Found at line "),
    write(Line),
    write(" in predicate "),
    write(PredicateName),
    write("."),
    nl, !,
    findDefinitionVariable(NameCode, T).

findFirstEncounterOfVariable(NameCode, [[_, PredicateName, _], Content], Line, PredicateName) :-
    append(A, _, Content),
    countLexeme(A, [tvariable, NameCode], 1),
    append(_, M, A),
    countToken(M, tlineNumber, 1),
    append(_, [[tlineNumber, Line]|_], M), !.