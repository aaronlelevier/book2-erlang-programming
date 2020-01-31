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
-include_lib("book2/include/macros.hrl").

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

%% from Pid1 -> Pid2 -> Pid3
%% and Pid3 will respond to Pid1
transfer(Msg) ->
  % this Pid is Pid1!
  Self = self(),
  ?DEBUG({start, Self}),

  % spawns
  Pid2 = spawn(?MODULE, forward_loop, [Self]),
  ?DEBUG({forward_loop, Pid2}),

  Pid3 = spawn(?MODULE, forward_loop, [Self]),
  ?DEBUG({forward_loop_2, Pid3}),

  ?DEBUG({pid1, Self}),
  ?DEBUG({pid2, Pid2}),
  ?DEBUG({pid3, Pid3}),

  % 1st forward includes the Pid to forward to
  Pid2 ! {forward, Pid3, Msg},
  ?DEBUG(first_msg_sent),

  % Self receives forwarded message back from Pid3
  log_loop().

log_loop() ->
  receive
    Msg -> Msg
  after ?TIMEOUT ->
    log_loop_timeout
  end.

forward_loop(Pid0) ->
  receive
    {forward, Pid, Msg} = Ctx ->
      ?DEBUG({Ctx, self()}),
      % 2nd forward doesn't include a Pid to forward to
      Pid ! {forward, Msg},
      forward_loop(Pid0);
    {forward, Msg} = Ctx2 ->
      ?DEBUG({Ctx2, self(), Pid0}),
      % Final Msg is sent back to Self
      Pid0 ! Msg,
      forward_loop(Pid0)
  after
    ?TIMEOUT -> forward_loop_timeout
  end.
