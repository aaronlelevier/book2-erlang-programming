%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc FSM for a Race
%%% References:
%%% - gen_statem manual page: https://erlang.org/doc/man/gen_statem.html#stop-1
%%% - gen_statem behavior: https://erlang.org/doc/design_principles/statem.html
%%% @end
%%% Created : 24. Apr 2020 6:46 AM
%%%-------------------------------------------------------------------
-module(race_fsm).
-author("aaron lelevier").

-behaviour(gen_statem).

%% Public API
-export([add_racer/1, get_racer_count/0]).

%% API
-export([start_link/1, stop/0]).

%% gen_statem callbacks
-export([init/1, format_status/2, state_name/3, handle_event/4, terminate/3,
  code_change/4, callback_mode/0, handle_event/3]).

%% state functions
-export([registration_open/3]).

-define(SERVER, ?MODULE).

-include_lib("book2/include/macros.hrl").

%%%===================================================================
%%% Public API
%%%===================================================================

add_racer(Name) ->
  gen_statem:call(?MODULE, {add_racer, Name}, ?TIMEOUT).

get_racer_count() ->
  gen_statem:call(?MODULE, get_racer_count, ?TIMEOUT).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Creates a gen_statem process which calls Module:init/1 to
%% initialize. To ensure a synchronized start-up procedure, this
%% function does not return until Module:init/1 has returned.
start_link(MaxRacers) ->
  gen_statem:start_link({local, ?SERVER}, ?MODULE, MaxRacers, []).

stop() ->
  gen_statem:stop(?MODULE).

%%%===================================================================
%%% gen_statem callbacks
%%%===================================================================

%% @private
%% @doc Whenever a gen_statem is started using gen_statem:start/[3,4] or
%% gen_statem:start_link/[3,4], this function is called by the new
%% process to initialize.
init(MaxRacers) ->
  LoopData = #{max_racers => MaxRacers, num_racers => 0},
  ?LOG(LoopData),
  {ok, registration_open, LoopData}.

%% @private
%% @doc This function is called by a gen_statem when it needs to find out
%% the callback mode of the callback module.
%% https://erlang.org/doc/man/gen_statem.html#Module:callback_mode-0
callback_mode() ->
  state_functions.

%% @private
%% @doc Called (1) whenever sys:get_status/1,2 is called by gen_statem or
%% (2) when gen_statem terminates abnormally.
%% This callback is optional.
format_status(_Opt, [_PDict, _StateName, _State]) ->
  Status = some_term,
  Status.

%% @private
%% @doc There should be one instance of this function for each possible
%% state name.  If callback_mode is state_functions, one of these
%% functions is called when gen_statem receives and event from
%% call/2, cast/2, or as a normal process message.
state_name(_EventType, _EventContent, State) ->
  NextStateName = next_state,
  {next_state, NextStateName, State}.

%% @private
%% @doc If callback_mode is handle_event_function, then whenever a
%% gen_statem receives an event from call/2, cast/2, or as a normal
%% process message, this function is called.
handle_event({call, From}, get_racer_count, Data) ->
  Actions = [{
    reply, From, submap(Data, [num_racers, max_racers])
  }],
  {keep_state, Data, Actions};
handle_event(EventType, EventContent, Data) ->
  ?LOG({EventType, EventContent, Data}),
  %% Ignore all other events
  {keep_state, Data}.

submap(Map, Keys) ->
  maps:from_list([
    {K, maps:get(K, Map)} || K <- Keys
  ]).

handle_event(_EventType, _EventContent, _StateName, State) ->
  NextStateName = the_next_state_name,
  {next_state, NextStateName, State}.

%% @private
%% @doc This function is called by a gen_statem when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_statem terminates with
%% Reason. The return value is ignored.
terminate(_Reason, _StateName, _State) ->
  ok.

%% @private
%% @doc Convert process state when code is changed
code_change(_OldVsn, StateName, State, _Extra) ->
  {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

registration_open(
    {call, From}, {add_racer, _Name} = Request,
    #{max_racers := MaxRacers, num_racers := NumRacers} = Data) ->
  ?LOG({{call, From}, Request, Data}),
  {Reply, NewNumRacers} = if
            NumRacers < MaxRacers ->
              {{ok, racer_added}, NumRacers+1};
            true ->
              {{error, race_full}, NumRacers}
          end,
  {keep_state, Data#{num_racers => NewNumRacers}, [{reply, From, Reply}]};
registration_open(EventType, EventContent, Data) ->
  handle_event(EventType, EventContent, Data).

