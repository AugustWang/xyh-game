%%----------------------------------------------------
%% $Id: lib_admin.erl 13132 2014-06-04 03:08:33Z piaohua $
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
    ,del_items/2
    ,set_mcard/2
    ,set_sign/1
    ,set_task/4
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
    ,android_server_active/1
    ,android_server_active2/2
    ,android_server_active3/2
    ,android_server_active4/2
    ,android_server_active5/2
    ,send_init_info/1
    ,set_adv_role/1
    ,active_set/0
    ,active_set/5
    ,colosseum_rank_prize/1
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
    Pid ! {pt, 2013, [Num]},
    {ok, Num}.

add_heroes_exp(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2025, [Num]},
    {ok, Num}.

set_growth(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2027, [Num]},
    {ok, Num}.

set_tollgate(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2032, [Num]},
    {ok, Num}.

add_hero(Rid, HeroId) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2034, [HeroId]},
    {ok, HeroId}.

add_hero(Rid, HeroId, Quality) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2035, [HeroId,Quality]}.

set_honor(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2036, [Num]},
    {ok, Num}.

add_exp(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2050, [Num]},
    {ok, Num}.

add_horn(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2052, [Num]}.

%% 卸载英雄身上装备id
set_hero_equ(Rid) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2066, []}.

set_task(Rid, Target, Cid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2067, [Target,Cid,Num]}.

set_vip(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2070, [Num]},
    {ok, Num}.

set_fest(Rid, FestId, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2072, [FestId, Num]}.

set_attr(Rid, AttrType, AttrVal) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2074, [AttrType, AttrVal]},
    {ok, AttrType, AttrVal}.

del_items(Rid, ItemTid) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2073, [ItemTid]},
    {ok, ItemTid}.

set_mcard(Rid, Num) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2076, [Num]},
    {ok, Num}.

set_sign(Rid) ->
    Pid = lib_role:get_role_pid(role_id, Rid),
    Pid ! {pt, 2077, []},
    {ok}.

add_buy(Rid, ProductId) ->
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
-spec send_email(ToRid, Content, Items, State, End) -> ok | error when
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
    {ok, State, End};
send_email(_,_,_,_,_) -> {error}.
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
            {ok, State, End};
        false -> {error}
    end;
send_email_custom(_,_,_,_,_) -> {error}.

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
    %% timeing:save(),
    %% custom:save(),
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
            {ok, Password};
        {error, Reason} ->
            ?WARN("reset password error:~w", [Reason]),
            {error, Reason}
    end.

%% 发送短信验证码
send_verify(Rid, Telephone) ->
    case lib_role:send_verify_code11(Rid, Telephone) of
        {ok, _} ->
            ?INFO("Telephone:~w", [Telephone]),
            {ok, Telephone};
        {error, Reason} ->
            ?WARN("send_verify_code:~w", [Reason]),
            {error, Reason}
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
            Len = util:rand(6,9),
            Key = util:random_string(Len),
            %% Key = util:random_string(8),
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

%% android_server_active(RankList) ->
%%     Time1 = util:mktime({{2014,07,13}, {0,0,0}}),
%%     Time2 = util:mktime({{2014,07,13}, {23,59,59}}),
%%     Time3 = util:unixtime(),
%%     case RankList =/= [] andalso Time3 >= Time1 andalso Time3 =< Time2 of
%%         true ->
%%             RankList2 = lists:keysort(1,RankList),
%%             RankList3 = lists:sublist(RankList2, 10),
%%             F = fun(I,N) ->
%%                     IdL  = integer_to_list(I),
%%                     NaL = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$")),
%%                     case N == NaL of
%%                         true -> 0;
%%                         false -> 1
%%                     end
%%             end,
%%             RankList4 = [{Pos, Rid} || {Pos,_,Rid,Name,_,_} <- RankList3, F(Rid,Name) =/= 0],
%%             android_server_active1(RankList4);
%%         false -> ok
%%     end.
%%
%% android_server_active1([]) -> ok;
%% android_server_active1([{Pos,Rid}|Rest]) ->
%%     Diamond = case Pos of
%%         1 -> 5000;
%%         2 -> 3000;
%%         3 -> 2000;
%%         _ -> 1000
%%     end,
%%     Title = data_text:get(2),
%%     Body = data_text:get(23),
%%     Body2 = io_lib:format(Body, [Pos, Diamond]),
%%     Prize = [{2, Diamond}],
%%     mod_mail:new_mail(Rid, 0, 59, Title, Body2, Prize),
%%     ?INFO("[ANDROID COLISEUM TOP RANK SEND PRIZE] RID:~w DIAMOND:~w", [Rid,Diamond]),
%%     android_server_active1(Rest).

android_server_active(RankList) ->
    Time1 = util:mktime({{2014,08,15}, {0,0,0}}),
    Time2 = util:mktime({{2014,08,15}, {23,59,59}}),
    Time3 = util:unixtime(),
    Time4 = util:mktime({{2014,08,31}, {0,0,0}}),
    Time5 = util:mktime({{2014,08,31}, {23,59,59}}),
    case RankList =/= [] andalso Time3 >= Time1 andalso Time3 =< Time2 of
        true ->
            RankList2 = lists:keysort(1,RankList),
            RankList3 = lists:sublist(RankList2, 10),
            F = fun(I,N) ->
                    IdL  = integer_to_list(I),
                    NaL = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$")),
                    case N == NaL of
                        true -> 0;
                        false -> 1
                    end
            end,
            RankList4 = [{Pos, Rid} || {Pos,_,Rid,Name,_,_} <- RankList3, F(Rid,Name) =/= 0],
            android_server_active1(RankList4);
        false -> ok
    end,
    case RankList =/= [] andalso Time3 >= Time4 andalso Time3 =< Time5 of
        true ->
            RankList22 = lists:keysort(1,RankList),
            RankList33 = lists:sublist(RankList22, 10),
            F2 = fun(I,N) ->
                    IdL  = integer_to_list(I),
                    NaL = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$")),
                    case N == NaL of
                        true -> 0;
                        false -> 1
                    end
            end,
            RankList44 = [{Pos, Rid} || {Pos,_,Rid,Name,_,_} <- RankList33, F2(Rid,Name) =/= 0],
            android_server_active11(RankList44);
        false -> ok
    end.

android_server_active1([]) -> ok;
android_server_active1([{Pos,Rid}|Rest]) ->
    {Num1,Num2,Num3} = case Pos of
        1 -> {40,25,900};
        2 -> {25,15,600};
        3 -> {15,10,400};
        _ -> {5,5,100}
    end,
    Title = data_text:get(2),
    Body = data_text:get(28),
    Body2 = io_lib:format(Body, [Pos,Num1,Num2,Num3]),
    mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{15002,Num1},{15003,Num2},{7, Num3}]),
    ?INFO("[ANDROID COLISEUM TOP RANK SEND PRIZE] RID:~w Pos:~w", [Rid,Pos]),
    android_server_active1(Rest).

android_server_active11([]) -> ok;
android_server_active11([{Pos,Rid}|Rest]) ->
    {Num1,Num2,Num3} = case Pos of
        1 -> {80,50,900};
        2 -> {50,30,600};
        3 -> {35,20,400};
        _ -> {10,10,100}
    end,
    Title = data_text:get(2),
    Body = data_text:get(28),
    Body2 = io_lib:format(Body, [Pos,Num1,Num2,Num3]),
    mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{15002,Num1},{15003,Num2},{7, Num3}]),
    ?INFO("[ANDROID COLISEUM TOP RANK SEND PRIZE] RID:~w Pos:~w", [Rid,Pos]),
    android_server_active11(Rest).

%% android_server_active2(Rid,Gid) ->
%%     Time1 = util:mktime({{2014,07,04}, {9,0,0}}),
%%     Time2 = util:mktime({{2014,07,11}, {10,0,0}}),
%%     Time3 = util:unixtime(),
%%     Num = case Gid of
%%         24 -> 5;
%%         45 -> 10;
%%         66 -> 20;
%%         _ -> 0
%%     end,
%%     case Num =/= 0 andalso Time3 >= Time1 andalso Time3 =< Time2 of
%%         true ->
%%             Title = data_text:get(2),
%%             Body = data_text:get(22),
%%             Body2 = io_lib:format(Body, [Gid, Num]),
%%             mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{3, Num}]),
%%             ok;
%%         false -> ok
%%     end.

android_server_active2(Rid,Gid) ->
    Time1 = util:mktime({{2014,07,18}, {9,0,0}}),
    Time2 = util:mktime({{2014,07,31}, {10,0,0}}),
    Time3 = util:unixtime(),
    Num = case Gid of
        24 -> 5;
        45 -> 10;
        66 -> 20;
        _ -> 0
    end,
    case Num =/= 0 andalso Time3 >= Time1 andalso Time3 =< Time2 of
        true ->
            Title = data_text:get(2),
            Body = data_text:get(22),
            Body2 = io_lib:format(Body, [Gid, Num]),
            mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{3, Num}]),
            ok;
        false -> ok
    end.

%% android_server_active2(Rid,Gid) ->
%%     Time1 = util:mktime({{2014,08,09}, {11,0,0}}),
%%     Time2 = util:mktime({{2014,09,23}, {11,0,0}}),
%%     Time3 = util:unixtime(),
%%     {Num1,Num2} = case Gid of
%%         2 -> {30005,2};
%%         24 -> {5,500};
%%         45 -> {10,200};
%%         66 -> {20,100};
%%         _ -> {0,0}
%%     end,
%%     case Num1 =/= 0 andalso Time3 >= Time1 andalso Time3 =< Time2 of
%%         true ->
%%             case Gid of
%%                 2 ->
%%                     self() ! {pt, 2035, [30005,2]},
%%                     %% Title = data_text:get(2),
%%                     %% Body = data_text:get(26),
%%                     %% Body2 = io_lib:format(Body, [Gid]),
%%                     %% mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{5,{Num1,Num2}}]),
%%                     ok;
%%                 _ ->
%%                     Title = data_text:get(2),
%%                     Body = data_text:get(22),
%%                     Body2 = io_lib:format(Body, [Gid, Num1,Num2]),
%%                     mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{3, Num1},{2,Num2}]),
%%                     ok
%%             end;
%%         false -> ok
%%     end.

android_server_active3(Rid,Hid) ->
    Time1 = util:mktime({{2014,07,18}, {9,0,0}}),
    Time2 = util:mktime({{2014,07,20}, {23,59,59}}),
    Time3 = util:unixtime(),
    Time4 = util:mktime({{2014,07,21}, {9,0,0}}),
    Time5 = util:mktime({{2014,07,31}, {23,59,59}}),
    {Diamond,Tired} = case lists:member(Hid,[30015,30016,30022,30024]) of
        true -> {300,100};
        false ->
            case lists:member(Hid,[30025,30012,30013,30023]) of
                true -> {600,200};
                false -> {0,0}
            end
    end,
    {Diamond2,Tired2} = case lists:member(Hid,[30015,30016,30022,30024]) of
        true -> {100,50};
        false ->
            case lists:member(Hid,[30025,30012,30013,30023]) of
                true -> {200,100};
                false -> {0,0}
            end
    end,
    HName = case Hid of
        30015 -> <<"恶魔猎手">>;
        30016 -> <<"枪神女警">>;
        30022 -> <<"寒冰射手">>;
        30024 -> <<"矮人飞机">>;
        30025 -> <<"熊猫">>;
        30012 -> <<"盖哥">>;
        30013 -> <<"山丘之王">>;
        30023 -> <<"黑暗游侠">>;
        _ -> <<>>
    end,
    case Time3 >= Time1
        andalso Time3 =< Time2
        andalso Diamond =/= 0
        andalso Tired =/= 0
        andalso HName =/= <<>> of
        true ->
            Title = data_text:get(2),
            Body = data_text:get(24),
            Body2 = io_lib:format(Body, [HName, Diamond,Tired]),
            mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{2,Diamond},{7,Tired}]),
            ok;
        false -> ok
    end,
    case Time3 >= Time4
        andalso Time3 =< Time5
        andalso Diamond2 =/= 0
        andalso Tired2 =/= 0
        andalso HName =/= <<>> of
        true ->
            Title2 = data_text:get(2),
            Body22 = data_text:get(24),
            Body222 = io_lib:format(Body22, [HName, Diamond2,Tired2]),
            mod_mail:new_mail(Rid, 0, 59, Title2, Body222, [{2,Diamond2},{7,Tired2}]),
            ok;
        false -> ok
    end.

android_server_active4(Rid,RMB) ->
    Time1 = util:mktime({{2014,08,01}, {10,0,0}}),
    Time2 = util:mktime({{2014,08,31}, {23,59,59}}),
    Time3 = util:unixtime(),
    {Num1,Num2,Num3,Num4} = case RMB of
        98  -> {10,5,100,8};
        308 -> {35,20,400,0};
        448 -> {50,30,600,0};
        618 -> {80,50,900,55};
        _ -> {0,0,0,0}
    end,
    case Num1 =/= 0 andalso Time3 >= Time1 andalso Time3 =< Time2 of
        true ->
            case RMB of
                98 ->
                    Title = data_text:get(2),
                    Body = data_text:get(29),
                    Body2 = io_lib:format(Body, [RMB, Num1,Num2,Num3,Num4]),
                    mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{15002,Num1},{15003,Num2},{7, Num3},{34,Num4}]),
                    ok;
                618 ->
                    Title = data_text:get(2),
                    Body = data_text:get(29),
                    Body2 = io_lib:format(Body, [RMB, Num1,Num2,Num3,Num4]),
                    mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{15002,Num1},{15003,Num2},{7, Num3},{34,Num4}]),
                    ok;
                _ ->
                    Title = data_text:get(2),
                    Body = data_text:get(27),
                    Body2 = io_lib:format(Body, [RMB, Num1,Num2,Num3]),
                    mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{15002,Num1},{15003,Num2},{7, Num3}]),
                    ok
            end;
        false -> ok
    end.

android_server_active5(Rid,5) ->
    Time1 = util:mktime({{2014,08,09}, {11,0,0}}),
    Time2 = util:mktime({{2014,08,13}, {10,59,59}}),
    Time3 = util:unixtime(),
    Time4 = util:mktime({{2014,08,13}, {11,0,0}}),
    Time5 = util:mktime({{2014,08,17}, {10,59,59}}),
    Time6 = util:mktime({{2014,08,17}, {11,0,0}}),
    Time7 = util:mktime({{2014,08,21}, {10,59,59}}),
    Num = if
        Time3 >= Time1 andalso Time3 =< Time2 -> 5;
        Time3 >= Time4 andalso Time3 =< Time5 -> 10;
        Time3 >= Time6 andalso Time3 =< Time7 -> 20;
        true -> 0
    end,
    case Num of
        0 -> ok;
        _ ->
            Title = data_text:get(2),
            Body = data_text:get(31),
            Body2 = io_lib:format(Body, [Num]),
            mod_mail:new_mail(Rid, 0, 59, Title, Body2, [{33,Num}]),
            ok
    end;
android_server_active5(_,_) -> ok.

active_set(Type,Val,Body,Time1,Time2) ->
    %% ?INFO("Type:~w,Val:~w,Body:~w,Time1:~w,Time2:~w",[Type,Val,Body,Time1,Time2]),
    Type1 = list_to_atom(Type),
    Val1 = util:string_to_term(Val),
    case active_set_check(Val1,Type1,Body) of
        ok ->
            extra:set(Type1,Val1,Body,[],Time1,Time2),
            {ok};
        _ -> {error}
    end.

active_set_check([],_,_) -> ok;
active_set_check([{Id,L}|T],Type,Body) ->
    case active_set_check1(L,[]) of
        error -> error;
        Arg ->
            HId = case Type of
                hero ->
                    case Id of
                        30015 -> <<"恶魔猎手">>;
                        30016 -> <<"枪神女警">>;
                        30022 -> <<"寒冰射手">>;
                        30024 -> <<"矮人飞机">>;
                        30025 -> <<"熊猫">>;
                        30012 -> <<"盖哥">>;
                        30013 -> <<"山丘之王">>;
                        30023 -> <<"黑暗游侠">>;
                        _ -> <<>>
                    end;
                _ -> Id
            end,
            M = io_lib:format(Body,[HId|Arg]),
            io:format("~w~n",[M]),
            active_set_check(T,Type,Body)
    end.
active_set_check1([],Rt) ->
    lists:reverse(Rt);
active_set_check1([{Tid,Num}|T],Rt) ->
    case is_integer(Tid) andalso is_integer(Num) of
        true -> active_set_check1(T,[Num|Rt]);
        false -> error
    end.

active_set() ->
    A = active_set1(),
    ?INFO("active_set1 result :~w", [A]),
    B = active_set2(),
    ?INFO("active_set2 result :~w", [B]),
    C = active_set3(),
    ?INFO("active_set3 result :~w", [C]),
    D = active_set4(),
    ?INFO("active_set4 result :~w", [D]),
    E = active_set5(),
    ?INFO("active_set5 result :~w", [E]),
    ok.

active_set1() ->
    Type = rmb,
    Val = [{98,[{15002,10},{15003,5},{7,100}]}
    ,{308,[{15002,35},{15003,20},{7,400}]}
    ,{448,[{15002,50},{15003,30},{7,600}]}
    ,{618,[{15002,80},{15003,50},{7,900}]}],
    Body = "萌亲,您成功充值~w人民币,获得~w个中级深渊卷,~w个高级深渊卷,~w体力值的奖励!",
    Time1 = util:mktime({{2014,08,01}, {10,0,0}}),
    Time2 = util:mktime({{2014,08,31}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time1,Time2).

active_set2() ->
    Type = hero,
    Val = [{30015,[{2,300},{7,100}]}
    ,{30016,[{2,300},{7,100}]}
    ,{30022,[{2,300},{7,100}]}
    ,{30024,[{2,300},{7,100}]}
    ,{30025,[{2,600},{7,200}]}
    ,{30012,[{2,600},{7,200}]}
    ,{30013,[{2,600},{7,200}]}
    ,{30023,[{2,600},{7,200}]}],
    Body = "萌亲,您抽到“~s”英雄,获得~w钻石和~w体力值奖励!",
    Time1 = util:mktime({{2014,08,01}, {10,0,0}}),
    Time2 = util:mktime({{2014,08,31}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time1,Time2).

active_set3() ->
    Type = luck,
    Val = [{5,[{33,5}]}],
    Body = "萌亲,~w,您幸运的抽中了血法英雄,额外获得英雄经验药水~w个",
    Time1 = util:mktime({{2014,08,21}, {10,0,0}}),
    Time2 = util:mktime({{2014,08,31}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time1,Time2).

active_set4() ->
    Type = colosseum,
    Val = [{1,[{2,3600}]}
        ,{2,[{2,3600}]}
        ,{3,[{2,3600}]}
        ,{4,[{2,1200}]}
        ,{5,[{2,1200}]}
        ,{6,[{2,1200}]}
        ,{7,[{2,1200}]}
        ,{8,[{2,1200}]}
        ,{9,[{2,1200}]}
        ,{10,[{2,1200}]}
    ],
    Body = "萌親,恭喜您在角鬥場比賽中榮登第~w名,獲得~w鑽石的獎勵!",
    Time1 = util:mktime({{2014,09,08}, {20,0,0}}),
    Time2 = util:mktime({{2014,09,08}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time1,Time2),
    Time3 = util:mktime({{2014,09,11}, {20,0,0}}),
    Time4 = util:mktime({{2014,09,11}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time3,Time4),
    Time5 = util:mktime({{2014,09,14}, {20,0,0}}),
    Time6 = util:mktime({{2014,09,14}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time5,Time6),
    Time7 = util:mktime({{2014,09,17}, {20,0,0}}),
    Time8 = util:mktime({{2014,09,17}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time7,Time8),
    Time9 = util:mktime({{2014,09,20}, {20,0,0}}),
    Time10 = util:mktime({{2014,09,20}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time9,Time10),
    Time11 = util:mktime({{2014,09,23}, {20,0,0}}),
    Time12 = util:mktime({{2014,09,23}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time11,Time12),
    Time13 = util:mktime({{2014,09,26}, {20,0,0}}),
    Time14 = util:mktime({{2014,09,26}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time13,Time14),
    Time15 = util:mktime({{2014,09,29}, {20,0,0}}),
    Time16 = util:mktime({{2014,09,29}, {23,59,59}}),
    extra:set(Type,Val,Body,[],Time15,Time16).

active_set5() ->
    Type = tollgate,

    Val1 = [{24,[{3,3},{2,300}]}],
    Body1 = "萌親,您參加冒險比賽完成~w關卡,獲得~w顆幸運星和~w鑽石!",

    Val2 = [{45,[{3,6},{12014,1}]}],
    Body2 = "萌親,您參加冒險比賽完成~w關卡,獲得~w顆幸運星和四級血之寶珠~w個!",

    Val3 = [{66,[{3,12},{12034,1}]}],
    Body3 = "萌親,您參加冒險比賽完成~w關卡,獲得~w顆幸運星和四級防禦寶珠~w個!",

    Val4 = [{75,[{30026,5},{12025,1}]}],
    Body4 = "萌親,您參加冒險比賽完成~w關卡,獲得血法之魂~w個和五級攻擊寶珠~w個!",

    Val5 = [{87,[{30026,5},{12095,1}]}],
    Body5 = "萌親,您參加冒險比賽完成~w關卡,獲得血法之魂~w個和五級免暴寶珠~w個!",

    Val6 = [{99,[{30026,5},{12015,1}]}],
    Body6 = "萌親,您參加冒險比賽完成~w關卡,獲得血法之魂~w個和五級血之寶珠~w個!",

    Val7 = [{108,[{30026,5},{12075,1}]}],
    Body7 = "萌親,您參加冒險比賽完成~w關卡,獲得血法之魂~w個和五級命中寶珠~w個!",

    Time1 = util:mktime({{2014,09,03}, {10,0,0}}),
    Time2 = util:mktime({{2014,09,19}, {23,59,59}}),
    extra:set(Type,Val1,Body1,[],Time1,Time2),
    extra:set(Type,Val2,Body2,[],Time1,Time2),
    extra:set(Type,Val3,Body3,[],Time1,Time2),
    extra:set(Type,Val4,Body4,[],Time1,Time2),
    extra:set(Type,Val5,Body5,[],Time1,Time2),
    extra:set(Type,Val6,Body6,[],Time1,Time2),
    extra:set(Type,Val7,Body7,[],Time1,Time2).

colosseum_rank_prize(RankList) ->
    RankList2 = lists:keysort(1,RankList),
    RankList3 = lists:sublist(RankList2, 10),
    F = fun(I,N) ->
            IdL  = integer_to_list(I),
            NaL = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$")),
            case N == NaL of
                true -> 0;
                false -> 1
            end
    end,
    RankList4 = [{Pos, Rid} || {Pos,_,Rid,Name,_,_} <- RankList3, F(Rid,Name) =/= 0],
    colosseum_rank_prize1(RankList4).

colosseum_rank_prize1([]) -> ok;
colosseum_rank_prize1([{Pos,Rid}|T]) ->
    extra:set_use(colosseum,Pos,Rid),
    colosseum_rank_prize1(T).

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
