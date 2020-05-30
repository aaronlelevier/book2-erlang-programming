%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(ch12_db).
-behaviour(gen_server).

%% API
-export([start/0, stop/0, write/2, delete/1, read/1, match/1]).

%% gen_server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

%% Macros
-define(SERVER, ?MODULE).

%% Types
-type key() :: any().
-type element() :: any().

%%%===================================================================
%%% API
%%%===================================================================

-spec start() -> {ok, Pid :: pid()}.
start() ->
  gen_server:start({local, ?SERVER}, ?MODULE, [], []).


-spec stop() -> ok.
stop() ->
  gen_server:stop(?SERVER).


-spec write(Key :: key(), Element :: element()) -> ok.
write(Key, Element) ->
  gen_server:call(?SERVER, {write, {Key, Element}}).


delete(Key) ->
  gen_server:call(?SERVER, {delete, Key}).


-spec read(Key :: key()) -> {ok, Element :: element()} | {error, instance}.
read(Key) ->
  gen_server:call(?SERVER, {read, Key}).


-spec match(Element :: element()) -> [Key :: key()].
match(Element) ->
  gen_server:call(?SERVER, {match, Element}).


%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

init([]) ->
  {ok, []}.


handle_call({write, {_Key, _Element} = Data}, _From, State) ->
  {reply, ok, [Data | State]};
handle_call({delete, Key}, _From, State) ->
  {reply, ok, proplists:delete(Key, State)};
handle_call({read, Key}, _From, State) ->
  Reply = case proplists:lookup(Key, State) of
            none ->
              {error, instance};
            {Key, Element} ->
              {ok, Element}
          end,
  {reply, Reply, State};
handle_call({match, Element}, _From, State) ->
  Reply = [K || {K, E} <- State, E =:= Element],
  {reply, Reply, State};
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
