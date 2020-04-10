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
  create_tables/1, close_tables/0, restore_tables/0,
  add_usr/1, update_usr/1,
  lookup_id/1, lookup_msisdn/1, get_index/1,
  delete_disabled/0, delete_usr/1, delete_usr/2]).

-include("usr.hrl").

%% Table maintenance functions

create_tables(FileName) ->
  ets:new(usrRam, [named_table, {keypos, #usr.msisdn}]),
  ets:new(usrIndex, [named_table]), % keypos: CustId
  dets:open_file(
    usrDisk, [{file, FileName}, {keypos, #usr.msisdn}]).

close_tables() ->
  ets:delete(usrRam),
  ets:delete(usrIndex),
  dets:close(usrDisk).

restore_tables() ->
  Update = fun(#usr{msisdn = PhoneNo, id = CustId} = Usr) ->
                ets:insert(usrIndex, {CustId, PhoneNo}),
                ets:insert(usrRam, Usr),
                continue
           end,
  dets:traverse(usrDisk, Update).

%% Write Usr to DB Functions

add_usr(#usr{msisdn = PhoneNo, id = CustId} = Usr) ->
  ets:insert(usrIndex, {CustId, PhoneNo}),
  update_usr(Usr).

update_usr(Usr) ->
  ets:insert(usrRam, Usr),
  dets:insert(usrDisk, Usr).

%% Lookup Functions

lookup_id(CustId) ->
  case get_index(CustId) of
    {ok, PhoneNo} -> lookup_msisdn(PhoneNo);
    {error, instance} -> {error, instance}
  end.

get_index(CustId) ->
  case ets:lookup(usrIndex, CustId) of
    [{CustId, PhoneNo}] -> {ok, PhoneNo};
    [] -> {error, instance}
  end.

lookup_msisdn(PhoneNo) ->
  case ets:lookup(usrRam, PhoneNo) of
    [Usr] -> {ok, Usr};
    [] -> {error, instance}
  end.

%% Delete Usr Functions

delete_disabled() ->
  ets:safe_fixtable(usrRam, true),
  catch loop_delete_disabled(ets:first(usrRam)),
  ets:safe_fixtable(usrRam, false),
  ok.

loop_delete_disabled('$end_of_table') ->
    ok;
loop_delete_disabled(PhoneNo) ->
  case ets:lookup(usrRam, PhoneNo) of
    [#usr{status = disabled, id = CustId}] ->
      delete_usr(PhoneNo, CustId);
    _ ->
      ok
  end,
  loop_delete_disabled(ets:next(usrRam, PhoneNo)).

delete_usr(CustId) ->
  {ok, PhoneNo} = get_index(CustId),
  delete_usr(PhoneNo, CustId).

delete_usr(PhoneNo, CustId) ->
  true = ets:delete(usrRam, PhoneNo),
  true = ets:delete(usrIndex, CustId),
  ok = dets:delete(usrDisk, PhoneNo).
