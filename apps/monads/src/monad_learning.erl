%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 23. May 2020 7:15 AM
%%%-------------------------------------------------------------------
-module(monad_learning).
-author("Aaron Lelevier").
-vsn(1.0).
-compile({parse_transform, do}).
-include_lib("book2/include/macros.hrl").

-export([is_integers/1, do_identity/1, rand_int/0, if_safe_div_zero/3,
  if_unsafe_div_zero/2, log/1, add_one/0]).

%% @doc checks a list if each item is an integer and returns a list of booleans
-spec is_integers(L :: [any()]) -> [boolean()].
is_integers([H | T]) ->
  [is_integer(H) | is_integers(T)];
is_integers([]) -> [].

%% Identity Monad

do_identity(X) ->
  do([identity_m ||
    Result <- is_integer(X),
    Result]).

rand_int() ->
  do([identity_m ||
    X <- rand:normal(),
    X2 <- X * 100000,
    X3 <- trunc(X2),
    abs(X3)]).

%% Maybe Monad

%% @doc example usage: monad_learning:if_safe_div_zero(8, 4, fun(X) -> X + 1 end).
if_safe_div_zero(X, Y, Fun) ->
  do([maybe_m ||
    Result <- case Y == 0 of
                true -> fail("Cannot divide by zero");
                false -> return(X / Y)
              end,
    % must apply `return` to format as: {just, X}
    return(log(Result)),
    % apply Fun and return
    return(Fun(Result))]).

%% won't hit the false clause if Y == 0, but maybe the above is better
%% because it allows prettier chaining
if_unsafe_div_zero(X, Y) ->
  case Y == 0 of
    true -> 0;
    false -> X / Y
  end.

%% Utility Functions

log(X) ->
  ?LOG(X),
  X.

add_one() ->
  fun(X) -> ?LOG(X), X + 1 end.
