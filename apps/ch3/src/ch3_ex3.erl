%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:33 AM
%%%-------------------------------------------------------------------
-module(ch3_ex3).
-author("aaron lelevier").
-export([print_1_to_n/1, print_1_to_n_even_numbers/1]).

print_1_to_n(N) ->
  [io:format("Number:~p~n", [X]) || X <- lists:seq(1, N)],
  ok.

print_1_to_n_even_numbers(N) ->
  [io:format("Number:~p~n", [X]) ||
    X <- lists:seq(1, N),
    X rem 2 =:= 0
  ],
  ok.
