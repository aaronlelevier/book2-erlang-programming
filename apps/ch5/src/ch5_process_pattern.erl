%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc Generic handler that's a Waiting Room
%%% We should be able to:
%%% - add people to waiting room
%%%   - CAST response is "ok" with no Waiting Number
%%%   - CALL - client gets back: {ok, Number}
%%% - say how may people are in the waiting room
%%% - call people in a FIFO order and they are removed from the waiting room
%%% @end
%%% Created : 31. Jan 2020 5:59 AM
%%%-------------------------------------------------------------------
-module(ch5_process_pattern).
-author("aaron lelevier").
-include_lib("book2/include/macros.hrl").

%% exports
-export([start/2, stop/1, call/2, cast/2]).
-export([init/1]).

start(Name, Data) ->
  Pid = spawn(?MODULE, init, [Data]),
  register(Name, Pid),
  ok.

stop(Name) ->
  Name ! {stop, self()},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    stop_timeout
  end.

call(Name, Msg) ->
  Name ! {call, self(), Msg},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    call_timeout
  end.

cast(Name, Msg) ->
  Name ! {cast, self(), Msg},
  ok.

reply(To, Reply) ->
  To ! {reply, Reply}.

init(Data) ->
  loop(initialize(Data)).

loop(State) ->
  receive
    {call, Pid, Msg} ->
      {Reply, NewState} = handle_msg({call, Msg}, State),
      reply(Pid, Reply),
      loop(NewState);
    {cast, Pid, Msg} ->
      NewState = handle_msg({cast, Msg}, State),
      loop(NewState);
    {stop, Pid} ->
      reply(Pid, terminate(State))
  after ?TIMEOUT * 5 ->
    loop_timeout
  end.

%% impl specific functions

initialize(State) -> State.

handle_msg({call, count}, State) ->
  {reply_count(State), State};
handle_msg({call, {add, Person}}, State) ->
  NewState = [Person|State],
  {reply_count(NewState), NewState};
handle_msg({call, remove}, State) ->
  % reverses list so add/removal is FIFO
  [H|T] = lists:reverse(State),
  NewState = lists:reverse(T),
  Reply = {ok, H},
  {Reply, NewState};
handle_msg({cast, {add, Person}}, State) ->
  [Person|State].

terminate(_State) -> ok.

%% helpers
reply_count(State) -> {ok, erlang:length(State)}.

%% TODO: could add functional interface, so client isn't using `call`

%% TODO: add remove support for `cast`

%% TODO: could use `queue` as an internal data structure,
%% so don't have to reverse list for removals, more natural