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
-export([start/3]).

%% @doc starts a ring of N processes and sends the Message
%% around the ring M number of times
-spec start(M::integer(), N::integer(), Message::string()).
start(M, N, Message) -> {M, N, Message}.

%% TODO: A - have a central process that sets up the ring and
%% initiates message sending

%% TODO: B - initiate a process, the process then initiates each
%% next process in the ring, with this method, need to find a way
%% to link the processes
