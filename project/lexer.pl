%% Definitions of tokens
/*
    2.20.3 Reserved Names
    The boot compiler (see -b option) does not support the module system. As large parts of the system are written in Prolog itself we need some way to avoid name clashes with the user's predicates, database keys, etc. Like Edinburgh C-Prolog Pereira, 1986 all predicates, database keys, etc., that should be hidden from the user start with a dollar ($) sign.
*/
token([tcomment1, IA]) -->
    comment1(I), !,
    { atom_chars(IA, I)
    }.

%% Handling windows written files with "\r\n"
token([[tcomment2, IA], [execNL, '\n']]) -->
    comment2(I), !,
    { append(I1, [C1, C2], I),
      (   char_code('\r', C1),
          char_code('\n', C2),
          atom_chars(IA, I1)
      ;   \+ char_code('\r', C1),
          char_code('\n', C2),
          append(I1, [C1], I2),
          atom_chars(IA, I2)
      )
    }.

token([tnot, "not"]) -->
    "not", !.
token([tassignArithmetic, "is"]) -->
    "is", !.
token([tmod, "mod"]) -->
    "mod", !.
token([trem, "rem"]) -->
    "rem", !.
token([trdiv, "rdiv"]) -->
    "rdiv", !.
token([tgcd, "gcd"]) -->
    "gcd", !.
token([tgcd, "xor"]) -->
    "xor", !.

token([tstring, IA]) -->
    stringy(I), !,
    { atom_chars(IA, I)
    }.
token([[tpredicate, IA], [tleftParen, "("]]) -->
    predicateName(I), !,
    { append(IO, [_], I),
      IO\=[],
      atom_chars(IA, IO)
    }.
token([[tpredicate, IA], [tneck, ":-"]]) -->
    predicateNameNoArg(I), !,
    { append(IO, [_, _], I),
      IO\=[],
      atom_chars(IA, IO)
    }.

token([tnumber, I]) -->
    number(I), !.

token([tequalArithmetic, "=:="]) -->
    "=:=", !.
token([tequalDeep, "=@="]) -->
    "=@=", !.
token([tnotEqualDeep, "\\=@="]) -->
    "\\=@=", !.
token([tnotequalArithmetic, "=\\="]) -->
    "=\\=", !.
token([tdcg, "-->"]) -->
    "-->", !.

token([tarrow, "->"]) -->
    "->", !.
token([tgoal, "?-"]) -->
    "?-", !.
token([tneck, ":-"]) -->
    ":-", !.

token([tpp, "++"]) -->
    "++", !.
token([tmm, "--"]) -->
    "--", !.
token([tgreaterEqual, ">="]) -->
    ">=", !.
token([tlessEqual, "=<"]) -->
    "=<", !.
token([tequalTerm, "=="]) -->
    "==", !.
token([tnotequalTerm, "\\="]) -->
    "\\=", !.
token([tnotequalTerm, "\\=="]) -->
    "\\==", !.
token([texp, "**"]) -->
    "**", !.
token([tintegerDivide, "//"]) -->
    "//", !.
token([tbinShiftLeft, "<<"]) -->
    "<<", !.
token([tbinShiftRight, ">>"]) -->
    ">>", !.
token([tbitwiseAnd, "/\\"]) -->
    "/\\", !.
token([tbitwiseOr, "\\/"]) -->
    "\\/", !.


token([texp, "^"]) -->
    "^", !.
token([tmultiply, "*"]) -->
    "*", !.
token([tfloatDivide, "/"]) -->
    "/", !.
token([tadd, "+"]) -->
    "+", !.
token([tsubtract, "-"]) -->
    "-", !.
token([tless, "<"]) -->
    "<", !.
token([tgreater, ">"]) -->
    ">", !.
token([tunify, "="]) -->
    "=", !.
token([tcut, "!"]) -->
    "!", !.
token([tescape, "\\"]) -->
    "\\", !.

token([tspace, "\\s"]) -->
    "\\s", !.
token([ttab, "\\t"]) -->
    "\\t", !.
token([tnl, "\\n"]) -->
    "\\n", !.
token([execSpace, " "]) -->
    " ", !.
token([execTAB, "    "]) -->
    "\t", !.
token([execNL, "\n"]) -->
    (   "\n"
    ;   "\r\n"
    ), !.

token([tleftParen, "("]) -->
    "(", !.
token([trightParen, ")"]) -->
    ")", !.
token([tleftBrace, "{"]) -->
    "{", !.
token([trightBrace, "}"]) -->
    "}", !.
token([tleftSqParen, "["]) -->
    "[", !.
token([trightSqParen, "]"]) -->
    "]", !.
token([tdisjunction, ";"]) -->
    ";", !.
token([ttwodots, ":"]) -->
    ":", !.
token([tconjuction, ","]) -->
    ",", !.
token([tquot, "'"]) -->
    "'", !.
token([tdoubleQuot, "\""]) -->
    "\"", !.
token([tdot, "."]) -->
    ".", !.

token([twildcard, "_"]) -->
    "_", !.
token([tvariable, IA]) -->
    variable(I), !,
    { atom_chars(IA, I)
    }.
token([tatom, IA]) -->
    atomMine(I), !,
    { atom_chars(IA, I)
    }.
token([tunknown, IA]) -->
    allThatIsNotAToken(I), !,
    { I\=[],
      atom_chars(IA, I)
    }.


%% Main predicate
tokens([Token|Tail]) -->
    token(Token), !,
    tokens(Tail).
tokens([]) --> !,
    [], !.


%% Helper predicates
stringy([C|Cs]) -->
    [C],
    { char_code('"', C)
    }, !,
    stringyHelper1(Cs).
stringy([C|Cs]) -->
    [C],
    { char_code('\'', C)
    }, !,
    stringyHelper2(Cs).

stringyHelper1([C]) -->
    [C],
    { char_code('\n', C),
      fail
    }, !.
stringyHelper1([C1, C2, C3]) -->
    [C1, C2, C3],
    { char_code(\, C1),
      char_code(\, C2),
      char_code('"', C3)
    }, !.
stringyHelper1([C1, C2|Cs]) -->
    [C1, C2],
    { char_code(\, C1),
      char_code('"', C2)
    }, !,
    stringyHelper1(Cs).
stringyHelper1([C]) -->
    [C],
    { char_code('"', C)
    }.
stringyHelper1([C|Cs]) -->
    [C],
    stringyHelper1(Cs).

stringyHelper2([C]) -->
    [C],
    { char_code('\n', C),
      fail
    }, !.
stringyHelper2([C1, C2, C3]) -->
    [C1, C2, C3],
    { char_code(\, C1),
      char_code(\, C2),
      char_code('\'', C3)
    }, !.
stringyHelper2([C1, C2|Cs]) -->
    [C1, C2],
    { char_code(\, C1),
      char_code('\'', C2)
    }, !,
    stringyHelper2(Cs).
stringyHelper2([C]) -->
    [C],
    { char_code('\'', C)
    }.
stringyHelper2([C|Cs]) -->
    [C],
    stringyHelper2(Cs).

atomMine([C|Cs]) -->
    [C],
    { code_type(C, prolog_atom_start)
    }, !,
    atomHelper(Cs).

atomHelper([C|Cs]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !,
    atomHelper(Cs).
atomHelper([C]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !.
atomHelper([]) -->
    [], !.


variable([C|Cs]) -->
    [C],
    { code_type(C, prolog_var_start)
    }, !,
    variableHelper(Cs).
variableHelper([C|Cs]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !,
    variableHelper(Cs).
variableHelper([C]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !.
variableHelper([]) -->
    [], !.

predicateName([C|Cs]) -->
    [C],
    { (   code_type(C, csymf),
          code_type(C, lower)
      ;   char_code("$", C)
      )
    }, !,
    predicateNameHelper(Cs).
predicateNameHelper([C|Cs]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !,
    predicateNameHelper(Cs).
predicateNameHelper([C]) -->
    [C],
    { char_code("(", C)
    }, !.

predicateNameNoArg([C|Cs]) -->
    [C],
    { (   code_type(C, csymf),
          code_type(C, lower)
      ;   char_code("$", C)
      )
    }, !,
    predicateNameNoArgHelper(Cs).
predicateNameNoArgHelper([C|Cs]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !,
    predicateNameNoArgHelper(Cs).
predicateNameNoArgHelper([C1, C2]) -->
    [C1, C2],
    { char_code(":", C1),
      char_code("-", C2)
    }, !.


comment1([C1, C2|Cs]) -->
    [C1, C2],
    { char_code(/, C1),
      char_code(*, C2)
    }, !,
    anythingButStarSlash(Cs).

comment2([C1|Cs]) -->
    [C1],
    { char_code('%', C1)
    }, !,
    anythingButNL(Cs).

anything([C|Cs]) -->
    [C],
    anything(Cs).
anything([]) -->
    [].

allThatIsNotAToken([C|Cs]) -->
    [C|Cs],
    \+ tokens(C),
    \+ tokens([C|Cs]),
    allThatIsNotAToken(Cs).
allThatIsNotAToken([]) -->
    [].

anythingButNL([C|Cs]) -->
    [C],
    { \+ char_type(C, newline)
    },
    anythingButNL(Cs).
anythingButNL([C1, C2]) -->
    [C1, C2],
    { (   char_type(C1, newline),
          char_type(C2, newline)
      ;   \+ char_type(C1, newline),
          char_type(C2, newline)
      )
    }.

anythingButStarSlash([C1, C2]) -->
    [C1, C2],
    { char_code(*, C1),
      char_code(/, C2)
    }.
anythingButStarSlash([C|Cs]) -->
    [C],
    anythingButStarSlash(Cs).

predicate([C|Cs]) -->
    [C],
    { (   code_type(C, csymf),
          code_type(C, lower)
      ;   char_code("$", C)
      )
    }, !,
    predicateHelper(Cs).
predicateHelper([C|Cs]) -->
    [C],
    { code_type(C, prolog_identifier_continue)
    }, !,
    predicateHelper(Cs).
predicateHelper([]) --> !.
