%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Feb 2020 5:56 AM
%%%-------------------------------------------------------------------
-module(ch5_mutex).
-author("aaron lelevier").

%% exports
-export([start/0, stop/0]).
-export([wait/0, signal/0]).
-export([init/0]).

%% me
-export([client_loop/0]).

-include_lib("book2/include/macros.hrl").

-define(MUTEX_SERVER, ?MODULE).

start() ->
  Pid = spawn(?MODULE, init, []),
  register(?MUTEX_SERVER, Pid),
  Pid.

stop() ->
  ?MUTEX_SERVER ! {stop, self()}.

wait() ->
  ?MUTEX_SERVER ! {wait, self()},
  receive
    ok ->
      ok
  end.

signal() ->
  ?DEBUG(signal),
  ?MUTEX_SERVER ! {signal, self()},
  ok.

init() -> free().

free() ->
  ?DEBUG(free),
  receive
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
    {signal, Pid} ->
      free()
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
    wait ->
      wait(),
      client_loop();
    {signal, Pid} ->
      signal(),
      Pid ! ok
  end.