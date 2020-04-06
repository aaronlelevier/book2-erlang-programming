%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Mar 2020 6:12 AM
%%%-------------------------------------------------------------------
-module(ch7_ex3_tests).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).

-include_lib("eunit/include/eunit.hrl").

db_setup() ->
  ok = ch7_ex3:start().

db_cleanup(_) ->
  ok = ch7_ex3:stop().

db_as_a_record_test_() ->
  {setup,
    fun db_setup/0,
    fun db_cleanup/1,
    [
      fun can_read_and_write_to_db/0
    ]}.

can_read_and_write_to_db() ->
  Table = address,
  Street = "150 Capital Dr #180",
  City = "Golden",
  State = "CO",
  Zipcode = "80401",
  Address = {Street, City, State, Zipcode},
  % write
  Id = ch7_ex3:write(Table, Address),
  ?assert(is_reference(Id)),

  % write 2 - write to the same table w/ a 2nd Address
  Address2 = {"a", "b", "c", "d"},
  Id2 = ch7_ex3:write(Table, Address2),
  ?assert(is_reference(Id2)),

  % read - exists
  ?assertEqual({ok, Address}, ch7_ex3:read(Table, Id)),

  % read - does not exist
  Id3 = make_ref(),
  ?assertEqual({error, instance}, ch7_ex3:read(Table, Id3)).
