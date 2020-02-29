%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Feb 2020 6:50 AM
%%%-------------------------------------------------------------------
-module(ch6_add_one2).
-author("aaron lelevier").
-export([start/0, loop/0, request/1]).
-include_lib("book2/include/macros.hrl").

start() ->
  Pid = spawn_link(?MODULE, loop, []),
  register(?MODULE, Pid),
  {ok, Pid}.

loop() ->
  receive
    {request, Pid, Msg} ->
      Pid ! {result, Msg + 1}
  end,
  loop().

request(Int) ->
  ?MODULE ! {request, self(), Int},
  receive
    {result, Result} -> Result
  after ?TIMEOUT -> timeout
  end.
