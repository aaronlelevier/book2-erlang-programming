%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc Frequency server example
%%%
%%% @end
%%% Created : 28. Jan 2020 6:05 AM
%%%-------------------------------------------------------------------
-module(ch5_client_server).
-author("aaron lelevier").
-include_lib("book2/include/macros.hrl").

%% exports
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).
%% extra
-export([server_name/0]).

%% Macros
-define(SERVER, frequency).
-define(FREQUENCIES, [1, 2]).

-type frequency() :: integer().
-type frequencies() :: {[frequency()], [frequency()]}.
-type reply() :: ok | {ok, frequency()} | {error, no_frequencies}.

%% Client functions

start() ->
  register(?SERVER, spawn(?MODULE, init, [])).

stop() -> call(stop).

allocate() -> call(allocate).

deallocate(Freq) -> call({deallocate, Freq}).

%% Extra Client Functions

server_name() -> ?SERVER.

%% Internal API

%% @doc frequencies are initialized as a tuple where the
% first item is the list of free frequencies, and the 2nd
% item is a list of allocated frequencies
init() ->
  Frequencies = get_frequencies(),
  loop(Frequencies).

-spec get_frequencies() -> frequencies().
get_frequencies() ->
  {?FREQUENCIES, []}.

-spec call(any()) -> any().
call(Message) ->
  ?SERVER ! {request, self(), Message},
  receive
    {reply, Reply} ->
      Reply
  after ?TIMEOUT ->
    call_timeout
  end.

-spec loop(frequencies()) -> any().
loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, {deallocate, Freq}} ->
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      reply(Pid, ok)
  end.

-spec reply(pid(), reply()) -> {reply, reply()}.
reply(Pid, Reply) ->
  ?DEBUG({Pid, Reply}),
  Pid ! {reply, Reply}.

-spec allocate(frequencies(), pid()) -> {frequencies(), reply()}.
allocate({[], _L}=Frequencies, _Pid) ->
  {Frequencies, {error, no_frequencies}};
allocate({[H|T], L}, Pid) ->
  {{T, [{Pid, H}|L]}, {ok, H}}.

-spec deallocate(frequencies(), frequency()) -> {frequencies(), ok}.
deallocate({L1, L2}, Freq) ->
  NewL2 = lists:keydelete(Freq, 1, L2),
  {{[Freq|L1], NewL2}, ok}.