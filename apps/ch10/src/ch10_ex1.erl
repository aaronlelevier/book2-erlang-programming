%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 14. Apr 2020 5:46 AM
%%%-------------------------------------------------------------------
-module(ch10_ex1).
-author("aaron lelevier").
-vsn(1.0).
-export([accumulate/1]).

accumulate(L) ->
  % unique
  L2 = sets:to_list(sets:from_list(L)),
  % sort ascending
  L3 = lists:sort(L2),
  accumulate(L3, undefined, []).

accumulate([], Item, Acc) -> lists:reverse([Item|Acc]);
accumulate([H|T], Item, Acc) ->
  case Item of
    undefined ->
      accumulate(T, {H}, Acc);
    {X} ->
      {Item2, Acc2} = if
        H - 1 == X -> {{X, H}, Acc};
        true -> {{H}, [{X}|Acc]}
      end,
      accumulate(T, Item2, Acc2);
    {X, Y} ->
      {Item2, Acc2} = if
        H - 1 == Y -> {{X, H}, Acc};
        true -> {{H}, [{X, Y}|Acc]}
      end,
      accumulate(T, Item2, Acc2)
  end.
