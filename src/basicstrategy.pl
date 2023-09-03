:- use_module(library(csv)).
% basic_strategy/3
% H - Player's hand value
% D - Dealer's card value
% A - Action (hit, stand, double, split)

basic_strategy(H, D, A) :-
  % Se debe implementar la estrategia según mano suave o dura.
  basic(hard, H, D, A).

basic(hard, H, _, stand) :- H > 16.
basic(hard, H, _, hit)   :- H < 9.
basic(hard, H, D, Action) :- basic_hard(H, D, Action).

basic(soft, _, _, no_implementada). % implementar la estrategia suave.

:- 
  csv_read_file('basic_hard.csv', Rows, [functor(basic_hard), arity(3)]),
  maplist(assert, Rows).
  % Construir basic_soft en función del archivo basic_soft.csv

