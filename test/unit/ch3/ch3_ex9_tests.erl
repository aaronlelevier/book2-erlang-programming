%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:35 AM
%%%-------------------------------------------------------------------
-module(ch3_ex9_tests).
-author("aaron lelevier").
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

-define(TEST_FILE, "apps/ch3/files/ex9.txt").

word_counts_test() ->
  {ok, Map} = ch3_ex9:word_counts(?TEST_FILE),
  ?assert(maps:size(Map) > 0).

file_to_list_test() ->
  L = ch3_ex9:file_to_list(?TEST_FILE),
  ?assert(length(L) > 0).

list_to_words_test() ->
  Lines = ["hi bob", "how", "are you"],
  L = ch3_ex9:list_to_words(Lines),
  ?assertEqual(["hi", "bob", "how", "are", "you"], L).

count_words_test() ->
  L = ["a", "yo", "b", "yo"],
  Map = ch3_ex9:count_words(L),
  ?assertEqual(#{"a" => 1, "b" =>1, "yo" => 2}, Map).