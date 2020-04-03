%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% Playing with ETS tables
%%% @end
%%% Created : 01. Apr 2020 6:26 AM
%%%-------------------------------------------------------------------
-module(ch10_reading).
-author("aaron lelevier").
-vsn(1.0).
-export([]).
-compile(export_all).
-include_lib("ch10/include/countries.hrl").

-define(TABLE, countries).

tools_table() ->
  % create table
  Table = ets:new(tools, [named_table]),

  % single insert
  true = ets:insert(Table, {cassette_lockring, 0}),

  % multiple insert
  true = ets:insert(Table, [{chain_whip, 0}, {master_link_pliers, 0}]),

  % save to file
  ok = ets:tab2file(Table, "tools.ets").


%% records example

new_table() ->
  ets:new(?TABLE, [named_table, {keypos, #capital.name}]).

close_table() ->
  ets:delete(?TABLE).

insert_records() ->
  ets:insert(?TABLE, #capital{name="Budapest", country="Hungary", pop=240}),
  ets:insert(?TABLE, #capital{name="Prestoria", country="South Africa", pop=240}),
  ets:insert(?TABLE, #capital{name="Rome", country="Italy", pop=550}).
