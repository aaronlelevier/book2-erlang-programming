-module(ch5_client_server_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

start_stop_test() ->
  ServerName = ch5_client_server:server_name(),
  ?assertEqual(
    undefined, whereis(ServerName)),

  % start - starts and registers server
  ch5_client_server:start(),
  ?assert(is_pid(whereis(ServerName))),

  % stop - stops server
  ch5_client_server:stop(),
  ?assertEqual(
    undefined, whereis(ServerName)).

allocate_deallocate_test() ->
  ch5_client_server:start(),

  {ok, 1} = ch5_client_server:allocate(),
  {ok, 2} = ch5_client_server:allocate(),
  {error, no_frequencies} = ch5_client_server:allocate(),

  ok = ch5_client_server:deallocate(1),
  {ok, 1} = ch5_client_server:allocate(),

  ch5_client_server:stop().
