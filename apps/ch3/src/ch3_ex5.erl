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
-export([filter/2, reverse/1, concatenate/1, concat/1, flatten/1]).

%% filters the list `L` by less-than-or-equal to `Val`
filter(L, Val) -> [X || X <- L, X =< Val].

%% reverse list `L`
reverse(L) ->
  reverse(L, []).
reverse([], Acc) -> Acc;
reverse([H | T], Acc) ->
  reverse(T, [H | Acc]).

%% concatenates a list of 1d lists to a single 1d list
concatenate([]) -> [];
concatenate([H | T]) ->
  H ++ concatenate(T).

concat(L) ->
  concat(L, L, []).

concat([], [], Acc) -> reverse(Acc);
concat([], [H|T], Acc) ->
  concat(H, T, Acc);
concat([H|T], Ml, Acc) ->
  case is_list(H) of
    true -> concat(H, T, Acc);
    _ -> concat(T, Ml, [H|Acc])
  end.

%% flattens a list of Nd lists to a 1d list
%% credit: https://stackoverflow.com/a/9346017/1913888
flatten(X) -> lists:reverse(flatten(X, [])).

flatten([], Acc) -> Acc;
flatten([H | T], Acc) when is_list(H) -> flatten(T, flatten(H, Acc));
flatten([H | T], Acc) -> flatten(T, [H | Acc]).

