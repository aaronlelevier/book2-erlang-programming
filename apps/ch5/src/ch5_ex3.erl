%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc Swapping Handlers
%%% impl a `event_manager:swap_handler(Name, OldHandler, NewHandler)`
%%% method for doing a delete_handler/add_handler in a single method
%%% so no events are lost
%%% @end
%%% Created : 17. Feb 2020 6:07 AM
%%%-------------------------------------------------------------------
-module(ch5_ex3).
-author("aaron lelevier").
-export([start/2, stop/1]).
-export([
  add_handler/3, delete_handler/2, get_data/2, send_event/2,
  handler_list/1, swap_handlers/3]).
-export([init/1]).
-include_lib("book2/include/macros.hrl").

%% types

-type event() :: {Action::atom(), Id::integer(), Desc::string()}.

%% public

start(Name, HandlerList) ->
  register(Name, spawn(?MODULE, init, [HandlerList])), ok.

init(HandlerList) ->
  loop(initialize(HandlerList)).

initialize([]) -> [];
initialize([{Handler, InitData} | Rest]) ->
  [{Handler, Handler:init(InitData)} | initialize(Rest)].

stop(Name) ->
  Name ! {stop, self()},
  receive
    {reply, Reply} -> Reply
  end.

terminate([]) -> [];
terminate([{Handler, Data} | Rest]) ->
  [{Handler, Handler:terminate(Data)} | terminate(Rest)].

-spec add_handler(Name::atom(), Handler::atom(), Data::list()) -> ok.
add_handler(Name, Handler, Data) ->
  call(Name, {add_handler, Handler, Data}).

delete_handler(Name, Handler) ->
  call(Name, {delete_handler, Handler}).

get_data(Name, Handler) ->
  call(Name, {get_data, Handler}).

-spec send_event(Name::atom(), Event::event()) -> void.
send_event(Name, Event) ->
  call(Name, {send_event, Event}).

handler_list(Name) -> call(Name, handler_list).

swap_handlers(Name, OldHandler, NewHandler) ->
  {data, {file, File}} = delete_handler(Name, OldHandler),
  ok = add_handler(Name, NewHandler, File).

handle_msg({add_handler, Handler, Data}, LoopData) ->
  {ok, [{Handler, Handler:init(Data)} | LoopData]};
handle_msg({delete_handler, Handler}, LoopData) ->
  case lists:keysearch(Handler, 1, LoopData) of
    false ->
      {error, instance};
    {value, {Handler, Data}} ->
      Reply = {data, Handler:terminate(Data)},
      NewLoopData = lists:keydelete(Handler, 1, LoopData),
      {Reply, NewLoopData}
  end;
handle_msg({get_data, Handler}, LoopData) ->
  case lists:keysearch(Handler, 1, LoopData) of
    false ->
      {{error, instance}, LoopData};
    {value, {Handler, Data}} ->
      {{data, Data}, LoopData}
  end;
handle_msg({send_event, Event}, LoopData) ->
  {ok, event(Event, LoopData)};
handle_msg(handler_list, LoopData) ->
  Handlers = [Handler || {Handler, _HandlerData} <- LoopData],
  {Handlers, LoopData}.

event(_Event, []) -> [];
event(Event, [{Handler, Data} | Rest]) ->
  [{Handler, Handler:handle_event(Event, Data)} | event(Event, Rest)].

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
      reply(From, terminate(State))
  end.
