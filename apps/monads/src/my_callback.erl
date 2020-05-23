%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 8:02 AM
%%%-------------------------------------------------------------------
-module(my_callback).
-author("Aaron Lelevier").
-vsn(1.0).
-export([fn/1]).
-behavior(my_behavior).

fn(A) -> A + 1.