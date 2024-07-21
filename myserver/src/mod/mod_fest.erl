%%----------------------------------------------------
%% $Id: mod_fest.erl 13274 2014-06-21 04:48:00Z rolong $
%% @doc 活动模块
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(mod_fest).
-export([
        activity_send/1
        ,activity_stores/1
        %% ,activity_stores2/1
        ,activity_init/1
        ,activity_first_pay/1
        ,activity_verify_check/2
        ,activity_friend_login_count/1
        ,firstpay/2
        ,is_firstpay/1
        ,cdkey_check/1
        ,cdkey_check_ok/2
        ,pay_double/2
        ,init_pay_double/1
        ,update_pay_double/1
        ,zip/1
        ,unzip/1
        ,zip2/1
        ,unzip2/1
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
data_first_pay_test() ->
    Ids = data_first_pay:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(X) ->
                Data = data_first_pay:get(X),
                Tid = util:get_val(tid, Data),
                Num = util:get_val(num, Data),
                ?assertMatch(ok,case Tid < ?MIN_EQU_ID of
                        true ->
                            case Tid == 5 of
                                true ->
                                    ?assert(is_tuple(Num)),
                                    {Hid,_} = Num,
                                    ?assert(data_hero:get(Hid) =/= undefined),
                                    ok;
                                false ->
                                    ?assert(data_prop:get(Tid) =/= undefined),
                                    ok
                            end;
                        false ->
                            ?assert(data_equ:get(Tid) =/= undefined),
                            ok
                    end),
                ?assert(is_integer(Tid)),
                ?assert(is_integer(Num) orelse is_tuple(Num))
        end, Ids),
    ok.

data_diamond_shop_test() ->
    Ids = data_diamond_shop:get(ids),
    ?assert(length(Ids) > 0),
    F = fun(X) ->
            Data = data_diamond_shop:get(X),
            util:get_val(shopid,Data,0)
    end,
    ShopIds = [F(X1) || X1 <- Ids],
    ?assert(lists:seq(1,length(Ids)) == ShopIds),
    lists:foreach(fun(X) ->
                Data = data_diamond_shop:get(X),
                Tier = util:get_val(tier,Data,0),
                RMB = util:get_val(rmb,Data,0),
                Diamond = util:get_val(diamond,Data,0),
                ShopId = util:get_val(shopid,Data,0),
                Double = util:get_val(double,Data,[]),
                ?assert(Tier > 0),
                ?assert(RMB > 0),
                ?assert(Diamond > 0),
                ?assert(ShopId > 0),
                ?assert(Double =/= [])
        end, Ids),
    ok.
-endif.

-define(FIRSTPAY, 60).
-define(GIVEDIAMOND, 61).
-define(WEIXINSHARE, 62).
-define(INVITE, 63).
-define(GRADE, 64).
-define(LOGINFRIEND, 65).
-define(BINDING, 66).
-define(CDKEY, 67).

%% 活动id推送
activity_send(Rs) ->
    #role{activity = ActIds} = Rs,
    Id = case lib_system:fest_id() of
        0 -> [];
        V -> [[V]]
    end,
    Id2 = [[Id3] || {Id3, _, _, _} <- ActIds],
    Id ++ Id2.

%% 首充状态推送
activity_first_pay(Rs) ->
    #role{attain = Attain, activity = Activity} = Rs,
    {_, _, _Type, Cond, _} = lists:keyfind(33, 3, Attain),
    case lists:keyfind(?FIRSTPAY, 1, Activity) of
        {?FIRSTPAY, _V, _N, St} ->
            case St =:= 0 of
                true ->
                    case Cond > 0 of
                        true ->
                            NewAct = lists:keyreplace(?FIRSTPAY, 1, Activity, {?FIRSTPAY, 0, 1, 1}),
                            Rs1 = role:save_delay(fest, Rs),
                            {Rs1#role{activity = NewAct}, 0};
                        false -> {Rs, 1}
                    end;
                false -> {Rs, 2}
            end;
        false -> {Rs, 127}
    end.

%% 激活码验证
activity_verify_check(Rs, Verify) ->
    Sql = list_to_binary([<<"SELECT `role_id` FROM `activity` WHERE `verify` = ">>, integer_to_list(Verify)]),
    case db:get_one(Sql) of
        {ok, Rid} ->
            #role{friends = Friend} = Rs,
            myevent:send_event(Rid, {add_friend, Rs#role.id}),
            {Rs#role{friends = [Rid | Friend]}, Rid};
        {error, null} -> {Rs, null};
        {error, _} -> {Rs, error}
    end.

%% 统计昨日登录的好友数量
activity_friend_login_count(Rs) ->
    #role{friends = Friends} = Rs,
    Fri = case Friends =:= [] of
        true -> [0];
        false -> Friends
    end,
    NewFri = [integer_to_list(I) || I <- Fri],
    NewFri1 = string:join(NewFri, ","),
    Yesterday = util:unixtime(yesterday),
    Sql = list_to_binary([<<"SELECT COUNT(DISTINCT role_id) FROM `log_login` WHERE `day_stamp` = ">>
            , integer_to_list(Yesterday), <<" AND `role_id` IN (">>, NewFri1, <<")">>]),
    case db:get_one(Sql) of
        {ok, Num} ->
            {ok, Num};
        {error, Reason} -> {error, Reason}
    end.

%% 初始化非节日活动
%% TODO:添加新活动检测
activity_init(Rs) ->
    Id = Rs#role.id,
    Sql = list_to_binary([<<"SELECT `activityinfo`, `verify`, `friends` FROM `activity` WHERE `role_id` = ">>, integer_to_list(Id)]),
    case db:get_row(Sql) of
        {ok, [Info, Ver, Fri]} ->
            Info2 = activity_init1(unzip(Info)),
            {ok, Rs#role{
                    activity = Info2
                    ,verify  = Ver
                    ,friends = unzip2(Fri)
                    %% ,logintime = util:unixtime()
                }};
        {error, null} ->
            Rs1 = Rs#role{
                    activity = activity_init2()
                    ,verify  = produce_verify(Rs)
                    %% ,logintime = util:unixtime()
                },
            Rs2 = role:save_delay(fest, Rs1),
            {ok, Rs2};
        {error, Reason} ->
            {error, Reason}
    end.

activity_init1([]) -> [];
activity_init1(List) ->
    Data = activity_init2(),
    activity_init1(Data, List).
activity_init1([], List) -> List;
activity_init1([{Id,V,N,S}|Rest], List) ->
    case lists:keyfind(Id,1,List) of
        false ->
            activity_init1(Rest,[{Id,V,N,S}|List]);
        _ ->
            activity_init1(Rest, List)
    end.

activity_init2() ->
    ActData = data_activity_list:get(ids),
    FestData = data_fest:get(ids),
    ActDiamond = data_activity_num:get(ids),
    %% 过滤活动表里的节日活动(节日活动不保存db)
    NewData1 = ActData -- FestData,
    NewData2 = NewData1 ++ ActDiamond,
    [{Id, 0, 1, 0} || Id <- NewData2].

produce_verify(Rs) ->
    #role{id = Id} = Rs,
    Num = util:rand(100, 999),
    Id * 1000 + Num.

%% 数据库相关操作
activity_stores(Rs) ->
    #role{
        id         = Id
        ,verify    = Verify
        ,activity  = ActInfo
        ,friends   = Friends
        %% ,logintime = Time
    } = Rs,
    Val1 = ?ESC_SINGLE_QUOTES(zip(ActInfo)),
    Val2 = ?ESC_SINGLE_QUOTES(zip2(Friends)),
    Sql = list_to_binary([<<"UPDATE `activity` SET `activityinfo` = '">>
            , Val1,<<"', `friends` = '">>, Val2, <<"', `verify` = ">>
            , integer_to_list(Verify), <<" WHERE `role_id` = ">>, integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, 0} -> activity_stores2(Rs);
        {error, Reason} -> {error, Reason};
        {ok, Num} -> {ok, Num}
    end.

activity_stores2(Rs) ->
    #role{
        id         = Id
        ,verify    = Verify
        ,activity  = ActInfo
        ,friends   = Friends
        %% ,logintime = Time
    } = Rs,
    Val1 = ?ESC_SINGLE_QUOTES(zip(ActInfo)),
    Val2 = ?ESC_SINGLE_QUOTES(zip2(Friends)),
    Sql  = list_to_binary([<<"SELECT count(*) FROM `activity` WHERE `role_id` = ">>,integer_to_list(Id)]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `activity` (`role_id`, `verify`, `activityinfo`, `friends`) VALUES (">>
                    , integer_to_list(Id), <<",">>, integer_to_list(Verify), <<",'">>
                    , Val1, <<"','">>, Val2, <<"')">>]),
            db:execute(Sql2);
        {error, Reason} -> {error, Reason};
        {ok, Num} -> {ok, Num}
    end.

firstpay(Rs, Diamond) ->
    #role{activity = Act} = Rs,
    case lists:keyfind(?FIRSTPAY, 1, Act) of
        false -> Rs;
        {?FIRSTPAY,_V,_N,St} ->
            case St =:= 0 of
                true ->
                    Rs1 = lib_role:add_attr(diamond, Diamond, Rs),
                    Rs2 = lib_role:add_attr_ok(diamond, 47, Rs, Rs1),
                    case is_pid(Rs#role.pid_sender) of
                        true -> lib_role:notice(Rs2);
                        false -> ok
                    end,
                    Rs2;
                false -> Rs
            end
    end.

is_firstpay(Rs) ->
    #role{activity = Act} = Rs,
    case lists:keyfind(?FIRSTPAY, 1, Act) of
        false -> 1;
        {?FIRSTPAY,_V,_N,St} ->
            case St =:= 0 of
                true -> 0;
                false -> 1
            end
    end.

cdkey_check(Key) ->
    Sql = list_to_binary([<<"SELECT `time`, `type`, `role_id` FROM `activate_key` WHERE `key` = '">>, Key, <<"'">>]),
    case db:get_row(Sql) of
        {ok, [Time, Type, Rid]} ->
            NowTime = util:unixtime(),
            IsTime = (Time + 30 * 86400) - NowTime,
            Code = case IsTime > 0 of
                true ->
                    case Rid == 0 of
                        true -> 0;
                        false -> 2
                    end;
                false -> 1
            end,
            {Code, Type};
        {error, null} -> {3, 0};
        {error, Reason} ->
            ?WARN("cdkey_check  Key:~w, error:~w", [Key, Reason]),
            {128, 0}
    end.

cdkey_check_ok(Key, Rid) ->
    Sql = list_to_binary([<<"UPDATE `activate_key` SET `role_id` = ">>
            ,integer_to_list(Rid),<<" WHERE `key` = '">>,Key,<<"'">>]),
    case db:execute(Sql) of
        {error, Reason} ->
            ?WARN("cdkey_check_ok Key:~w,Rid:~w, error:~w,",[Key,Rid,Reason]),
            ok;
        {ok, _} -> ok
    end.

%%' pay double
pay_double(Rs, DiamondData) ->
    #role{paydouble = PayDouble} = Rs,
    DoubleId = util:get_val(shopid, DiamondData, 0),
    Double = util:get_val(double, DiamondData, 0),
    case DoubleId =/= 0 andalso Double =/= 0 of
        true ->
            PayNum = case PayDouble == [] of
                true -> 0;
                false ->
                    case lists:keyfind(DoubleId,1,PayDouble) of
                        false -> 0;
                        {_,Num} -> Num
                    end
            end,
            case PayNum < Double of
                true ->
                    Diamond = util:get_val(diamond, DiamondData),
                    Rs1 = lib_role:add_attr(diamond, Diamond, Rs),
                    Rs2 = lib_role:add_attr_ok(diamond, 47, Rs, Rs1),
                    PayDouble2 = lists:keystore(DoubleId,1,PayDouble,{DoubleId,PayNum+1}),
                    lib_role:notice(diamond,Rs2),
                    Rs2#role{paydouble = PayDouble2, save = [paydouble]};
                false -> Rs
            end;
        false -> Rs
    end.

init_pay_double(Rs) ->
    Sql = list_to_binary([<<"SELECT `paydouble` FROM `paydouble` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [PayDouble]} ->
            PayDouble2 = unzip_pay(PayDouble),
            {ok,Rs#role{paydouble = PayDouble2}};
        {error, null} -> {ok, Rs};
        {error, Reason} ->
            ?WARN("init_pay_double id(~w) error:~w", [Rs#role.id,Reason]),
            {error, Reason}
    end.

update_pay_double(Rs) ->
    #role{id = Id
        ,paydouble = PayDouble
    } = Rs,
    PayDouble2 = ?ESC_SINGLE_QUOTES(zip_pay(PayDouble)),
    Sql = list_to_binary([<<"UPDATE `paydouble` SET `paydouble` = '">>
            ,PayDouble2, <<"' WHERE `role_id` = ">>, integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, 0} ->
            insert_pay_double(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

insert_pay_double(Rs) ->
    #role{id = Id
        ,paydouble = PayDouble
    } = Rs,
    PayDouble2 = ?ESC_SINGLE_QUOTES(zip_pay(PayDouble)),
    Sql = list_to_binary([<<"SELECT count(*) FROM `paydouble` WHERE `role_id` = ">>
            ,integer_to_list(Id)]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `paydouble` (`role_id`, `paydouble`) VALUES (">>
                    ,integer_to_list(Id), <<",'">>, PayDouble2,<<"')">>]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

-define(PAYDOUBLE_ZIP_VERSION, 1).
zip_pay(undefined) -> <<>>;
zip_pay([]) -> <<>>;
zip_pay(L) ->
    Bin = list_to_binary([<<X1:32,X2:32>> || {X1,X2} <- L]),
    <<?PAYDOUBLE_ZIP_VERSION:8, Bin/binary>>.

unzip_pay(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            case Bin1 == <<>> of
                true -> [];
                false ->
                    [{X1,X2} || <<X1:32,X2:32>> <= Bin1]
            end;
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            []
    end.

%%.

%% --- 私有函数 ---

%% zip / unzip
%% 解包binary
unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip1(Bin1, []);
        2 ->
            unzip11(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

unzip1(<<X1:8, X2:32, X3:8, X4:8, RestBin/binary>>, Rt) ->
    Rt1 = case X1 == ?CDKEY andalso X4 == 2 of
        true ->
            [{X1, X2, X3, 1} | Rt];
        false ->
            [{X1, X2, X3, X4} | Rt]
    end,
    unzip1(RestBin, Rt1);
unzip1(<<>>, Rt) ->
    Rt.

unzip11(<<X1:8, X2:32, X3:8, X4:32, RestBin/binary>>, Rt) ->
    Rt1 = [{X1, X2, X3, X4} | Rt],
    unzip11(RestBin, Rt1);
unzip11(<<>>, Rt) ->
    Rt.

%% 打包成binary
-define(FEST_ZIP_VERSION, 2).
zip(L) ->
    Bin = list_to_binary([<<X1:8, X2:32, X3:8, X4:32>> || {X1, X2, X3, X4} <- L]),
    <<?FEST_ZIP_VERSION:8, Bin/binary>>.

unzip2(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip3(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

unzip3(<<Id1:32, RestBin/binary>>, Rt) ->
    Rt1 = [Id1 | Rt],
    unzip3(RestBin, Rt1);
unzip3(<<>>, Rt) ->
    Rt.

-define(FRIENDS_ZIP_VERSION, 1).
zip2(L) ->
    Bin = list_to_binary([<<Id1:32>> || Id1 <- L]),
    <<?FRIENDS_ZIP_VERSION:8, Bin/binary>>.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
