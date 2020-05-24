%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 4:53 PM
%%%-------------------------------------------------------------------
-module(pmod_example, [A]).
-author("Aaron Lelevier").
-vsn(1.0).
-export([b/0]).
-compile({parse_transform, pmod_pt}).

b() -> A + 1.