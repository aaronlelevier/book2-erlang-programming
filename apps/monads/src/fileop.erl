%%%-------------------------------------------------------------------
%%% @author rabbitmq/erlando
%%% @doc
%%% Source here:
%%%   https://gist.github.com/amtal/1240052/cb89edda39e08257a6abd24d961b7d65a88cf814
%%% But that comes from the erlando README:
%%%   https://github.com/rabbitmq/erlando#the-inevitable-monad-tutorial
%%% @end
%%%-------------------------------------------------------------------

%% Credit:

-module(fileop).
-export([write_file/3]).
-compile({parse_transform,do}).

%% Uses an error monad to neatly compose a bunch of failing functions.
%%
%% Everything being composed returns ok|{ok,Result}|{error,Reason}. At
%% the first error, the reason term is returned. The monad factors out
%% the behaviour of piping all possible errors to the output (via a
%% try-throw or case tree) if they occur.
-type error_m(Result,Reason) :: ok | {ok,Result} | {error,Reason}.
%%
%% Here we know the underlying representation of the monad. We don't
%% necessarily need to! A "run" function can be added that turns the
%% opaque monad into a familiar type.
%%
%% -opaque error_m(Result,Reason).
%% -spec run_error_m(error_m(Result,Reason)) ->
%%      ok | {ok,Result} | {error,Reason}.
%%
%%
%% Some command line examples:
%%
%% 1> fileop:write_file(".","foo",[]).
%% {error,eisdir}
%% 2> fileop:write_file("foo.txt",[foo],[]).
%% {error,{not_iolist,[foo]}}
%% 3> fileop:write_file("foo.txt","foo",[lock]).
%% {error,badarg}
%% 4> fileop:write_file("foo.txt","foo",[]).
%% ok
%%
%% Note the syntax being reminiscent of list comprehensions. LCs are
%% using the List monad.
-spec write_file(term(), term(), [atom()]) -> error_m(ok, term()).
write_file(Path, Data, Modes) ->
  Modes1 = [binary, write | (Modes -- [binary, write])],
  do([error_m ||
    Bin <- make_binary(Data),
    Hdl <- file:open(Path, Modes1),
    Result <- do([error_m ||
      ok <- file:write(Hdl, Bin),
      file:sync(Hdl)]),
    file:close(Hdl),
    Result]).


%% Example of two ways to return error monad values.
%%
%% The first is opaque, using error_m:return/1 either directly or via
%% do. We don't need to know the underlying monad implementation to use it.
%%
%% The second is trivial, using the underlying representation we know.
-spec make_binary(atom()|list()|binary()) -> error_m(binary(), term()).
make_binary(Bin) when is_binary(Bin) ->
  do([error_m || return(Bin)]);
make_binary(Atom) when is_atom(Atom) ->
  error_m:return(atom_to_binary(Atom,latin1));
make_binary(List) ->
  try {ok,iolist_to_binary(List)}
  catch error:_ -> {error, {not_iolist,List}}
  end.