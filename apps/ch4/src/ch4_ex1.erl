%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Jan 2020 5:51 AM
%%%-------------------------------------------------------------------
-module(ch4_ex1).
-author("aaron lelevier").
-export([start/0, print/1, stop/0, loop/0]).
-include_lib("book2/include/macros.hrl").

%% Macros
-define(SERVER, echo).

%% Public API

start() ->
  try register(?SERVER, spawn(?MODULE, loop, [])) of
    true ->
      ok
  catch
    error:badarg -> {error, already_started}
  end.

print(Term) ->
  echo ! {self(), {print, Term}},
  response().

stop() ->
  echo ! {self(), stop},
  response().

response() ->
  receive
    {echo, Msg} ->
      Msg
  after
    ?TIMEOUT ->
      timeout
  end.

loop() ->
  receive
    {Pid, {print, Term}} ->
      io:format("print term: ~p~n", [Term]),
      Pid ! {echo, ok},
      loop();
    {Pid, stop} ->
      Pid ! {echo, ok}
  end.
