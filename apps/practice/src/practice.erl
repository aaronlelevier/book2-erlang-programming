%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc Functional programming practice.
%%%
%%% References:
%%% - [Functional Programming Glossary](https://degoes.net/articles/fp-glossary)
%%%
%%% @end
%%% Created : 08. May 2020 6:30 AM
%%%-------------------------------------------------------------------
-module(practice).
-author("aaron lelevier").
-vsn(1.0).
-export([]).
-compile(export_all).

map(F, L) -> [F(X) || X <- L].

filter(P, L) -> [X || X <- L, P(X) == true].

fold(_F, Acc, []) -> Acc;
fold(F, Acc0, [H|T]) ->
  Acc1 = F(H, Acc0),
  fold(F, Acc1, T).