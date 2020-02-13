%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc DB module
%%% Has a functional interface to a DB where the data is stored in the
%%% process state. This is a key/value DB where the key is an atom and
%%% the value can be anything.
%%% @end
%%% Created : 12. Feb 2020 5:16 AM
%%%-------------------------------------------------------------------
-module(ch5_ex1).
-author("aaron lelevier").
-include_lib("book2/include/macros.hrl").

%% functional interface
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).
%% server
-export([init/0, call/2]).

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

-spec write(Key::atom(), Element::any()) -> ok.
write(Key, Element) -> ok.

-spec delete(Key::atom()) -> ok.
delete(Key) -> ok.

-spec read(Key::atom()) -> {ok, Element::any()} | {error, instance}.
read(Key) -> ok.

-spec match(Element::any()) -> [Key::atom()].
match(Element) -> [keys].

%% server

call(Name, Msg) ->
  Name ! {call, self(), Msg},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    call_timeout
  end.

reply(To, Reply) ->
  To ! {reply, Reply}.

init() ->
  loop([]).

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

handle_msg({call, {add, Person}}, State) ->
  NewState = [Person|State],
  {ok, NewState};
handle_msg({call, remove}, State) ->
  % reverses list so add/removal is FIFO
  [H|T] = lists:reverse(State),
  NewState = lists:reverse(T),
  Reply = {ok, H},
  {Reply, NewState}.

terminate(_State) -> ok.
