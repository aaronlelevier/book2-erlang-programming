%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 30. May 2020 8:00 AM
%%%-------------------------------------------------------------------
-module(ch12_db_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").


ch12_db_setup() -> ok.


ch12_db_cleanup(_) -> ok.


start() ->
  {ok, Pid} = ch12_db:start(),
  ?assert(is_pid(Pid)),
  ?assertEqual(Pid, whereis(ch12_db)).


write() ->
  Key = foo,
  Element = bar,
  % pre-test
  ?assertEqual({error, instance}, ch12_db:read(Key)),

  ?assertEqual(ok, ch12_db:write(Key, Element)),

  ?assertEqual({ok, Element}, ch12_db:read(Key)).


delete() ->
  Key = biz,
  Element = baz,
  % pre-test
  ?assertEqual(ok, ch12_db:write(Key, Element)),

  ?assertEqual(ok, ch12_db:delete(Key)),

  ?assertEqual({error, instance}, ch12_db:read(Key)).

read() ->
  Key = person,
  Element = bob,
  Element2 = gary,

  ?assertEqual(ok, ch12_db:write(Key, Element)),
  ?assertEqual(ok, ch12_db:write(Key, Element2)),

  % first matched element returned
  % this is the last element that was saved to the DB
  ?assertEqual({ok, Element2}, ch12_db:read(Key)).


match() ->
  Key = person,
  Key2 = name,
  Element = john,

  ?assertEqual(ok, ch12_db:write(Key, Element)),
  ?assertEqual(ok, ch12_db:write(Key2, Element)),

  ?assertEqual([Key2, Key], ch12_db:match(Element)).


stop() ->
  ?assertEqual(ok, ch12_db:stop()),

  ?assertEqual(undefined, whereis(ch12_db)).


ch12_db_test_() ->
  {setup,
    fun ch12_db_setup/0,
    fun ch12_db_cleanup/1,
    [
      fun start/0,
      fun write/0,
      fun delete/0,
      fun read/0,
      fun match/0,
      fun stop/0
    ]
  }.