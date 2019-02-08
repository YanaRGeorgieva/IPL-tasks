:- use_module(library(dcg/basics)).
:- use_module(library(readutil)).
:- use_module(library(quintus)).
:- 
   [ lexer,
     utils,
     fileWork,
     packClauses,
     findVarDecl,
     findPredDecl,
     findVarUse,
     findPredUse,
     changeVarName,
     changePredName,
     extractPredicate
   ].

:- set_prolog_flag(verbose, silent).
:- initialization(main, main).
main :-
    readyToWork("Code Refactoring Tool for Prolog written in Prolog!\nChoose one of the option in the following list by typing \"i\":\nCan answer questions like:\n1. Where is X defined (first encountering in clause for variable)?\n\tReturns list of \"line number, predicate name\".\n2. Where is X defined (all encounterings of clause in program for predicate where it is the head of a clause)?\n\tReturns list of \"line number\".\n3. Where is X used (all encounterings of variable in clauses except first encounters)?\n\tReturns list of \"line number, predicate name\".\n4. Where is X used (all encounterings of clause in program for predicate where it is in the body of a clause)?\n\tReturns list of \"line number, predicate name\".\nCan refactor the code a bit:\n5. Can rename variable identifier in a given program and let's you choose which one.\n\tReturns a list of \"predicate name a.k.a. the whole predicate definition\".\n6. Can rename predicate identifier in a given program.\n7. Extract predicate from longer clause. Creates a new predicate whose name will be $predicate_name (user defined) and will be situated at the end of the file.\nExit me by typing \"quit\" or if you want a new file to edit, then type \"switch\".\nYou can save changes to file with \"save\".\nYou can ask for help with \"help\"."),
    halt.
main :-
    halt(1).

readyToWork(Message) :-
    write("Please enter the name of the file you would like to refactor: "),
    current_stream(0, read, ReadStream),
    read_line_to_codes(ReadStream, FilenameCode),
    string_codes(Filename, FilenameCode),
    readFileAndStart(Filename, Message, PLNCTokens),
    % writeToConsole(PLNCTokens),
    % prettyWriteList(PLNCTokens),
    startCycleTillQuit(Message, PLNCTokens, Filename).

readFileAndStart(Filename, Message, []) :-
    isOkayName(Filename),
    open(Filename, read, Stream),
    line_count(Stream, 0),
    close(Stream),
    write("\nEmpty file!\n"),
    readyToWork(Message).
readFileAndStart(Filename, Message, NamedPackedLines) :-
    isOkayName(Filename),
    write("\nLoading file...\n"),
    open(Filename, read, Stream),
    read_stream_to_codes(Stream, Source),
    phrase(tokens(STokens), Source),
    line_count(Stream, LineCount),
    LineCount=\=0,
    close(Stream),
    flattenMine(STokens, Tokens),
    enumerateLines(LineCount, Tokens, EnumTokens),
    packClauses(LineCount, EnumTokens, PackedClauses),
    parseClauseNames(PackedClauses, NamedPackedLines),
    % prettyWriteList(NamedPackedLines),
    write("\nFile loaded and ready to refactor file.\n"),
    write(Message).
readFileAndStart(Filename, Message, []) :-
    \+ isOkayName(Filename),
    write("Not okay filename!\n"),
    readyToWork(Message).

isOkayName(Filename) :-
    exists_file(Filename),
    absolute_file_name(Filename, [file_type(prolog), access(read)], _).

startCycleTillQuit(Message, TokenStream, Filename) :-
    nl,
    current_stream(0, read, Stream),
    read_line_to_codes(Stream, CodesCommand),
    string_codes(Command, CodesCommand),
    switchOptions(Command, Message, TokenStream, Filename).


switchOptions(Command, Message, TokenStream, Filename) :-
    onlyWhites(Command),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("help", Message, TokenStream, Filename) :-
    write(Message),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("quit", _, _, _) :-
    write("Bye!"),
    nl.
switchOptions("save", Message, TokenStream, Filename) :-
    saveToFile(TokenStream),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("switch", Message, _, _) :-
    readyToWork(Message).
switchOptions("print", Message, TokenStream, Filename) :-
    writeToConsole(TokenStream),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("1", Message, TokenStream, Filename) :-
    whereIsXDefinedVariable(TokenStream),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("2", Message, TokenStream, Filename) :-
    whereIsXDefinedPredicate(TokenStream),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("3", Message, TokenStream, Filename) :-
    whereIsXUsedVariable(TokenStream),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("4", Message, TokenStream, Filename) :-
    whereIsXUsedPredicate(TokenStream),
    startCycleTillQuit(Message, TokenStream, Filename), !.
switchOptions("5", Message, TokenStream, Filename) :-
    changeNameOfXVariable(TokenStream, NewTokenStream),
    startCycleTillQuit(Message, NewTokenStream, Filename), !.
switchOptions("6", Message, TokenStream, Filename) :-
    changeNameOfXPredicate(TokenStream, NewTokenStream),
    startCycleTillQuit(Message, NewTokenStream, Filename), !.
switchOptions("7", Message, TokenStream, Filename) :-
    extractPredicate(TokenStream, NewTokenStream),
    startCycleTillQuit(Message, NewTokenStream, Filename), !.
switchOptions(_, Message, TokenStream, Filename) :-
    write("Bad command.\n"),
    startCycleTillQuit(Message, TokenStream, Filename), !.
