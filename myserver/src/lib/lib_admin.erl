%%----------------------------------------------------
%% $Id: lib_admin.erl 13274 2014-06-21 04:48:00Z rolong $
%% @doc WEB管理后台调用的API
%% @author Rolong<erlang6@qq.com>
%% @end
%%----------------------------------------------------
-module(lib_admin).
-export(
   [
    get_online_roleid/0
    ,get_online_roleid/1
    ,add_item/3
    ,add_item/4
    ,add_gold/2
    ,add_diamond/2
    ,add_attain/3
    ,add_item_by_sort/3
    ,add_attr/3
    ,add_attr/4
    ,add_power/2
    ,add_hero/2
    ,add_hero/3
    ,add_heroes_exp/2
    ,add_exp/2
    ,add_horn/2
    ,set_growth/2
    ,role_debug/1
    ,set_tollgate/2
    ,set_honor/2
    ,set_hero_equ/1
    ,set_vip/2
    ,set_fest/3
    ,set_attr/3
    ,set_mcard/2
    ,add_buy/2
    ,check_attain/1
    ,check_timeing/0
    ,check_custom/0
    ,send_mail/3
    ,send_email/3
    ,send_email/5
    ,send_email_custom/5
    ,send_mail2/2
    ,send_mail3/0
    ,send_mail4/0
    %% ,send_mail6/0
    ,reset_cast/0
    ,send_honor/0
    %% ,send_newlev/1
    ,send_notice/0
    ,chat_broadcast/1
    ,reset_password/2
    ,send_verify/2
    ,fix_type/1
    ,set_app_store_rmb/0
    ,create_activate/1
    ,create_activate/2
    ,set_new_honor/0
    ,get_name/1
    ,get_picture/1
    ,get_vip/1
    ,new_server_active/2
    ,new_server_active2/1
    ,send_init_info/1
    ,set_adv_role/1
   ]
  ).

-include("common.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

role_debug(Rid) ->
    sender:send_info(Rid, 1011).

add_item_by_sort(Rid, Sort, Num) ->
    Ids = mod_item:get_ids_by_sort(Sort),
    IdsTL = [{Id, Num} || Id <- Ids],
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2002, [IdsTL]}.

add_item(Rid, Tid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2002, [[{Tid, Num}]]}.

add_item(IdType, Id, Tid, Num) ->
    case get_pid(IdType, Id) of
        false -> {error};
        Pid ->
            Ids = case Tid < 1000 of
                true -> get_tids(Tid, Num);
                false ->
                    AllIds = data_equ:get(ids) ++
                    data_prop:get(ids),
                    case lists:member(Tid, AllIds) of
                        true -> [{Tid, Num}];
                        false -> []
                    end
            end,
            Idss = case Num > 100 of
                true -> [];
                false -> Ids
            end,
            case Idss == [] of
                true -> {error};
                false ->
                    Pid ! {pt, 2002, [Ids]},
                    {ok, Tid, Num}
            end
    end.

get_tids(Sort, Num) ->
    Ids = mod_item:get_ids_by_sort(Sort),
    [{Id, Num} || Id <- Ids].

add_gold(Rid, Num) ->
    add_attr(role_id, Rid, gold, Num).

add_diamond(Rid, Num) ->
    add_attr(role_id, Rid, diamond, Num).

add_attr(IdType, Id, AttrName, AttrVal) ->
    case get_pid(IdType, Id) of
        false -> {error};
        Pid ->
            Pid ! {pt, 2008, [AttrName, AttrVal]},
            {ok, AttrName, AttrVal}
    end.

get_pid(IdType, Id) ->
    Id2 = fix_id(IdType, Id),
    lib_role:get_role_pid(IdType, Id2).

fix_id(name, Id) when is_list(Id) -> list_to_bitstring(Id);
fix_id(account_id, Id) when is_list(Id) -> list_to_bitstring(Id);
fix_id(role_id, Id) when is_list(Id) -> list_to_integer(Id);
fix_id(_, Id) -> Id.


add_attr(Rid, Attr, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2008, [Attr, Num]}.

add_attain(Rid, Type, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2009, [Type, Num]},
    {ok, Type, Num}.

add_power(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2013, [Num]}.

add_heroes_exp(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2025, [Num]}.

set_growth(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2027, [Num]}.

set_tollgate(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2032, [Num]}.

add_hero(Rid, HeroId) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2034, [HeroId]}.

add_hero(Rid, HeroId, Quality) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2035, [HeroId,Quality]}.

set_honor(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2036, [Num]}.

add_exp(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2050, [Num]}.

add_horn(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2052, [Num]}.

%% 卸载英雄身上装备id
set_hero_equ(Rid) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2066, []}.

set_vip(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2070, [Num]}.

set_fest(Rid, FestId, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2072, [FestId, Num]}.

set_attr(Rid, AttrType, AttrVal) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2074, [AttrType, AttrVal]},
    {ok, AttrType, AttrVal}.

set_mcard(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2076, [Num]}.

add_buy(Rid, ProductId) ->
    ?DEBUG("ProductId :~w", [ProductId]),
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2078, [ProductId]},
    {ok, ProductId}.

check_attain(Rid) ->
    Sql = list_to_binary([<<"SELECT `attain` FROM `attain` WHERE `id` = ">>
            ,integer_to_list(Rid)]),
    Att = case db:get_row(Sql) of
        {ok, [Data]} ->
            Data2 = mod_attain:unzip(Data),
            [[A,B,C,D,E] || {A,B,C,D,E} <- Data2];
        {error,_Reason} -> []
    end,
    {ok, lists:sort(Att)}.

check_timeing() ->
    ValList = timeing:get(),
    case ValList == [] of
        true -> [];
        false ->
            [[Key,S,E,SL,UL,B,I] || {Key,{S,E,SL,UL,_T,B,I}} <- ValList]
    end.

check_custom() ->
    custom:get().

%%' send email(可以后台群发邮件,角色id不要手动填写, 老版本已弃用)
send_mail(ToRid, Content, Items) when is_integer(ToRid) ->
    Items2 = util:string_to_term(Items),
    Title = data_text:get(3),
    mod_mail:new_mail(ToRid, 0, 58, Title, Content, Items2);
send_mail(ToRid, Content, Items) ->
    L = string:tokens(ToRid, ","),
    F = fun(X) -> list_to_integer(X) end,
    ToRids = [F(X) || X <- L],
    send_mail(ToRids, Content, Items, mass).
send_mail([], _Content, _Items, mass) -> ok;
send_mail([H|T], Content, Items, mass) ->
    Items2 = util:string_to_term(Items),
    Title = data_text:get(3),
    mod_mail:new_mail(H, 0, 58, Title, Content, Items2),
    send_mail(T, Content, Items, mass).

%% 测试邮件系统
send_mail2(ToRid, N) ->
    %% L = [91,123,49,44,49,48,48,48,125,44,123,50,44,49,48,48,125,93],
    L2 = "[]",
    %% L = data_text:get(3),
    send_mail(ToRid, "welcome mengshoutang", L2),
    %% send_mail(ToRid, L, L2),
    case N < 1 of
        true -> ok;
        false ->
            send_mail2(ToRid, N - 1)
    end.

%% 测试群发邮件系统(线上只执行一次)
send_mail3() ->
    Sql = list_to_binary([<<"SELECT `id` FROM `role` WHERE tollgate_id = 451">>]),
    case db:get_all(Sql) of
        {ok, Data} ->
            Data2 = lists:flatten(Data),
            send_mail3(Data2);
        {error, _} -> error
    end.
send_mail3([]) -> ok;
send_mail3([ToRid | T]) ->
    Title = data_text:get(2),
    Body = data_text:get(10),
    Prize = [{2, 5000}],
    mod_mail:new_mail(ToRid, 0, 58, Title, Body, Prize),
    io:format(".", []),
    send_mail3(T).

%% 4月1日00:00起至4月7日23:59登录过萌兽堂的用户都将获得2000钻石的补偿
%% (线上只执行一次)
send_mail4() ->
    Time1 = util:mktime({{2014,04,01}, {0,0,0}}),
    Time2 = util:mktime({{2014,04,07}, {23,59,59}}),
    Sql = list_to_binary([<<"SELECT DISTINCT `role_id` FROM `log_login` WHERE `login_time` >= ">>
            ,integer_to_list(Time1), <<" AND `login_time` <= ">>
            ,integer_to_list(Time2)]),
    case db:get_all(Sql) of
        {ok, Data} ->
            Data2 = lists:flatten(Data),
            %% myenv:set("@send_mail4", Data2),
            application:set_env(send_mail4, '@send_mail4', Data2),
            %% cache:set(send_mail4, Data2),
            send_mail4(Data2);
        {error, _} -> error
    end.
send_mail4([]) -> ok;
send_mail4([ToRid | T]) ->
    Title = data_text:get(2),
    Body = data_text:get(11),
    Prize = [{2, 2000}],
    mod_mail:new_mail(ToRid, 0, 59, Title, Body, Prize),
    io:format(".", []),
    send_mail4(T).

%% 新的后台邮件发送
send_email(ToRid, Content, Items) ->
    Items2 = util:string_to_term(Items),
    Items3 = fix_type(Items2),
    Items4 = [X || X <- Items3, X =/= []],
    send_mail5(ToRid, Content, Items4),
    ok.

fix_type(Items) ->
    fix_type(Items, []).
fix_type([], Rt) -> Rt;
fix_type([H|T], Rt) ->
    Rt1 = fix_type1(H),
    fix_type(T, [Rt1 | Rt]).
fix_type1({gold,    Num}) when Num > 0 -> {?CUR_GOLD, Num};
fix_type1({diamond, Num}) when Num > 0 -> {?CUR_DIAMOND, Num};
fix_type1({luck,    Num}) when Num > 0 -> {?CUR_LUCK, Num};
fix_type1({tired,   Num}) when Num > 0 -> {?CUR_TIRED, Num};
fix_type1({horn,    Num}) when Num > 0 -> {?CUR_HORN, Num};
fix_type1({equ,     Num1, Num2}) when Num1 > 0 andalso Num2 > 0 -> {Num1, Num2};
fix_type1({prop,    Num1, Num2}) when Num1 > 0 andalso Num2 > 0 -> {Num1, Num2};
fix_type1({mat,     Num1, Num2}) when Num1 > 0 andalso Num2 > 0 -> {Num1, Num2};
fix_type1({hero,    Num1, Num2}) when Num1 > 0 andalso Num2 > 0 -> {?CUR_HERO, {Num1, Num2}};
fix_type1(_) -> [].

send_mail5(ToRid, Content, Items) when is_integer(ToRid) ->
    Title = data_text:get(3),
    mod_mail:new_mail(ToRid, 0, 58, Title, Content, Items);
send_mail5(ToRid, Content, Items) when is_list(ToRid) ->
    L = string:tokens(ToRid, ","),
    F = fun(X) -> list_to_integer(X) end,
    ToRids = [F(X) || X <- L],
    send_mail5(ToRids, Content, Items, mass);
send_mail5(ToRid, _Content, _Items) ->
    ?WARN("mass send email error :~w", [ToRid]),
    ok.
send_mail5([], _Content, _Items, mass) -> ok;
send_mail5([H|T], Content, Items, mass) ->
    Title = data_text:get(3),
    mod_mail:new_mail(H, 0, 58, Title, Content, Items),
    io:format(".", []),
    send_mail5(T, Content, Items, mass).

%% @doc 定时活动奖励发送接口
-spec send_email(ToRid, Content, Items, State, End) -> ok when
    ToRid    :: string(),
    Content  :: string(),
    Items    :: string(),
    State    :: integer(),
    End      :: integer().
send_email(ToRid, Content, Items, State, End) when State > 0 andalso End > State ->
    List = string:tokens(ToRid, ","),
    F1 = fun(X) -> list_to_integer(X) end,
    ToRids = [F1(X) || X <- List],
    Items2 = util:string_to_term(Items),
    Items3 = fix_type(Items2),
    Items4 = [X || X <- Items3, X =/= []],
    Title = data_text:get(3),
    UList = get_online_list(ToRids),
    send_mail5(UList, Content, Items4, mass),
    Val = {State, End, ToRids, UList, Title, Content, Items4},
    timeing:set(Val),
    ok;
send_email(_,_,_,_,_) -> ok.
get_online_list(ToRids) ->
    get_online_list(ToRids, []).
get_online_list([], Rt) -> Rt;
get_online_list([H|T], Rt) ->
    case lib_role:get_online_pid(role_id, H) of
        false -> get_online_list(T, Rt);
        _Pid ->
            get_online_list(T, [H|Rt])
    end.

%%.

%%' 自定义活动设置
send_email_custom(CustomFunArg, Content, Items, State, End) when State > 0 andalso End > State ->
    Val = util:string_to_term(CustomFunArg),
    Val2 = custom_check(Val, []),
    case Val2 =/= [] of
        true ->
            Items2 = util:string_to_term(Items),
            Items3 = fix_type(Items2),
            Items4 = [X || X <- Items3, X =/= []],
            custom:set(Val2,Content,Items4,State,End),
            ok;
        false -> error
    end;
send_email_custom(_,_,_,_,_) -> error.

%% 自定义活动的函数
custom_check([], Rt) -> Rt;
custom_check([{Fun,Arg1,Arg2}|T], Rt) ->
    case custom_check(Fun, Arg1, Arg2) of
        true -> custom_check(T, [{Fun,Arg1,Arg2}|Rt]);
        false -> custom_check(T, Rt)
    end.
custom_check(custom_register, Arg1, Arg2) ->
    Arg1 < Arg2 andalso Arg1 =/= 0 andalso Arg2 =/= 0;
custom_check(custom_login, Arg1, Arg2) ->
    Arg1 < Arg2 andalso Arg1 =/= 0 andalso Arg2 =/= 0;
custom_check(custom_tollgate, Arg1, Arg2) ->
    Arg1 < Arg2 andalso Arg1 =/= 0 andalso Arg2 =/= 0;
custom_check(custom_login_days, Arg1, Arg2) ->
    Arg1 < Arg2 andalso Arg1 =/= 0 andalso Arg2 =/= 0;
custom_check(custom_shop_diamond, Arg1, Arg2) ->
    Arg1 < Arg2 andalso Arg1 =/= 0 andalso Arg2 =/= 0;
custom_check(_,_,_) -> false.

%%.

%% 凌晨广播重置在线用户数据
reset_cast() ->
    %% 凌晨存储当天活动数据
    timeing:save(),
    custom:save(),
    sender:cast_info(world, 2043, []).

%% 21点给在线用户发荣誉值
send_honor() ->
    sender:cast_info(world, 2044, []).

%% send_newlev(Rid) ->
%%     Pid = lib_role:get_role_pid(role_id, Rid),
%%     Pid ! {pt, 2062, []},
%%     ok.

send_notice() ->
    sender:cast_info(world, 2062, []),
    ok.

%% 系统广播消息(字符串转换binary)
chat_broadcast(Content) ->
    Cont = list_to_binary(Content),
    Time1 = util:unixtime(),
    TimeDiff1 = case get('@chat_time') of
        undefined -> 0;
        T1 -> T1
    end,
    case (Time1 - TimeDiff1) >= 0 of
        true ->
            sender:pack_cast(world, 27020, [3, 0, <<"系统公告">>, Cont, 0]),
            put('@chat_time', Time1),
            ok;
        false -> ok
    end.

%% 手动重置密码,慎用重置时把用户踢出在线
reset_password(Rid, Password) ->
    NewPasswd = util:md5(Password),
    %% NewPasswd2 = erlang:binary_to_list(NewPasswd),
    Sql = list_to_binary([<<"UPDATE `role` SET `password` = '">>
            ,NewPasswd, <<"' WHERE `id` = ">>
            ,integer_to_list(Rid)]),
    case db:execute(Sql) of
        {ok, _} ->
            ?INFO("new password :~w", [Password]),
            ok;
        {error, Reason} ->
            ?WARN("reset password error:~w", [Reason]),
            ok
    end.

%% 发送短信验证码
send_verify(Rid, Telephone) ->
    case lib_role:send_verify_code11(Rid, Telephone) of
        {ok, _} ->
            ?INFO("Telephone:~w", [Telephone]),
            ok;
        {error, Reason} ->
            ?WARN("send_verify_code:~w", [Reason]),
            ok
    end.

%% 如果name==<<>>就获取id,
get_name(Rs) ->
    case Rs#role.name == <<>> of
        true ->
            list_to_binary(integer_to_list(Rs#role.id));
        false -> Rs#role.name
    end.

%% 获取用户的头像,
get_picture(Rs) ->
    case Rs#role.coliseum == [] of
        true -> 0;
        false ->
            [_,_,_,Pic,_,_,_,_] = Rs#role.coliseum,
            Pic
    end.

%% 获取用户的vip level,
get_vip(Rs) ->
    case Rs#role.vip of
        [] ->
            ?WARN("vip data is empty :", []),
            0;
        [Vip,_Time,_Val] ->
            Vip - 1
    end.

%% @doc 获取所有在线的角色ID，用于后台在线列表
-spec get_online_roleid() -> [list(), ...].
get_online_roleid()->
    MS = ets:fun2ms(
        fun(#online{id=Id})-> Id end
    ),
    L = ets:select(online, MS),
    Rt = [ integer_to_list(Rid) || Rid <- L ], % 这里不能直接返回，不然ei_rpc无法解包
    Rt.

%% @doc 获取所有在线的角色ID
-spec get_online_roleid(Type) -> [integer(), ...] when
    Type :: list.
get_online_roleid(list)->
    MS = ets:fun2ms(
        fun(#online{id=Id})-> Id end
    ),
    ets:select(online, MS).

%%' app_store表添加rmb字段
set_app_store_rmb() ->
    Sql = list_to_binary([<<"SELECT `id`, `product_id` FROM `app_store`">>]),
    case db:get_all(Sql) of
        {ok, Data} ->
            set_app_store_rmb1(Data),
            ok;
        {error, Reason} ->
            ?WARN("set_app_store_rmb error:~w", [Reason]),
            ok
    end.
set_app_store_rmb1([]) -> ok;
set_app_store_rmb1([[Id, ProductId]|T]) ->
    DiamondData = case data_diamond_shop2:get(binary_to_list(ProductId)) of
        undefined ->
            ?WARN("data_diamond_shop error : ~w", [ProductId]),
            [];
        Data -> Data
    end,
    RMB = util:get_val(rmb, DiamondData, 0),
    Sql = list_to_binary([<<"UPDATE `app_store` SET `rmb` = ">>
            ,integer_to_list(RMB), <<" WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, _} ->
            io:format(".", []),
            set_app_store_rmb1(T);
        {error, Reason} ->
            ?WARN("set_app_store_rmb error:~w", [Reason]),
            ok
    end.
%%.

%%' 生成500个随机激活码
%% create_activate(Num) ->
%%     create_activate(Num, []).
%% create_activate(Num , Rt) ->
%%     case Num < 0 of
%%         true ->
%%             Rt2 = util:del_repeat_element(Rt),
%%             case length(Rt2) < Num of
%%                 true -> create_activate(Num - length(Rt2), Rt2);
%%                 false -> insert_activate(Rt2)
%%             end;
%%         false ->
%%             Rt1 = util:random_string(13),
%%             create_activate(Num - 1, [Rt1|Rt])
%%     end.
%% insert_activate([]) -> ok;
%% insert_activate([Key|Rest]) ->
%%     Time = util:unixtime(),
%%     Sql1 = list_to_binary([<<"SELECT `key` FROM `activate_key` WHERE `key` = '">>
%%             ,Key, <<"'">>]),
%%     case db:get_one(Sql1) of
%%         {ok, _} -> insert_activate(Rest);
%%         {error, null} ->
%%             Sql2 = list_to_binary([<<"INSERT `activate_key` (`key`, `time`) VALUES ('">>
%%                     ,Key, <<"',">>, integer_to_list(Time), <<")">>]),
%%             db:execute(Sql2),
%%             io:format(".", []),
%%             insert_activate(Rest);
%%         {error, Reason} ->
%%             ?WARN("insert_activate error:~w", [Reason]),
%%             ok
%%     end.

%% type < 30
create_activate(Num) ->
    Sql = list_to_binary([<<"SELECT MAX(`type`) FROM `activate_key`">>]),
    case db:get_row(Sql) of
        {ok, [N]} ->
            N1 = case N of
                undefined -> 0;
                _ -> N
            end,
            create_activate1(Num, N1 + 1);
        {error, Reason} ->
            ?WARN("create_activate max type error:~w", [Reason]),
            ok
    end.

create_activate(Num, Type) ->
    Sql = list_to_binary([<<"SELECT count(*) FROM `activate_key` WHERE `type` = ">>
            ,integer_to_list(Type)]),
    case db:get_one(Sql) of
        {ok, _} ->
            create_activate1(Num, Type);
        {error, Reason} ->
            ?WARN("create_activate max type(~w) error:~w", [Type,Reason]),
            ok
    end.

create_activate1(Num, Type) ->
    case Num < 0 of
        true -> ok;
        false ->
            Key = util:random_string(13),
            Time = util:unixtime(),
            Sql1 = list_to_binary([<<"SELECT `key` FROM `activate_key` WHERE `key` = '">>
                    ,Key, <<"'">>]),
            case db:get_one(Sql1) of
                {ok, _} -> create_activate1(Num - 1, Type);
                {error, null} ->
                    Sql2 = list_to_binary([<<"INSERT `activate_key` (`key`, `type`, `time`) VALUES ('">>
                            ,Key, <<"',">>, integer_to_list(Type), <<",">>, integer_to_list(Time), <<")">>]),
                    db:execute(Sql2),
                    io:format(".", []),
                    create_activate1(Num - 1, Type);
                {error, Reason} ->
                    ?WARN("insert_activate error:~w", [Reason]),
                    ok
            end
    end.

%%.

%%' 新版角斗场累加上老的荣誉值
%% TODO: 要处理在线用户数据
set_new_honor() ->
    Sql = list_to_binary([<<"select `rid`, `newexp`, `exp` from `arena` where `robot` = 0 and exp > 0 ;">>]),
    case db:get_all(Sql) of
        {ok, Data} ->
            set_new_honor1(Data);
        {error, Reason} ->
            ?WARN("set_new_honor error:~w", [Reason]),
            ok
    end.
set_new_honor1([]) -> ok;
set_new_honor1([[Rid,NewExp,Exp]|Rest]) ->
    Sql = list_to_binary([<<"update `arena` set `newexp` = ">>
            ,integer_to_list(NewExp + Exp), <<" WHERE `robot` = 0 and `rid` = ">>
            ,integer_to_list(Rid)]),
    case db:execute(Sql) of
        {ok, _} ->
            io:format(".", []),
            %% coliseum ! {set_rank_newexp, Id, NewLev, NewExp + Exp},
            set_new_honor1(Rest);
        {error, Reason} ->
            ?WARN("set_new_honor1 error:~w", [Reason]),
            ok
    end.
%%.

%%' 开新服活动(sid=2,port=8300)
new_server_active(Diamond, ToRid) ->
    Time1 = util:mktime({{2014,04,30}, {0,0,0}}),
    Time2 = util:mktime({{2014,05,03}, {23,59,59}}),
    Time3 = util:unixtime(),
    case Time3 >= Time1 andalso Time3 =< Time2 of
        true ->
            Title = data_text:get(2),
            Body = data_text:get(14),
            Body2 = io_lib:format(Body, [Diamond]),
            Prize = [{2, Diamond}],
            mod_mail:new_mail(ToRid, 0, 59, Title, Body2, Prize),
            ?INFO("[IN_APP_PURCHASE OK SEND PRIZE] diamond:~w", [Diamond]),
            ok;
        false -> ok
    end.

new_server_active2(RankList) ->
    Time1 = util:mktime({{2014,05,01}, {0,0,0}}),
    Time2 = util:mktime({{2014,05,03}, {23,59,59}}),
    Time3 = util:unixtime(),
    case RankList =/= [] andalso Time3 >= Time1 andalso Time3 =< Time2 of
        true ->
            RankList2 = lists:sort(RankList),
            RankList3 = lists:sublist(RankList2, 10),
            RankList4 = [{Pos, Rid} || {Pos,_,Rid,_,_,_,_} <- RankList3, Rid > 20524],
            %% RankList4 = [{Pos, Rid} || {Pos,_,Rid,_,_,_,_} <- RankList3],
            new_server_active3(RankList4);
        false -> ok
    end.

new_server_active3([]) -> ok;
new_server_active3([{Pos,Rid}|Rest]) ->
    Diamond = case Pos of
        1 -> 50000;
        2 -> 20000;
        3 -> 10000;
        _ -> 5000
    end,
    Title = data_text:get(2),
    Body = data_text:get(15),
    Body2 = io_lib:format(Body, [Pos, Diamond]),
    Prize = [{2, Diamond}],
    mod_mail:new_mail(Rid, 0, 59, Title, Body2, Prize),
    ?INFO("[COLISEUM TOP RANK SEND PRIZE] diamond:~w", [Diamond]),
    new_server_active3(Rest).

%%.

%%' give new user a set of heroes and items,use for test
%% 前三个每个ID发4个：215006、214006、213006
%% 后三个每个ID发1个：207006、206006、205006、202006
%% 阿尔萨斯ID：30001、
%% 小黑ID：30023、
%% 女警ID：30016、
%% 血精灵祭祀ID：30011
send_init_info(Rid) ->
    %% Items1 = "[{equ,215006,4},{equ,214006,4},{equ,213006,4}]",
    %% Items2 = "[{equ,207006,1},{equ,206006,1},{equ,205006,1},{equ,202006,1}]",
    %% Heroes = "[{hero,30001,5},{hero,30023,5},{hero,30016,5},{hero,30011,5}]",
    %% send_email(Rid, "darling,The gift for you.", Items1),
    %% send_email(Rid, "darling,The gift for you.", Items2),
    %% send_email(Rid, "darling,The gift for you.", Heroes),
    set_growth(Rid, 13),
    set_tollgate(Rid, 20),
    add_gold(Rid, 1000000),
    add_diamond(Rid, 100000),
    List1 = [{equ,215006,3},{equ,214006,3},{equ,213006,3}],
    List2 = [{equ,207006,1},{equ,206006,1},{equ,205006,1},{equ,202006,1}],
    List3 = [{hero,30001,5},{hero,30023,5},{hero,30016,5},{hero,30011,5}],
    send_init_info2(List1 ++ List2 ++ List3,Rid),
    add_heroes_exp(Rid,9500000),
    ok.
send_init_info2([],_Rid) -> ok;
send_init_info2([{A,I,N}|T],Rid) ->
    case A of
        hero ->
            add_hero(Rid,I,N),
            send_init_info2(T, Rid);
        equ ->
            add_item(Rid,I,N),
            send_init_info2(T,Rid);
        _ ->
            send_init_info2(T,Rid)
    end.

%%.

%%' become a super user
set_adv_role(Rid) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2075, [56]},
    List1 = [{equ,215006,4},{equ,214006,4},{equ,213006,4}],
    List2 = [{equ,207006,1},{equ,206006,1},{equ,205006,1},{equ,202006,1}],
    List3 = [{hero,30001,5},{hero,30023,5},{hero,30016,5},{hero,30011,5}],
    List4 = [{prop,12015,20},{prop,12025,20},{prop,12035,20},{prop,12045,20}
        ,{prop,12055,20},{prop,12065,20},{prop,12075,20},{prop,12085,20}
        ,{prop,12095,20},{prop,12105,20}],
    List5 = [{mat,10109,1000}],
    List = List1 ++ List2 ++ List3 ++ List4 ++ List5,
    set_adv_role2(List, Rid),
    add_gold(Rid, 1000000),
    add_diamond(Rid, 1000000),
    add_heroes_exp(Rid, 9500000),
    set_growth(Rid, 13),
    set_vip(Rid, 2000000),
    ok.
set_adv_role2([], Rid) ->
    io:format("Now ID:(~w) is super user",[Rid]);
set_adv_role2([{A,I,N}|T],Rid) ->
    case A of
        hero ->
            add_hero(Rid,I,N),
            set_adv_role2(T,Rid);
        equ ->
            add_item(Rid,I,N),
            set_adv_role2(T,Rid);
        prop ->
            add_item(Rid,I,N),
            set_adv_role2(T,Rid);
        mat ->
            add_item(Rid,I,N),
            set_adv_role2(T,Rid);
        _ ->
            set_adv_role2(T,Rid)
    end.

%%.

%%' Copy the user information to another account
%% copy_adv_user(Fid,Tid) ->
%%     Pid = lib_role:get_role_pid(role_id, Fid),
%%     {ok, Rs} = gen_server:call(Pid, get_state),

%%.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
