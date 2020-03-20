%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%% DB implementation using lists
%%% @end
%%% Created : 19. Mar 2020 6:40 AM
%%%-------------------------------------------------------------------
-module(ch8_ex1).
-author("aaron lelevier").
-vsn(1.0).
-export([start/0, stop/0, read/1, write/2, delete/1, init/0, convert/0]).
%% helpers
-export([convert_list_to_map/1]).

%% DB server name
-define(SERVER, ?MODULE).

%% default timeout
-define(TIMEOUT, 1000).

%% Public API ------------------------------------------------------

start() ->
  register(?SERVER, spawn(?MODULE, init, [])).

stop() -> unregister(?SERVER), ok.

read(Key) -> call({read, Key}).

write(Key, Value) -> call({write, {Key, Value}}).

delete(Key) -> call({delete, Key}).

convert() -> call(convert).

%% Private API ------------------------------------------------------

init() ->
  State = #{
    state => [],
    crud_module => ch8_crud_proplist
  },
  loop(State).

call(Msg) ->
  ?SERVER ! {self(), Msg},
  receive
    {?SERVER, Reply} ->
      Reply
  after ?TIMEOUT ->
    {timeout, Msg}
  end.

reply(To, Msg) -> To ! {?SERVER, Msg}.

loop(State) ->
  receive
    {From, convert} ->
      CrudMod = maps:get(crud_module, State),
      Data = maps:get(state, State),
      State2 = #{
        state => convert_list_to_map(Data),
        crud_module => ch8_crud_map
      },
      reply(From, ok),
      loop(State2);
    {From, {CrudMethod, Request}} ->
      CrudMod = maps:get(crud_module, State),
      Data = maps:get(state, State),
      {Response, Data2} = CrudMod:CrudMethod(Request, Data),
      State2 = maps:put(state, Data2, State),
      reply(From, Response),
      loop(State2)
  end.

-spec convert_list_to_map(L :: list()) -> map().
convert_list_to_map(L) ->
  maps:from_list(L).