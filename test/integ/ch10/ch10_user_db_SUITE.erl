%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2020 7:20 AM
%%%-------------------------------------------------------------------
-module(ch10_user_db_SUITE).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("ch10/include/usr.hrl").

all() -> [
  add_and_update_usr,
  can_lookup_and_get_index
].

add_and_update_usr(_) ->
  ch10_user_db:create_tables("usr_db_ct.dets"),
  0 = ets:info(usrRam, size),

  ch10_user_db:add_usr(#usr{msisdn = 123, id = 1}),
  1 = ets:info(usrRam, size),

  ok = ch10_user_db:update_usr(#usr{msisdn = 456, id = 1}),

  ch10_user_db:close_tables().

can_lookup_and_get_index(_) ->
  ch10_user_db:create_tables("usr_db_ct.dets"),

  Usr1 = #usr{msisdn = 123, id = 1},
  Usr2 = #usr{msisdn = 456, id = 2},

  ch10_user_db:add_usr(Usr1),
  ch10_user_db:add_usr(Usr2),

  % lookup_id
  {ok, Usr1} = ch10_user_db:lookup_id(1),
  {error, instance} = ch10_user_db:lookup_id(-1),

  % lookup_msisdn
  {ok, Usr12} = ch10_user_db:lookup_msisdn(456),
  {error, instance} = ch10_user_db:lookup_msisdn(-123),

  % get_index
  {ok, 456} = ch10_user_db:get_index(2),
  {error, instance} = ch10_user_db:get_index(-123),

  ch10_user_db:close_tables().
