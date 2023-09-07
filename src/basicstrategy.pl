:- use_module(library(csv)).
% basic_strategy/3
% H - Player's hand value
% D - Dealer's card value
% A - Action (hit, stand, double, split)

basic_strategy(H, D, A) :- basic(hard, H, D, A).
basic_strategy(H, D, A) :- basic(soft, H, D, A).

basic(hard, H, _, stand) :- H > 16.
basic(hard, H, _, hit)   :- H < 9.
basic(hard, H, D, Action) :- basic_hard(H, D, Action).

basic(soft, H, _, stand) :- H > 19.
basic(soft, H, _, hit) :- H < 18.
basic(soft, H, D, Action) :- basic_soft(H, D, Action).

:- 
  csv_read_file('basic_hard.csv', Rows, [functor(basic_hard), arity(3)]),
  maplist(assert, Rows).

:- 
  csv_read_file('basic_soft.csv', Rows, [functor(basic_soft), arity(3)]),
  maplist(assert, Rows).