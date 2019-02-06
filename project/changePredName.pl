changeNameOfXPredicate(Tokens, NewTokens) :-
    write("Enter name of predicate: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NameCode),
    write("Enter name of new predicate name: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NewNameCode),
    (   predicate(NewNameCode, _, _),
        changePredicateName(NameCode, NewNameCode, Tokens, NewTokens)
    ;   \+ predicate(NewNameCode, _, _),
        write("Invalid name of predicate.\n")
    ).

changePredicateName(_, _, [], []) :-
    write("Done rename!\n"), !.
changePredicateName(NameCode, NewNameCode, [[[Info, PredicateName, Type], Content]|T], [[[Info, NewPredicateName, Type], NewContent]|Result]) :-
    string_codes(PredicateName, NameCode),
    string_codes(NewPredicateName, NewNameCode),
    renamePredicateInContent(NameCode, NewNameCode, Content, NewContent), !,
    changePredicateName(NameCode, NewNameCode, T, Result).
changePredicateName(NameCode, NewNameCode, [[[Info, PredicateName, Type], Content]|T], [[[Info, PredicateName, Type], NewContent]|Result]) :-
    \+ string_codes(PredicateName, NameCode),
    renamePredicateInContent(NameCode, NewNameCode, Content, NewContent), !,
    changePredicateName(NameCode, NewNameCode, T, Result).

renamePredicateInContent(_, _, [], []) :- !.
renamePredicateInContent(NameCode, NewNameCode, [[tpredicate, Lexeme]|T], [[tpredicate, NewPredicateName]|R]) :-
    string_codes(Lexeme, NameCode),
    string_codes(NewPredicateName, NewNameCode), !,
    renamePredicateInContent(NameCode, NewNameCode, T, R).
renamePredicateInContent(NameCode, NewNameCode, [[tpredicate, Lexeme]|T], [[tpredicate, Lexeme]|R]) :-
    \+ string_codes(Lexeme, NameCode), !,
    renamePredicateInContent(NameCode, NewNameCode, T, R).
renamePredicateInContent(NameCode, NewNameCode, [[Token, Lexeme]|T], [[Token, Lexeme]|R]) :-
    Token\=tpredicate, !,
    renamePredicateInContent(NameCode, NewNameCode, T, R).