%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Feb 2020 6:21 AM
%%%-------------------------------------------------------------------
-module(ch6_ex2).
-author("aaron lelevier").

%% exports
-export([start/0, stop/0]).
-export([wait/0, signal/0]).
-export([init/0]).
%% me
-export([client_loop/0, status/0]).

-include_lib("book2/include/macros.hrl").

%% macros
-define(MUTEX_SERVER, ?MODULE).

start() ->
  Pid = spawn(?MODULE, init, []),
  register(?MUTEX_SERVER, Pid),
  {ok, Pid}.

stop() ->
  ?MUTEX_SERVER ! {stop, self()}, ok.

wait() ->
  ?MUTEX_SERVER ! {wait, self()},
  receive
    ok ->
      ok
  end.

%% releases the mutex
signal() ->
  ?DEBUG(signal),
  ?MUTEX_SERVER ! {signal, self()},
  ok.

init() -> free().

free() ->
  ?DEBUG(free),
  receive
    {status, Pid} ->
      Pid ! {status, free},
      free();
    {wait, Pid} ->
      Pid ! ok,
      busy(Pid);
    {stop, Pid} ->
      terminate(),
      Pid ! ok
  end.

busy(Pid) ->
  ?DEBUG(busy),
  receive
    {status, Pid} ->
      Pid ! {status, busy},
      busy(Pid);
    {signal, Pid} ->
      free()
  end.

status() ->
  ?MUTEX_SERVER ! {status, self()},
  receive
    {status, Status} ->
      {status, Status}
  end.

terminate() ->
  ?DEBUG(terminate),
  receive
    {wait, Pid} ->
      exit(Pid, kill),
      terminate()
  after
    0 -> ok
  end.

%% client loop
client_loop() ->
  receive
    {wait, Pid} ->
      Pid ! ok,
      wait(),
      client_loop();
    {signal, Pid} ->
      signal(),
      Pid ! ok
  end.