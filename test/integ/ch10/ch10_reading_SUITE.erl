%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 06. Apr 2020 7:00 AM
%%%-------------------------------------------------------------------
-module(ch10_reading_SUITE).
-author("aaron lelevier").
-vsn(1.0).
-compile(export_all).
-compile(nowarn_export_all).

-define(TABLE, countries).

all() -> [
  can_insert_records,
  can_match_on_country
].

can_insert_records(_) ->
  ch10_reading:new_table(),

  '$end_of_table' = ets:first(?TABLE),
  ch10_reading:insert_records(),

  First = ets:first(?TABLE),
  true = First /= undefined,

  ch10_reading:close_table().

can_match_on_country(_) ->
  ?TABLE = ch10_reading:new_table(),

  ch10_reading:insert_records(),

  L = ch10_reading:match("Italy"),
  true = lists:member(["Venice"], L),
  true = lists:member(["Rome"], L),

  ch10_reading:close_table().





