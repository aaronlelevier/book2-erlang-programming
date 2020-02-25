%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Feb 2020 6:51 AM
%%%-------------------------------------------------------------------
-module(ch6_ex1_tests).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  ?assert(true).

echo_server_not_linked_test() ->
  Server = server,
  {ok, Pid} = ch6_ex1:start(Server, false),
  ?assertEqual({status, runnable}, process_info(Pid, status)),

  ?assertEqual(ok, ch6_ex1:stop(server)),

  ?assertEqual(undefined, process_info(Pid, status)).

echo_server_linked_to_client_test() ->
  Server = server_b,
  {ok, WorkerPid} = ch6_ex1:worker(self(), Server, true),
  ServerPid = receive {reply, server_started, Reply} -> Reply end,
  ?assertEqual({status, waiting}, process_info(WorkerPid, status)),
  ?assertEqual({status, waiting}, process_info(ServerPid, status)),

  ?assertEqual(ok, ch6_ex1:stop(Server)),

  ?assertEqual(undefined, process_info(WorkerPid)),
  ?assertEqual(undefined, process_info(ServerPid)).
