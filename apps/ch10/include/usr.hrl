%% File: usr.hrl
%% Definition of a Usr for the `usr_db`
%%
%% Type spec for records documentation:
%% https://erlang.org/doc/reference_manual/typespec.html#type-information-in-record-declarations

-record(usr, {
  msisdn :: integer(),
  id ::integer(),
  status = enabled :: {enabled | disabled},
  plan = postpay :: {postpay | prepay},
  services = [data] :: [{data | sms | lbs}]
}).