%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 3:21 PM
%%%-------------------------------------------------------------------
-module(maybe_m_tests).
-author("Aaron Lelevier").
-include_lib("eunit/include/eunit.hrl").
-compile({parse_transform, do}).

if_safe_div_zero(X, Y, Fun) ->
  do([maybe_m ||
    Result <- case Y == 0 of
                true  -> fail("Cannot divide by zero");
                false -> return(X / Y)
              end,
    return(Fun(Result))]).

div_0_returns_nothing_test() ->
  ?assertEqual(
    nothing,
    if_safe_div_zero(8, 0, fun(X) -> X + 1 end)
  ).

div_N_returns_just_w_value_test() ->
  ?assertEqual(
    {just, 3.0},
    if_safe_div_zero(8, 4, fun(X) -> X + 1 end)
  ).
