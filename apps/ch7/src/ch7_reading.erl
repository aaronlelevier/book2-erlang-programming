%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc example of an `include` file being imported from an `app`
%%%
%%% @end
%%% Created : 11. Mar 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch7_reading).
-author("aaron lelevier").
-compile(export_all).
-export([]).

%% only need to click "find include file" Intellij helper and was added to compiler
%% include files search path
-include("ch7_macros.hrl").

is_multiple(A, B) when ?MULTIPLE(A, B) -> true;
is_multiple(_A, _B) -> false.