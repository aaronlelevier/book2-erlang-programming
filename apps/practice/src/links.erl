%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc Code examples from "Learn You Some Erlang"
%%%
%%% References:
%%% - [LYSE](https://learnyousomeerlang.com/errors-and-processes)
%%% - [Processes](https://erlang.org/doc/reference_manual/processes.html)
%%%
%%% @end
%%% Created : 08. May 2020 6:52 AM
%%%-------------------------------------------------------------------
-module(links).
-author("aaron lelevier").
-vsn(1.0).
-export([]).
-compile(export_all).

myproc() ->
  timer:sleep(1000),
  exit(reason).

myproc(Trap) ->
  process_flag(trap_exit, Trap),
  myproc().

