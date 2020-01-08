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

%% Types

-type db() :: [{atom(), any()}].

%% Public API

new() -> [].

destroy(Db) -> ok.

write(Key, Element, Db) ->
  [{Key, Element}|Db].

delete(Key, Db) -> new_db.

-spec read(Key::atom(), Db::db()) -> {ok, Element::any()} | {error, instance}.
read(Key, Db) -> {ok, element}.

match(Element, Db) -> [].
