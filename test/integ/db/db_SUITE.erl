%% @doc start application and test it

-module(db_SUITE).
-author("aaron lelevier").
-compile(export_all).
-compile(nowarn_export_all).

%% ct --------------------------------------------------------------------

init_per_suite(Config) ->
  {ok, _} = application:ensure_all_started(db),
  Config.

end_per_suite(_Config) ->
  ok = application:stop(db).

all() ->
  ct_helper:all(?MODULE).

%% tests --------------------------------------------------------------------

example(_Config) -> ok.