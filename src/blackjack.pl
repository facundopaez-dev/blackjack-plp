% Incluye la base de conocimiento con las definiciones de las cartas.
:- [cards, basicstrategy].

% PRELIMINARES -------------------------------------------------------------

% 1. value/2
% value(card(Number, Suit), Value).
% Dada una carta, Value debe tomar el valor de esa carta.
% Para las numéricas corresponde su mismo valor, para las figuras (J,Q,K) siempre 10 y para el As 11 o 1.

% 
% value(_, _).

% value(card(2, c), 2).
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
cant([_|T], R) :- cant(T, C), R is C+1.

% 2. hand_values/2
% hand_values(Hand, Value).
% Una mano se representa como una lista: 
%   [card(Number, Suit)]
% hand_values recupera todos los valores de esa mano.
% Ejemplo: [card(4, c), card(8, t), card(q, d)].

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

basic_strategy(H, D, A) :- basic(hard, H, D, A), !.
basic_strategy(H, D, A) :- basic(soft, H, D, A), !.

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
cuenta([H|T], Cuenta) :- cuentaCarta(H, V), cuenta(T, Ct), Cuenta is V + Ct.

cuentaCarta(Card, -1) :- value(Card, V), V < 7, V > 1, !.
cuentaCarta(Card, 1) :- value(Card, V), V > 9, !.
cuentaCarta(Card, 0) :- value(Card, V), V < 10, V > 6.

test_high([card(j, t), card(9, t), card(k, t), card(j, d), card(q, p), card(k, d), card(k, c), card(j, c)]).

test_high2(Vs) :- findall(card(N, P), (card(N, P), value(card(N, P), 10)), Vs).

% *************************************************** ESTADISTICA ***************************************************
% OBJETIVO: Dada una lista de cartas jugadas informar la probabilidad de que en la siguiente tirada salga una carta
% alta, una carta media y una carta baja.

% Para cumplir este objetivo se necesitan las siguientes reglas:
% - regla para obtener el mazo (cartas no jugadas) dada una lista de cartas jugadas.
% - regla para contar la cantidad de cartas que hay en el mazo.
% - regla para contar la cantidad de cartas altas que hay en el mazo.
% - regla para contar la cantidad de cartas medias que hay en el mazo.
% - regla para contar la cantidad de cartas bajas que hay en el mazo.
% - regla para calcular la probabilidad de que en la siguiente tirada salga una carta alta, una carta media y una carta baja.

% Cartas altas: 10, J, Q, K, A -> estas cartas suman 1.
% Cartas medias: 7, 8, 9 -> restan 0.
% Cartas bajas: 2, 3, 4, 5, 6 -> estas cartas restan 1.

% * Reglas para imprimir datos *
imprimir_cantidad_cartas_mazo(CartasJugadas) :-
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_mazo(Mazo, CantidadCartasMazo),
    write('Cantidad de cartas que hay en el mazo (cartas no jugadas): '), writeln(CantidadCartasMazo).

imprimir_cantidad_cartas_altas_mazo(CartasJugadas) :-
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_altas_mazo(Mazo, CantidadCartasAltasMazo),
    write('Cantidad de cartas altas que hay en el mazo (cartas no jugadas): '), writeln(CantidadCartasAltasMazo).

imprimir_cantidad_cartas_medias_mazo(CartasJugadas) :-
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_medias_mazo(Mazo, CantidadCartasMediasMazo),
    write('Cantidad de cartas medias que hay en el mazo (cartas no jugadas): '), writeln(CantidadCartasMediasMazo).

imprimir_cantidad_cartas_bajas_mazo(CartasJugadas) :-
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_bajas_mazo(Mazo, CantidadCartasBajasMazo),
    write('Cantidad de cartas bajas que hay en el mazo (cartas no jugadas): '), writeln(CantidadCartasBajasMazo).

% * Reglas de soporte *
mazo_inicial_cartas([card(a, c), card(2, c), card(3, c), card(4, c), card(5, c), card(6, c), card(7, c), card(8, c), card(9, c), card(10, c), card(j, c), card(q, c), card(k, c), card(a, p), card(2, p), card(3, p), card(4, p), card(5, p), card(6, p), card(7, p), card(8, p), card(9, p), card(10, p), card(j, p), card(q, p), card(k, p), card(a, t), card(2, t), card(3, t), card(4, t), card(5, t), card(6, t), card(7, t), card(8, t), card(9, t), card(10, t), card(j, t), card(q, t), card(k, t), card(a, d), card(2, d), card(3, d), card(4, d), card(5, d), card(6, d), card(7, d), card(8, d), card(9, d), card(10, d), card(j, d), card(q, d), card(k, d)]).

% Definicion de la regla para obtener el mazo (cartas no jugadas) dada una lista de cartas jugadas
obtener_mazo(CartasJugadas, Mazo) :-
    mazo_inicial_cartas(MazoInicialCartas),
    subtract(MazoInicialCartas, CartasJugadas, Mazo).

% Definicion de la regla para contar la cantidad de cartas que hay en el mazo (cartas no jugadas)
cantidad_cartas_mazo(Mazo, CantidadCartasMazo) :- cant(Mazo, CantidadCartasMazo).

% * Reglas para calcular la probabilidad de que la siguiente carta que salga del mazo (cartas no jugadas) sea alta *
% Definicion de la regla para contar la cantidad de cartas altas que hay en el mazo (cartas no jugadas)
cantidad_cartas_altas_mazo([], 0).
cantidad_cartas_altas_mazo([H|T], CantidadCartasAltasMazo) :-
    value(H, Value),
    Value > 9,
    cantidad_cartas_altas_mazo(T, R),
    CantidadCartasAltasMazo is R + 1.

cantidad_cartas_altas_mazo([H|T], CantidadCartasAltasMazo) :-
    value(H, Value),
    Value =< 9,
    cantidad_cartas_altas_mazo(T, R),
    CantidadCartasAltasMazo is R + 0.

prob_carta_alta(CartasJugadas) :-
    % Obtiene el mazo (cartas no jugadas)
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_mazo(Mazo, CantidadCartasMazo),
    cantidad_cartas_altas_mazo(Mazo, CantidadCartasAltasMazo),
    ProbCartaAlta is CantidadCartasAltasMazo / CantidadCartasMazo * 100,
    write('La probabilidad de que en la siguiente tirada salga una carta alta es: '), write(ProbCartaAlta), writeln(' %').

% * Reglas para calcular la probabilidad de que la siguiente carta que salga del mazo (cartas no jugadas) sea media *
% Definicion de la regla para contar la cantidad de cartas medias que hay en el mazo (cartas no jugadas)
cantidad_cartas_medias_mazo([], 0).
cantidad_cartas_medias_mazo([H|T], CantidadCartasMediasMazo) :-
    value(H, Value),
    Value >= 7,
    Value =< 9,
    cantidad_cartas_medias_mazo(T, R),
    CantidadCartasMediasMazo is R + 1.

cantidad_cartas_medias_mazo([H|T], CantidadCartasMediasMazo) :-
    value(H, Value),
    Value < 7,
    cantidad_cartas_medias_mazo(T, R),
    CantidadCartasMediasMazo is R + 0.

cantidad_cartas_medias_mazo([H|T], CantidadCartasMediasMazo) :-
    value(H, Value),
    Value > 9,
    cantidad_cartas_medias_mazo(T, R),
    CantidadCartasMediasMazo is R + 0.

prob_carta_media(CartasJugadas) :-
    % Obtiene el mazo (cartas no jugadas)
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_mazo(Mazo, CantidadCartasMazo),
    cantidad_cartas_medias_mazo(Mazo, CantidadCartasMediasMazo),
    ProbCartaMedia is CantidadCartasMediasMazo / CantidadCartasMazo * 100,
    write('La probabilidad de que en la siguiente tirada salga una carta media es: '), write(ProbCartaMedia), writeln(' %').

% * Reglas para calcular la probabilidad de que la siguiente carta que salga del mazo (cartas no jugadas) sea baja *
% Definicion de la regla para contar la cantidad de cartas bajas que hay en el mazo (cartas no jugadas)
cantidad_cartas_bajas_mazo([], 0).
cantidad_cartas_bajas_mazo([H|T], CantidadCartasBajasMazo) :-
    value(H, Value),
    Value >= 2,
    Value =< 6,
    cantidad_cartas_bajas_mazo(T, R),
    CantidadCartasBajasMazo is R + 1.

cantidad_cartas_bajas_mazo([H|T], CantidadCartasBajasMazo) :-
    value(H, Value),
    Value > 6,
    cantidad_cartas_bajas_mazo(T, R),
    CantidadCartasBajasMazo is R + 0.

prob_carta_baja(CartasJugadas) :-
    % Obtiene el mazo (cartas no jugadas)
    obtener_mazo(CartasJugadas, Mazo),
    cantidad_cartas_mazo(Mazo, CantidadCartasMazo),
    cantidad_cartas_bajas_mazo(Mazo, CantidadCartasBajasMazo),
    ProbCartaBaja is CantidadCartasBajasMazo / CantidadCartasMazo * 100,
    write('La probabilidad de que en la siguiente tirada salga una carta baja es: '), write(ProbCartaBaja), writeln(' %').

play(CartasJugadas) :-
    imprimir_cantidad_cartas_mazo(CartasJugadas),
    imprimir_cantidad_cartas_altas_mazo(CartasJugadas),
    imprimir_cantidad_cartas_medias_mazo(CartasJugadas),
    imprimir_cantidad_cartas_bajas_mazo(CartasJugadas),
    writeln(''),
    prob_carta_alta(CartasJugadas),
    prob_carta_media(CartasJugadas),
    prob_carta_baja(CartasJugadas),
    !.