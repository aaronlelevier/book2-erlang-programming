%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 5:28 PM
%%%-------------------------------------------------------------------
-module(state_t_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").
-compile({parse_transform, pmod_pt}).

b_test() ->
  StateT = state_t:new(identity_m),
  ?assertEqual({state_t, identity_m}, StateT).
