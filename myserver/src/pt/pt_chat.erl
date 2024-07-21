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
    case Content =/= [] of
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
                    {ok, [0]};
                false ->
                    {ok, [2]}
            end;
        false ->
            {ok, [3]}
    end;

%% 喇叭
handle(27010, [2, Content], Rs) ->
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

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
