-module(smpp_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    application:start(common_lib),
    smpp_sup:start_link().

stop(_State) ->
    application:stop(common_lib),
    ok.
