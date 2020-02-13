%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Feb 2020 6:39 AM
%%%-------------------------------------------------------------------
-module(ch5_ex1_tests).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

start_test() ->
  Server = db,
  ?assertEqual(undefined, whereis(Server)),

  % start
  ?assertEqual(ok, ch5_ex1:start()),
  ?assertEqual(true, is_pid(whereis(Server))),

  % stop
  ?assertEqual(ok, ch5_ex1:stop()),
  ?assertEqual(undefined, whereis(Server)).

%% TODO: use https://erlang.org/doc/man/proplists.html
read_write_test() ->
  % start
  ?assertEqual(ok, ch5_ex1:start()),

  % write
  {Key, Element} = {aaron, [{bike, commencal}, {size, 29}]},
  ?assertEqual(ok, ch5_ex1:write(Key, Element)),

  % read - key exists
  ?assertEqual({ok, Element}, ch5_ex1:read(Key)),

  % read - key does not exist
  ?assertEqual({error, instance}, ch5_ex1:read(some_bad_key)),

  % stop
  ?assertEqual(ok, ch5_ex1:stop()).
