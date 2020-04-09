%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2020 6:48 AM
%%%-------------------------------------------------------------------
-module(ch10_user_db_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

create_and_close_tables_test() ->
  % no tables
  ?assertEqual(undefined, ets:info(usrRam)),
  ?assertEqual(undefined, ets:info(usrIndex)),
  ?assertEqual(undefined, dets:info(usrDisk)),

  ch10_user_db:create_tables("ch10_user_db.dets"),

  % all exist
  ?assertNotEqual(undefined, ets:info(usrRam)),
  ?assertNotEqual(undefined, ets:info(usrIndex)),
  ?assertNotEqual(undefined, dets:info(usrDisk)),

  ch10_user_db:close_tables(),

  % all closed
  ?assertEqual(undefined, ets:info(usrRam)),
  ?assertEqual(undefined, ets:info(usrIndex)),
  ?assertEqual(undefined, dets:info(usrDisk)).

