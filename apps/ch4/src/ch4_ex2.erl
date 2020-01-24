%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. Jan 2020 6:42 AM
%%%-------------------------------------------------------------------
-module(ch4_ex2).
-author("aaron lelevier").
-export([start/3, loop/0]).
-include_lib("book2/include/macros.hrl").

%% @doc starts a ring of N processes and sends the Message
%% around the ring M number of times
-spec start(M::integer(), N::integer(), Msg ::string()) -> any().
start(M, N, Msg) ->
  ?DEBUG({M, N, Msg}),
  PidList = pidlist(N),
  [H|T] = PidList,
  H ! {Msg, T, PidList, 1, M}.

pidlist(N) ->
  [spawn(?MODULE, loop, []) || _X <- lists:seq(1, N)].

loop() ->
  receive
    {quit, CurPidList, PidList, CurM, M}=QuitMsg ->
      ?DEBUG({self(), QuitMsg}),
      ?DEBUG({self(), quitting}),
      case CurPidList of
        [] ->
          ?DEBUG({self(), "all Pids have quite"}),
          done;
        [H|T] ->
          ?DEBUG({self(), "in sequence of quits, tell next Pid to quit"}),
          H ! {quit, T, PidList, CurM, M}
      end;
    {Msg, CurPidList, PidList, CurM, M}=FwdMsg ->
      ?DEBUG({self(), FwdMsg}),
      case CurPidList of
        [] ->
          if
            CurM =:= M ->
              ?DEBUG({self(), "initialize sequence of quits"}),
              [H|T] = PidList,
              H ! {quit, T, PidList, CurM, M},
              loop();
            true ->
              ?DEBUG({self(), "incr M and start new round of Msg's"}),
              [H|T] = PidList,
              H ! {Msg, T, PidList, CurM+1, M},
              loop()
          end;
        [H|T] ->
          ?DEBUG({self(), "same round send to next Pid in CurPidList"}),
          H ! {Msg, T, PidList, CurM, M},
          loop()
      end
  end.

%% TODO: A - have a central process that sets up the ring and
%% initiates message sending

%% TODO: B - initiate a process, the process then initiates each
%% next process in the ring, with this method, need to find a way
%% to link the processes
