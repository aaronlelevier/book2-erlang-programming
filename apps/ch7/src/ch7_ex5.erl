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

%% constructors
-export([btree/1, root/1]).
%% functions
-export([sum/1]).

-record(btree, {nodes = []}).
-record(node, {id, is_root = false, parent, value, children = []}).

%% constructors

btree(Nodes) ->
  #btree{nodes = Nodes}.

root(Value) ->
  #node{id = make_ref(), is_root = true, value = Value}.

node(Value) ->
  #node{id = make_ref(), value = Value}.

%% tree traversal functions

sum(Btree) -> 0.

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

%% node data accessor functions

id(#node{id = Id}) -> Id.

is_root(#node{is_root = IsRoot}) -> IsRoot.

parent(#node{parent = undefined}) -> undefined;
parent(#node{parent = Parent}) -> Parent#node.id.

children(#node{children = Children}) ->
  [X#node.id || X <- Children].

