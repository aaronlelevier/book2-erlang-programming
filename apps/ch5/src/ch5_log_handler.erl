%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Feb 2020 6:39 AM
%%%-------------------------------------------------------------------
-module(ch5_log_handler).
-author("aaron lelevier").
-export([init/1, terminate/1, handle_event/2]).

init(File) ->
  {ok, Fd} = file:open(File, write),
  Fd.

terminate(Fd) -> file:close(Fd).

handle_event({Action, Id, Event}, Fd) ->
  {MegaSec, Sec, MicroSec} = now(),
  io:format(
    Fd, "~w,~w,~w,~w,~w,~p~n",
    [MegaSec, Sec, MicroSec, Action, Id, Event]),
  Fd;
handle_event(_Event, Fd) ->
  Fd.

