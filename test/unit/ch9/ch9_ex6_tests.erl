%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 29. Mar 2020 6:06 AM
%%%-------------------------------------------------------------------
-module(ch9_ex6_tests).
-author("aaron lelevier").
-compile(nowarn_export_all).
-include_lib("eunit/include/eunit.hrl").

tree_to_list_test() ->
  Tree = {node,
    {node,
      {leaf, cat},
      {node,
        {leaf, dog},
        {leaf, emu}
      }
    },
    {leaf, fish}
  },

  Ret = ch9_ex6:treeToList(Tree),

  ?assertEqual([8,6,2,cat,2,dog,emu,fish], Ret).