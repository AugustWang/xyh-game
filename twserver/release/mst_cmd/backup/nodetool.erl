%% @author Rolong<rolong@vip.qq.com>
%%
main(Args) ->
    ok = start_epmd(),
    %% Extract the args
    {RestArgs, TargetNode} = process_args(Args, [], undefined),

    %% See if the node is currently running  -- if it's not, we'll bail
    case {net_kernel:hidden_connect_node(TargetNode), net_adm:ping(TargetNode)} of
        {true, pong} ->
            ok;
        {_, pang} ->
            io:format("Node ~p not responding to pings.\n", [TargetNode]),
            halt(1)
    end,

    case RestArgs of
        ["ping"] ->
            %% If we got this far, the node already responsed to a ping, so just dump
            %% a "pong"
            io:format("pong\n");
        ["stop"] ->
            io:format("~p\n", [rpc:call(TargetNode, init, stop, [], 60000)]);
        ["reboot"] ->
            io:format("~p\n", [rpc:call(TargetNode, init, reboot, [], 60000)]);
        ["rpc", Module, Function | RpcArgs] ->
            case rpc:call(TargetNode, list_to_atom(Module), list_to_atom(Function),
                          [RpcArgs], 60000) of
                ok ->
                    ok;
                {badrpc, Reason} ->
                    io:format("RPC to ~p failed: ~p\n", [TargetNode, Reason]),
                    halt(1);
                _ ->
                    halt(1)
            end;
        ["rpcterms", Module, Function, ArgsAsString] ->
            case rpc:call(TargetNode, list_to_atom(Module), list_to_atom(Function),
                          consult(ArgsAsString), 60000) of
                {badrpc, Reason} ->
                    io:format("RPC to ~p failed: ~p\n", [TargetNode, Reason]),
                    halt(1);
                Other ->
                    io:format("~p\n", [Other])
            end;
        Other ->
            io:format("Other: ~p\n", [Other]),
            io:format("Usage: nodetool {ping|stop|restart|reboot}\n")
    end,
    net_kernel:stop().

process_args([], Acc, TargetNode) ->
    {lists:reverse(Acc), TargetNode};
process_args(["-setcookie", Cookie | Rest], Acc, TargetNode) ->
    erlang:set_cookie(node(), list_to_atom(Cookie)),
    process_args(Rest, Acc, TargetNode);
process_args(["-name", TargetName | Rest], Acc, _) ->
    ThisNode = append_node_suffix(TargetName, "_maint_"),
    {ok, _} = net_kernel:start([ThisNode, longnames]),
    process_args(Rest, Acc, nodename(TargetName));
process_args(["-sname", TargetName | Rest], Acc, _) ->
    ThisNode = append_node_suffix(TargetName, "_maint_"),
    {ok, _} = net_kernel:start([ThisNode, shortnames]),
    process_args(Rest, Acc, nodename(TargetName));
process_args([Arg | Rest], Acc, Opts) ->
    process_args(Rest, [Arg | Acc], Opts).


start_epmd() ->
    [] = os:cmd(epmd_path() ++ " -daemon"),
    ok.

epmd_path() ->
    ErtsBinDir = filename:dirname(escript:script_name()),
    Name = "epmd",
    case os:find_executable(Name, ErtsBinDir) of
        false ->
            case os:find_executable(Name) of
                false ->
                    io:format("Could not find epmd.~n"),
                    halt(1);
                GlobalEpmd ->
                    GlobalEpmd
            end;
        Epmd ->
            Epmd
    end.


nodename(Name) ->
    case string:tokens(Name, "@") of
        [_Node, _Host] ->
            list_to_atom(Name);
        [Node] ->
            [_, Host] = string:tokens(atom_to_list(node()), "@"),
            list_to_atom(lists:concat([Node, "@", Host]))
    end.

append_node_suffix(Name, Suffix) ->
    case string:tokens(Name, "@") of
        [Node, Host] ->
            list_to_atom(lists:concat([Node, Suffix, os:getpid(), "@", Host]));
        [Node] ->
            list_to_atom(lists:concat([Node, Suffix, os:getpid()]))
    end.


%%
%% Given a string or binary, parse it into a list of terms, ala file:consult/0
%%
consult(Str) when is_list(Str) ->
    consult([], Str, []);
consult(Bin) when is_binary(Bin)->
    consult([], binary_to_list(Bin), []).

consult(Cont, Str, Acc) ->
    case erl_scan:tokens(Cont, Str, 0) of
        {done, Result, Remaining} ->
            case Result of
                {ok, Tokens, _} ->
                    {ok, Term} = erl_parse:parse_term(Tokens),
                    consult([], Remaining, [Term | Acc]);
                {eof, _Other} ->
                    lists:reverse(Acc);
                {error, Info, _} ->
                    {error, Info}
            end;
        {more, Cont1} ->
            consult(Cont1, eof, Acc)
    end.
%% ex: ts=4 sw=4 et
%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
