whereIsXUsedVariable(Tokens) :-
    write("Enter name of variable: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NameCode),
    findEncounteringsOfVarible(NameCode, Tokens, 0).

findEncounteringsOfVarible(_, [], _) :-
    write("Done search!\n"), !.

findEncounteringsOfVarible(NameCode, [H|T], _) :-
    \+ findEncounterVariable(NameCode,
                             H,
                             _,
                             _,
                             _), !,
    findEncounteringsOfVarible(NameCode, T, 0).

findEncounteringsOfVarible(NameCode, [H|T], 0) :-
    findEncounterVariable(NameCode, H, Line, PredicateName, Rest),
    findFirstEncounterOfVariable(NameCode, H, Line, PredicateName), !,
    findEncounteringsOfVarible(NameCode, [Rest|T], 1).

findEncounteringsOfVarible(NameCode, [H|T], 1) :-
    findEncounterVariable(NameCode, H, Line, PredicateName, Rest),
    write("Found at line "),
    write(Line),
    write(" in predicate "),
    write(PredicateName),
    write("."),
    nl, !,
    findEncounteringsOfVarible(NameCode, [Rest|T], 1).

findEncounterVariable(NameCode, [[Info, PredicateName, Type], Content], Line, PredicateName, [[Info, PredicateName, Type], Rest]) :-
    append(V1, V2, Content),
    append(A2, A, V1),
    countLexeme(A, [tvariable, NameCode], 1),
    append(M, [[tvariable, S]|MS], A),
    string_codes(S, NameCode),
    countToken(M, tlineNumber, 1),
    append(_, [[tlineNumber, Line]|_], M),
    append(M, MS, R1),
    append(A2, R1, R2),
    append(R2, V2, Rest), !.