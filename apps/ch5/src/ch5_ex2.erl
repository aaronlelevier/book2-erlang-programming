%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Feb 2020 6:22 AM
%%%-------------------------------------------------------------------
-module(ch5_ex2).
-author("aaron lelevier").
-include_lib("book2/include/macros.hrl").

%% exports
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).
%% extra
-export([server_name/0]).
%% worker
-export([worker_loop/0]).

%% Macros
-define(SERVER, frequency).
-define(FREQUENCIES, [1, 2]).

-type frequency() :: integer().
%% { AvailableFrequencies, InUseFrequencies }
-type frequencies() :: {[frequency()], [{pid(), frequency()}]}.
-type reply() :: ok | {ok, frequency()} | {error, no_frequencies}.

%% Client functions

start() ->
  register(?SERVER, spawn(?MODULE, init, [])), ok.

stop() -> call(stop).

-spec allocate() -> reply().
allocate() -> call(allocate).

-spec deallocate(Freq::integer()) -> ok | error.
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
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq, Pid),
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
allocate({[], _L} = Frequencies, _Pid) ->
  {Frequencies, {error, no_frequencies}};
allocate({[Freq | T], L}, Pid) ->
  {{T, [{Pid, Freq} | L]}, {ok, Freq}}.

-spec deallocate(frequencies(), frequency(), pid()) ->
  {frequencies(), ok} | {frequencies(), error}.
deallocate({L1, L2}, Freq, Pid) ->
  case lists:member({Pid, Freq}, L2) of
    true ->
      NewL2 = lists:keydelete(Freq, 1, L2),
      {{[Freq | L1], NewL2}, ok};
    _ ->
      {{L1, L2}, error}
  end.

%% worker - process that I can tell to allocate/deallocate frequencies

worker_loop() ->
  receive
    {Pid, allocate} ->
      % TODO: handle error case where can't allocate
      reply(Pid, allocate()),
      worker_loop()
  % TODO: handle deallocate case
  after ?TIMEOUT ->
    worker_loop_timeout
  end.



