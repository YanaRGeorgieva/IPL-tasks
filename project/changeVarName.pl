changeNameOfXVariable(Tokens, NewTokens) :-
    write("Enter the of variable name: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NameCode),
    write("Enter a new variable name: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, NewNameCode),
    write("Enter the predicate name where you want to rename the variable: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, PredicateCode),
    (   variable(NewNameCode, _, _),
        changeVariableName(NameCode, NewNameCode, PredicateCode, Tokens, NewTokens)
    ;   \+ variable(NewNameCode, _, _),
        write("Invalid name of variable.\n")
    ).

changeVariableName(_, _, _, [], []) :-
    write("Done rename!\n"), !.

changeVariableName(NameCode, NewNameCode, PredicateCode, [[[Info, PredicateName, Type], Content]|T], [[[Info, PredicateName, Type], NewContent]|Result]) :-
    string_codes(PredicateName, PredicateCode),
    renameVariableInContent(NameCode, NewNameCode, Content, NewContent), !,
    changeVariableName(NameCode, NewNameCode, PredicateCode, T, Result).
changeVariableName(NameCode, NewNameCode, PredicateCode, [[[Info, PredicateName, Type], Content]|T], [[[Info, PredicateName, Type], Content]|Result]) :-
    \+ string_codes(PredicateName, PredicateCode), !,
    changeVariableName(NameCode, NewNameCode, PredicateCode, T, Result).

renameVariableInContent(_, _, [], []) :- !.
renameVariableInContent(NameCode, NewNameCode, [[tvariable, Lexeme]|T], [[tvariable, NewVariableName]|R]) :-
    string_codes(Lexeme, NameCode),
    string_codes(NewVariableName, NewNameCode),
    renameVariableInContent(NameCode, NewNameCode, T, R).
renameVariableInContent(NameCode, NewNameCode, [[tvariable, Lexeme]|T], [[tvariable, Lexeme]|R]) :-
    \+ string_codes(Lexeme, NameCode),
    renameVariableInContent(NameCode, NewNameCode, T, R).
renameVariableInContent(NameCode, NewNameCode, [[Token, Lexeme]|T], [[Token, Lexeme]|R]) :-
    Token\=tvariable,
    renameVariableInContent(NameCode, NewNameCode, T, R).