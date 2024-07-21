%%----------------------------------------------------
%% $Id: pt_vip.erl 13109 2014-06-03 07:32:41Z piaohua $
%% @doc 协议35 - vip
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_vip).
-export([handle/3]).

-include("common.hrl").

%% vip 基础信息
handle(35010, [], Rs) ->
    case Rs#role.vip of
        [] ->
            ?WARN("vip data is empty :", []),
            {ok, [0,0,0,0,0,0,0,0,0]};
        [Vip, _Time, Val] ->
            %% Data = [C || {A,B,C,D} <- Val],
            Dia   = get_vip_val(diamond, Val),
            Free  = get_vip_val(free, Val),
            Chat  = get_vip_val(chat, Val),
            Prize = get_vip_val(prize, Val),
            Fast  = get_vip_val(fast, Val),
            Buys1 = get_vip_val(buys1, Val),
            Buys2 = get_vip_val(buys2, Val),
            Buys3 = get_vip_val(buys3, Val),
            {ok, [Vip - 1,Dia,Free,Chat,Prize,Fast,Buys1,Buys2,Buys3]}
    end;

%% vip 礼包奖励领取
handle(35020, [], Rs) ->
    case Rs#role.vip of
        [] ->
            ?WARN("vip data is empty :", []),
            {ok, [127]};
        [Vip, Time, Val] ->
            {prize,V,N,C} = lists:keyfind(prize, 1, Val),
            case C < util:unixtime(today) of
                true ->
                    case data_vip_prize:get(V) of
                        undefined -> {ok, [128]};
                        Data ->
                            Prize = util:get_val(prize, Data),
                            case mod_item:add_items(Rs, Prize) of
                                {ok, Rs1, PA, EA} ->
                                    mod_item:send_notice(Rs#role.pid_sender, PA, EA),
                                    Rs2 = lib_role:add_attr_ok(batch, 52, Rs, Rs1),
                                    lib_role:notice(Rs2),
                                    lib_role:notice(luck, Rs2),
                                    NewTime = util:unixtime(),
                                    Val2 = lists:keyreplace(prize, 1, Val, {prize,V,N + 1,NewTime}),
                                    Rs3 = Rs2#role{vip = [Vip, Time, Val2]},
                                    Rs4 = mod_attain:attain_state(69, 1, Rs3),
                                    mod_item:log_item(add_item,Rs#role.id,7,Prize),
                                    {ok, [0], Rs4#role{save = [vip]}};
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 52, Title, Body, Prize),
                                    NewTime = util:unixtime(),
                                    Val3 = lists:keyreplace(prize, 1, Val, {prize,V,N + 1,NewTime}),
                                    Rs3 = Rs#role{vip = [Vip, Time, Val3]},
                                    Rs4 = mod_attain:attain_state(69, 1, Rs3),
                                    {ok, [3], Rs4#role{save = [vip]}};
                                {error, _} ->
                                    {ok, [129]}
                            end
                    end;
                false ->
                    {ok, [1]}
            end
    end;

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===
get_vip_val(prize, Val) ->
    case lists:keyfind(prize, 1, Val) of
        false -> 0;
        {_,_,N,C} ->
            case C < util:unixtime(today) of
                true -> 0;
                false -> N
            end
    end;
get_vip_val(AtomId, Val) ->
    case lists:keyfind(AtomId, 1, Val) of
        false -> 0;
        {_,_,N,_} -> N
    end.

%% 测试函数,测试正常后修改/删除
%% timetest() ->
%%     {M, S, _MS} = os:timestamp(),
%%     M * 1000000 + S. % + MS / 1000000.
%%
%% timetest2(today) ->
%%     {M, S, MS} = os:timestamp(),
%%     {_, Time} = calendar:now_to_local_time({M, S, MS}),
%%     M * 1000000 + S - calendar:time_to_seconds(Time).

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
