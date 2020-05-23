%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 7:15 AM
%%%-------------------------------------------------------------------
-module(monads_learning).
-author("Aaron Lelevier").
-vsn(1.0).
-export([is_integers/1, do_identity/1, rand_int/0]).
-compile({parse_transform, do}).

%% @doc checks a list if each item is an integer and returns a list of booleans
-spec is_integers(L :: [any()]) -> [boolean()].
is_integers([H | T]) ->
  [is_integer(H) | is_integers(T)];
is_integers([]) -> [].

%% @doc examples of using an identity monad
%% https://github.com/rabbitmq/erlando#the-inevitable-monad-tutorial

do_identity(X) ->
  do([identity_m ||
    Result <- is_integer(X),
    Result]).

rand_int() ->
  do([identity_m ||
    X <- rand:normal(),
    X2 <- X*100000,
    X3 <- trunc(X2),
    abs(X3)]).
