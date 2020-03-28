%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2020 8:17 AM
%%%-------------------------------------------------------------------
-module(ch9_ex3).
-author("aaron lelevier").
-vsn(1.0).
-export([zip/2, zipWith/3]).

zip(L1, L2) ->
  [{lists:nth(N, L1), lists:nth(N, L2)} || N <- lists:seq(1, length(L1))].

zipWith(Fun, L1, L2) ->
  [
    Fun(lists:nth(N, L1), lists:nth(N, L2))
    || N <- lists:seq(1, length(L1))
  ].
