%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 30. Aug 2020 8:26 AM
%%%-------------------------------------------------------------------
-module(ch15_tcp).
-author("Aaron Lelevier").
-vsn(1.0).
-export([client/2, server/0, wait_connect/2]).

%% Macros
-define(LISTEN_PORT, 1234).

%%%===================================================================
%%% API
%%%===================================================================
client(Host, Data) ->
  {ok, Socket} = gen_tcp:connect(Host, ?LISTEN_PORT, [binary, {packet, 0}]),
  send(Socket, Data),
  ok = gen_tcp:close(Socket).

server() ->
  {ok, ListenSocket} = gen_tcp:listen(?LISTEN_PORT, [binary, {active, false}]),
  spawn(?MODULE, wait_connect, [ListenSocket, 0]),
  ok.

wait_connect(ListenSocket, Count) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  spawn(?MODULE, wait_connect, [ListenSocket, Count+1]),
  get_request(Socket, [], Count).

%%%===================================================================
%%% Internal functions
%%%===================================================================
send(Socket, <<Chunk:100/binary, Rest/binary>>) ->
  gen_tcp:send(Socket, Chunk),
  send(Socket, Rest);
send(Socket, <<Rest/binary>>) ->
  gen_tcp:send(Socket, Rest).

get_request(Socket, BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0, 5000) of
    {ok, Binary} ->
      get_request(Socket, [Binary|BinaryList], Count);
    {error, closed} ->
      handle(lists:reverse(BinaryList), Count)
  end .

handle(Binary, Count) ->
  {ok, Fd} = file:open("log_file_" ++ integer_to_list(Count), write),
  file:write(Fd, Binary),
  file:close(Fd).
