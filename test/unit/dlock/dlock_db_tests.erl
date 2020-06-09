%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 09. Jun 2020 6:40 AM
%%%-------------------------------------------------------------------
-module(dlock_db_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").


db_setup() ->
  {ok, _Pid} = dlock_db:start_link(),
  ok = mnesia:start().

db_cleanup(_) ->
  stopped = mnesia:stop(),
  ok = dlock_db:stop().

mnesia_start_stop_test_() ->
  {setup,
    fun db_setup/0,
    fun db_cleanup/1,
    [
      fun create_tables/0,
      fun dlock_db:restore_tables/0,
      fun delete_tables/0
    ]}.

create_tables() ->
  {atomic, ok} = dlock_db:create_tables(),
  % 3 tables now exist
  ?assert(is_list(mnesia:table_info(item, all))),
  ?assert(is_list(mnesia:table_info(lock, all))),
  ?assert(is_list(mnesia:table_info(queue, all))).

delete_tables() ->
  dlock_db:delete_tables(),
  % all 3 tables should be deleted
  assert_table_does_not_exist(item),
  assert_table_does_not_exist(lock),
  assert_table_does_not_exist(queue).

assert_table_does_not_exist(Table) ->
  Ret = try mnesia:table_info(Table, index)
        catch exit:X -> X
        end,
  ?assertEqual({aborted, {no_exists, Table, index}}, Ret).