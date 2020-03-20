%%%-------------------------------------------------------------------
%%% @author alelevier
%%% @doc Crud implementation for map. All methods should have
%%% this signature:
%%% ```
%%% Method(Request, State) -> {Response, State2}.
%%% ```
%%% @end
%%% Created : 19. Mar 2020 5:03 PM
%%%-------------------------------------------------------------------
-module(ch8_crud_map).
-author("alelevier").

%% API
-export([read/2, write/2, delete/2]).

read(Request, State) ->
  Key = Request,
  Response = try maps:get(Key, State) of
               Value -> {ok, Value}
             catch
               error: {badkey,Key} -> {error, undefined}
             end,
  {Response, State}.

write(Request, State) ->
  {Key, Value} = Request,
  {ok, maps:put(Key, Value, State)}.

delete(Request, State) ->
  Key = Request,
  {ok, maps:remove(Key, State)}.
