%%----------------------------------------------------
%% $Id: pt_01.erl 12474 2014-05-09 02:26:15Z piaohua $
%% @doc === 内部协议01 - 跨时空事件处理 ===
%%      跨进程事件，如果玩家之间交互，
%%      包括和离线玩家交互的事件
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(pt_01).
-export([handle/3]).

-include("common.hrl").

%% 事件处理

%% 反击战报
handle(1001, {lost_report, Rid, Name}, Rs) ->
    Em = {Rid, Name},
    Report = Rs#role.arena_lost_report,
    case lists:member(Em, Report) of
        true -> {ok};
        false ->
            ?DEBUG("~w", [{add, lost_report, Rid, Name}]),
            Report1 = lists:sublist(Report, 1, 49),
            LostReport = [Em | Report1],
            Rs1 = Rs#role{arena_lost_report = LostReport},
            {ok, role:save_delay(arena, Rs1)}
    end;

%% 新竞技场反击战报(coliseum)
handle(1001, {new_lost_report, Rid, Name, Time}, Rs) ->
    Em = {Rid, Name, Time},
    [Id,Lev,Exp,Pic,Num,HighR,PrizeT,Report] = Rs#role.coliseum,
    case lists:keymember(Rid, 1, Report) of
        true -> {ok};
        false ->
            ?INFO("~w", [{add, new_lost_report, Rid, Name}]),
            Report1 = lists:sublist(Report, 1, 30),
            LostReport = [Id,Lev,Exp,Pic,Num,HighR,PrizeT,[Em|Report1]],
            Rs1 = Rs#role{coliseum = LostReport},
            case Rs#role.pid_sender of
                undefined -> ok;
                _ ->
                    sender:pack_send(Rs#role.pid_sender, 33040, [2])
            end,
            {ok, role:save_delay(coliseum, Rs1)}
    end;

%% 离线邮件事件通知
handle(1001, {new_mail}, _Rs) ->
    put('@new_email', 1),
    {ok};

%% 设置好友关系
%% handle(1001, {add_friend, Id}, Rs) ->
%%     Friends = Rs#role.friends,
%%     Rs1 = Rs#role{friends = [Id | Friends]},
%%     {ok, role:save_delay(fest, Rs1)};

handle(1001, {send_info, Cmd, Data}, _Rs) ->
    self() ! {pt, Cmd, Data},
    {ok};

handle(1001, Event, Rs) ->
    ?WARN("undefined event, Rid:~w, Event:~w", [Rs#role.id, Event]),
    {ok};

%% 登陆完成后处理离线事件
handle(1002, Events, Rs) ->
    %% ?INFO("do_events:~w", [Events]),
    Events1 = lists:reverse(Events),
    do_events(Rs, Events1),
    {ok};

%% 角色进程调试开关
handle(1011, [], Rs) ->
    case get('$mydebug') of
        true ->
            io:format("~n[ACCOUNT:~s] DEBUG >>> OFF <<<~n", [Rs#role.account_id]),
            put('$mydebug', false);
        _ ->
            io:format("~n[ACCOUNT:~s] DEBUG <<< ON >>>~n", [Rs#role.account_id]),
            put('$mydebug', true)
    end,
    {ok};

%% 关闭调试
handle(1012, [], Rs) ->
    case get('$mydebug') of
        true ->
            io:format("~n[ACCOUNT:~s] DEBUG >>> OFF <<<~n", [Rs#role.account_id]),
            put('$mydebug', false);
        _ ->
            io:format("~n[ACCOUNT:~s] DEBUG >>> OFF <<<~n", [Rs#role.account_id])
    end,
    {ok};

handle(_Cmd, _Data, _RoleState) ->
    {error, bad_request}.

%%' === 私有函数 ===

do_events(Rs, [Event | Events]) ->
    self() ! {pt, 1001, Event},
    do_events(Rs, Events);
do_events(_Rs, []) -> ok.

%%.

%% vim: set foldmethod=marker foldmarker=%%',%%.:
