%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% Higher-order functions
%%% @end
%%% Created : 27. Mar 2020 7:05 AM
%%%-------------------------------------------------------------------
-module(ch9_ex1).
-author("aaron lelevier").
-vsn(1.0).
-export([sequential_int_hof/2, filter_list_by_n/2]).
-compile(export_all).

%% hof that applies the function `F` to each integer in a list 1..N
sequential_int_hof(F, N) ->
  [F(X) || X <- lists:seq(1, N)].

filter_list_by_n(P, L) ->
  [X || X <- L, P(X)].

%% filter list L by predicate P and call Fun on each item of the filtered list
filter_map(P, L, Fun) ->
  [Fun(X) || X <- L, P(X)].

fold(_Fun, Acc, []) -> Acc;
fold(Fun, Acc, [H|T]) ->
  fold(Fun, Fun(H, Acc), T).



