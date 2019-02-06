whereIsXDefinedPredicate(Tokens) :-
    write("Enter name of predicate: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NameCode),
    findDefinitionPredicate(NameCode, Tokens).

findDefinitionPredicate(_, []) :-
    write("Done search!\n"), !.
findDefinitionPredicate(NameCode, [[[_, PredicateName, _], Content]|T]) :-
    string_codes(PredicateName, NameCode),
    append(A, _, Content),
    countLexeme(A, [tpredicate, NameCode], 1),
    append(_, M, A),
    countToken(M, tlineNumber, 1),
    append(_, [[tlineNumber, Line]|_], M),
    write("Found at line "),
    write(Line),
    write("."),
    nl, !,
    findDefinitionPredicate(NameCode, T).
findDefinitionPredicate(NameCode, [[[_, PredicateName, _], _]|T]) :-
    \+ string_codes(PredicateName, NameCode), !,
    findDefinitionPredicate(NameCode, T).