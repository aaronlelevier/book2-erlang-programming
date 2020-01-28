%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:33 AM
%%%-------------------------------------------------------------------
-module(ch3_ex4).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("book2/include/macros.hrl").

%% Types

-type db() :: [{atom(), any()}].

%% Public API

new() -> [].

destroy(_Db) -> ok.

write(Key, Element, Db) ->
  [{Key, Element}|Db].

delete(Key, Db) ->
  [{Key2, Element} || {Key2, Element} <- Db, Key =/= Key2].

%% searches Db based on `Key` and returns a list of matched `Elements`
-spec read(Key::atom(), Db::db()) -> {ok, Element::any()} | {error, instance}.
read(Key, Db) ->
  L = read(Key, Db, []),
  case L =:= [] of
    true -> {error, instance};
    _ -> {ok, L}
  end.

read(_Key, [], Acc) -> Acc;
read(Key, [H|T], Acc) ->
  {Key2, Element} = H,
  Acc2 = case Key =:= Key2 of
    true -> [Element|Acc];
    _ -> Acc
  end,
  read(Key, T, Acc2).

%% searches Db based on `Element` and returns a list of matched `Keys`
match(Element, Db) ->
  [Key || {Key,El} <- Db, Element =:= El].
