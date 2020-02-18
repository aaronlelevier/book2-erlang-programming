%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc pip delimited logger
%%%
%%% @end
%%% Created : 05. Feb 2020 6:39 AM
%%%-------------------------------------------------------------------
-module(ch5_log_handler2).
-author("aaron lelevier").
-export([init/1, terminate/1, handle_event/2]).

init(File) ->
  ch5_log_handler:init(File).

terminate({File, Fd}) ->
  ch5_log_handler:terminate({File, Fd}).

%% this impl is diff
handle_event({Action, Id, Event}, Fd) ->
  {MegaSec, Sec, MicroSec} = now(),
  io:format(
    Fd, "~w;~w;~w;~w;~w;~p~n",
    [MegaSec, Sec, MicroSec, Action, Id, Event]),
  Fd;
handle_event(_Event, Fd) ->
  Fd.

