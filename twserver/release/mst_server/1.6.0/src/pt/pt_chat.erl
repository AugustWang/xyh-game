%%----------------------------------------------------
%% $Id$
%% @doc 协议27 - 聊天
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_chat).
-export([handle/3]).

-include("common.hrl").

%% 发送聊天消息
handle(27010, [1, Content], Rs) ->
    Time = util:unixtime(),
    TimeDiff = case get('@chat_time') of
        undefined -> 0;
        T -> T
    end,
    case Content =/= [] andalso Content =/= <<>> of
        true ->
            Time2 = case mod_vip:vip_privilege_check(Rs) of
                true ->
                    [V, _Time, _Val] = Rs#role.vip,
                    Data = data_vip:get(V - 1),
                    util:get_val(chat, Data, 0);
                false -> data_config:get(chatTime)
            end,
            case (Time - TimeDiff) >= Time2 of
                true ->
                    Name = lib_admin:get_name(Rs),
                    Vip = lib_admin:get_vip(Rs),
                    sender:pack_cast(world, 27020, [1, Rs#role.id, Name, Content, Vip]),
                    put('@chat_time', Time),
                    case env:get(server_id) > 10000 of
                        true ->
                            gm_cmd(Content,Rs#role.id);
                        false -> ok
                    end,
                    {ok, [0]};
                false ->
                    {ok, [2]}
            end;
        false ->
            {ok, [3]}
    end;

%% 喇叭
handle(27010, [2, Content], Rs) ->
    case Content =/= [] andalso Content =/= <<>> of
        true ->
            case Rs#role.horn > 0 of
                true ->
                    #role{horn = Horns} = Rs,
                    Name = lib_admin:get_name(Rs),
                    Vip = lib_admin:get_vip(Rs),
                    sender:pack_cast(world, 27020, [2, Rs#role.id, Name, Content, Vip]),
                    Rs1 = Rs#role{horn = Horns - 1},
                    lib_role:notice(horn, Rs1),
                    {ok, [0], Rs1};
                false -> {ok, [1]}
            end;
        false ->
            {ok, [3]}
    end;

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

%% #gold 1000 | #diamond 1000 | #item 30001 2
gm_cmd(Msg,Rid) ->
    Cmds = [
        {"#gold",add_gold}
        ,{"#diamond",add_diamond}
        ,{"#tollgate",set_tollgate}
        ,{"#power",add_power}
        ,{"#item",add_item}
        ,{"#exp",add_heroes_exp}
        ,{"#hero",add_hero}
        ,{"#vip",set_vip}
    ],
    gm_cmd(Cmds,Msg,Rid).
gm_cmd(Cmds,Msg,Rid) when is_binary(Msg) ->
    MsgList = binary_to_list(Msg),
    %% Str = lists:subtract(MsgList,Cmd),
    [Cmd|Rest] = string:tokens(MsgList," "),
    Str = case Rest == [] of
        true -> [];
        false ->
            [A|_] = Rest,
            A
    end,
    case lists:keyfind(Cmd,1,Cmds) of
        false -> ok;
        {Cmd,Fun} when Cmd == "#item" orelse Cmd == "#hero" ->
            case Rest of
                [TidS|NumS] when NumS /= [] ->
                    Tid = case string:to_integer(TidS) of
                        {error,_} -> 0;
                        {TidS1,_} -> TidS1
                    end,
                    [Nums|_] = NumS,
                    Num = case string:to_integer(Nums) of
                        {error,_} -> 0;
                        {NumS1,_} -> NumS1
                    end,
                    case Tid /= 0 andalso Num /= 0 of
                        true ->
                            lib_admin:Fun(Rid,Tid,Num),
                            ok;
                        false -> ok
                    end;
                _ -> ok
            end;
        {Cmd,Fun} ->
            case string:to_integer(Str) of
                {error,_} -> ok;
                {Num,_} ->
                    lib_admin:Fun(Rid,Num),
                    ok
            end
    end;
gm_cmd(_,_,_) -> ok.


%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
