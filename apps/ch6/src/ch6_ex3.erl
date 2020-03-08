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

children() -> call(children).

-spec start_child({
  Mode :: transient | permanent,
  M :: atom(),
  F :: atom(),
  A :: atom()
}) -> Id :: reference().
start_child({Mode, M, F, A}) -> call({start_child, {Mode, M, F, A}}).

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

init_child({Mode, M, F, A}) ->
  {ok, Pid} = apply(M, F, A),
  UniqueId = make_ref(),
  Restarts = 0,
  {UniqueId, Pid, {M, F, A}, Mode, Restarts}.

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
    {From, {start_child, {Mode, M, F, A}}} ->
      {State2, UniqueId} = start_child(State, {Mode, M, F, A}),
      reply(From, UniqueId),
      loop(State2);
    {From, stop} ->
      ?LOG(State),
      From ! {reply, terminate(State)};
    {'EXIT', Pid, _Reason} ->
      State2 = restart_children(Pid, State),
      loop(State2);
    Other ->
      ?LOG({error, Other})
  end.

restart_children(Pid, State) ->
  Children = maps:get(children, State),
  % get child data
  {value, {_UniqueId, Pid, {M, F, A}, Mode, Restarts}} =
    lists:keysearch(Pid, 2, Children),
  % remove from `children` list
  Children2 = lists:keydelete(Pid, 2, Children),
  % restart if Mode = permanent
  NewChildren =
    case Mode of
      transient ->
        Children2;
      permanent ->
        {ok, NewPid} = apply(M, F, A),
        [{make_ref(), NewPid, {M, F, A}, Mode, Restarts + 1} | Children2]
    end,
  State#{children := NewChildren}.

start_child(State, {Mode, M, F, A}) ->
  {ok, Pid} = apply(M, F, A),
  Children = maps:get(children, State),
  UniqueId = make_ref(),
  NewChildren = [{UniqueId, Pid, {M, F, A}, Mode, 0} | Children],
  State2 = State#{children := NewChildren},
  {State2, UniqueId}.

terminate(State) ->
  ?LOG(State),
  Children = maps:get(children, State, []),
  terminate(State, Children).

terminate(_State, []) -> ok;
terminate(State, [{_UniqueId, Pid, _MFA, _Mode, _Restarts} | Children]) ->
  exit(Pid, kill),
  terminate(State, Children).

stop() ->
  ?MODULE ! {self(), stop},
  receive
    {reply, Reply} -> Reply
  end.

%% helpers

child_restarts(Key, Map) ->
  Value = maps:get(Key, Map, 0),
  Map#{Key => Value + 1}.
