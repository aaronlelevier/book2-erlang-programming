%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 4:30 PM
%%%-------------------------------------------------------------------
-module(max_m).
-author("Aaron Lelevier").
-vsn(1.0).
-behaviour(monad).
-export(['>>='/2, return/1, fail/1]).

%% Return the max value less than 10
'>>='(X, Fun) when X < 10 -> Fun(X);
'>>='(X, _Fun) -> X.

return(X) -> {ok, X}.

fail(X) -> {error, X}.

