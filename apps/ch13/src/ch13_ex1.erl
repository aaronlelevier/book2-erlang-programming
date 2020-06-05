%%%-------------------------------------------------------------------
%%% @author Aaron Lelevier
%%% @doc
%%%
%%% @end
%%% Created : 05. Jun 2020 7:43 AM
%%%-------------------------------------------------------------------
-module(ch13_ex1).
-author("Aaron Lelevier").
-vsn(1.0).
-export([create_tables/0, promote/1]).

-record(muppet, {name, callsign, salary}).

%% @doc run 1 time for initial DB setup
create_tables() ->
  create_schema(),
  start(),
  create_table().

create_schema() -> mnesia:create_schema([node()]).

start() -> mnesia:start().

create_table() ->
  mnesia:create_table(muppet, [
    {attributes, record_info(fields, muppet)},
    {disc_copies, [node()]}
  ]).

%% @doc ch13 ex2 - increase a muppet's salary by 10%
promote(Name) ->
  Fun = fun() -> case mnesia:read({muppet, Name}) of
                   [Muppet] ->
                     % "trunc" to convert initial value to an integer
                     NewSalary = trunc(Muppet#muppet.salary * 1.1),
                     mnesia:write(Muppet#muppet{salary = NewSalary});
                   [] ->
                     {error, instance}
                 end
        end,
  mnesia:transaction(Fun).

