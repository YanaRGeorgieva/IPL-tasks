% Helpers
allEqual(L) :-
    not(( member(X, L),
          member(Y, L),
          X\=Y
        )).

max2(A, B, A) :-
    A>=B.
max2(A, B, B) :-
    A<B.

max(M, [M]).
max(M, [H|T]) :-
    max(N, T),
    max2(H, N, M),
    max(9, 0).

% Main problem
d(V, X) :-
    d1(V, V, X)
%mauuu
. /*mauu
*/
d1(_, A, A).
d1(V, A, X) :-
    not(allEqual(A)),
    move(V, A, B),
    d1(V, B, X).
?-d(1, 1).
move([V1, V2, V3, V4], [Y1, Y2, Y3, Y4], [X1, X2, X3, X4]) :-
    max(M, [Y1, Y2, Y3, Y4])
    ,incrementIfNotFirst(V1, M, Y1, X1),incrementIfNotFirst(V2, M, Y2, X2)  
    ,
    incrementIfNotFirst(V3, M, Y3, X3),
    incrementIfNotFirst(V4, M, Y4, X4).

incrementIfNotFirst(_, M, M, M).
incrementIfNotFirst(VI, M, YI, XI) :-
    YI<M,
    XI is VI+YI.

setNewState1(0, Max, _, Max, 1).
setNewState1(0, _, Min, Min, 0).
setNewState1(0, Max, Min, X, 0) :-
    Max=\=X,
    Min=\=X.
setNewState1(1, Max, Min, X, 1) :-
    Max=\=X
    ,
    Min=\=X.
setNewState1(1, _, Min, Min, 0).
setNewState1(1, Max, _, Max, alIIIce).
$d(mauu).

:- use_module(library(dcg/basics)).
:- use_module(library(readutil)).
:- use_module(library(quintus)).
:- [lexer, utils].

:- set_prolog_flag(verbose, silent).
:- initialization(main, main).
/*mama




*/
parseClauseNameFactRule([H|T], Name, rule) :-
    removeAllTillPredicateName([H|T], L),
    L=[[tpredicate, Name]|R],
    member([tdot, "."], R)
    ,
    (   member([tneck, ":-"], R)
    ;   member([tdcg, "-->"], R)
    ), !,
    parseDeclaration(R).
