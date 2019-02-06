whereIsXUsedPredicate(Tokens) :-
    write("Enter name of predicate: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NameCode),
    findEncounteringsOfPredicate(NameCode, Tokens, 0).

findEncounteringsOfPredicate(_, [], _) :-
    write("Done search!\n"), !.

findEncounteringsOfPredicate(NameCode, [H|T], _) :-
    \+ findEncounterOfPredicate(NameCode,
                                H,
                                _,
                                _,
                                _), !,
    findEncounteringsOfPredicate(NameCode, T, 0).

findEncounteringsOfPredicate(NameCode, [[[_, PredicateName, _], Content]|T], 0) :-
    string_codes(PredicateName, NameCode),
    findEncounterOfPredicate(NameCode,
                             [[_, PredicateName, _], Content],
                             Line,
                             PredicateName,
                             Rest),
    findFirstEncounterOfPredicate(NameCode,
                                  
                                  [ [_, PredicateName, _],
                                    Content
                                  ],
                                  Line,
                                  PredicateName), !,
    findEncounteringsOfPredicate(NameCode, [Rest|T], 1).

findEncounteringsOfPredicate(NameCode, [[[_, PredicateName, _], Content]|T], 0) :-
    \+ string_codes(PredicateName, NameCode),
    findEncounterOfPredicate(NameCode,
                             [[_, PredicateName, _], Content],
                             Line,
                             PredicateName,
                             Rest),
    write("Found at line "),
    write(Line),
    write(" in predicate "),
    write(PredicateName),
    write("."),
    nl, !,
    findEncounteringsOfPredicate(NameCode, [Rest|T], 1).

findEncounteringsOfPredicate(NameCode, [H|T], 1) :-
    findEncounterOfPredicate(NameCode,
                             H,
                             Line,
                             PredicateName,
                             Rest),
    write("Found at line "),
    write(Line),
    write(" in predicate "),
    write(PredicateName),
    write("."),
    nl, !,
    findEncounteringsOfPredicate(NameCode, [Rest|T], 1).

findFirstEncounterOfPredicate(NameCode, [[_, PredicateName, _], Content], Line, PredicateName) :-
    append(A, _, Content),
    countLexeme(A, [tpredicate, NameCode], 1),
    append(_, M, A),
    countToken(M, tlineNumber, 1),
    append(_, [[tlineNumber, Line]|_], M), !.

findEncounterOfPredicate(NameCode, [[Info, PredicateName, Type], Content], Line, PredicateName, [[Info, PredicateName, Type], Rest]) :-
    append(V1, V2, Content),
    append(A2, A, V1),
    countLexeme(A, [tpredicate, NameCode], 1),
    append(M, [[tpredicate, S]|MS], A),
    string_codes(S, NameCode),
    countToken(M, tlineNumber, 1),
    append(_, [[tlineNumber, Line]|_], M),
    append(M, MS, R1),
    append(A2, R1, R2),
    append(R2, V2, Rest), !.