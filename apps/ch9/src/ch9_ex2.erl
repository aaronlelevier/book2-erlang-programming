%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% List comprehensions
%%% @end
%%% Created : 28. Mar 2020 7:27 AM
%%%-------------------------------------------------------------------
-module(ch9_ex2).
-author("aaron lelevier").
-vsn(1.0).
-export([
  divisible_by/2, integers_squared/1, intersection/2,
  symmetric_diff/2]).

divisible_by(N, L) -> [X || X <- L, X rem N =:= 0].

integers_squared(L) -> [X * X || X <- L, is_integer(X)].

intersection(L1, L2) ->
  [X || X <- L1, Y <- L2, X =:= Y].

symmetric_diff(L1, L2) ->
  lists:merge(
    [X || X <- L1, not lists:member(X, L2)],
    [Y || Y <- L2, not lists:member(Y, L1)]
  ).
