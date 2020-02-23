%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Feb 2020 6:50 AM
%%%-------------------------------------------------------------------
-module(ch6_add_two).
-author("aaron lelevier").
-export([start/0, loop/0, request/1]).
-include_lib("book2/include/macros.hrl").

start() ->
  false = process_flag(trap_exit, true),
  true = register(?MODULE, spawn_link(?MODULE, loop, [])).

loop() ->
  receive
    {request, Pid, Msg} ->
      Pid ! {result, Msg + 2}
  end,
  loop().

request(Int) ->
  ?MODULE ! {request, self(), Int},
  receive
    {result, Result} -> Result;
    {'EXIT', _Pid, Reason} -> {error, Reason}
  after ?TIMEOUT -> timeout
  end.
