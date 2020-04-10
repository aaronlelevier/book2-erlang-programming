%%%-------------------------------------------------------------------
%%% @author aaron lelevier
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2020 6:20 AM
%%%-------------------------------------------------------------------
-module(ch10_usr).
-author("aaron lelevier").
-vsn(1.0).
-export([]).
-compile(export_all).

-include("usr.hrl").

-define(TIMEOUT, 10000).

%% Operation and Maintenance --------------------------------

start() ->
  start("usrDb.dets").

start(FileName) ->
  register(?MODULE, spawn(?MODULE, init, [FileName, self()])),
  receive
    started -> ok
  after
    ?TIMEOUT ->
      {error, starting}
  end.

-spec stop() -> ok | {error, Reason :: atom()}.
stop() -> call(stop).

%% Customer Service API -------------------------------------------

add_usr(PhoneNo, CustId, Plan) when Plan == prepay; Plan == postpay ->
  call({add_usr, PhoneNo, CustId, Plan}).

delete_usr(CustId) ->
  call({delete_usr, CustId}).

set_service(CustId, Service, Flag) when Flag == true; Flag == false ->
  call({set_service, CustId, Service, Flag}).

set_status(CustId, Status) when Status == enabled; Status == disabled ->
  call({set_status, CustId, Status}).

delete_disabled() ->
  call(delete_disabled).

lookup_id(CustId) ->
  ch10_user_db:lookup_id(CustId).

%% Service API ---------------------------------------

lookup_msisdn(CustId) ->
  ch10_user_db:lookup_msisdn(CustId).

service_flag(PhoneNo, Service) ->
  case ch10_user_db:lookup_msisdn(PhoneNo) of
    {ok, #usr{services = Services, status = enabled}} ->
      lists:member(Service, Services);
    {ok, #usr{status = disabled}} ->
      {error, disabled};
    {error, Reason} ->
      {error, Reason}
  end.

%% Messaging Functions -------------------------------------

call(Request) ->
  Ref = make_ref(),
  ?MODULE ! {request, {self(), Ref}, Request},
  receive
    {reply, Ref, Reply} -> Reply
  after
    ?TIMEOUT -> {error, timeout}
  end.

reply({From, Ref}, Reply) ->
  From ! {reply, Ref, Reply}.

%% Internal Server Functions -------------------------------

init(FileName, Pid) ->
  ch10_user_db:create_tables(FileName),
  ch10_user_db:restore_tables(),
  Pid ! started,
  loop().

loop() ->
  receive
    {request, From, stop} ->
      reply(From, ch10_user_db:close_tables());
    {request, From, Request} ->
      Reply = request(Request),
      reply(From, Reply),
      loop()
  end.

%% Handling Client Requests

request({add_usr, PhoneNo, CustId, Plan}) ->
  ch10_user_db:add_usr(
    #usr{msisdn = PhoneNo, id = CustId, plan = Plan});

request({delete_usr, CustId}) ->
  ch10_user_db:delete_usr(CustId);

request({set_service, CustId, Service, Flag}) ->
  case ch10_user_db:lookup_id(CustId) of
    {ok, Usr} ->
      Services = lists:delete(Service, Usr#usr.services),
      NewServices = case Flag of
                      true -> [Service | Services];
                      false -> Services
                    end,
      ch10_user_db:update_usr(Usr#usr{services = NewServices});
    {error, instance} ->
      {error, instance}
  end;

request({set_status, CustId, Status}) ->
  case ch10_user_db:lookup_id(CustId) of
    {ok, Usr} ->
      ch10_user_db:update_usr(Usr#usr{status = Status});
    {error, instance} ->
      {error, instance}
  end;

request(delete_disabled) ->
  ch10_user_db:delete_disabled().
