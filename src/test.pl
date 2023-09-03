:- set_prolog_flag(verbose, silent).

:- initialization main.

main :-
  current_prolog_flag(argv, Argv),
  [Goal|_] = Argv,
  format('Tu comando es "~w"\n', Goal),
  halt.

main :-
  halt(1).
