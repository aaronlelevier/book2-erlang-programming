%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 06. Jun 2020 8:22 AM
%%%-------------------------------------------------------------------
-module(dlock_worker_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").

start_monitor_test() ->
  Items = [app1],
  Callback = {pid, self()},
  Timeout = 1000,
  Req = dlock:build_request(Items, Callback, Timeout),
  {ok, {Pid, _Ref}} = dlock_worker:start_monitor(Req),

  State = dlock_worker:get_state(Pid),

  ?assertEqual(Req, State).