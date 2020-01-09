%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:33 AM
%%%-------------------------------------------------------------------
-module(ch3_ex5).
-author("aaron lelevier").
-compile(export_all).

%% filters the list `L` by less-than-or-equal to `Val`
filter(L, Val) -> [X || X <- L, X =< Val].

%% reverse list `L`
reverse(L) ->
  reverse(L, []).
reverse([], Acc) -> Acc;
reverse([H|T], Acc) ->
  reverse(T, [H|Acc]).

%% concatenates a list of 1d lists to a single 1d list
concatenate(L) -> L.

%% flattens a list of Nd lists to a 1d list
flatten(L) -> L.