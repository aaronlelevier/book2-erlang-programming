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
%% debug
-compile(export_all).

%% Public API

start_link(ChildSpecList) ->
  State = #{
    client_pid => self(),
    child_specs => ChildSpecList,
    children => []
  },
  Pid = spawn_link(?MODULE, init, [State]),
  register(?MODULE, Pid),
  % wait for all child processes to spawn
  receive {Pid, done} -> void end,
  ok.

stop() -> ok.

children() -> call(children).

%% Private API

init(State) ->
  process_flag(trap_exit, true),
  State2 = start_children(State),
  reply_done(State2),
  loop(State2).

reply_done(State) ->
  #{client_pid := ClientPid} = State,
  ClientPid ! {self(), done}.

%% take the `child_specs` list, spawn each child, and
%% populate the `children` list
start_children(State) ->
  #{child_specs := ChildSpecs} = State,
  start_children(State, ChildSpecs).

start_children(State, []) -> State;
start_children(State, [{Mode, M, F, A} | ChildSpecs]) ->
  Child = init_child({Mode, M, F, A}),
  #{children := Children} = State,
  State2 = State#{
    children := [Child | Children]
  },
  start_children(State2, ChildSpecs).

%% TODO: test in isolation
init_child({Mode, M, F, A}) ->
  {ok, Pid} = apply(M, F, A),
  UniqueId = make_ref(),
  Restarts = 0,
  {UniqueId, Pid, {M,F,A}, Mode, Restarts}.


call(Msg) ->
  ?MODULE ! {self(), Msg},
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
  receive
    {From, children} ->
      reply(From, maps:get(children, State)),
      loop(State);
    Other ->
      ?LOG({error, Other})
  end.
%%  ClientPid = State#state.client_pid,
%%  ChildList = State#state.child_list,
%%  receive
%%    {'EXIT', Pid, _Reason} ->
%%      NewChildList = restart_children(Pid, ChildList),
%%      ClientPid ! {self(), children_restarted},
%%      State2 = State#state{child_list = NewChildList},
%%      loop(State2);
%%    {count, From} ->
%%      reply(From, length(ChildList)),
%%      loop(State);
%%    {stop, From} ->
%%      From ! {reply, terminate(ChildList)}
%%  end.

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
