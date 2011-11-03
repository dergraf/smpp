-module(smpp_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
         start_child/2]).

%% Supervisor callbacks
-export([init/1]).


%% ===================================================================
%% API functions
%% ===================================================================
%%
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Name, Module) ->
    Spec = {Name,
        {Module, start_link, [Name]},
        permanent,
        1000,
        supervisor,
        [Module]},
    supervisor:start_child(?MODULE, Spec).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    Flags = {one_for_one, 0, 1},
    Workers = [], %% each smsc or esme starts its supervisor on demand
    {ok, {Flags, Workers}}.

