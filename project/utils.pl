flattenMine([], []):- !.
flattenMine([H|T], R):- flattenElem(H, RH), flattenMine(T, RT), append(RH, RT, R), !.

flattenElem([H|T], [[H|T]]):- \+ is_list(H), !.
flattenElem([H|T], [H|T]):- is_list(H), H = [H1|_], \+ is_list(H1), !.
flattenElem([H|T], [[H|T]]):- is_list(H), H = [H1|_], is_list(H1), !.

count([], _, 0).
count([H|T], H, N):- count(T, H, M), N is M + 1.
count([H|T], Y, N):- H \= Y, count(T, Y, N).

range(B, B, [B]).
range(A, B, [A|R]):- A < B, A1 is A + 1, range(A1, B, R).

intersection([], _, []).
intersection([H|T], B, [H|R]):- member(H, B), intersection(T, B, R).
intersection([H|T], B, R):- \+ member(H, B), intersection(T, B, R).

megaConcat([], []).
megaConcat([H|T], R):- megaConcat(T, Q), append(H, Q, R).

prettyWriteList([]).
prettyWriteList([H|T]):- write(H), nl, nl, prettyWriteList(T).

removeAllWhites([], []).
removeAllWhites([[H,M]|T], [[H,M]|T]):- \+ member(H, [tlineNumber, execTAB, execSpace, execNL, tunknown, tcomment1, tcomment2]), !.
removeAllWhites([[H,_]|T], R):- member(H, [tlineNumber, execTAB, execSpace, execNL, tunknown, tcomment1, tcomment2]), !,
    removeAllWhites(T, R).

countLexeme([], _, 0).
countLexeme([[Token, Lexeme1]|T], [Token, Lexeme2], N):-
    string_codes(Lexeme1, Lexeme2),
    countLexeme(T, [Token, Lexeme2], M), 
    N is M + 1.
countLexeme([[Token, Lexeme1]|T], [Token, Lexeme2], N):-
    \+ string_codes(Lexeme1, Lexeme2),
    countLexeme(T, [Token, Lexeme2], N).
countLexeme([[Token1, _]|T], [Token2, Lexeme], N):-
    Token1 \= Token2,
    countLexeme(T, [Token2, Lexeme], N).

countToken([], _, 0).
countToken([[H, _]|T], H, N):- countToken(T, H, M), N is M + 1.
countToken([[H, _]|T], Y, N):- H \= Y, countToken(T, Y, N).

removeDuplicates([], []).
removeDuplicates([H|T], [H|R]):- removeDuplicates(T, R), \+ member(H, R).
removeDuplicates([H|T], R):- removeDuplicates(T, R), member(H, R).


filterOnlyVariables([], []).
filterOnlyVariables([[tvariable, Name]|T], [[tvariable, Name]|R]):-
    filterOnlyVariables(T, R).
filterOnlyVariables([[Token, _]|T], R):-
    Token \= tvariable,
    filterOnlyVariables(T, R).

variableNameListsToCodes([], []).
variableNameListsToCodes([[Token, Var]|T], [[Token, VarCode]|R]):-
    string_codes(Var, VarCode),
    variableNameListsToCodes(T, R).

variableCodesListsToNames([], []).
variableCodesListsToNames([[Token, VarCode]|T], [[Token, Var]|R]):-
    string_codes(Var, VarCode),
    variableCodesListsToNames(T, R).

balansedParenthese([], 0, 0, 0):- !.
balansedParenthese([[Token, _]|T], N, M, Q):-
    Token == tleftParen,
    N1 is N + 1, !,
    balansedParenthese(T, N1, M, Q).
balansedParenthese([[Token, _]|T], N, M, Q):-
    Token == trightParen,
    N1 is N - 1, !,
    balansedParenthese(T, N1, M, Q).
balansedParenthese([[Token, _]|T], N, M, Q):-
    Token == tleftBrace,
    M1 is M + 1, !,
    balansedParenthese(T, N, M1, Q).
balansedParenthese([[Token, _]|T], N, M, Q):-
    Token == trightBrace,
    M1 is M - 1, !,
    balansedParenthese(T, N, M1, Q).
balansedParenthese([[Token, _]|T], N, M, Q):-
    Token == tleftSqParen,
    Q1 is Q + 1, !,
    balansedParenthese(T, N, M, Q1).
balansedParenthese([[Token, _]|T], N, M, Q):-
    Token == trightSqParen,
    Q1 is Q - 1, !,
    balansedParenthese(T, N, M, Q1).
balansedParenthese([[Token, _]|T], N, M, Q):-
    not(member(Token, [tleftParen, trightParen, tleftBrace, trightBrace, tleftSqParen,trightSqParen])),
    balansedParenthese(T, N, M, Q).


removeInfoPart([], []).
removeInfoPart([[_, Content]|T], Res):-
    removeInfoPart(T, R),
    append(Content, R, Res).

removeLineNumber([], []).
removeLineNumber([[tlineNumber, _]|T], R):-
    removeLineNumber(T, R).
removeLineNumber([[Token, Lexeme]|T], [[Token, Lexeme]|R]):-
    Token \= tlineNumber,
    removeLineNumber(T, R).


addAnds([H], [H]).
addAnds([H|T], [H, [tconjuction, ","]|R]):- addAnds(T, R).

removeFirstConj(Tokens, NewTokens):-
    append(A, B, Tokens),
    removeAllWhites(A, []),
    B = [[tconjuction, ","]|C],
    append(A, C, NewTokens), !.
removeFirstConj(Tokens, Tokens):-
    append(A, B, Tokens),
    removeAllWhites(A, []),
    B \= [[tconjuction, ","]|_], !.
removeFirstConj(Tokens, Tokens):-
    append(A, _, Tokens),
    \+ removeAllWhites(A, []), !.

anyFirstConj(Tokens):-
    append(A, B, Tokens),
    removeAllWhites(A, []),
    B = [[tconjuction, ","]|_], !.


removeNL([], []).
removeNL([H|T], [H|R]):- H \= [execNL, "\n"], removeNL(T, R).
removeNL([H|T], R):- H == [execNL, "\n"], removeNL(T, R).

removeLastConjDot(Tokens, B, A):-
    append(B, [[tconjuction, ","]|A], Tokens),
    removeAllWhites(A, []), !.
removeLastConjDot(Tokens, B, C):-
    append(B, [[tdot, "."]|A], Tokens),
    removeNL(A, C), !.
removeLastConjDot(Tokens, Tokens, []):-
    append(_, [[tconjuction, ","]|A], Tokens),
    \+ removeAllWhites(A, []), !.
removeLastConjDot(Tokens, Tokens, []):-
    \+ append(_, [[tconjuction, ","]|_], Tokens), !.
removeLastConjDot(Tokens, Tokens, []):-
    \+ append(_, [[tdot, "."]|_], Tokens), !.
