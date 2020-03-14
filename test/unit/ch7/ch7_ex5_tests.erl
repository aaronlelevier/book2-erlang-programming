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

a_child_can_only_have_one_parent_test() ->
  Parent = ch7_ex5:node(4),
  Child = ch7_ex5:node(1),
  % add a Parent is okay if the Child doesn't have a parent
  {Parent2, Child2} = ch7_ex5:add_child(Parent, Child),
  % trying to add a Parent to a Child with a Parent causes an error
  ?assertException(
    throw, {error, existing_parent},
    ch7_ex5:add_child(Parent2, Child2)).

parent_can_have_to_children_max_test() ->
  Parent = ch7_ex5:node(4),
  ChildA = ch7_ex5:node(1),
  ChildB = ch7_ex5:node(2),

  {Parent2, ChildA2} = ch7_ex5:add_child(Parent, ChildA),
  {Parent3, ChildB2} = ch7_ex5:add_child(Parent2, ChildB),

  % parent now has 2 children
  ParentId = element(2, Parent),
  ChildAId = element(2, ChildA),
  ChildBId = element(2, ChildB),

  % confirm the Parent is a parent of both children
  ?assertEqual(ParentId, ch7_ex5:parent(ChildA2)),
  ?assertEqual(ParentId, ch7_ex5:parent(ChildB2)),

  % confirm the children both belong to the Parent
  ?assertEqual([ChildAId, ChildBId], ch7_ex5:children(Parent3)),

  % adding a 3rd Child will raise an exception
  ChildC = ch7_ex5:node(3),
  ?assertException(
    throw, {error, two_children_max},
    ch7_ex5:add_child(Parent3, ChildC)).

is_root_is_set_based_on_constructor_test() ->
  Root = ch7_ex5:root(7),
  Node = ch7_ex5:node(1),
  ?assertEqual(true, ch7_ex5:is_root(Root)),
  ?assertEqual(false, ch7_ex5:is_root(Node)).

root_cant_have_a_parent_test() ->
  Root = ch7_ex5:root(7),
  Parent = ch7_ex5:node(1),
  ?assertException(
    throw, {error, root_cant_have_a_parent},
    ch7_ex5:add_child(Parent, Root)
  ).
