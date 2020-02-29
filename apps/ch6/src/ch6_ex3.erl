%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Feb 2020 6:45 AM
%%%-------------------------------------------------------------------
-module(ch6_ex3).
-author("aaron lelevier").
-include_lib("book2/include/macros.hrl").

%% API
-export([start_link/2, stop/1, init/2, children/2]).

start_link(Name, ChildSpecList) ->
  Pid = spawn_link(?MODULE, init, [self(), ChildSpecList]),
  register(Name, Pid),
  % wait for the spawned supervisor process to signal that it is done
  % spawning all child processes
  receive {Pid, done} -> void end,
  ok.

init(ClientPid, ChildSpecList) ->
  process_flag(trap_exit, true),
  loop(ClientPid, start_children(ClientPid, ChildSpecList)).

start_children(ClientPid, []) ->
  ClientPid ! {self(), done},
  [];
start_children(ClientPid, [{Mode, M, F, A} | ChildSpecList]) ->
  case (catch apply(M, F, A)) of
    {ok, Pid} ->
      [{Pid, {Mode, M, F, A}} | start_children(ClientPid, ChildSpecList)];
    _ ->
      start_children(ClientPid, ChildSpecList)
  end.

children(Name, count) ->
  call(Name, count).

call(Name, count) ->
  Name ! {count, self()},
  receive
    {reply, Reply} ->
      Reply
  after
    ?TIMEOUT ->
      call_timeout
  end.

reply(To, Msg) ->
  To ! {reply, Msg}.

loop(ClientPid, ChildList) ->
  receive
    {'EXIT', Pid, _Reason} ->
      NewChildList = restart_children(Pid, ChildList),
      ClientPid ! {self(), children_restarted},
      loop(ClientPid, NewChildList);
    {count, From} ->
      reply(From, length(ChildList)),
      loop(ClientPid, ChildList);
    {stop, From} ->
      From ! {reply, terminate(ChildList)}
  end.

restart_children(Pid, ChildList) ->
  {value, {Pid, {Mode, M, F, A}}} = lists:keysearch(Pid, 1, ChildList),
  ChildList2 = lists:keydelete(Pid, 1, ChildList),
  NewChildList = case Mode of
                   transient ->
                     ChildList2;
                   permanent ->
                     {ok, NewPid} = apply(M, F, A),
                     [{NewPid, {Mode, M, F, A}} | ChildList2]
                 end,
  NewChildList.

terminate([]) -> ok;
terminate([{Pid, _} | ChildList]) ->
  exit(Pid, kill),
  terminate(ChildList).

stop(Name) ->
  Name ! {stop, self()},
  receive
    {reply, Reply} -> Reply
  end.
