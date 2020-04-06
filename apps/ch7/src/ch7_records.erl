%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2020 6:14 AM
%%%-------------------------------------------------------------------
-module(ch7_records).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).
-export([]).

-record(person, {name, age, phone}).

-record(name, {first, surname}).
%% can default a record field
%% can have nested record fields
-record(person2, {name = #name{}, age, phone}).

birthday(#person{age = Age} = P) ->
  P#person{age = Age + 1}.

joes_birthday(#person{age = Age, name = "Joe"} = P) ->
  P#person{age = Age + 1};
joes_birthday(P) ->
  P.

joe() ->
  #person{age = 21, name = "Joe", phone = 5678}.

show_person(#person{age = Age, name = Name, phone = Phone} ) ->
  io:format("age:~p name:~p phone:~p~n", [Age, Name, Phone]).

get_nested_record_field() ->
  Name = #name{first = "Aaron", surname = "Lele"},
  Aaron = #person2{name = Name, age = 35, phone = 123},
  % can access a nested record field in a single line
  Aaron#person2.name#name.first.

%% RecordExp#name.field - RecordExp can be a function invocation if wrapped in parenthesis
get_nested_record_field2() ->
  GenName = fun(First, Surname) -> #name{first = First, surname = Surname} end,
  (GenName("Bob", "Cohen"))#name.first.