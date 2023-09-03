% Incluye las reglas definidas por el alumno en blackjack.pl
% La lógica del programa.
:- [blackjack].

% Establece variables del interprete de prolog.
% verbose = silent establece la supresión de los mensajes informacionales.
:- set_prolog_flag(verbose, silent).

% Indica que al cargar el código se debe evaluar la regla main.
:- initialization main.


main :-
  % Recupera la lista de argumentos por línea de comandos.
  current_prolog_flag(argv, Argv),
  % Convierte la lista de strings en lista de terminos. (definido más abajo).
  terms_strings(Params, Argv),
  % built-in de prolog. Evalua la regla command con la lista de parametros como argumentos individuales.
  % ej. apply(command, [dealer, soft,[card(a,c),card(j,d)]]) evalua
  % command(dealer, soft, [card(a,c),card(j,d)])
  apply(command, Params),
  halt. % Finaliza la ejecución.

% En caso de que no pueda evaluar ningún comando, imprime mensaje de error.
main :-
  format('Incorrect parameters!\n'),
  halt. % Finaliza la ejecución.

%------------------------------------------------
% PLAY
%------------------------------------------------
% Evalua play e imprime la acción.
% ej.: swipl -s main.pl play "[card(a,c),card(j,d)]" "card(8,p)" "[card(a,c),card(j,d),card(8,p),card(5,t)]"
%
command(play, Hand, Dealer, Cards) :-
  play(Hand, Dealer, Cards, Action),
  format('~p\n',[Action]), !.

%------------------------------------------------
% DEALERS
%------------------------------------------------

% dealer soft
% ej.: swipl -s main.pl dealer soft "[card(a,c),card(j,d)]"
%
command(dealer, soft, Hand) :-
  dealer_soft(Hand, Action),
  format('~p\n',[Action]), !.

% dealer hard
% ej.: swipl -s main.pl dealer hard "[card(a,c),card(j,d)]"
%
command(dealer, hard, Hand) :-
  dealer_hard(Hand, Action),
  format('~p\n',[Action]), !.

%------------------------------------------------
% VERIFICACIONES
%------------------------------------------------
% value imprime el valor de la mano, "blackjack" o "over".
% ej.: swipl -s main.pl value "[card(a,c),card(j,d)]"
%
command(value, Hand) :-
  blackjack(Hand),
  format('blackjack\n'), !.

command(value, Hand) :-
  hand(Hand, Val),
  format('~d\n', Val), !.

command(value, Hand) :-
  over(Hand),
  format('over\n'), !.


command(value, _) :-
  format('no pude interpretar esta mano\n'), !.

%------------------------------------------------
% SOPORTE
%------------------------------------------------
% Parsea los argumentos en forma de terminos o string.
% params: [Ht|Tt] Lista de argumentos en forma de término.
%         [Hs|Ts] Lista de argumentos en forma de string.
terms_strings([],[]).
terms_strings([Ht|Tt],[Hs|Ts]) :-
  term_string(Ht,Hs),
  terms_strings(Tt,Ts).
