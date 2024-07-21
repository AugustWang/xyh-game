%%----------------------------------------------------
%% $Id: pt_mail.erl 12953 2014-05-22 09:32:28Z piaohua $
%% @doc 协议26 - 邮件系统
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_mail).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
-endif.


%% 邮件列表
handle(26005, [MaxId], Rs) ->
    case mod_mail:get_mail_list(MaxId, Rs) of
        {ok, List} ->
            List1 = case Rs#role.email of
                undefined -> [];
                L -> L
            end,
            List3 = util:del_repeat_element(List ++ List1),
            Rs1 = Rs#role{email = List3},
            List2 = get_new_mail(List, MaxId),
            %% ?DEBUG("==List2:~w, List:~w, LengthList2:~w", [List2, List, erlang:length(List2)]),
            %% TODO: 定时清理过期邮件
            case erlang:length(List2) >= 20 of
                true ->
                    %% sender:pack_send(Rs#role.pid_sender, 26001, []);
                    self() ! {pt, 2054, []};
                false -> ok
            end,
            {ok, [List2], Rs1};
        {error, _} ->
            {ok, [[]]}
    end;

%% 收取附件
handle(26010, [MailId], Rs) ->
    case Rs#role.email of
        undefined ->
            case mod_mail:get_mail(MailId, Rs) of
                {ok, List} ->
                    {Data, Rs1} = get_enclosure_prize(List, Rs),
                    {ok, [Data], Rs1};
                {error, _} ->
                    {ok, [127]}
            end;
        L ->
            case lists:keyfind(MailId, 1, L) of
                false ->
                    case mod_mail:get_mail(MailId, Rs) of
                        {ok, List} ->
                            {Data, Rs1} = get_enclosure_prize(List, Rs),
                            {ok, [Data], Rs1};
                        {error, _} ->
                            {ok, [128]}
                    end;
                List2 ->
                    {Data, Rs2} = get_enclosure_prize([List2], Rs),
                    List3 = lists:keydelete(MailId, 1, L),
                    Rs3 = Rs2#role{email = List3},
                    {ok, [Data], Rs3}
            end
    end;

%% 删除邮件
handle(26015, [EmailId], Rs) ->
    case Rs#role.email of
        undefined ->
            case mod_mail:delete_mail(EmailId, Rs) of
                {ok, _} ->
                    {ok, [0]};
                {error, _} ->
                    {ok, [127]}
            end;
        L ->
            List3 = lists:keydelete(EmailId, 1, L),
            Rs3 = Rs#role{email = List3},
            case mod_mail:delete_mail(EmailId, Rs3) of
                {ok, _} ->
                    {ok, [0], Rs3};
                {error, _} ->
                    {ok, [128]}
            end
    end;

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

get_enclosure_prize([], Rs) -> {1, Rs};
get_enclosure_prize(Mail, Rs) ->
    [{MailId,_FromId,Type,_From,_Content,Val2,_Ctime}] = Mail,
    case get_new_mail(Mail, 0) of
        [] -> {1, Rs};
        _ ->
            case mod_item:add_items(Rs, Val2) of
                {ok, Rs1, PA, EA} ->
                    mod_item:send_notice(Rs#role.pid_sender, PA, EA),
                    lib_role:notice(Rs1),
                    lib_role:notice(luck, Rs1),
                    case mod_mail:delete_mail(MailId, Rs1) of
                        {ok, _} ->
                            Rs2 = case (Rs1#role.gold - Rs#role.gold) > 0 of
                                true -> lib_role:add_attr_ok(gold, Type, Rs, Rs1);
                                false -> Rs1
                            end,
                            Rs3 = case (Rs2#role.diamond - Rs#role.diamond) > 0 of
                                true -> lib_role:add_attr_ok(diamond, Type, Rs, Rs2);
                                false -> Rs2
                            end,
                            {0, Rs3};
                        {error, _} -> {130, Rs}
                    end;
                {error, full} ->
                    {3, Rs};
                {error, _Error} ->
                    {129, Rs}
            end
    end.

%% 不处理过期邮件
get_new_mail(Email, MaxId) ->
    F1 = fun({Id,_Fid,From,Content,Items,Ctime}) ->
            Time = util:unixtime(),
            TimeLeft = case Items == [] of
                true -> 7 * 86400 - (Time - Ctime);
                false -> 15 * 86400 - (Time - Ctime)
                %% true -> 1 * 60 * 60 - (Time - Ctime);
                %% false -> 2 * 60 * 60 - (Time - Ctime)
            end,
            Val = mod_mail:items_list2(Items, []),
            [Id, From, Content, TimeLeft, Val]
    end,
    [F1({X1,X2,X4,X5,X6,X7}) || {X1,X2,_X3,X4,X5,X6,X7} <- Email, X1 > MaxId, F1({X1,X2,X4,X5,X6,X7}) =/= []].

%% 收取邮件过虑过期邮件
%% get_new_mail2(Email, MaxId) ->
%%     F1 = fun({Id,_Fid,From,Content,Items,Ctime}) ->
%%             Time = util:unixtime(),
%%             TimeLeft = case Items == [] of
%%                 true -> 7 * 86400 - (Time - Ctime);
%%                 false -> 15 * 86400 - (Time - Ctime)
%%                 %% true -> 1 * 60 * 60 - (Time - Ctime);
%%                 %% false -> 2 * 60 * 60 - (Time - Ctime)
%%             end,
%%             Val = mod_mail:items_list2(Items, []),
%%             %% TODO:不处理过期,定期处理
%%             case TimeLeft > 0 of
%%                 true -> [Id, From, Content, TimeLeft, Val];
%%                 false -> []
%%             end
%%     end,
%%     [F1({X1,X2,X4,X5,X6,X7}) || {X1,X2,X3,X4,X5,X6,X7} <- Email, X1 > MaxId, F1({X1,X2,X4,X5,X6,X7}) =/= []].

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
