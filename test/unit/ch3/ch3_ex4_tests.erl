%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch3_ex4_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

all_test() ->
  % new
  Db = ch3_ex4:new(),
  ?assertEqual([], Db),

  % write
  Db1 = ch3_ex4:write(francesco, london, Db),
  ?assertEqual([{francesco, london}], Db1),

  Db2 = ch3_ex4:write(lelle, stockholm, Db1),
  ?assertEqual([{lelle, stockholm}, {francesco, london}], Db2),

  Db3 = ch3_ex4:write(joern, stockholm, Db2),
  ?assertEqual(
    [{joern, stockholm}, {lelle, stockholm}, {francesco, london}], Db3),

  % read
  ?assertEqual({error, instance}, ch3_ex4:read(ola, Db3)),

  ?assertEqual({ok, [london]}, ch3_ex4:read(francesco, Db3)),

  % match
  ?assertEqual([joern, lelle], ch3_ex4:match(stockholm, Db3)),

  % delete
  Db4 = ch3_ex4:delete(lelle, Db3),
  ?assertEqual(
    [{joern, stockholm}, {francesco, london}], Db4),

  % match
  ?assertEqual([joern], ch3_ex4:match(stockholm, Db4)).