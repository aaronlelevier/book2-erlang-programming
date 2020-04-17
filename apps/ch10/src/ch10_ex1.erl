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
-export([accumulate/1, prettyList/1, pad/2]).

accumulate(L) ->
  % unique
  L2 = sets:to_list(sets:from_list(L)),
  % sort ascending
  L3 = lists:sort(L2),
  accumulate(L3, undefined, []).

accumulate([], Item, Acc) -> lists:reverse([Item | Acc]);
accumulate([H | T], Item, Acc) ->
  case Item of
    undefined ->
      accumulate(T, {H}, Acc);
    {X} ->
      {Item2, Acc2} = if
                        H - 1 == X -> {{X, H}, Acc};
                        true -> {{H}, [{X} | Acc]}
                      end,
      accumulate(T, Item2, Acc2);
    {X, Y} ->
      {Item2, Acc2} = if
                        H - 1 == Y -> {{X, H}, Acc};
                        true -> {{H}, [{X, Y} | Acc]}
                      end,
      accumulate(T, Item2, Acc2)
  end.

%% take the results of accumulate/1 and convert to string output
prettyList(L) -> prettyList(L, []).

prettyList([], Acc) ->
  L2 = lists:join(",",  lists:reverse(Acc)),
  concat_str(L2, "");
prettyList([{X} | T], Acc) ->
  S1 = integer_to_list(X),
  prettyList(T, [S1 | Acc]);
prettyList([{X, Y} | T], Acc) ->
  S1 = integer_to_list(X),
  S2 = integer_to_list(Y),
  prettyList(T, [S1 ++ "-" ++ S2 | Acc]).

concat_str([], Str) -> Str;
concat_str([H|T], Str) ->
  concat_str(T, Str ++ H).

%% pads a Word to the right by N, given N is length than the
%% length of the string
pad(N, Word) when length(Word) > N -> Word;
pad(N, Word) -> string:right(Word, N, 32).