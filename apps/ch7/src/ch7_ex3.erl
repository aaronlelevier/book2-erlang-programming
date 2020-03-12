%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% References:
%%% - Record type declaration docs: https://erlang.org/doc/reference_manual/typespec.html#type-information-in-record-declarations
%%% @end
%%% Created : 12. Mar 2020 6:12 AM
%%%-------------------------------------------------------------------
-module(ch7_ex3).
-author("aaron lelevier").

%% functional interface
-export([start/0, stop/0, write/2, delete/1, read/2, match/1]).
%% server
-export([init/0, call/1]).
%% include
-include_lib("book2/include/macros.hrl").

%% Records
-record(data, {key :: atom(), data :: any()}).

%% macros
-define(SERVER, db).

%% Public API

-spec start() -> ok.
start() ->
  Pid = spawn(?MODULE, init, []),
  register(?SERVER, Pid),
  ok.

-spec stop() -> ok.
stop() ->
  ?SERVER ! {stop, self()},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    stop_timeout
  end.

-spec read(Table :: atom(), Id :: reference()) -> {ok, Element :: any()} | {error, instance}.
read(Table, Id) ->
  call({read, {Table, Id}}).

-spec write(Table :: atom(), Element :: any()) -> ok.
write(Table, Element) ->
  call({write, {Table, Element}}).

-spec delete(Key :: atom()) -> ok.
delete(Key) ->
  call({delete, Key}).

-spec match(Element :: any()) -> [Key :: atom()].
match(Element) ->
  call({match, Element}).

%% server

call(Msg) ->
  ?SERVER ! {call, self(), Msg},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    call_timeout
  end.

reply(To, Reply) ->
  To ! {reply, Reply}.

init() ->
  loop(#{}).

loop(State) ->
  receive
    {call, Pid, Msg} ->
      {Reply, NewState} = handle_msg({call, Msg}, State),
      reply(Pid, Reply),
      loop(NewState);
    {stop, Pid} ->
      reply(Pid, terminate(State))
  after ?TIMEOUT * 5 ->
    loop_timeout
  end.

%% impl specific functions

handle_msg({call, {write, {Table, Element}}}, State) ->
  TableRows = maps:get(Table, State, []),
  Id = make_ref(),
  State2 = State#{Table => [{Id, Element} | TableRows]},
  {Id, State2};
handle_msg({call, {read, {Table, Id}}}, State) ->
  Rows = maps:get(Table, State, []),
  Reply = case lists:keysearch(Id, 1, Rows) of
            {value, {Id, Element}} ->
              {ok, Element};
            false ->
              {error, instance}
          end,
  {Reply, State};
handle_msg({call, {delete, Key}}, State) ->
  NewState = maps:remove(Key, State),
  {ok, NewState};
handle_msg({call, {match, Element}}, State) ->
  Keys = [K || {K, V} <- maps:to_list(State), V =:= Element],
  {Keys, State}.

terminate(_State) -> ok.
