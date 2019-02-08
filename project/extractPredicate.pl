extractPredicate(TokenStream, NewTokenStream) :-
    write("Enter start line: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, StartLineCode),
    write("Enter end line: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, EndLineCode),
    string_chars(StringStartLine, StartLineCode),
    term_string(TSL, StringStartLine),
    string_chars(StringEndLine, EndLineCode),
    term_string(TEL, StringEndLine),
    (   number(TSL),
        number_codes(StartLine, StartLineCode),
        number(TEL),
        number_codes(EndLine, EndLineCode),
        extract(StartLine, EndLine, TokenStream, NewTokenStream)
    ;   write("Bad number.\n")
    ).
    % write([StartLine, EndLine]),
getLineStartAndEnd(StartLine, StartLine, Tokens, [Info, Content], A, B) :-
    append(A, [[Info, Content]|B], Tokens),
    append(_, [[tlineNumber, StartLine]|_], Content),
    not(member(none, Info)),
    not(member(fact, Info)), !.
getLineStartAndEnd(StartLine, EndLine, Tokens, [Info, Content], A, B) :-
    StartLine=\=EndLine,
    append(A, [[Info, Content]|B], Tokens),
    append(_, [[tlineNumber, StartLine]|TT], Content),
    append(_, [[tlineNumber, EndLine]|_], TT),
    not(member(none, Info)),
    not(member(fact, Info)), !.
getLineStartAndEnd(StartLine, StartLine, Tokens, [], _, _) :-
    append(_, [[Info, Content]|_], Tokens),
    append(_, [[tlineNumber, StartLine]|_], Content),
    (   member(none, Info)
    ;   member(fact, Info)
    ),
    write("Not valid lines.\n"), !.
getLineStartAndEnd(StartLine, EndLine, Tokens, [], _, _) :-
    StartLine=\=EndLine,
    append(_, [[Info, Content]|_], Tokens),
    append(_, [[tlineNumber, StartLine]|TT], Content),
    append(_, [[tlineNumber, EndLine]|_], TT),
    (   member(none, Info)
    ;   member(fact, Info)
    ),
    write("Not valid lines.\n"), !.
getLineStartAndEnd(StartLine, EndLine, Tokens, [], _, _) :-
    StartLine=\=EndLine,
    not(( append(_, [[_, Content]|_], Tokens),
          append(_, [[tlineNumber, StartLine]|TT], Content),
          append(_, [[tlineNumber, EndLine]|_], TT)
        )),
    write("Not valid lines.\n"), !.

extract(StartLine, EndLine, Tokens, Tokens) :-
    getLineStartAndEnd(StartLine,
                       EndLine,
                       Tokens,
                       [],
                       _,
                       _), !.

extract(StartLine, EndLine, Tokens, Tokens) :-
    getLineStartAndEnd(StartLine,
                       EndLine,
                       Tokens,
                       Clause,
                       _,
                       _),
    Clause=[_, Content],
    EndLiney is EndLine+1,
    \+ extractLines(StartLine,
                    EndLiney,
                    Content,
                    _,
                    _,
                    _,
                    _),
    write("Error extracting lines!\n"), !.

extract(StartLine, EndLine, Tokens, Tokens) :-
    getLineStartAndEnd(StartLine,
                       EndLine,
                       Tokens,
                       Clause,
                       _,
                       _),
    Clause=[_, Content],
    EndLiney is EndLine+1,
    extractLines(StartLine,
                 EndLiney,
                 Content,
                 _,
                 MiddlePart,
                 _,
                 _),
    \+ balansedParenthese(MiddlePart, 0, 0, 0),
    write("No balanced parenthese!\n"), !.

extract(StartLine, EndLine, Tokens, NewTokens) :-
    getLineStartAndEnd(StartLine,
                       EndLine,
                       Tokens,
                       Clause,
                       FirstTokS,
                       LastTokS),
    Clause=[Info, Content],
    EndLiney is EndLine+1,
    extractLines(StartLine,
                 EndLiney,
                 Content,
                 FirstPart,
                 MiddlePart,
                 EndPart,
                 Tok),
    balansedParenthese(MiddlePart, 0, 0, 0),
    write("\nEnter new predicate name: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, PredNameCode),
    (   predicate(PredNameCode, _, _),
        continueExtract(PredNameCode,
                        Info,
                        FirstPart,
                        MiddlePart,
                        EndPart,
                        Tok,
                        FirstTokS,
                        LastTokS,
                        Info,
                        NewTokens)
    ;   \+ predicate(PredNameCode, _, _),
        write("Invalid name of predicate.\n")
    ).

extractLines(StartLine, EndLine2, Content, FirstPart, MiddlePart, [[tlineNumber, EndLine2]|T2], [tconjuction, ","]) :-
    append(FirstPart, [[tlineNumber, StartLine]|T1], Content),
    append(MiddlePart,
           [[tlineNumber, EndLine2]|T2],
           [[tlineNumber, StartLine]|T1]),
    \+ member([tneck, ":-"], MiddlePart),
    \+ member([tdcg, "-->"], MiddlePart),
    \+ member([tgoal, "?-"], MiddlePart),
    \+ removeAllWhites(MiddlePart, []), !.

extractLines(StartLine, EndLine2, Content, FirstPart, [[tlineNumber, StartLine]|T1], [], [tdot, "."]) :-
    append(FirstPart, [[tlineNumber, StartLine]|T1], Content),
    \+ append(_,
              [[tlineNumber, EndLine2]|_],
              [[tlineNumber, StartLine]|T1]),
    \+ member([tneck, ":-"], [[tlineNumber, StartLine]|T1]),
    \+ member([tdcg, "-->"], [[tlineNumber, StartLine]|T1]),
    \+ member([tgoal, "?-"], [[tlineNumber, StartLine]|T1]),
    \+ removeAllWhites([[tlineNumber, StartLine]|T1], []), !.

continueExtract(PredNameCode, Info, FirstPart, MiddlePart, EndPart, Tok, FirstTokS, LastTokS, Info, NewTokens) :-
    string_codes(PredName, PredNameCode),
    string_concat("$", PredName, NewPredName),
    filterOnlyVariables(FirstPart, VarFP),
    filterOnlyVariables(MiddlePart, VarMP),
    filterOnlyVariables(EndPart, VarEP),
    append(VarFP, VarEP, RestVars),
    % write(FirstPart), nl,
    % write(varsFP), nl,
    % write(VarFP), nl,
    %
    % write(MiddlePart), nl,
    % write(varsMP), nl,
    % write(VarMP), nl,
    %
    % write(EndPart), nl,
    % write(varsEP), nl,
    % write(VarEP), nl,
    %
    % write(Tok), nl,
    variableNameListsToCodes(RestVars, VarRCodes),
    variableNameListsToCodes(VarMP, VarMPCodes),
    intersection(VarRCodes, VarMPCodes, VarCodes),
    removeDuplicates(VarCodes, NoDupVarCodes),
    variableCodesListsToNames(NoDupVarCodes, VarsPred),
    createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok),
    append(FirstPart, NewPredicate, M1),
    append(M1, EndPart, M2),
    append(FirstTokS, [[Info, M2]|LastTokS], AlmostTokens),
    createLargePredicate(NewPredName, VarsPred, MiddlePart, NewPredicateLong),
    length(AlmostTokens, N),
    Numy is N+1,
    append(AlmostTokens, [[[Numy, NewPredName, rule], NewPredicateLong]], NewT),
    refacatorLineNumAndClauses(NewT, NewTokens),
    write("Done!\n").
    % prettyWriteList(NewTokens).
createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok) :-
    addAnds(VarsPred, VarsAnds),
    anyFirstConj(MiddlePart),
    anyLastConj(MiddlePart),
    append([[tconjuction, ","], [tpredicate, NewPredName], [tleftParen, "("]],
           VarsAnds,
           L1),
    append(L1, [[trightParen, ")"], Tok, [execNL, "\n"]], NewPredicate).

createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok) :-
    addAnds(VarsPred, VarsAnds),
    anyFirstConj(MiddlePart),
    \+ anyLastConj(MiddlePart),
    Tok==[tdot, "."],
    append([[tconjuction, ","], [tpredicate, NewPredName], [tleftParen, "("]],
           VarsAnds,
           L1),
    append(L1, [[trightParen, ")"], [tdot, "."], [execNL, "\n"]], NewPredicate).

createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok) :-
    addAnds(VarsPred, VarsAnds),
    anyFirstConj(MiddlePart),
    \+ anyLastConj(MiddlePart),
    Tok\=[tdot, "."],
    append([[tconjuction, ","], [tpredicate, NewPredName], [tleftParen, "("]],
           VarsAnds,
           L1),
    append(L1, [[trightParen, ")"], [execNL, "\n"]], NewPredicate).

createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok) :-
    addAnds(VarsPred, VarsAnds),
    \+ anyFirstConj(MiddlePart),
    anyLastConj(MiddlePart),
    append([[tpredicate, NewPredName], [tleftParen, "("]], VarsAnds, L1),
    append(L1, [[trightParen, ")"], Tok, [execNL, "\n"]], NewPredicate).

createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok) :-
    addAnds(VarsPred, VarsAnds),
    \+ anyFirstConj(MiddlePart),
    \+ anyLastConj(MiddlePart),
    Tok\=[tdot, "."],
    append([[tpredicate, NewPredName], [tleftParen, "("]], VarsAnds, L1),
    append(L1, [[trightParen, ")"], [execNL, "\n"]], NewPredicate).

createMiniPredicate(NewPredName, VarsPred, MiddlePart, NewPredicate, Tok) :-
    addAnds(VarsPred, VarsAnds),
    \+ anyFirstConj(MiddlePart),
    \+ anyLastConj(MiddlePart),
    Tok==[tdot, "."],
    append([[tpredicate, NewPredName], [tleftParen, "("]], VarsAnds, L1),
    append(L1, [[trightParen, ")"], [tdot, "."], [execNL, "\n"]], NewPredicate).

createLargePredicate(NewPredName, VarsPred, MiddlePart, NewPredicate) :-
    addAnds(VarsPred, VarsAnds),
    append([[tpredicate, NewPredName], [tleftParen, "("]], VarsAnds, L1),
    append(L1, [[trightParen, ")"], [tneck, ":-"], [execNL, "\n"]], Head),
    % write(NewPredicate),nl,
    % write(MiddlePart),nl,
    removeFirstConj(MiddlePart, NMP1),
    % write(NMP1),nl,
    removeLastConjDot(NMP1, NMP2, NMP3),
    % write(NMP2),nl,
    % write(NMP3),nl,
    append(NMP2, [[tdot, "."], [execNL, "\n"]], NewPr),
    append(NewPr, NMP3, Tail),
    append(Head, Tail, NewPredicate).

refacatorLineNumAndClauses(Tokens, NamedPackedLines) :-
    removeInfoPart(Tokens, T1),
    removeLineNumber(T1, T2),
    countToken(T2, execNL, LineCount),
    newLinesInComment(T2, N),
    LC is LineCount+N,
    % write(T2),nl,nl,
    % write(LC),nl,
    enumerateLines(LC, T2, EnumTokens),
    % write(EnumTokens),
    packClauses(LineCount, EnumTokens, PackedClauses),
    parseClauseNames(PackedClauses, NamedPackedLines).
