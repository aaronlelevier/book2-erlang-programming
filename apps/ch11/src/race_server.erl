%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% @end
%%%--------------------------------------------------------------------module(ch11_reading).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(ch11_reading_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #ch11_reading_state{}}.

handle_call(_Request, _From, State = #ch11_reading_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #ch11_reading_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #ch11_reading_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #ch11_reading_state{}) ->
  ok.

code_change(_OldVsn, State = #ch11_reading_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
