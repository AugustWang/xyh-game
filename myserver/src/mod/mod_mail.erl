%%----------------------------------------------------
%% $Id: mod_mail.erl 12953 2014-05-22 09:32:28Z piaohua $
%% @doc 邮件模块
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(mod_mail).
-export([
        get_mail_list/2
        ,get_mail/2
        ,delete_mail/2
        ,new_mail/6
        ,mail_zip/1
        ,mail_unzip/1
        ,items_list/2
        ,items_list2/2
        ,delete_overdue_mail1/0
        ,delete_overdue_mail2/0
    ]
).

-include("common.hrl").
-include("prop.hrl").
-include("equ.hrl").
-include("hero.hrl").


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
-endif.

%% 获取最新邮件列表
get_mail_list(MaxId, Rs) ->
    Sql = list_to_binary([<<"SELECT `email_id`, `from_id`, `type_id`, `from`, `content`, `enclosure`, `ctime` FROM `email` WHERE `role_id` = ">>
            , integer_to_list(Rs#role.id), <<" AND `email_id` > ">>, integer_to_list(MaxId), <<" ORDER BY `email_id` LIMIT 0, 20">>]),
    case db:get_all(Sql) of
        {ok, Rows} ->
            List = get_mail_list2(Rows, []),
            {ok, List};
        {error, null} ->
            {ok, []};
        {error, Reason} ->
            {error, Reason}
    end.

%% 获取邮件
%% TODO:只要附件字段就可以
get_mail(Id, Rs) ->
    Sql = list_to_binary([<<"SELECT `email_id`, `from_id`, `type_id`, `from`, `content`, `enclosure`, `ctime` FROM `email` WHERE `role_id` = ">>
            , integer_to_list(Rs#role.id), <<" AND `email_id` = ">>, integer_to_list(Id)]),
    case db:get_row(Sql) of
        {ok, Rows} ->
            List = get_mail_list2([Rows], []),
            {ok, List};
        {error, null} ->
            {ok, []};
        {error, Reason} ->
            {error, Reason}
    end.

%% 删除邮件
delete_mail(Id , Rs) ->
    Sql = list_to_binary([<<"DELETE FROM `email` WHERE `email_id` = ">>
            , integer_to_list(Id), <<" AND `role_id` = ">>, integer_to_list(Rs#role.id)]),
    db:execute(Sql).

%% @doc 新邮件(直接操作数据库,Items=[{Type,Num},{Type,{HeroId,Quality}}])
-spec new_mail(ToRid, FId, Type, From, Content, Items) -> ok | error when
    ToRid   :: integer(),
    FId     :: integer(),
    Type    :: integer(),
    From    :: string(),
    Content :: string(),
    Items   :: list().
new_mail(ToRid, FId, Type, From, Content, Items) ->
    case length(Items) > 3 of
        true ->
            {List1, List2} = lists:split(3, Items),
            case new_mail2(ToRid, FId, Type, From, Content, List1) of
                ok -> new_mail(ToRid, FId, Type, From, Content, List2);
                R -> R
            end;
        false ->
            new_mail2(ToRid, FId, Type, From, Content, Items)
    end.

%% 定期处理过期邮件
delete_overdue_mail1() ->
    Time = util:unixtime() - (15 * 86400),
    Sql = list_to_binary([<<"DELETE FROM `email` WHERE `ctime` < ">>
            , integer_to_list(Time)]),
    case db:execute(Sql) of
        {ok, _} -> ok;
        {error, Reason} ->
            ?WARN("delete overdue mail error: ~w", [Reason]),
            error
    end.

%% 定期处理过期邮件
delete_overdue_mail2() ->
    Time = util:unixtime() - (7 * 86400),
    Sql = list_to_binary([<<"DELETE FROM `email` WHERE `ctime` < ">>
            , integer_to_list(Time), <<" AND `enclosure` = ''">>]),
    case db:execute(Sql) of
        {ok, _} -> ok;
        {error, Reason} ->
            ?WARN("delete overdue mail error: ~w", [Reason]),
            error
    end.

%% --- 私有函数 ---

%% mail_zip / mail_unzip
-define(MAIL_ZIP_VERSION, 1).
%% 解包附件
mail_unzip(<<>>) -> [];
mail_unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            mail_unzip1(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

mail_unzip1(<<X1:32, X2:32, X3:32, RestBin/binary>>, Rt) ->
    Rt1 = [{X1, X2, X3} | Rt],
    mail_unzip1(RestBin, Rt1);
mail_unzip1(<<>>, Rt) -> Rt.

%% 打包附件
mail_zip([]) -> <<>>;
mail_zip(Items) ->
    Bin = list_to_binary(mail_zip1(Items, [])),
    <<?MAIL_ZIP_VERSION:8, Bin/binary>>.

mail_zip1([{Type, Num, Custom} | Items], Rt) ->
    Rt1 = <<Type:32, Num:32, Custom:32>>,
    mail_zip1(Items, [Rt1 | Rt]);
mail_zip1([], Rt) -> Rt.


new_mail2(ToRid, FId, Type, From, Content, Items) ->
    Ctime = util:unixtime(),
    Items2 = items_list2(Items, []),
    Val = ?ESC_SINGLE_QUOTES(mail_zip(Items2)),
    Sql2 = list_to_binary([<<"INSERT `email` (`role_id`, `from_id`, `type_id`, `from`, `content`, `enclosure`, `ctime`) VALUES (">>
            , integer_to_list(ToRid), <<",">>, integer_to_list(FId), <<",">>
            , integer_to_list(Type), <<",'">>
            , From, <<"','">>, Content, <<"','">>
            , Val, <<"',">>, integer_to_list(Ctime), <<")">>]),
    case db:execute(Sql2) of
        {ok, _} ->
            case lib_role:get_online_pid(role_id, ToRid) of
                false ->
                    %% 离线用户事件处理
                    myevent:send_event(ToRid, {new_mail}),
                    ok;
                ToPid ->
                    %% 不能call自己
                    case ToPid =:= self() of
                        true -> self() ! {pt, 2054, []}, ok;
                        false ->
                            case catch gen_server:call(ToPid, get_pid_sender) of
                                {ok, ToPidSender} ->
                                    sender:pack_send(ToPidSender, 26001, []),
                                    ok;
                                {'EXIT', Reason} ->
                                    ?WARN("call pid_sender error: ~w", [Reason]),
                                    error
                            end
                    end
            end;
        {error, Reason} ->
            ?WARN("send new mail error: ~w", [Reason]),
            error
    end.

get_mail_list2([H | T], Result) ->
    [Eid, FromId, Type, From, Content, Enclosure, Ctime] = H,
    Val = mail_unzip(Enclosure),
    Val2 = items_list(Val, []),
    List = {Eid, FromId, Type, From, Content, Val2, Ctime},
    get_mail_list2(T, [List | Result]);
get_mail_list2([], Result) -> Result.

items_list([{Type, Num, Custom} | Items], R) ->
    case Type == 5 of
        true ->
            List = [{Type, {Num, Custom}} | R],
            items_list(Items, List);
        false ->
            List2 = [{Type, Num} | R],
            items_list(Items, List2)
    end;
items_list([], R) -> R.

%% 合并相同的Tid,转换存储db
items_list2([{Type, Num} | Items], R) ->
    case check_items_list2(Type, Num) of
        true ->
            case Type == 5 andalso is_tuple(Num) of
                true ->
                    {H, Q} = Num,
                    List = [{Type, H, Q} | R],
                    items_list2(Items, List);
                false ->
                    %% List2 = [{Type, Num, 0} | R],
                    R1 = case lists:keyfind(Type, 1, R) of
                        false -> [{Type, Num, 0} | R];
                        {_, Num1, _} ->
                            lists:keyreplace(Type, 1, R, {Type, Num + Num1, 0})
                    end,
                    items_list2(Items, R1)
            end;
        false -> []
    end;

items_list2([[Type, Num] | Items], R) ->
    case check_items_list2(Type, Num) of
        true ->
            case Type == 5 andalso is_tuple(Num) of
                true ->
                    {H, Q} = Num,
                    List = [{Type, H, Q} | R],
                    items_list2(Items, List);
                false ->
                    R1 = case lists:keyfind(Type, 1, R) of
                        false -> [{Type, Num, 0} | R];
                        {_, Num1, _} ->
                            lists:keyreplace(Type, 1, R, {Type, Num + Num1, 0})
                    end,
                    items_list2(Items, R1)
            end;
        false -> []
    end;
items_list2([Type | Items], R) when is_integer(Type) ->
    items_list2([{Type, 1} | Items], R);
items_list2([], R) ->
    R.

%% 检测邮件数据是否正确
check_items_list2(Type, Num) ->
    if
        Type =< 0 ->
            ?ERR("send email enclosure data error: ~w", [Type]),
            false;
        Type == ?CUR_GOLD andalso is_integer(Num) -> true;
        Type == ?CUR_DIAMOND andalso is_integer(Num) -> true;
        Type == ?CUR_LUCK andalso is_integer(Num) -> true;
        Type == ?CUR_TIRED andalso is_integer(Num) -> true;
        Type == ?CUR_HERO andalso is_tuple(Num) ->
            case Num of
                {Id, Q} ->
                    Ids = data_hero:get(ids),
                    Qids = data_hero_quality:get(ids),
                    F = fun(T) ->
                            {A, _} = data_hero_quality:get(T),
                            A
                    end,
                    QList = [F(I) || I <- Qids],
                    lists:member(Id, Ids) andalso lists:member(Q, QList);
                _ -> false
            end;
        Type >= ?MIN_EQU_ID andalso is_integer(Num) ->
            lists:member(Type, data_equ:get(ids));
        true ->
            lists:member(Type, data_prop:get(ids)) andalso is_integer(Num)
    end.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
