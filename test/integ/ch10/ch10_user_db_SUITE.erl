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
  add_and_update_usr
].

add_and_update_usr(_) ->
  ch10_user_db:create_tables("usr_db_ct.dets"),
  0 = ets:info(usrRam, size),

  ch10_user_db:add_usr(#usr{msisdn = 123, id = 1}),
  1 = ets:info(usrRam, size),

  ok = ch10_user_db:update_usr(#usr{msisdn = 456, id = 1}),

  ch10_user_db:close_tables().
