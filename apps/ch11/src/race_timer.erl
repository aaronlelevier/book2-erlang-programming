%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 02. May 2020 7:22 AM
%%%-------------------------------------------------------------------
-module(race_timer).
-author("aaron lelevier").
-vsn(1.0).
-export([]).

-include_lib("book2/include/macros.hrl").

%% DEBUG
-compile(export_all).

init(Seconds) -> spawn(?MODULE, loop, [idle, Seconds]).

loop(idle, Seconds) ->
  receive
    start -> run_loop(0, Seconds)
  end.

run_loop(CurSec, MaxSec) ->
  ?LOG({cur, CurSec, max, MaxSec}),
  timer:sleep(1000),
  CurSec2 = CurSec + 1,
  if
    CurSec2 == MaxSec ->
      ?LOG({cur, CurSec2, max, MaxSec});
    true ->
      run_loop(CurSec2, MaxSec)
  end.