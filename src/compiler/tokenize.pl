% Author - Prasheel Nandwana
% Purpose - This file contains the code to tokenize the input file
% Version - 1.0
% Date - 04-28-2024

convert(File) :-
    open(File, read, Stream),
    read_lines(Stream, TokenList),
    close(Stream),
    consult('./parser.pl'),
    program(Tree, TokenList, []),
    consult('../runtime/eval.pl'),
    eval_program(Tree, [],NEnv).

read_lines(Stream, []) :-
    at_end_of_stream(Stream).

read_lines(Stream, [Result|Lines]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    atom_codes(Line, Codes),
    convert_to_integer(Line,Result),
    read_lines(Stream, Lines).

convert_to_integer(String, Result) :-
    (   atom_number(String, Number),
        integer(Number)
    ->  Result = Number
    ;   Result = String
    ).