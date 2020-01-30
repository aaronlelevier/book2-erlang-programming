%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Jan 2020 6:33 AM
%%%-------------------------------------------------------------------
-module(ch3_ex9).
-author("aaron lelevier").
-export([word_counts/1, file_to_list/1, list_to_words/1, count_words/1]).

%% returns word counts from a file in a `map`
-spec word_counts(Path::file:name_all()) ->
  {ok, map()} | {error, Reason::file:posix()}.
word_counts(Path) ->
  L = file_to_list(Path),
  Words = list_to_words(L),
  {ok, count_words(Words)}.

%% returns a files contents as a list where each item in the list is a
%% line of the file
-spec file_to_list(Path::file:name_all()) -> [string()].
file_to_list(Path) ->
  FullPath = filename:join(filename:absname(""), Path),
  {ok, Bin} = file:read_file(FullPath),
  Str = string:to_lower(binary_to_list(Bin)),
  string:split(Str, "\n", all).

%% converts the return value of `file_to_list` to a 1d list of words
list_to_words(L) ->
  % each line is a string, and we remove all periods (".")
  Lines = [hd(string:replace(H, ".", "all")) || H <- L],

  % convert each line to a list of words
  LineLists = [string:split(X, " ", all) || X <- Lines],

  % concat all lists of words to a single list
  lists:concat(LineLists).

%% return s a map where the key is the unique item from the list and
%% the value is the number of occurrences
-spec count_words(L::string()) -> map().
count_words(L) ->
  count_words(L, #{}).

count_words([], Map) -> Map;
count_words([H|T], Map) ->
  Value = maps:get(H, Map, 0),
  count_words(T, Map#{H => Value + 1}).
