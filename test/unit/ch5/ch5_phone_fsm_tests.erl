%%%-------------------------------------------------------------------
%%% @author alelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Feb 2020 5:06 PM
%%%-------------------------------------------------------------------
-module(ch5_phone_fsm_tests).
-author("alelevier").
-include_lib("eunit/include/eunit.hrl").

-define(PHONE, my_phone).

%% test w/o setup/cleanup

start_and_stop_test() ->
  Name = foo,
  ?assertEqual(undefined, whereis(Name)),

  true = ch5_phone_fsm:start(Name),
  ?assert(is_pid(whereis(Name))),

  ok = ch5_phone_fsm:stop(Name),
  ?assertEqual(undefined, whereis(Name)).

%% now the FSM is running, so test transitions

top_setup() -> ch5_phone_fsm:start(?PHONE).

top_cleanup(_) -> ch5_phone_fsm:stop(?PHONE).

get_the_current_state() ->
  ?assertEqual(idle, ch5_phone_fsm:state(?PHONE)).
get_the_current_state_test_() ->
  {setup,
    fun top_setup/0,
    fun top_cleanup/1,
    [fun get_the_current_state/0]}.

