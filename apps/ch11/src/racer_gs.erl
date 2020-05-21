%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(racer_gs).

-behaviour(gen_server).

%% API
-export([start_link/1, update_location/2, get_location/1, get_progress/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-type lat() :: float().
-type lng() :: float().
-type point() :: {lat(), lng()}.

%% async update location
-spec update_location(Name :: atom(), Point :: point()) -> ok.
update_location(Name, Point) ->
  gen_server:cast(Name, {update_location, Point}).

%% sync get location - last point update
-spec get_location(Name :: atom()) -> {location, point()}.
get_location(Name) ->
  gen_server:call(Name, get_location).

%% sync get progress - which is the count of location points recorded
-spec get_progress(Name:: atom()) -> {progress, integer()}.
get_progress(Name) ->
  gen_server:call(Name, get_progress).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [], []).

init([]) ->
  {ok, #{points => []}}.

handle_call(get_location, _From, State) ->
  [H|_T] = maps:get(points, State),
  {reply, {location, H}, State};
handle_call(get_progress, _From, State) ->
  L = maps:get(points, State),
  {reply, {progress, length(L)}, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({update_location, Point}, State) ->
  L = maps:get(points, State),
  {noreply, State#{points := [Point|L]}};

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
