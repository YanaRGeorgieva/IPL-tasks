:- use_module(library(dcg/basics)).
:- use_module(library(readutil)).
:- [tokens, prettify, print, essentials, controlStructures].
:- set_prolog_flag(verbose, silent).

:- initialization(main, main).

main :-
    current_prolog_flag(argv, Argv),
    Argv=[H1, H2|_],
    atom_string(H1, File),
    atom_string(H2, Number),
    mainy(File, Number),
    format('You can see the result in the html file.~n'),
    halt.
main :-
    halt(1).

mainy(File, Number) :-
    open(File, read, RFile),
    read_stream_to_codes(RFile, CSource),
    close(RFile),
    phrase(tokens(Tokens), CSource),
    flattenMine(Tokens, TokenStream),
    (   Number=="0",
        PrettyCode=TokenStream
    ;   Number=="1",
        prettify(TokenStream, Raw),
        flattenMine(Raw, PrettyCode)
    ;   Number=="2",
        prettify(TokenStream, Raw),
        identifyControlStructures(Raw, RawF),
        flattenMine(RawF, PrettyCode)
    ),
    open('page.html', write, WFile),
    write(WFile,
          '<!doctype>\n    <html>\n\n        <head>\n            <title>hello.c</title>\n            <meta name="viewport" content="width=device-width, initial-scale=1">\n            <style>\n                .keyword {\n                    color: blue;\n                }\n\n                .number {\n                    color: violet;\n                }\n\n                .identifier {\n                    color: green;\n                }\n\n                .operator {\n                    font-style: bold;\n                    color: blue;\n                }\n\n                .comment {\n                    color: lime;\n                }\n\n                .string {\n                    color: orange;\n                }\n\n                .parenthese {\n                    font-style: bold;\n                    color: brown;\n                }\n\n                .quotation {\n                    font-style: bold;\n                    color: black;\n                }\n\n                .unknown {\n                    font-style: bold;\n                    color: red;\n                }\n\n                .function {\n                    color: purple;\n                }\n\n                .collapsible {\n                    background-color: PaleGreen;\n                    cursor: pointer;\n                    padding: 10px;\n                    width: 100%;\n                    border: none;\n                    text-align: left;\n                    outline: none;\n                    font-size: 15px;\n                }\n\n                .active,\n                .collapsible:hover {\n                    background-color: PaleGoldenRod;\n                }\n\n                .content {\n                    padding: 0 18px;\n                    display: none;\n                    overflow: hidden;\n                    background-color: #f1f1f1;\n                }\n            </style>\n        </head>\n\n        <body>\n            <pre class="code">'),
    tohtmlfile(WFile, PrettyCode),
    write(WFile,
          ' <script>\n                    var coll = document.getElementsByClassName("collapsible");\n                    var i;\n\n                    for (i = 0; i < coll.length; i++) {\n                      coll[i].addEventListener("click", function() {\n                        this.classList.toggle("active");\n                        var content = this.nextElementSibling;\n                        if (content.style.display === "block") {\n                          content.style.display = "none";\n                        } else {\n                          content.style.display = "block";\n                        }\n                      });\n                    }\n                    </script>\n                        </pre>\n                    </body>\n\n                    </html>'),
    close(WFile).
