%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% Roll-my-own HOF's from lists module. Ref: https://erlang.org/doc/man/lists.html
%%% @end
%%% Created : 28. Mar 2020 8:17 AM
%%%-------------------------------------------------------------------
-module(ch9_ex4).
-author("aaron lelevier").
-vsn(1.0).
-export([all/2, dropwhile/2]).
-include_lib("book2/include/macros.hrl").

%% returns true if all Pred(Elem) return true
all(_Pred, []) -> true;
all(Pred, [H|T]) ->
  case Pred(H) of
    true ->
      all(Pred, T);
    false ->
      false
  end.

dropwhile(_Pred, []) -> [];
dropwhile(Pred, [H|T]=L) ->
  case Pred(H) of
    true ->
      dropwhile(Pred, T);
    false ->
      L
  end.