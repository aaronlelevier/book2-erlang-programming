%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 19. Mar 2020 6:49 AM
%%%-------------------------------------------------------------------
-module(ch8_ex1_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).

-include_lib("eunit/include/eunit.hrl").

start_server_setup() ->
  ?assertEqual(true, ch8_ex1:start()).

stop_server_cleanup(_) ->
  ?assertEqual(ok, ch8_ex1:stop()).

read_write_delete_test_() ->
  {setup,
    fun start_server_setup/0,
    fun stop_server_cleanup/1,
    [
      fun can_write/0,
      fun can_read/0,
      fun can_delete/0
    ]
  }.

can_write() ->
  Key = 1,
  Value = {name, "bob"},
  % write - ok
  ?assertEqual(ok, ch8_ex1:write(Key, Value)).

can_read() ->
  Key = 1,
  Value = {name, "bob"},
  % read - ok
  ?assertEqual({ok, Value}, ch8_ex1:read(Key)),
  % read - error
  ?assertEqual({error, undefined}, ch8_ex1:read(invalid_key)).

can_delete() ->
  Key = 1,
  % delete
  ?assertEqual(ok, ch8_ex1:delete(Key)),
  % read - previous existing key now returns "undefined"
  ?assertEqual({error, undefined}, ch8_ex1:read(Key)).

convert_list_to_map_test() ->
  L = [{1, "bob"}, {2, {a, b}}],
  Ret = ch8_ex1:convert_list_to_map(L),
  ?assertEqual(#{1 => "bob", 2 => {a, b}}, Ret).

read_write_delete_after_converting_db_structure_test_() ->
  {setup,
    fun start_server_setup/0,
    fun stop_server_cleanup/1,
    [
      fun can_write/0,
      fun can_read/0,
      fun can_convert/0,
      fun can_read/0,
      fun can_write/0
      ]
  }.

can_convert() ->
  ?assertEqual(ok, ch8_ex1:convert()).
