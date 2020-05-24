%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is Erlando.
%%
%% The Initial Developer of the Original Code is VMware, Inc.
%% Copyright (c) 2011-2013 VMware, Inc.  All rights reserved.
%%
-module(state_t, [M]).
-behaviour(monad_trans).
-compile({parse_transform, do}).
-compile({parse_transform, pmod_pt}).

-export_type([state_t/3]).

-export(['>>='/2, return/1, fail/1]).
-export([get/0, put/1, eval/2, exec/2, run/3,
         modify/1, modify_and_return/1, lift/1]).

-opaque state_t(S, M, A) :: fun( (S) -> monad:monadic(M, {A, S}) ).


-spec '>>='(state_t(S, M, A), fun( (A) -> state_t(S, M, B) ), M) -> state_t(S, M, B).
'>>='(X, Fun) ->
    fun (S) ->
            do([M || {A, S1} <- X(S),
                     (Fun(A))(S1)])
    end.


-spec return(A, M) -> state_t(_S, M, A).
return(A) ->
    fun (S) ->
            M:return({A, S})
    end.


-spec fail(any(), M) -> state_t(_S, M, _A).
fail(E) ->
    fun (_) ->
            M:fail(E)
    end.


-spec get(M) -> state_t(S, M, S).
get() ->
    fun (S) ->
            M:return({S, S})
    end.


-spec put(S, M) -> state_t(S, M, ok).
put(S) ->
    fun (_) ->
            M:return({ok, S})
    end.


-spec eval(state_t(S, M, A), S, M) -> monad:monadic(M, A).
eval(SM, S) ->
    do([M || {A, _S1} <- SM(S),
             return(A)]).


-spec exec(state_t(S, M, _A), S, M) -> monad:monadic(M, S).
exec(SM, S) ->
    do([M || {_A, S1} <- SM(S),
             return(S1)]).


%%-spec run(state_t(S, M, A), S, M) -> monad:monadic(M, {A, S}).
run(SM, S, _M) -> SM(S).


-spec modify(fun( (S) -> S ), M) -> state_t(S, M, ok).
modify(Fun) ->
    fun (S) ->
            M:return({ok, Fun(S)})
    end.


-spec modify_and_return(fun( (S) -> {A, S} ), M) -> state_t(S, M, A).
modify_and_return(Fun) ->
    fun (S) ->
            M:return(Fun(S))
    end.


-spec lift(monad:monadic(M, A), M) -> state_t(_S, M, A).
lift(X) ->
    fun (S) ->
            do([M || A <- X,
                     return({A, S})])
    end.
