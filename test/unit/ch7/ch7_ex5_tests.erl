%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2020 6:31 AM
%%%-------------------------------------------------------------------
-module(ch7_ex5_tests).
-author("aaron lelevier").
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

add_child_links_child_and_parent_test() ->
  Parent = ch7_ex5:node(4),
  Child = ch7_ex5:node(1),
  % pre-test
  ?assertEqual([], ch7_ex5:children(Parent)),
  ?assertEqual(undefined, ch7_ex5:parent(Child)),

  {Parent2, Child2} = ch7_ex5:add_child(Parent, Child),

  Parent2Id = element(2, Parent2),
  Child2Id = element(2, Child2),
  ?assertEqual(Parent2Id, ch7_ex5:parent(Child2)),
  ?assertEqual([Child2Id], ch7_ex5:children(Parent2)).
