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
-include_lib("book2/include/macros.hrl").

-include_lib("stdlib/include/ms_transform.hrl").


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
  ets:new(countries, [named_table, {keypos, #capital.name}]).

close_table() ->
  ets:delete(countries).

insert_records() ->
  ets:insert(countries, #capital{name="Budapest", country="Hungary", pop=240}),
  ets:insert(countries, #capital{name="Prestoria", country="South Africa", pop=240}),
  ets:insert(countries, #capital{name="Rome", country="Italy", pop=550}),
  ets:insert(countries, #capital{name="Venice", country="Italy", pop=150}).

match(Country) ->
  ets:match(countries, #capital{name='$1', country = Country, _ = '_'}).

match_object(Country) ->
  ets:match_object(countries, #capital{country = Country, _ = '_'}).

%% NOTE: works w/o above header, must generate "MS" in the shell
%% MS = ets:fun2ms(fun(#capital{pop = P, name = N}) when P < 300 -> N end).
select(MS) ->
  ets:select(countries, MS).

%% NOTE: this header must be included above for "MS" to work!!
%%-include_lib("stdlib/include/ms_transform.hrl").
select() ->
  MS = ets:fun2ms(fun(#capital{pop = P, name = N}) when P < 300 -> N end),
  ets:select(countries, MS).
