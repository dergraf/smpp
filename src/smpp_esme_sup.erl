-module(smpp_esme_sup).
-behaviour(supervisor).

%% interface
-export([start/0,
         start_child/1]).

%% internal exports
-export([start_link/1,
         init/1]).

start() ->
    smpp_sup:start_child(?MODULE, ?MODULE).

start_child(T) ->
    supervisor:start_child(?MODULE, [T]).

start_link(Name) ->
    supervisor:start_link({local, Name}, ?MODULE, []).

init([]) ->
    Mod = smpp_esme,
    Flags = {simple_one_for_one, 0, 1},
    ChildSpec = {Mod,
                 {Mod, start_link, []},
                 temporary,
                 1000,
                 worker,
                 [Mod]},
    {ok, {Flags, [ChildSpec]}}.
