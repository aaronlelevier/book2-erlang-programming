%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Feb 2020 6:19 AM
%%%-------------------------------------------------------------------
-module(ch6_ex1).
-author("aaron lelevier").
-export([start/2, print/2, stop/1, loop/0, worker/3, worker_init/3]).
-include_lib("book2/include/macros.hrl").

%% Macros
-define(SERVER, echo).

%% Public API

%% link to client here
-spec start(Name :: atom(), Link :: boolean()) -> {ok, pid()}.
start(Name, Link) ->
  Pid = spawn(?MODULE, loop, []),
  if Link =:= false ->
    void;
  true ->
    link(Pid)
  end,
  true = register(Name, Pid),
  {ok, Pid}.

print(Name, Term) ->
  Name ! {self(), {print, Term}},
  response().

%% stop should cause an abnormal exit, so client also terminated
stop(Name) ->
  Name ! {self(), stop},
  response().

response() ->
  receive
    {reply, Msg} ->
      Msg
  after
    ?TIMEOUT ->
      timeout
  end.

loop() ->
  receive
    {Pid, {print, Term}} ->
      io:format("Pid:~p prints term:~p~n", [self(), Term]),
      Pid ! {reply, ok},
      loop();
    {Pid, stop} ->
      % abnormal exit
      Pid ! {reply, ok},
      exit(self(), kill)
  end.

worker(ClientPid, Name, Link) ->
  Pid = spawn(?MODULE, worker_init, [ClientPid, Name, Link]),
  {ok, Pid}.

worker_init(ClientPid, Name, Link) ->
  {ok, Pid} = start(Name, Link),
  ClientPid ! {reply, server_started, Pid},
  ?LOG(Pid),
  worker_loop(Name).

worker_loop(Name) ->
  receive
    {Pid, stop} ->
      Pid ! {reply, ok},
      stop(Name);
    {Pid, Other} ->
      Pid ! {reply, Other},
      worker_loop(Name)
  end.

