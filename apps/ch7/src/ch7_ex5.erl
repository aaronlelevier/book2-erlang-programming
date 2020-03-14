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
-record(root, {id, value, children = []}).
-record(node, {id, parent, value, children = []}).

%% btree - is a collection of nodes

btree(Nodes) ->
  #btree{nodes = Nodes}.

%% node types

root(Value) ->
  #root{id = make_ref(), value = Value}.

node(Value) ->
  #node{id = make_ref(), value = Value}.

%% tree traversal functions

sum(Btree) -> 0.

%% tree construction functions

add_child(Parent, Child) ->
  Parent2 = Parent#node{children = [Child]},
  Child2 = Child#node{parent = Parent},
  {Parent2, Child2}.

id(#node{id = Id}) -> Id.

parent(#node{parent = undefined}) -> undefined;
parent(#node{parent = Parent}) -> Parent#node.id.

children(#node{children = Children}) ->
  [X#node.id || X <- Children].

