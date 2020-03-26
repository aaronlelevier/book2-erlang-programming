%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 24. Mar 2020 6:42 AM
%%%-------------------------------------------------------------------
-module(ch9_reading).
-author("aaron lelevier").
-vsn(1.0).
-export([]).
-compile(export_all).

%% apply a transformation to each item in a list

map(_F, []) -> [];
map(F, [H | T]) ->
  [F(H) | map(F, T)].

double(L) ->
  map(fun(X) -> X * 2 end, L).

double2(L) ->
  map(times(2), L).

%% reverse each item in a 2d list
revAll(L) ->
  map(fun(X) -> lists:reverse(X) end, L).

%% predicate - a function that returns a boolean

%% filter a list using a predicate

even(X) -> X rem 2 =:= 0.

filter(_P, []) -> [];
filter(P, [H | T]) ->
  case P(H) of
    true ->
      [H | filter(P, T)];
    _ ->
      filter(P, T)
  end.

%% funs can have side effects

printer() ->
  fun(X) -> io:format("~p~n", [X]) end.

sendTo(Pid) ->
  fun(X) -> Pid ! X end.

%% functions as results

times(X) -> fun(Y) -> X * Y end.

%% use already defined functions

double_value(X) -> X * 2.

exponent_value(X) -> X * X.

map_values(L) ->
  lists:map(fun double_value/1, L).

%% applies all Functions in the list of Funs to get the final Value
combine(Value, []) -> Value;
combine(Value, [F | Funs]) -> combine(F(Value), Funs).

%% fold a list traverses a list and has a reference to the item and the
%% accumulator on each iter over the list
fold() -> lists:foldl(fun(X, Prod) -> X * Prod end, 1, [1, 2, 3]).