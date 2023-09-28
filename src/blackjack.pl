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
value(card(V, P),V) :- card(V, P), number(V).
value(card(j, P), 10) :- card(j, P).
value(card(q, P), 10) :- card(q, P).
value(card(k, P), 10) :- card(k, P).

% El operador ! es para cortar la ejecucion en una regla.
% Este operador se llama cut y corta el backtracking que realiza Prolog.
% value(card(a, P), 11) :- card(a, P), !.
value(card(a, P), 11) :- card(a, P).
value(card(a, P), 1) :- card(a, P).

cant([], 0).
cant([H|T], R) :- cant(T, C), R is C+1.

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
% Indica el valor mas alto sin pasarse de 21.

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

% 5. over/1 over(Hand). Indica si la mano se pasa.

% over(_).

over(Hand) :- 
    findall(V, (hand_values(Hand, V)), Vs),
    min_list(Vs, Value),
    Value > 21.

% 6. blackjack/1 blackjack(Hand). Indica si la mano es 21 con sólo dos cartas.
%twentyone(_).
% blackjack(_).

blackjack(Hand) :-
    hand(Hand, 21),
    length(Hand, 2).

% INTERMEDIO -------------------------------------------------------------

% 7. soft/1
% soft(Hand).
% Indica si la mano es suave.

% soft(_).
% Cuando la mano arroja mas de un valor, la mano es suave

soft(Hand) :-
    findall(V, (hand_values(Hand, V), V < 22), Vs),
    length(Vs, Cant),
    Cant > 1.

% 8. hard/1
% hard(Hand).
% Indica si la mano es dura.

% hard(_).
% Cuando la mano arroja un unico valor, la mano es dura

hard(Hand) :-
    findall(V, (hand_values(Hand, V),V  < 22), Vs),
    length(Vs, 1).

basic_strategy(H, D, A) :- hard(H), hand(H,Value), value(D, V), basic(hard, Value, V, A).
basic_strategy(H, D, A) :- soft(H), hand(H,Value), value(D, V), basic(soft, Value, V, A).

low_strategy(H, D, A) :- soft(H), hand(H,Value), value(D, V), LowValue is Value + 1, basic(soft, LowValue, V, A).
low_strategy(H, D, A) :- hard(H), hand(H,Value), value(D, V), LowValue is Value + 1, basic(hard, LowValue, V, A).

high_strategy(H, D, A) :- soft(H), hand(H,Value), value(D, V), HighValue is Value - 3, basic(soft, HighValue, V, A).
high_strategy(H, D, A) :- hard(H), hand(H,Value), value(D, V), HighValue is Value - 3, basic(hard, HighValue, V, A).

% 9. dealer_soft/2
% dealer_soft(Hand, Action).
% Action unifica a la acción del dealer: hit o stand. Se planta con un 17 suave.

% dealer_soft(_, _).
dealer_soft(Hand, hit) :- hand(Hand, Value), Value < 17.
dealer_soft(Hand, stand) :- hand(Hand, Value), Value >= 17.

% 10. dealer_hard/2
% dealer_hard(Hand, Action).
% Action unifica a la acción del dealer: hit o stand. Se planta con un 17 duro.

% dealer_hard(_, _).
dealer_hard(Hand, hit) :- hand(Hand, Value), Value < 17, !.
dealer_hard(Hand, stand) :- hand(Hand, Value), Value > 17, !.
dealer_hard(Hand, hit) :- hand(Hand, 17), soft(Hand), !.
dealer_hard(Hand, stand) :- hand(Hand, 17), hard(Hand), !.

% PRINCIPAL -------------------------------------------------------------

% 11. play/4
% play(Hand, DealerCard, PlayedCards, Action).
% Utiliza toda la información de la mesa para decicir la acción del jugador: stand o hit.
% Condiciones:
% Debe utilizarse como base la estrategia básica en basicstrategy.pl, de la cual debe implementarse el resto de la misma.
% Deben utilizarse todos los parámetros del jugador.
% Puede implementar todas las reglas de soporte que considere necesaria.

play(Hand, DealerCard, PlayedCards, Action) :-
    hand(Hand, Value),
    value(DealerCard, ValueDealer),
    basic_strategy(Value, ValueDealer, Action).

play(Hand, DealerCard, PlayedCards, Action) :-
    cuenta(PlayedCards, Cuenta),
    Cuenta < 5, 
    Cuenta > -5,
    basic_strategy(Hand,DealerCard,Action).

play(Hand, DealerCard, PlayedCards, Action) :-
    cuenta(PlayedCards, Cuenta),
    Cuenta < -4, 
    low_strategy(Hand,DealerCard,Action).

play(Hand, DealerCard, PlayedCards, Action) :-
    cuenta(PlayedCards, Cuenta),
    Cuenta > 4, 
    high_strategy(Hand,DealerCard,Action).

cuenta([], 0) :- !.
cuenta([H|T],Cuenta) :- cuentaCarta(H, V), cuenta(T, Ct), Cuenta is V + Ct.

cuentaCarta(Card, -1) :- value(Card, V), V < 7, V > 1, !.
cuentaCarta(Card, 1) :- value(Card, V), V > 9,!.
cuentaCarta(Card, 0) :- value(Card, V), V < 10, V > 6.

test_high([card(j,t),card(9,t),card(k,t), card(j,d), card(q,p), card(k,d), card(k,c), card(j,c)]).

test_high2(Vs) :- findall(card(N, P), (card(N, P), value(card(N, P), 10)), Vs).