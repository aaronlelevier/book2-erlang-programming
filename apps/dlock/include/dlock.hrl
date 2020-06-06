%% How to set record type definitions
%% https://erlang.org/doc/reference_manual/typespec.html#type-information-in-record-declarations

%% @doc a client request sent to the "dlock" server
-record(dlock_request, {
  created,
  callback,
  timeout = 1000,
  items = []
}).