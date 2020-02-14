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
-export([server_name/0, count/1]).
%% worker
-export([worker/1, response/2, frequencies/0]).

%% Macros
-define(SERVER, frequency).
-define(FREQUENCIES, [1, 2]).

-type frequency() :: integer().
%% { AvailableFrequencies, InUseFrequencies }
-type frequencies() :: {[frequency()], [{pid(), frequency()}]}.
-type reply() :: ok | error | {ok, frequency()} | {error, no_frequencies}.

%% Client functions

start() ->
  register(?SERVER, spawn(?MODULE, init, [])), ok.

stop() -> call(stop).

-spec allocate() -> reply().
allocate() -> call(allocate).

-spec deallocate(Freq :: integer()) -> ok | error.
deallocate(Freq) -> call({deallocate, Freq}).

%% Extra Client Functions

server_name() -> ?SERVER.

-spec count(atom()) -> integer().
count(in_use) -> call({count, in_use}).

frequencies() -> call(frequencies).

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
    {request, Pid, frequencies} ->
      reply(Pid, Frequencies),
      loop(Frequencies);
    {request, Pid, {count, in_use}} ->
      Reply = count(in_use, Frequencies),
      reply(Pid, Reply),
      loop(Frequencies);
    {request, Pid, stop} ->
      {ok, InUse} = count(in_use, Frequencies),
      case InUse of
        0 ->
          reply(Pid, ok);
        I when I > 0 ->
          reply(Pid, {error, frequencies_currently_allocated}),
          loop(Frequencies)
      end
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
      NewL2 = lists:keydelete(Freq, 2, L2),
      {{[Freq | L1], NewL2}, ok};
    _ ->
      {{L1, L2}, error}
  end.

count(in_use, Frequencies) ->
  {_Avail, InUse} = Frequencies,
  {ok, length(InUse)}.

%% worker - process that I can tell to allocate/deallocate frequencies

worker(State) ->
  receive
    {Pid, allocate} ->
      % TODO: handle error case where can't allocate
      reply(Pid, allocate()),
      worker(State);
    {Pid, {deallocate, Freq}} ->
      reply(Pid, deallocate(Freq)),
      worker(State)
  after ?TIMEOUT ->
    worker_loop_timeout
  end.

response(Pid, Msg) ->
  Pid ! {self(), Msg},
  Response = receive
               {reply, Val} ->
                 Val
             after
               ?TIMEOUT ->
                 response_timeout
             end,
  Response.
