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

make_btree() ->
  Root = ch7_ex5:root(3),

  % create 1st level children and add to Root
  Child1A = ch7_ex5:node(4),
  Child1B = ch7_ex5:node(2),
  {Root2, Child1A2} = ch7_ex5:add_child(Root, Child1A),
  {Root3, Child1B2} =  ch7_ex5:add_child(Root2, Child1B),

  % create 2nd level children under Child1A only
  Child2A = ch7_ex5:node(1),
  Child2B = ch7_ex5:node(7),
  {Child1A3, Child2A2} = ch7_ex5:add_child(Child1A2, Child2A),
  {Child1A4, Child2B2} =  ch7_ex5:add_child(Child1A3, Child2B),

  Nodes = [Root3, Child1A4, Child1B2, Child2A2, Child2B2],
  ch7_ex5:btree(Nodes).

make_btree_test() ->
  Btree = make_btree(),

  Root = ch7_ex5:find(Btree, root),
  ?assertEqual(3, ch7_ex5:value(Root)),
  RootChildren = ch7_ex5:children(Root),
  ?assertEqual(2, length(RootChildren)),

  [ChildId1A, ChildId1B] = RootChildren,
  Child1A = ch7_ex5:find(Btree, ChildId1A),
  Child1B = ch7_ex5:find(Btree, ChildId1B),
  ?assertEqual(4, ch7_ex5:value(Child1A)),
  ?assertEqual(2, ch7_ex5:value(Child1B)),

  % check Child1A children
  Child1AChildren = ch7_ex5:children(Child1A),
  ?assertEqual(2, length(Child1AChildren)),
  [Child2AId, Child2BId] = Child1AChildren,
  Child2A = ch7_ex5:find(Btree, Child2AId),
  Child2B = ch7_ex5:find(Btree, Child2BId),
  ?assertEqual(1, ch7_ex5:value(Child2A)),
  ?assertEqual(7, ch7_ex5:value(Child2B)),

  % check Child1B children
  ?assertEqual([], ch7_ex5:children(Child1B)).
