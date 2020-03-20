%%%-------------------------------------------------------------------
%%% @author alelevier
%%% @doc Crud implementation for proplists. All methods should have
%%% this signature:
%%% ```
%%% Method(Request, State) -> {Response, State2}.
%%% ```
%%% @end
%%% Created : 19. Mar 2020 4:36 PM
%%%-------------------------------------------------------------------
-module(ch8_crud_proplist).
-author("alelevier").

%% API
-export([read/2, write/2, delete/2]).

read(Request, State) ->
  Key = Request,
  Response = case proplists:get_value(Key, State) of
               undefined ->
                 {error, undefined};
               Value ->
                 {ok, Value}
             end,
  {Response, State}.

write(Request, State) ->
  {Key, Value} = Request,
  State2 = case read(Key, State) of
             {{error, _}, _} ->
               State;
             {{ok, _}, _} ->
               proplists:delete(Key, State)
           end,
  {ok, [{Key, Value}|State2]}.

delete(Request, State) ->
  {ok, proplists:delete(Request, State)}.
