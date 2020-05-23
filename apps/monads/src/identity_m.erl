%%%-------------------------------------------------------------------
%%% @author https://github.com/rabbitmq/erlando#the-inevitable-monad-tutorial
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 7:27 AM
%%%-------------------------------------------------------------------
-module(identity_m).
-vsn(1.0).
-behaviour(monad).
-export(['>>='/2, return/1, fail/1]).

'>>='(X, Fun) -> Fun(X).
return(X)     -> X.
fail(X)       -> throw({error, X}).