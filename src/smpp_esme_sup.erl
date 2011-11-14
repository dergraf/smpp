-module(smpp_esme_sup).
-behaviour(supervisor).

%% interface
-export([start/1,
         start_child/1,
         stop_child/1]).

%% internal exports
-export([start_link/2,
         init/1]).

start(EsmeMod) ->
    smpp_sup:start_child(?MODULE, ?MODULE, EsmeMod).

start_child(T) ->
    supervisor:start_child(?MODULE, [T]).

start_link(Name, EsmeMod) ->
    supervisor:start_link({local, Name}, ?MODULE, [EsmeMod]).

stop_child(Pid) ->
    ok = supervisor:terminate_child(?MODULE, Pid).

init([EsmeMod]) ->
    Mod = EsmeMod,
    Flags = {simple_one_for_one, 0, 1},
    ChildSpec = {Mod,
                 {Mod, start_link, []},
                 temporary,
                 1000,
                 worker,
                 [Mod]},
    {ok, {Flags, [ChildSpec]}}.
