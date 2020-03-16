%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2020 6:22 AM
%%%-------------------------------------------------------------------
-module(ch8_modtest).
-author("aaron lelevier").

%% direct function call to `a` -> won't be be upgraded for a running process
-export([loop1/0]).

%% fully qualified function call to `a` -> will be upgraded
-export([loop2/0]).

%% fully qualified function call to `loop`
-export([loop3/0]).

%% fully qualified function call to `a` and `loop`
-export([loop4/0]).

%% common functions
-export([main/1, a/1, do/2]).

%% common ----------------------------------------------------

main(Loop) ->
  spawn(ch8_modtest, Loop, []).

a(N) -> N + 1.

do(ServerPid, N) ->
  ServerPid ! {self(), N},
  receive
    Y -> Y
  end.

%% loops ----------------------------------------------------

%% DFC all
loop1() ->
  receive
    {Sender, N} ->
      Sender ! a(N)
  end,
  loop1().

%% FQFC `a`
loop2() ->
  receive
    {Sender, N} ->
      Sender ! ch8_modtest:a(N)
  end,
  loop2().

%% FQFC `loop`
loop3() ->
  receive
    {Sender, N} ->
      Sender ! a(N)
  end,
  ch8_modtest:loop3().

%% FQFC `a` and `loop`
loop4() ->
  receive
    {Sender, N} ->
      Sender ! ch8_modtest:a(N)
  end,
  io:format("Pid:~p boo!~n", [self()]),
  ch8_modtest:loop4().

%% testing ----------------------------------------------------
%%
%% Create processes
%%Pid1 = ch8_modtest:main(loop1).
%%Pid2 = ch8_modtest:main(loop2).
%%Pid3 = ch8_modtest:main(loop3).
%%Pid4 = ch8_modtest:main(loop4).
%%Pids = [Pid1, Pid2, Pid3, Pid4].
%%
%% check output
%%lists:map(fun(Pid) -> ch8_modtest:do(Pid, 3) end, Pids).
%%
%% recompile
%% c(ch8_modtest).
%%
%% check output again
%%lists:map(fun(Pid) -> ch8_modtest:do(Pid, 3) end, Pids).
