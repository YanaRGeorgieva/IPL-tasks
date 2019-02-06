%% Writing to html file the stream of tokens
tohtmlfile(_, []) :- !.

tohtmlfile(Stream, [H|T]) :-
    is_identifier(H),
    H=[_, Lexeme],
    write(Stream, '<span class="identifier">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_string(H),
    H=[_, Lexeme],
    write(Stream, '<span class="string">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_function(H),
    H=[_, Lexeme],
    write(Stream, '<span class="function">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_header(H),
    H=[_, Lexeme],
    write(Stream, '<span class="string">&lt;'),
    write(Stream, Lexeme),
    write(Stream, '&gt;</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_keyWord(H),
    H=[_, Lexeme],
    write(Stream, '<span class="keyword">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_number(H),
    H=[_, Lexeme],
    write(Stream, '<span class="number">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_operator(H),
    H=[_, Lexeme],
    write(Stream, '<span class="operator">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_parenth(H),
    H=[_, Lexeme],
    write(Stream, '<span class="parenthese">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_quotation(H),
    H=[_, Lexeme],
    write(Stream, '<span class="quotation">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_unknown(H),
    H=[_, Lexeme],
    write(Stream, '<span class="unknown">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_comment(H),
    H=[_, Lexeme],
    write(Stream, '<span class="comment">'),
    write(Stream, Lexeme),
    write(Stream, '</span>'), !,
    tohtmlfile(Stream, T).

tohtmlfile(Stream, [H|T]) :-
    is_controlStructureBody(H),
    write(Stream, '<button class="collapsible">'),
    H=[H1|T1],
    tohtmlfile(Stream, H1),
    write(Stream, '</span></button>'),
    nl(Stream),
    write(Stream, '<div class="content">'),
    helper(Stream, T1),
    write(Stream, '</div>'), !,
    tohtmlfile(Stream, T).


tohtmlfile(Stream, [H|T]) :-
    is_blank(H),
    H=[_, Lexeme],
    write(Stream, Lexeme), !,
    tohtmlfile(Stream, T).



helper(_, []).
helper(Stream, L) :-
    append(A, [H|B], L),
    is_controlStructureBody(H),
    helper(Stream, A),
    tohtmlfile(Stream, [H]),
    helper(Stream, B).
helper(Stream, [H|T]) :-
    tohtmlfile(Stream, H),
    helper(Stream, T).
