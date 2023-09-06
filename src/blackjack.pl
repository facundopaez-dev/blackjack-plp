% Incluye la base de conocimiento con las definiciones de las cartas.
:- [cards, basicstrategy].

% PRELIMINARES -------------------------------------------------------------

% 1. value/2
% value(card(Number, Suit), Value).
% Dada una carta, Value debe tomar el valor de esa carta.
% Para las numéricas corresponde su mismo valor, para las figuras (J,Q,K) siempre 10 y para el As 11 o 1.

% 
% value(_, _).

% value(card(2,c), 2).
% El guion bajo es que no importa el valor

value(card(V, P), V) :- card(V, P), number(V).

value(card(j, P), 10) :- card(j, P).
value(card(q, P), 10) :- card(q, P).
value(card(k, P), 10) :- card(k, P).

% El operador ! es para cortar la ejecucion en una regla.
% Este operador se llama cut y corta el backtracking que realiza Prolog.
% value(card(a, P), 11) :- card(a, P), !.
value(card(a, P), 11) :- card(a, P).
value(card(a, P), 1) :- card(a, P).

cant([], 0).
cant([H|T], R) :- cant(T, C), R is H+C.

% ...

% 2. hand_values/2
% hand_values(Hand, Value).
% Una mano se representa como una lista: 
%   [card(Number, Suit)]
% hand_values recupera todos los valores de esa mano.
% Ejemplo: [card(4,c), card(8,t), card(q,d)].

% hand_values(_, _).

hand_values([], 0).
hand_values([H|T], R) :-
    value(H, VH),
    hand_values(T, VT),
    R is VH + VT.

% 3. hand/2
% hand(Hand, Value).
% Indica el valor más alto sin pasarse de 21.

% hand(_, _).

hand(Hand, Value) :-
    findall(V, (hand_values(Hand, V), V < 22), Vs),
    max_list(Vs, Value).

% DESAFIOS -------------------------------------------------------------

% 4. twentyone/1 twentyone(Hand). Indica si la mano es exactamente 21.
% 5. over/1 over(Hand). Indica si la mano se pasa.
% 6. blackjack/1 blackjack(Hand). Indica si la mano es 21 con sólo dos cartas.

% twentyone(_).
twentyone(Hand) :- hand(Hand, 21).

% over(_).
over(Hand) :-
    findall(R, hand_values(Hand, R), Vs),
    min_list(Vs, Value),
    Value > 21.

% blackjack(_).
blackjack(Hand) :-
    hand(Hand, 21),
    length(Hand, 2).

% INTERMEDIO -------------------------------------------------------------

% 7. soft/1
% soft(Hand).
% Indica si la mano es suave.

% soft(_).
soft(Hand) :- findall(Value, hand_values(Hand, Value), B), length(B, Cant), Cant > 1.

% 8. hard/1
% hard(Hand).
% Indica si la mano es dura.

hard(_).

% 9. dealer_soft/2
% dealer_soft(Hand, Action).
% Action unifica a la acción del dealer: hit o stand. Se planta con un 17 suave.

dealer_soft(_, _).

% 10. dealer_hard/2
% dealer_hard(Hand, Action).
% Action unifica a la acción del dealer: hit o stand. Se planta con un 17 duro.

dealer_hard(_, _).

% PRINCIPAL -------------------------------------------------------------

% 11. play/4
% play(Hand, DealerCard, PlayedCards, Action).
% Utiliza toda la información de la mesa para decicir la acción del jugador: stand o hit.
% Condiciones:
% Debe utilizarse como base la estrategia básica en basicstrategy.pl, de la cual debe implementarse el resto de la misma.
% Deben utilizarse todos los parámetros del jugador.
% Puede implementar todas las reglas de soporte que considere necesaria.

play(_,_,_,no_implementado).

