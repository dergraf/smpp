-module(smpp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
         start_child/3]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Name, Module, ChildMod) ->
    Spec = {Name,
        {Module, start_link, [Name, ChildMod]},
        permanent,
        1000,
        supervisor,
        [Module]},
    supervisor:start_child(?MODULE, Spec).

init([]) ->
    Flags = {one_for_one, 0, 1},
    Workers = [], %% each smsc or esme starts its supervisor on demand
    {ok, {Flags, Workers}}.

