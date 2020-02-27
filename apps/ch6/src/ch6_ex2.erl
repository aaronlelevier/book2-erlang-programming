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
%% me - server
-export([status/0]).
%% me - client
-export([start_client/0, client_loop/0]).

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
      {ok, {status, busy}}
  after
    ?TIMEOUT ->
      {wait_timeout, {status, busy}}
  end.

%% releases the mutex
signal() ->
  ?DEBUG(signal),
  ?MUTEX_SERVER ! {signal, self()},
  {ok, {status, free}}.

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
      Pid ! ok;
    Other ->
      ?DEBUG({error, Other}),
      free()
  end.

busy(Pid) ->
  ?DEBUG(busy),
  receive
    {status, Pid} ->
      Pid ! {status, busy},
      busy(Pid);
    {signal, Pid} ->
      free();
    {status, ClientPid} ->
      ClientPid ! {status, busy},
      busy(Pid);
    Other ->
      ?DEBUG({error, Other}),
      busy(Pid)
  end.

status() ->
  ?MUTEX_SERVER ! {status, self()},
  receive
    {status, Status} ->
      {status, Status}
  after
    ?TIMEOUT ->
      timeout
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

start_client() ->
  Pid = spawn(?MODULE, client_loop, []),
  {ok, Pid}.

client_loop() ->
  ?DEBUG(client_loop),
  receive
    {wait, Pid} ->
      Pid ! ok,
      wait(),
      client_loop();
    {signal, Pid} ->
      signal(),
      Pid ! ok,
      client_loop()
  end.
