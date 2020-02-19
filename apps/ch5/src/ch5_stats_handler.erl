%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2020 5:02 AM
%%%-------------------------------------------------------------------
-module(ch5_stats_handler).
-author("aaron lelevier").
-compile(export_all).
-export([init/1, terminate/1, handle_event/2]).

init(State) -> State.

terminate(State) -> State.

handle_event({Action, _Id, Event}, State) ->
  Key = {Action, Event},
  NewState = case proplists:lookup(Key, State) of
    {Key, Val} ->
      L = proplists:delete(Key, State),
      [{Key, Val+1}|L];
    none ->
      [{Key, 1}|State]
  end,
  NewState;
handle_event(_Event, Fd) ->
  Fd.

