:- [tokens, essentials].

calculateCyclomaticComplexityOfFunctionsMain(Input, Output) :- !,
    calculateCyclomaticComplexityOfFunctionsMain(Input, [], Output).

calculateCyclomaticComplexityOfFunctionsMain([], Buff, Buff) :- !.
calculateCyclomaticComplexityOfFunctionsMain([H|T], Buff, Res) :-
    is_packedFunction(H),
    calculateCC(H, ResH),
    append(Buff, [ResH], NewBuff), !,
    calculateCyclomaticComplexityOfFunctionsMain(T,
                                                 NewBuff,
                                                 Res).
calculateCyclomaticComplexityOfFunctionsMain([H|T], Buff, Res) :-
    is_packedStructure(H), !,
    calculateCyclomaticComplexityOfFunctionsMain(H, [], ResH),
    Res\=[],
    append(Buff, [ResH], NewBuff), !,
    calculateCyclomaticComplexityOfFunctionsMain(T,
                                                 NewBuff,
                                                 Res).
calculateCyclomaticComplexityOfFunctionsMain([H|T], Buff, Res) :-
    append(Buff, [H], NewBuff),
    calculateCyclomaticComplexityOfFunctionsMain(T,
                                                 NewBuff,
                                                 Res).

calculateCC(Input, Result) :-
    calculateCCHelper(Input, N, _, _),
    getColorButton(N, ColorButton),
    getColorBackground(N, ColorBackground),
    append([[tCC, ColorButton, ColorBackground]], Input, Result).

getColorButton(N, "LightGreen") :-
    N>0,
    N=<10.
getColorButton(N, "LawnGreen") :-
    N>10,
    N=<20.
getColorButton(N, "LightCoral") :-
    N>20,
    N=<40.
getColorButton(N, "OrangeRed") :-
    N>40.

getColorBackground(N, "PaleGreen ") :-
    N>0,
    N=<10.
getColorBackground(N, "MediumSeaGreen ") :-
    N>10,
    N=<20.
getColorBackground(N, "LightPink ") :-
    N>20,
    N=<40.
getColorBackground(N, "Tomato ") :-
    N>40.


calculateCCHelper([H], 1, 0, LPT) :- !,
    getPrefixTabsLength(H, LP),
    LPT is LP+1.

calculateCCHelper([H|T], N, Consecutive, HLPT) :- !,
    calculateCCHelper(T, M, Consecutive, HLPT),
    append(_, [[tquestion, _]|Rest], H),
    write(H),
    write(M),
    append(_, [[ttwodots, _]|_], Rest),
    getPrefixTabsLength(H, HLPT),
    N is M+1.

calculateCCHelper([H|T], N, Consecutive, HLPT) :- !,
    calculateCCHelper(T, M, Consecutive, HLPT),
    append(_, [[tquestion, _]|Rest], H),
    write(H),
    write(M),
    append(_, [[ttwodots, _]|_], Rest),
    getPrefixTabsLength(H, HLPT),
    N is M+1.
