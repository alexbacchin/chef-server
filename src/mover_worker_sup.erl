%% -*- erlang-indent-level: 4;indent-tabs-mode: nil;fill-column: 92 -*-
%% ex: ts=4 sw=4 et
%% @author Kevin Smith <kevin@opscode.com>
%% @author Seth Falcon <seth@opscode.com>
%% @copyright 2011-2012 Opscode, Inc.

-module(mover_worker_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,
         new_mover/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

new_mover(Config) ->
    supervisor:start_child(?SERVER, [Config]).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    MoverSpec = {undefined, {mover_gen_worker, start_link, []},
                 temporary, 10000, worker, [mover_gen_worker]},
    {ok, {{simple_one_for_one, 10, 10}, [MoverSpec]}}.