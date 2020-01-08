%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:33 AM
%%%-------------------------------------------------------------------
-module(ch3_ex2).
-author("aaron lelevier").
-export([create/1, create_reverse/1]).

%% takes an integer N and returns a list 1..N
-spec create(N::integer()) -> [integer()].
create(N) -> create(N, []).

create(0, Acc) -> Acc;
create(N, Acc) -> create(N-1, [N|Acc]).

%% takes an integer N and returns a list N..1
-spec create_reverse(N::integer()) -> [integer()].
create_reverse(N) -> lists:reverse(create(N)).

