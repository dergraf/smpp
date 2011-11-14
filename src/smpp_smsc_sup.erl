-module(smpp_smsc_sup).
-behaviour(supervisor).

%% interface
-export([start/1,
         start_child/1,
         stop_child/1]).

%% internal exports
-export([start_link/2,
         init/1]).

start(SmscMod) ->
    smpp_sup:start_child(?MODULE, ?MODULE, SmscMod).

start_child(T) ->
    supervisor:start_child(?MODULE, [T]).

start_link(Name, SmscMod) ->
    supervisor:start_link({local, Name}, ?MODULE, [SmscMod]).

stop_child(Pid) ->
    ok = supervisor:terminate_child(?MODULE, Pid).

init([SmscMod]) ->
    Mod = SmscMod,
    Flags = {simple_one_for_one, 0, 1},
    ChildSpec = {Mod,
                 {Mod, start_link, []},
                 temporary,
                 1000,
                 worker,
                 [Mod]},
    {ok, {Flags, [ChildSpec]}}.
