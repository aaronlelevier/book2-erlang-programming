%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 8:00 AM
%%%-------------------------------------------------------------------
-module(my_behavior).
-author("Aaron Lelevier").
-vsn(1.0).
-export([]).

-callback fn(A :: term()) -> B :: term().