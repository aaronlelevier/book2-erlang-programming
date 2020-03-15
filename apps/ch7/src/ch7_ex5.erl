%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2020 6:31 AM
%%%-------------------------------------------------------------------
-module(ch7_ex5).
-author("aaron lelevier").
-compile(export_all).
-include_lib("book2/include/macros.hrl").

%% constructors
-export([btree/1, root/1]).
%% functions
-export([sum/1]).

-record(btree, {nodes = []}).
-record(node, {id, is_root = false, parent, value, children = []}).

%% constructors

%% todo: assert there can only be 1 root node in the btree
btree(Nodes) ->
  #btree{nodes = Nodes}.

root(Value) ->
  #node{id = make_ref(), is_root = true, value = Value}.

node(Value) ->
  #node{id = make_ref(), value = Value}.

%% tree traversal functions

%% @doc sum all values using the Nodes list
sum([]) -> 0;
sum([H | T]) -> H#node.value + sum(T);
sum(Btree) when is_record(Btree, btree) -> sum(Btree#btree.nodes).

%% @doc sum all values by starting at the Root and traversing the tree
sum2([]) -> 0;
sum2([H | T]) -> sum2(H) + sum2(T);
sum2(Node) when is_record(Node, node) ->
  Node#node.value + sum2(Node#node.children).

%% @doc finds the max by traversing the Nodes list
max0(Btree) -> max0(Btree#btree.nodes, 0).
max0([], Max) -> Max;
max0([H | T], Max) ->
  Max2 = if
           H#node.value > Max ->
             H#node.value;
           true -> Max
         end,
  max0(T, Max2).

%% @doc finds the max by starting at the Root and traversing the tree
max1(Node) -> max1(Node, 0).
max1([], Max) -> Max;
max1([H | T], Max) -> max1(T, max1(H, Max));
max1(Node, Max) when is_record(Node, node) ->
  Max2 = max(Node#node.value, Max),
  max1(Node#node.children, Max2).

%% check if tree is ordered
is_ordered(Btree) ->
  Root = find(Btree, root),
  is_ordered(Root, true).

is_ordered([], Ret) -> Ret;
is_ordered([H|T], Ret) -> is_ordered(T, is_ordered(H, Ret));
is_ordered(Node, Ret) when is_record(Node, node) ->
  Ret2 = if
           length(Node#node.children) =:= 2 ->
             [A, B] = Node#node.children,
             ?LOG({A#node.value, B#node.value}),
             A#node.value < B#node.value;
           true ->
             Ret
         end,
  % now exit if we find the tree isn't ordered, or else continue
  % to recurse the tree
  case Ret2 of
    false ->
      false;
    true ->
      is_ordered(Node#node.children, Ret2)
  end.

%% tree construction functions

add_child(Parent, Child) ->
  Children = lists:reverse([Child | Parent#node.children]),

  % enforce Child to add to Parent's children can't be the Root node
  if
    Child#node.is_root =:= true ->
      throw({error, root_cant_have_a_parent});
    true ->
      void
  end,

  % enforce 2 children max rule
  if
    length(Children) > 2 ->
      throw({error, two_children_max});
    true ->
      void
  end,

  Parent2 = Parent#node{children = Children},

  % enforce can't set parent more than once
  Child2 = case Child#node.parent of
             undefined ->
               Child#node{parent = Parent};
             _ExistingParent ->
               throw({error, existing_parent})
           end,
  %%  Child2 = Child#node{parent = Parent},
  {Parent2, Child2}.

find(#btree{nodes = Nodes}, root) ->
  hd(lists:filter(fun(#node{is_root = IsRoot}) -> IsRoot =:= true end, Nodes));
find(#btree{nodes = Nodes}, Id) ->
  hd(lists:filter(fun(#node{id = NodeId}) -> NodeId =:= Id end, Nodes)).

%% node data accessor functions

id(#node{id = Id}) -> Id.

is_root(#node{is_root = IsRoot}) -> IsRoot.

value(#node{value = Value}) -> Value.

parent(#node{parent = undefined}) -> undefined;
parent(#node{parent = Parent}) -> Parent#node.id.

children(#node{children = Children}) ->
  [X#node.id || X <- Children].

