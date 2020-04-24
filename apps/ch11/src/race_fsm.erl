%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 24. Apr 2020 6:46 AM
%%%-------------------------------------------------------------------
-module(race_fsm).
-author("aaron lelevier").

-behaviour(gen_statem).

%% Public API
-export([start/1, add_racer/1]).

%% API
-export([start_link/0]).

%% gen_statem callbacks
-export([init/1, format_status/2, state_name/3, handle_event/4, terminate/3,
  code_change/4, callback_mode/0, handle_event/3]).

%% state functions
-export([registration_open/3, registration_open/4]).

-define(SERVER, ?MODULE).

-include_lib("book2/include/macros.hrl").

%%%===================================================================
%%% Public API
%%%===================================================================

start(MaxRacers) ->
  start_link(MaxRacers).

add_racer(Name) ->
  gen_statem:call(?MODULE, {add_racer, Name}, ?TIMEOUT).

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Creates a gen_statem process which calls Module:init/1 to
%% initialize. To ensure a synchronized start-up procedure, this
%% function does not return until Module:init/1 has returned.
start_link() ->
  start_link([]).

start_link(A) ->
  gen_statem:start_link({local, ?SERVER}, ?MODULE, A, []).

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
handle_event(EventType, EventContent, Data) ->
  ?LOG({EventType, EventContent, Data}),
  %% Ignore all other events
  {keep_state, Data}.

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

registration_open({call, From}, {add_racer, Name} = Request, Data) ->
  ?LOG({{call, From}, Request, Data}),
  Reply = {racer_added, Name},
  {keep_state, Data, [{reply, From, Reply}]}.

registration_open(EventType, EventContent, StateName, State) ->
  ?LOG({EventType, EventContent, StateName, State}),
  handle_event(EventType, EventContent, StateName, State).