%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(user_mgr).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(user_mgr_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #user_mgr_state{}}.

handle_call(_Request, _From, State = #user_mgr_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #user_mgr_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #user_mgr_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #user_mgr_state{}) ->
  ok.

code_change(_OldVsn, State = #user_mgr_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
