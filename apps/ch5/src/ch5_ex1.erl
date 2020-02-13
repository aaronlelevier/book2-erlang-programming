%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc DB module
%%% Has a functional interface to a key/value DB
%%% @end
%%% Created : 12. Feb 2020 5:16 AM
%%%-------------------------------------------------------------------
-module(ch5_ex1).
-author("aaron lelevier").
-include_lib("book2/include/macros.hrl").

%% functional interface
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).
%% server
-export([init/0, call/1]).

%% macros
-define(SERVER, db).

%% functional interface

start() ->
  Pid = spawn(?MODULE, init, []),
  register(?SERVER, Pid),
  ok.

stop() ->
  ?SERVER ! {stop, self()},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    stop_timeout
  end.

-spec write(Key :: atom(), Element :: any()) -> ok.
write(Key, Element) ->
  call({write, {Key, Element}}).

-spec delete(Key :: atom()) -> ok.
delete(Key) ->
  call({delete, Key}).

-spec read(Key :: atom()) -> {ok, Element :: any()} | {error, instance}.
read(Key) ->
  call({read, Key}).

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

handle_msg({call, {write, {Key, Element}}}, State) ->
  {ok, State#{Key => Element}};
handle_msg({call, {read, Key}}, State) ->
  Reply = try maps:get(Key, State) of
            Value -> {ok, Value}
          catch
            error:{badkey, Key} -> {error, instance}
          end,
  {Reply, State};
handle_msg({call, {delete, Key}}, State) ->
  NewState = maps:remove(Key, State),
  {ok, NewState};
handle_msg({call, {match, Element}}, State) ->
  Keys = [K || {K,V} <- maps:to_list(State), V =:= Element],
  {Keys, State}.

terminate(_State) -> ok.
