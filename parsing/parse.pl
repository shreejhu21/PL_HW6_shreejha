% parse.pl

% Entry point: succeeds iff the entire list of tokens matches Lines
parse(Tokens) :-
    parse_lines(Tokens, []).

% parse_lines(+Tokens, -Rest)
%   Lines → Line ; Lines | Line
parse_lines(Tokens, Rest) :-
    parse_line(Tokens, Rem1),
    (   Rem1 = [';'|Rem2]
    ->  parse_lines(Rem2, Rest)
    ;   Rest = Rem1
    ).

% parse_line(+Tokens, -Rest)
%   Line → Num , Line | Num
parse_line(Tokens, Rest) :-
    parse_num(Tokens, Rem1),
    (   Rem1 = [','|Rem2]
    ->  parse_line(Rem2, Rest)
    ;   Rest = Rem1
    ).

% parse_num(+Tokens, -Rest)
%   Num → Digit | Digit Num
parse_num([D|Tokens], Rest) :-
    digit(D),
    parse_num_rest(Tokens, Rest).

parse_num_rest([D|Tokens], Rest) :-
    digit(D),
    parse_num_rest(Tokens, Rest).
parse_num_rest(Rest, Rest).

% digit/1
digit(D) :-
    member(D, ['0','1','2','3','4','5','6','7','8','9']).
