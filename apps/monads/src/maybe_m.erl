%%%-------------------------------------------------------------------
%%% @author https://github.com/rabbitmq/erlando#the-inevitable-monad-tutorial
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 7:49 AM
%%%-------------------------------------------------------------------
-module(maybe_m).
-vsn(1.0).
-behaviour(monad).
-export(['>>='/2, return/1, fail/1]).

'>>='({just, X}, Fun) -> Fun(X);
'>>='(nothing,  _Fun) -> nothing.

return(X) -> {just, X}.
fail(_X)  -> nothing.

