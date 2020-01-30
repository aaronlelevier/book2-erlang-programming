%% @doc macros to be used project wide

-ifdef(debug_flag).
-define(DEBUG(X), io:format("DEBUG ~p:~p ~p~n",[?MODULE, ?LINE, X])).
-else.
-define(DEBUG(X), void).
-endif.

-define(LOG(X), io:format("DEBUG ~p:~p ~p~n",[?MODULE, ?LINE, X])).
