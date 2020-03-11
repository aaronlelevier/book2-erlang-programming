%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% Erl docs
%%% - macros: https://erlang.org/doc/reference_manual/macros.html
%%% -compile: https://erlang.org/doc/man/compile.html
%%% @end
%%% Created : 11. Mar 2020 5:56 AM
%%%-------------------------------------------------------------------
-module(ch7_macros).
-author("aaron lelevier").
-compile(export_all).
-export([]).

%% as a constant
-define(TIMEOUT, 1000).

%% macros get expanded and a space put in the middle
-define(FUNC, X).
-define(TION, + X).
double(X) -> ?FUNC?TION.

%% parameterized macros
-define(MULTIPLE(X, Y), X rem Y =:= 0).
%% a macro must be used here because it gets converted to it's literal term during
%% EPP (Erlang Preprocessor) and functions can't be used in when statements
is_multiple(A, B) when ?MULTIPLE(A, B) -> true;
is_multiple(_A, _B) -> false.

%% common pattern to have a commented out version of a macro for easy switching and debugging
-define(DBG(X), ok).
%%-define(DBG(X), io:format("~p~n", [X])).

%% raise X to the power of N
-spec power(X :: integer(), N :: integer()) -> integer().
power(X, N) ->
  power(X, X, N).
power(_X0, X, 0) -> X;
power(X0, X, N) ->
  X2 = X * X0,
  ?DBG({N, X0, X, X2}),
  power(X0, X2, N - 1).


%% double question marks (??) will expand a function argument to it's string representation
-define(VALUE(Call), io:format("~p = ~p~n", [??Call, Call])).
log_call_args_as_string() ->
  ?VALUE(length([1, 2, 3])).

%% macros available by default
default_macros(X) ->
  io:format(
    "module:~p module_string:~p file:~p line:~p func:~p function_name:~p function_arity:~p machine:~p X:~p~n",
    [?MODULE, ?MODULE_STRING, ?FILE, ?LINE, ?FUNC, ?FUNCTION_NAME, ?FUNCTION_ARITY, ?MACHINE, X]
  ).

%% conditional macro
-ifdef(debug).
  -define(DBG2(X), io:format(
    "func:~p function_name:~p function_arity:~p X:~p~n",
    [?FUNC, ?FUNCTION_NAME, ?FUNCTION_ARITY, X])
  ).
-else.
  -define(DBG2(X), ok).
-endif.

debug2(X) ->
  ?DBG2(X),
  X.