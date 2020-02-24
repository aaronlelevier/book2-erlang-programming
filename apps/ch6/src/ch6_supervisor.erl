%%%-------------------------------------------------------------------
%%% @author alelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Feb 2020 9:48 AM
%%%-------------------------------------------------------------------
-module(ch6_supervisor).
-author("alelevier").

%% API
-export([start_link/2, stop/1, init/1]).

start_link(Name, ChildSpecList) ->
  register(Name, spawn_link(?MODULE, init, [ChildSpecList])), ok.

init(ChildSpecList) ->
  process_flag(trap_exit, true),
  loop(start_children(ChildSpecList)).


start_children([]) -> [];
start_children([{M, F, A} | ChildSpecList]) ->
  case (catch apply(M, F, A)) of
    {ok, Pid} ->
      [{Pid, {M, F, A}} | start_children(ChildSpecList)];
    _ ->
      start_children(ChildSpecList)
  end.

loop(ChildList) ->
  receive
    {'EXIT', Pid, _Reason} ->
      NewChildList = restart_children(Pid, ChildList),
      loop(NewChildList);
    {stop, From} ->
      From ! {reply, terminate(ChildList)}
  end.

restart_children(Pid, ChildList) ->
  {value, {Pid, {M, F, A}}} = lists:keysearch(Pid, 1, ChildList),
  {ok, NewPid} = apply(M, F, A),
  [{NewPid, {M, F, A}} | lists:keydelete(Pid, 1, ChildList)].

terminate([]) -> ok;
terminate([{Pid, _}|ChildList]) ->
  exit(Pid, kill),
  terminate(ChildList).

stop(Name) ->
  Name ! {stop, self()},
  receive
    {reply, Reply} -> Reply
  end.
