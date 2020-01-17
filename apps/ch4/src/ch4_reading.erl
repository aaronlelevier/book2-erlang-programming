%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Jan 2020 6:29 AM
%%%-------------------------------------------------------------------
-module(ch4_reading).
-author("aaron lelevier").
-compile(export_all).
-export([]).

-define(TIMEOUT, 1000).

echo(Msg) ->
  Pid = spawn(?MODULE, loop, []),
  Pid ! {self(), Msg},
  receive
    {Pid, Msg} ->
      io:format("echo: ~p~n", [Msg])
  after
    ?TIMEOUT ->
      timeout
  end.

loop() ->
  receive
    {Pid, Msg} ->
      Pid ! {self(), Msg},
      loop();
    stop ->
      true;
    Other ->
      io:format(
        "unknown msg: ~p~n", [Other]),
      loop()
  end.

%% registered process receive
registered_echo(Msg) ->
  register(
    looper, spawn(?MODULE, loop, [])),
  looper ! {self(), Msg},
  Result = receive
             {_Pid, Msg} ->
               io:format("echo: ~p~n", [Msg])
           after
             ?TIMEOUT ->
               timeout
           end,
  exit(whereis(looper), "timed out"),
  Result.

%% @doc logs the time of the sleep, which is the same time
%% as the TIMEOUT
sleep() ->
  statistics(wall_clock),
  receive
  after
    ?TIMEOUT ->
      {_, Time} = statistics(wall_clock),
      io:format(
        "sleep time=~p~n", [Time])
  end.

%% TODO: transfer func that uses 3 Pids and tranfers a Msg
%% from Pid1 -> Pid2 -> Pid3
%% and Pid3 will respond to Pid1
