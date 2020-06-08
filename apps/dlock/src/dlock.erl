%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(dlock).
-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([request/3, release/2, build_request/3]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-include_lib("dlock/include/dlock.hrl").

%% Macros
-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

request(Items, Callback, Timeout) ->
  Request = build_request(Items, Callback, Timeout),
  gen_server:cast(request, Request).

release(Items, Callback) ->
  gen_server:cast(release, {Items, Callback}).

%% Helpers
build_request(Items, Callback, Timeout) ->
  #request{
    created = calendar:local_time(),
    callback = Callback,
    timeout = Timeout,
    items = Items
  }.

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

init([]) ->
  {ok, #{}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%% todo
handle_cast({request, Request}, State) ->
  ok = dlock_worker:start_monitor(Request),
  {noreply, State};
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
