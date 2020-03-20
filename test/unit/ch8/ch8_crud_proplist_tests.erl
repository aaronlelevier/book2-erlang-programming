%%%-------------------------------------------------------------------
%%% @author alelevier
%%% @doc
%%%
%%% @end
%%% Created : 19. Mar 2020 4:38 PM
%%%-------------------------------------------------------------------
-module(ch8_crud_proplist_tests).
-author("alelevier").

-include_lib("eunit/include/eunit.hrl").

read_key_exists_test() ->
  Key = 1,
  Value = "foo",
  State = [{Key, Value}],

  {Response, State2} = ch8_crud_proplist:read(Key, State),

  ?assertEqual({ok, Value}, Response),
  ?assertEqual(State, State2).

read_key_does_not_exist_test() ->
  Key = 1,
  State = [],

  {Response, State2} = ch8_crud_proplist:read(Key, State),

  ?assertEqual({error, undefined}, Response),
  ?assertEqual(State, State2).

write_adds_new_value_test() ->
  Key = 2,
  Value = "yo",
  Request = {Key, Value},
  State = [],

  {Response, State2} = ch8_crud_proplist:write(Request, State),

  ?assertEqual(ok, Response),
  ?assertEqual([{Key, Value}], State2).

write_overwrites_an_existing_value_test() ->
  Key = 2,
  Value = "foo",
  Value2 = "bar",
  Request = {Key, Value2},
  State = [{Key, Value}],

  {Response, State2} = ch8_crud_proplist:write(Request, State),

  ?assertEqual(ok, Response),
  ?assertEqual([{Key, Value2}], State2).

delete_existing_key_value_test() ->
  Key = 1,
  Value = "foo",
  State = [{Key, Value}],

  {Response, State2} = ch8_crud_proplist:delete(Key, State),

  ?assertEqual(ok, Response),
  ?assertEqual([], State2).

delete_silent_pass_if_key_does_not_exist_test() ->
  Key = 3,
  State = [],

  {Response, State2} = ch8_crud_proplist:delete(Key, State),

  ?assertEqual(ok, Response),
  ?assertEqual([], State2).