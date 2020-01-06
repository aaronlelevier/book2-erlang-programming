%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:33 AM
%%%-------------------------------------------------------------------
-module(ch3_ex1).
-author("aaron lelevier").
-export([sum/1, sum_range/2]).

%% sums all integers from 1..N
-spec sum(integer()) -> integer().
sum(N) when N > 0 -> N + sum(N-1);
sum(0) -> 0.

%% inclusively sums a range where N =< M
-spec sum_range(integer(), integer()) -> integer().
sum_range(M, M) -> M;
sum_range(N, M) when N =< M -> N + sum_range(N+1, M).
