%%%-------------------------------------------------------------------
%%% @author alelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2020 9:17 AM
%%%-------------------------------------------------------------------
-module(ch5_phone_fsm).
-author("alelevier").
-compile(export_all).

%% Public API

-spec start(Name::atom()) -> true.
start(Name) -> register(Name, spawn(?MODULE, init, [])).

-spec stop(Name::atom()) -> ok.
stop(Name) ->
  Name ! {stop, self()},
  receive
    {reply, Reply} -> Reply
  end.

-spec state(Name::atom()) -> atom().
state(Name) -> call(Name, state).

%% TODO: impl remaining client functions

idle() ->
  receive
    {Number, incoming} ->
      start_ringing(),
      ringing(Number);
    off_hook ->
      start_tone(),
      dial()
  end.

ringing(Number) ->
  receive
    {Number, other_on_hook} ->
      stop_ringing(),
      idle();
    {Number, off_hook} ->
      stop_ringing(),
      connected(Number)
  end.

connected(Number) -> Number.

dial() -> 0.

start_ringing() -> 0.

start_tone() -> 0.

stop_ringing() -> 0.

%% Private API

init() -> loop(idle).

%% common server functions

call(Name, Msg) ->
  Name ! {request, self(), Msg},
  receive
    {reply, Reply} -> Reply
  end.

reply(To, Msg) ->
  To ! {reply, Msg}.

loop(State) ->
  receive
    {request, From, Msg} ->
      {Reply, NewState} = handle_msg(Msg, State),
      reply(From, Reply),
      loop(NewState);
    {stop, From} ->
      reply(From, ok)
  end.

handle_msg(state, State) -> {State, State}.
