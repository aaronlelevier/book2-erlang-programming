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

-record(state, {
  client_pid,
  % { transient/permanent, M, F, A}
  child_spec_list = [],
  % {Pid, {M, F, A}}
  child_list = [],
  % map counter of child restarts: #{ {M,F,A} = 0 }
  child_restarts = #{}
}).

%% API
-export([start_link/2, stop/1, init/1, children/2]).
%% helpers
-export([child_restarts/2]).

start_link(Name, ChildSpecList) ->
  State = #state{
    client_pid = self(), child_spec_list = ChildSpecList},
  Pid = spawn_link(?MODULE, init, [State]),
  register(Name, Pid),
  % wait for the spawned supervisor process to signal that it is done
  % spawning all child processes
  receive {Pid, done} -> void end,
  ok.

init(State) ->
  process_flag(trap_exit, true),
  ?DEBUG({state, State}),
  ChildList = start_children(State, State#state.child_spec_list),
  State2 = State#state{child_list = ChildList},
  ?DEBUG({state2, State2}),
  loop(State2).

start_children(State, []) ->
  ?DEBUG({state, State}),
  ClientPid = State#state.client_pid,
  ClientPid ! {self(), done},
  [];
start_children(State, [{Mode, M, F, A} | ChildSpecList]) ->
  ?DEBUG({state, State}),
   case (catch apply(M, F, A)) of
    {ok, Pid} ->
      ?DEBUG({child_started, {M, F, A}, Pid}),
      [{Pid, {Mode, M, F, A}} | start_children(State, ChildSpecList)];
    _ ->
      ChildRestarts = child_restarts({M,F}, State#state.child_restarts),
      State2 = State#state{child_restarts = ChildRestarts},
      start_children(State2, ChildSpecList)
  end.

children(Name, count) -> call(Name, count).

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

loop(State) ->
  ClientPid = State#state.client_pid,
  ChildList = State#state.child_list,
  receive
    {'EXIT', Pid, _Reason} ->
      NewChildList = restart_children(Pid, ChildList),
      ClientPid ! {self(), children_restarted},
      State2 = State#state{child_list = NewChildList},
      loop(State2);
    {count, From} ->
      reply(From, length(ChildList)),
      loop(State);
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

%% helpers

child_restarts(Key, Map) ->
  Value = maps:get(Key, Map, 0),
  Map#{Key => Value + 1}.
