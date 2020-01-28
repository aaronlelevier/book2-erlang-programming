%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jan 2020 6:05 AM
%%%-------------------------------------------------------------------
-module(ch5_client_server).
-author("aaron lelevier").
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).
%% extra
-export([server_name/0]).

%% Macros
-define(SERVER, frequency).
-define(TIMEOUT, 1000).

%% Client functions

start() ->
  register(?SERVER, spawn(?MODULE, init, [])).

stop() -> call(stop).

allocate() -> call(allocate).

deallocate(Freq) -> call({deallocate, Freq}).

%% Extra Client Functions

server_name() -> ?SERVER.

%% Internal API

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

get_frequencies() -> [10, 11, 12].

call(Message) ->
  ?SERVER ! {request, self(), Message},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    call_timeout
  end.

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, {deallocate, Freq}} ->
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq),
      reply(Pid, ok),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      reply(pid, ok)
  end.

reply(Pid, Reply) ->
  Pid ! {reply, Reply}.

allocate(Frequencies, Pid) -> {Frequencies, Pid}.

deallocate(Frequencies, Freq) -> {Frequencies, Freq}.