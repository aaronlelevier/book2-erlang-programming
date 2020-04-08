%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2020 6:40 AM
%%%-------------------------------------------------------------------
-module(ch10_user_db).
-author("aaron lelevier").
-vsn(1.0).
-export([
  create_tables/1, close_tables/0,
  add_usr/1, update_usr/1]).

-include("usr.hrl").

create_tables(FileName) ->
  ets:new(usrRam, [named_table, {keypos, #usr.msisdn}]),
  ets:new(usrIndex, [named_table]),
  dets:open_file(
    usrDisk, [{file, FileName}, {keypos, #usr.msisdn}]).

close_tables() ->
  ets:delete(usrRam),
  ets:delete(usrIndex),
  dets:close(usrDisk).

add_usr(#usr{msisdn = PhoneNo, id = CustId} = Usr) ->
  ets:insert(usrIndex, {CustId, PhoneNo}),
  update_usr(Usr).

update_usr(Usr) ->
  ets:insert(usrRam, Usr),
  dets:insert(usrDisk, Usr).
