%% File: usr.hrl
%% Definition of a Usr for the `usr_db`
%%
%% Type spec for records documentation:
%% https://erlang.org/doc/reference_manual/typespec.html#type-information-in-record-declarations

-record(usr, {
  msidn :: integer(),
  id ::integer(),
  status = enabled :: {enabled | disabled},
  plan :: {postpay | prepay},
  services = [] :: [{data | sms | lbs}]
}).