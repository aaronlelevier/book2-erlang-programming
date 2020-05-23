%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 8:03 AM
%%%-------------------------------------------------------------------
-module(my_abstract).
-author("Aaron Lelevier").
-vsn(1.0).
-export([start/1]).

start(CallbackMod)->
  spawn(fun() -> loop(CallbackMod) end).

loop(CBM) ->
  receive
    {Sender, {do_it, A}} ->
      Sender ! CBM:fn(A),
      loop(CBM);
    stop ->
      io:format("~p (~p): Farewell!~n",
        [self(), ?MODULE]);
    Message ->
      io:format("~p (~p): Received silliness: ~tp~n",
        [self(), ?MODULE, Message]),
      loop(CBM)
  end.

