%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% DB implementation using lists
%%% @end
%%% Created : 19. Mar 2020 6:40 AM
%%%-------------------------------------------------------------------
-module(ch8_ex1).
-author("aaron lelevier").
-vsn(1.0).
-export([start/0, stop/0, read/1, write/2, delete/1, init/0]).

%% DB server name
-define(SERVER, ?MODULE).

%% default timeout
-define(TIMEOUT, 1000).

%% Public API ------------------------------------------------------

start() ->
  register(?SERVER, spawn(?MODULE, init, [])).

stop() -> ok.

read(Key) -> call({read, Key}).

write(Key, Value) -> call({write, {Key, Value}}).

delete(Key) -> call({delete, Key}).

%% Private API ------------------------------------------------------

init() ->
  loop([]).

call(Msg) ->
  ?SERVER ! {self(), Msg},
  receive
    {?SERVER, Reply} ->
      Reply
  after ?TIMEOUT ->
    {timeout, Msg}
  end.

reply(To, Msg) -> To ! {?SERVER, Msg}.

loop(State) ->
  receive
    {From, {write, {Key, Value}}} ->
      NewState = [{Key, Value} | State],
      reply(From, ok),
      loop(NewState);
    {From, {read, Key}} ->
      Reply = handle_msg(State, {read, Key}),
      reply(From, Reply),
      loop(State);
    {From, {delete, Key}} ->
      NewState = proplists:delete(Key, State),
      reply(From, ok),
      loop(NewState)
  end.

handle_msg(State, {read, Key}) ->
  case proplists:get_value(Key, State) of
    undefined ->
      {error, undefined};
    Value ->
      {ok, Value}
  end.