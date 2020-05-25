%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 24. May 2020 5:12 PM
%%%-------------------------------------------------------------------
-module(bike_db_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").

upsert_created_test() ->
  BikeData = #{product => one, brand => trek},
  DbState = #{count => 0 },

  {Reply, DbState2} = bike_db:upsert(BikeData, DbState),

  ?assertEqual({created, 1}, Reply),
  ?assertEqual(
    #{
      count => 1,
      one => #{id => 1, product => one, brand => trek}},
  DbState2).

upsert_updated_test() ->
  BikeData = #{
    id => 1, product => one, brand => trek, wheel_size => 29},
  DbState = #{
    count => 1,
    one => #{id => 1, product => one, brand => trek}
  },

  {Reply, DbState2} = bike_db:upsert(BikeData, DbState),

  ?assertEqual({updated, 1}, Reply),
  ?assertEqual(
    #{
      count => 1,
      one => #{
        id => 1, product => one, brand => trek, wheel_size => 29}},
    DbState2).