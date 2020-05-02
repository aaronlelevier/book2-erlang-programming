%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc This module represents a Racer.
%%% It's implementing the gen_server behavior.
%%%
%%% The Racer should have a Status of: pre_start, racing, finished,
%%% time_exceeded, dnf
%%% @end
%%%--------------------------------------------------------------------
-module(racer_gs).
-behaviour(gen_server).

-include_lib("book2/include/macros.hrl").

-export([start_link/1]).
%% API
-export([start_race/1, finish_race/1, status/1, state/1]).
%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%%%===================================================================
%%% Type specs
%%%===================================================================

-type lat() :: float().
-type lng() :: float().
-type point() :: {lat(), lng()}.

%%%===================================================================
%%% Macros
%%%===================================================================

-define(INIT_STATE, #{
  status => pre_start,
  points => [],
  duration => 1000

}).

%%%===================================================================
%%% API
%%%===================================================================

start_race(Name) ->
  gen_server:call(Name, start_race).

status(Name) ->
  maps:get(status, state(Name)).

state(Name) ->
  gen_server:call(Name, status).

finish_race(Name) ->
  gen_server:call(Name, finish).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, ?INIT_STATE, []).

init(State) ->
  {ok, State}.

%% start_race
handle_call(start_race, _From, #{status := pre_start} = State) ->
  NewState = State#{status => racing},
  timer:send_after(maps:get(duration, ?INIT_STATE), race_duration_end),
  {reply, ok, NewState};
handle_call(start_race, _From, #{status := Status} = State) ->
  Msg = lists:flatten(
    io_lib:format("Error: can only start race from pre_start status. Status: ~s", [Status])),
  {reply, {error, Msg}, State};

%% finish_race
handle_call(finish, _From, #{status := racing} = State) ->
  NewState = State#{status => finished},
  {reply, ok, NewState};
handle_call(start_race, _From, #{status := Status} = State) ->
  Msg = lists:flatten(
    io_lib:format("Error: can't finish if not racing status. Status: ~s", [Status])),
  {reply, {error, Msg}, State};

%% status
handle_call(status, _From, State) ->
  Reply = State,
  {reply, Reply, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

%% handle "end of race" message
handle_info(race_duration_end, #{status := racing} = State) ->
  ?LOG({race_duration_end, State}),
  {noreply, State#{status := time_exceeded}};
handle_info(Info, State) ->
  ?LOG({Info, State}),
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
