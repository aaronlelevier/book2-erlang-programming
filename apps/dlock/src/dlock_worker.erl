%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(dlock_worker).
-behaviour(gen_server).

%% API
-export([start_monitor/1, get_state/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% Macros
-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

start_monitor(Request) ->
  gen_server:start_monitor(?MODULE, Request, []).

get_state(Pid) ->
  gen_server:call(Pid, get_state).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

init(Request) ->
  {ok, Request}.

handle_call(get_state, _From, State) ->
  {reply, State, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

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
