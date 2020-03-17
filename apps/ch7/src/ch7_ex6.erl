%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% Create a parameterized macro with a flag for showing the expression
%%% to be evaluated
%%% @end
%%% Created : 17. Mar 2020 6:42 AM
%%%-------------------------------------------------------------------
-module(ch7_ex6).
-author("aaron lelevier").
-export([test1/0]).

-ifdef(debug).
  -define(
    SHOW_EVAL(Expr),
    io:format("~p~n", [??Expr]), Expr
  ).
-else.
  -define(SHOW_EVAL(Expr), Expr).
-endif.

test1() -> ?SHOW_EVAL(length([1,2,3])).