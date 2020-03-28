%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2020 8:19 AM
%%%-------------------------------------------------------------------
-module(ch9_ex4_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

all_test() ->
  IsEven = fun(X) -> X rem 2 =:= 0 end,

  ?assertEqual(false, ch9_ex4:all(IsEven, [2, 3, 4])),

  ?assertEqual(true, ch9_ex4:all(IsEven, [2, 4])).

dropwhile_test() ->
  L = [
    {id, 1},
    {name, "Bob"},
    {address, "123 Street"},
    {city, "San Fran"},
    {state, "CA"}
  ],

  Ret = ch9_ex4:dropwhile(fun({Key, _}) -> Key =/= city end, L),

  ?assertEqual(
    [
      {city, "San Fran"},
      {state, "CA"}
    ],
    Ret
  ).
