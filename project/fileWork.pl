saveToFile(TokenStream) :-
    write("Please enter the name of the file: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, FilenameCode),
    string_codes(Filename, FilenameCode),
    open(Filename, write, Stream),
    toPrologFile(Stream, TokenStream),
    close(Stream).

toPrologFile(_, []) :- !.
toPrologFile(Stream, [[_, Content]|T]) :-
    % write(Content), nl,
    writeFile(Stream, Content),
    toPrologFile(Stream, T).

writeFile(_, []) :- !.
writeFile(Stream, [[tlineNumber, _]|T]) :-
    % write([tlineNumber, Lexeme]),
 !,
    writeFile(Stream, T).
writeFile(Stream, [[Token, Lexeme]|T]) :-
    Token\=tlineNumber, %write(Lexeme), nl,
    write(Stream, Lexeme), !,
    writeFile(Stream, T).


writeToConsole([]) :- !.
writeToConsole([[_, Content]|T]) :-
    writeLines(Content),
    writeToConsole(T).

writeLines([]) :- !.
writeLines([[tlineNumber, Line]|T]) :-
    write(Line),
    write(". "), !,
    writeLines(T).
writeLines([[Token, Lexeme]|T]) :-
    % write([Token, Lexeme]),
    Token\=tlineNumber,
    write(Lexeme), !,
    writeLines(T).

% readProgram(Stream, []):- at_end_of_stream(Stream).
% readProgram(Stream, [TokenLine|RestOfLines]):- \+ at_end_of_stream(Stream),
%     read_line_to_codes(Stream, Line),
%     append(Line, [10], Liney),
%     phrase(tokens(TokenLin), Liney),
%     flattenMine(TokenLin, TokenLine),
%     readProgram(Stream, RestOfLines).
