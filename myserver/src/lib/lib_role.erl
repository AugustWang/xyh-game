%% ------------------------------------------------------------------
%% $Id: lib_role.erl 13256 2014-06-18 05:40:49Z rolong $
%% @doc 角色相关API库
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(lib_role).
-export([
        get_role_pid/2
        ,spend/3
        ,spend_ok/4
        ,add_attr/2
        ,add_attr/3
        ,add_attr_ok/4
        ,get_role_pid_from_ets/2
        ,get_online_pid/2
        ,get_offline_pid/2
        ,get_new_id/2
        ,init_skills/1
        ,exec_cmd/1
        ,notice/1
        ,notice/2
        ,notice/3
        ,db_init/3
        ,db_update/1
        ,zip_kvs/1
        ,tracer/1
        ,online_check/0
        ,stop/0
        ,jewel_init/1
        ,jewel_update/1
        ,save_to_db/2
        ,reset_password/3
        ,send_verify_code/1
        ,send_verify_code11/2
        ,check_phone_number/1
        ,send_verify_code2/2
        ,time2power/1
        ,time2diamond/1
        ,kick/2
        ,in_app_purchase_check/1
    ]).

-include("common.hrl").
-include("offline.hrl").

in_app_purchase_check(RecvReceipt) when is_binary(RecvReceipt) ->
    in_app_purchase_check(binary_to_list(RecvReceipt));

in_app_purchase_check(RecvReceipt) ->
    Query = env:get(verify_receipt),
    PostData = "{\"receipt-data\":\""++ RecvReceipt ++"\"}",
    try httpc:request(post, {Query, [], "", PostData}, [{timeout, 4000}], []) of
        {error, Reason} ->
            {error, {httpc_request, Reason}};
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Kvs}, _} ->
                    case lists:keyfind("status", 1, Kvs) of
                        {"status", 0} ->
                            case lists:keyfind("receipt", 1, Kvs) of
                                {"receipt", {obj, Receipt}} ->
                                    parse_receipt(Receipt, []);
                                Else ->
                                    {error, {find_receipt, Else}}
                            end;
                        {"status", RecvCode} ->
                            {error, {status, RecvCode}};
                        Else ->
                            {error, {find_status, Else}}
                    end;
                Error ->
                    {error, {decode, Error}}
            end;
        Error ->
            {error, {httpc_request, Error}}
        catch X:Y ->
            {error, {catch_error, X, Y}}
    end.

%% 键名 描述
%% quantity 购买商品的数量。对应SKPayment对象中的quantity属性
%% product_id 商品的标识，对应SKPayment对象的productIdentifier属性。
%% transaction_id 交易的标识，对应SKPaymentTransaction的transactionIdentifier属性
%% purchase_date 交易的日期，对应SKPaymentTransaction的transactionDate属性
%% original_-transaction_id 对于恢复的transaction对象，该键对应了原始的transaction标识
%% original_purchase_-date 对于恢复的transaction对象，该键对应了原始的交易日期
%% app_item_id App Store用来标识程序的字符串。一个服务器可能需要支持多个server的支付功能，可以用这个标识来区分程序。链接sandbox用来测试的程序的不到这个值，因此该键不存在。
%% version_external_-identifier 用来标识程序修订数。该键在sandbox环境下不存在
%% bid iPhone程序的bundle标识
%% bvrs iPhone程序的版本号

%% original_purchase_date_pst:2014-01-06 23:25:42 America/Los_Angeles
%% purchase_date_ms:1389079542072
%% unique_identifier:dbfd3179717b2aeaf23a002369c5774f55ffc606
%% original_transaction_id:1000000097886059
%% bvrs:1.0.0
%% transaction_id:1000000097886059
%% quantity:1
%% unique_vendor_identifier:85232F13-B890-4199-A3C4-23AFE94CD973
%% item_id:792630505
%% product_id:com.mst.diamond_120
%% purchase_date:2014-01-07 07:25:42 Etc/GMT
%% original_purchase_date:2014-01-07 07:25:42 Etc/GMT
%% purchase_date_pst:2014-01-06 23:25:42 America/Los_Angeles
%% bid:com.turbotech.mengshoutang
%% original_purchase_date_ms:1389079542072
%% Recv Status: 0

parse_receipt([{"bid", <<"com.turbotech.mengshoutang">>} | Receipt], Rt) ->
    parse_receipt(Receipt, Rt);

parse_receipt([{"bid", Val} | _Receipt], _Rt) ->
    {error, {bid, Val}};

parse_receipt([{"bvrs", Val} | Receipt], Rt) ->
    Rt1 = [{bvrs, Val} | Rt],
    parse_receipt(Receipt, Rt1);

parse_receipt([{"purchase_date_ms", Val} | Receipt], Rt) ->
    Rt1 = [{purchase_date_ms, Val} | Rt],
    parse_receipt(Receipt, Rt1);

parse_receipt([{"transaction_id", Val} | Receipt], Rt) ->
    Rt1 = [{transaction_id, Val} | Rt],
    parse_receipt(Receipt, Rt1);

parse_receipt([{"product_id", Val} | Receipt], Rt) ->
    Rt1 = [{product_id, Val} | Rt],
    parse_receipt(Receipt, Rt1);

%% parse_receipt([{Key, Val} | Receipt], Rt) ->
%%     Rt1 = [{Key, Val} | Rt],
%%     ?INFO("~s:~s", [Key, Val]),
%%     parse_receipt(Receipt, Rt1);

parse_receipt([_Kv | Receipt], Rt) ->
    parse_receipt(Receipt, Rt);

parse_receipt([], Rt) ->
    {ok, Rt}.

kick(Id, Reason) ->
    case get_role_pid_from_ets(role_id, Id) of
        false -> ok;
        {_, Pid} -> gen_server:call(Pid, {force_logout, Reason})
    end.

%% @doc CD时间换算成钻石
-spec time2diamond(Time) -> integer() when
    Time :: integer().

time2diamond(RestTime) ->
    case RestTime > 0 of
        true ->
            %% 按时间计算扣费额
            Unit = data_config:get(diamond_per_min),
            util:ceil(RestTime / 60 * Unit);
        false -> 0
    end.

%% @doc 时间换算成疲劳值（体力值）
-spec time2power(Rs) -> NewRs when
    Rs :: #role{},
    NewRs :: #role{}.

time2power(Rs) ->
    #role{power = Power, power_time = PowerTime} = Rs,
    Max = data_config:get(tired_max),
    TiredPower = data_config:get(tired_power), %% TiredPower (秒 / 一点疲劳)
    CurTime = util:unixtime(),
    case Power >= Max of
        true ->
            Rs#role{power_time = CurTime};
        false ->
            Sec = case PowerTime > 0 of
                true ->
                    CurTime - PowerTime;
                false ->
                    %% 初始化为最大时间
                    240 * Max
            end,
            Add = Sec div TiredPower,
            case Add > 0 of
                true ->
                    Rest = Sec rem TiredPower,
                    PowerTime1 = CurTime - Rest,
                    Add1 = Power + Add,
                    Add2 = if
                        Add1 > Max -> Max;
                        true -> Add1
                    end,
                    Rs#role{power = Add2, power_time = PowerTime1};
                false ->
                    Rs
            end
    end.

%% @doc 重置密码
-spec reset_password(Account, VerifyCode, Password) ->
    {ok, Num} | {error, Reason} when
    Account :: binary(),
    VerifyCode :: integer(),
    Password :: binary(),
    Num :: integer(),
    Reason :: aid | verify_code | term().

reset_password(Aid, VerifyCode, Password) ->
    case check_phone_number(Aid) of
        true -> reset_password1(Aid, VerifyCode, Password);
        false -> {error, phone}
    end.

reset_password1(Aid, VerifyCode, Password) ->
    case db:get_row("select verify_code, verify_time from role where aid = ~s;", [Aid]) of
        {ok, [VerifyCode, VerifyTime]} when VerifyCode > 0 ->
            Now = util:unixtime(),
            case (Now - VerifyTime) < 3600 * 24 of
                true ->
                    Password1 = util:md5(Password),
                    case db:execute("update role set password = ~s, verify_code = 0, verify_time = 0 where aid = ~s", [Password1, Aid]) of
                        {ok, Num} -> {ok, Num};
                        {error, Reason} -> {error, Reason}
                    end;
                false ->
                    {error, timeout}
            end;
        {ok, Code} ->
            ?WARN("Error VerifyCode: ~w (OK CODE:~w)", [VerifyCode, Code]),
            {error, verify};
        {error, null} ->
            {error, aid};
        {error, Reason} ->
            {error, Reason}
    end.

check_phone_number(Num) when is_binary(Num) ->
    check_phone_number(binary_to_list(Num));
check_phone_number(Num) ->
    case check_number(Num) andalso length(Num) == 11 of
        true ->
            case Num of
                [$1, $3 | _] -> true;
                [$1, $4 | _] -> true;
                [$1, $5 | _] -> true;
                [$1, $8 | _] -> true;
                _ -> false
            end;
        false -> false
    end.

check_number([H | T]) ->
    case H >= 48 andalso H =< 57 of
        true -> check_number(T);
        false -> false
    end;
check_number([]) ->
    true.

%% @doc 发送验证码
-spec send_verify_code(Account) ->
    {ok, Msg} | {error, Reason} when
    Account :: term(),
    Msg :: term(),
    Reason :: term().

send_verify_code(Aid) ->
    case check_phone_number(Aid) of
        true -> send_verify_code1(Aid);
        false -> {error, phone}
    end.

send_verify_code1(Aid) ->
    case db:get_one("select verify_time from role where aid = ~s;", [Aid]) of
        {ok, VerifyTime} ->
            Now = util:unixtime(),
            case (Now - VerifyTime) > 600 of
                true ->
                    Code = util:rand(100000, 999999),
                    case db:execute("update role set verify_code = ~s, verify_time = ~s where aid = ~s", [Code, Now, Aid]) of
                        {ok, _Num} -> send_verify_code2(Aid, Code);
                        {error, Reason} -> {error, Reason}
                    end;
                false ->
                    {error, waiting}
            end;
        {error, null} ->
            {error, aid};
        {error, Reason} ->
            {error, Reason}
    end.

send_verify_code11(Rid, Aid) ->
    case db:get_one("select verify_time from role where id = ~s;", [Rid]) of
        {ok, VerifyTime} ->
            Now = util:unixtime(),
            case (Now - VerifyTime) > 600 of
                true ->
                    Code = util:rand(100000, 999999),
                    case db:execute("update role set verify_code = ~s, verify_time = ~s where id = ~s", [Code, Now, Rid]) of
                        {ok, _Num} -> send_verify_code2(Aid, Code);
                        {error, Reason} -> {error, Reason}
                    end;
                false ->
                    {error, waiting}
            end;
        {error, null} ->
            {error, aid};
        {error, Reason} ->
            {error, Reason}
    end.

send_verify_code2(PhoneNum, Code) when is_binary(PhoneNum) ->
    send_verify_code2(binary_to_list(PhoneNum), Code);
send_verify_code2(PhoneNum, Code) ->
    %% 忠辉：13005483635
    Query = "http://inter.ueswt.com/sms.aspx?"
    "action=send"
    "&userid=5767"
    "&account=turbotech"
    "&password=turbine26076116"
    "&mobile=" ++ PhoneNum ++
    "&content=亲爱的《萌兽堂》玩家，您本次重置密码的"
    "验证码是：" ++ integer_to_list(Code) ++ "，"
    "如果不是您本人操作，请勿理会！【深圳市涡轮科技有限公司】"
    "&sendTime=&extno=",
    try httpc:request(get, {Query, []}, [{timeout, 3000}], []) of
        {error, Reason} ->
            ?WARN("Error: ~w", [Reason]),
            {error, Reason};
        {ok, {_, _, Body}} ->
            ReturnValues = parse_xml(Body),
            Status = util:get_val(returnstatus, ReturnValues, "undef"),
            Msg = util:get_val(message, ReturnValues, "undef"),
            case Status == "Success" of
                true ->
                    Rest = list_to_integer(util:get_val(remainpoint, ReturnValues)),
                    Counts = list_to_integer(util:get_val(successCounts, ReturnValues)),
                    TaskId = list_to_integer(util:get_val(taskID, ReturnValues)),
                    Msg1 = xmerl_ucs:to_utf8(Msg),
                    ?INFO("[Status:~s, Msg:~ts, Rest:~w, Counts:~w, TaskId:~w]", [Status, Msg1, Rest, Counts, TaskId]),
                    {ok, Msg};
                false ->
                    Rest = list_to_integer(util:get_val(remainpoint, ReturnValues)),
                    Counts = list_to_integer(util:get_val(successCounts, ReturnValues)),
                    TaskId = list_to_integer(util:get_val(taskID, ReturnValues)),
                    Msg1 = xmerl_ucs:to_utf8(Msg),
                    ?WARN("[Status:~s, Msg:~ts, Rest:~w, Counts:~w, TaskId:~w]", [Status, Msg1, Rest, Counts, TaskId]),
                    {error, Msg}
            end;
        _Error ->
            ?WARN("error data:~w", [_Error]),
            {error, error}
            catch X:Y ->
                ?WARN("ERROR ~p : ~p", [X, Y]),
                {error, error}
        end.

    -include_lib("xmerl/include/xmerl.hrl").

parse_xml(Xml) ->
    {Elements, _} = xmerl_scan:string(Xml),
    lists:foldl(fun(Item, Rt) ->
                case Item of
                    #xmlElement{name = returnstatus, content = [#xmlText{value = Value}]} ->
                        [{returnstatus, Value} | Rt];
                    #xmlElement{name = message, content = [#xmlText{value = Value}]} ->
                        [{message, Value} | Rt];
                    #xmlElement{name = remainpoint, content = [#xmlText{value = Value}]} ->
                        [{remainpoint, Value} | Rt];
                    #xmlElement{name = taskID, content = [#xmlText{value = Value}]} ->
                        [{taskID, Value} | Rt];
                    #xmlElement{name = successCounts, content = [#xmlText{value = Value}]} ->
                        [{successCounts, Value} | Rt];
                    _Else ->
                        Rt
                end
        end,
        [], Elements#xmlElement.content).


%% @doc 消耗属性
-spec spend(MoneyType, Value, Rs) -> {ok, NewRs} | {error, Reason} when
    MoneyType :: gold | diamond, %% 货币类型
    Value     :: integer(),      %% 消耗数量
    Rs        :: #role{},        %% 消耗前的状态
    NewRs     :: #role{},        %% 消耗后的状态
    Reason    :: term().         %% 错误信息

spend(gold, 0, R) -> {ok, R};
spend(gold, V, R) when V > 0 ->
    V1 = R#role.gold - V,
    case V1 >= 0 of
        true -> {ok, R#role{gold = V1}};
        false -> {error, gold}
    end;

spend(diamond, 0, R) -> {ok, R};
spend(diamond, V, R) when V > 0 ->
    V1 = R#role.diamond - V,
    case V1 >= 0 of
        true -> {ok, R#role{diamond = V1}};
        false -> {error, diamond}
    end;

spend(Type, V, _R) ->
    ?ERR("ERROR TYPE: ~w, VALUE: ~w", [Type, V]),
    {error, Type}.

%% @doc 增加属性
-spec add_attr(MoneyType, Value, Rs) -> NewRs when
    MoneyType :: gold | diamond, %% 货币类型
    Value     :: integer(),      %% 消耗数量
    Rs        :: #role{},        %% 消耗前的状态
    NewRs     :: #role{}.        %% 消耗后的状态

%% 增加金币
add_attr(gold, V, R) when V =< 0 -> R;
add_attr(gold, V, R) ->
    R#role{gold = R#role.gold + V};

%% 增加钻石
add_attr(diamond, V, R) when V =< 0 -> R;
add_attr(diamond, V, R) ->
    R#role{diamond = R#role.diamond + V};

%% 增加幸运星
add_attr(luck, V, R) when V =< 0 -> R;
add_attr(luck, V, R) ->
    {LuckStar, A, B, C} = R#role.luck,
    NewStar = {LuckStar + V, A, B, C},
    R#role{luck = NewStar};

%% 增加喇叭
add_attr(horn, V, R) when V =< 0 -> R;
add_attr(horn, V, R) ->
    R#role{horn = R#role.horn + V};

%% 增加荣誉
add_attr(honor, V, R) when V =< 0 -> R;
add_attr(honor, V, R) ->
    case R#role.coliseum of
        undefined -> R;
        [] -> R;
        [Id,Lev,Exp,Pic,Num,Hr,Pt,Re] ->
            R#role{coliseum = [Id,Lev,Exp + V,Pic,Num,Hr,Pt,Re]}
    end;

add_attr(K, V, R) ->
    ?ERR("[add_attr] undefined kvs: ~w-~w", [K, V]),
    R.

%% @doc 批量增加属性
-spec add_attr(Attrs, Rs) -> NewRs when
    Attrs :: [{AttrType, Value}],
    AttrType :: gold | diamond,
    Value :: integer(),
    Rs :: #role{},
    NewRs :: #role{}.

add_attr([{K, V}|T], R) ->
    NewR = add_attr(K, V, R),
    add_attr(T, NewR);
add_attr([], R) -> R.

%% @doc 成功消耗属性
-spec spend_ok(MoneyType, LogType, RsA, RsB) -> NewRsB when
    MoneyType :: gold | diamond, %% 货币类型
    LogType   :: integer(),      %% 日志类型（由策划定义）
    RsA       :: #role{},        %% 消耗前的状态
    RsB       :: #role{},        %% 消耗后的状态
    NewRsB    :: #role{}.        %% 返回新的状态

spend_ok(gold, LogType, RsA, RsB) ->
    V = RsA#role.gold - RsB#role.gold,
    %% 金币消耗统计
    gen_server:cast(admin, {gold_sub, V}),
    %% 日志
    ?LOG({gold, RsA#role.id, LogType, -V, RsB#role.gold}),
    RsB;
spend_ok(diamond, LogType, RsA, RsB) ->
    V = RsA#role.diamond - RsB#role.diamond,
    %% 钻石消耗统计
    gen_server:cast(admin, {diamond_sub, V}),
    %% 日志
    ?LOG({diamond, RsA#role.id, LogType, -V, RsB#role.diamond}),
    %% RsB2 = mod_attain:attain_state(48, V, RsB),
    RsB;
spend_ok(Type, _LogType, _RsA, RsB) ->
    ?ERR("ERROR TYPE: ~w", [Type]),
    RsB.
%%.

%% @doc 成功增加属性
-spec add_attr_ok(MoneyType, LogType, RsA, RsB) -> NewRsB when
    MoneyType :: gold | diamond, %% 货币类型
    LogType   :: integer(),      %% 日志类型（由策划定义）
    RsA       :: #role{},        %% 增加前的状态
    RsB       :: #role{},        %% 增加后的状态
    NewRsB    :: #role{}.        %% 返回新的状态

add_attr_ok(gold, LogType, RsA, RsB) ->
    V = RsB#role.gold - RsA#role.gold,
    %% 金币产出统计
    gen_server:cast(admin, {gold_add, V}),
    %% 金币成就推送
    RsB2 = mod_attain:attain_state(31, V, RsB),
    %% 日志
    ?LOG({gold, RsA#role.id, LogType, V, RsB#role.gold}),
    RsB2;

add_attr_ok(diamond, LogType, RsA, RsB) ->
    V = RsB#role.diamond - RsA#role.diamond,
    %% 钻石产出统计
    gen_server:cast(admin, {diamond_add, V}),
    %% 钻石成就推送
    RsB2 = mod_attain:attain_state(62, V, RsB),
    %% 日志
    ?LOG({diamond, RsA#role.id, LogType, V, RsB#role.diamond}),
    %% 累加vip中free值
    RsB3 = mod_vip:set_vip(free, V, 0, RsB2),
    RsB3;

%% 统计批量加送接口的日志
add_attr_ok(batch, LogType, RsA, RsB) ->
    VD = RsB#role.diamond - RsA#role.diamond,
    VG = RsB#role.gold - RsA#role.gold,
    RsBB = case VD > 0 of
        true ->
            add_attr_ok(diamond, LogType, RsA, RsB);
        false -> RsB
    end,
    case VG > 0 of
        true ->
            add_attr_ok(gold, LogType, RsA, RsBB);
        false -> RsBB
    end;

%% 加荣誉的日志(LogType=1:战斗发送,=2:定时发送)
add_attr_ok(honor, LogType, RsA, RsB) ->
    ExpA = case RsA#role.coliseum of
        undefined -> 0;
        [] -> 0;
        [_,_,A,_,_,_,_,_] -> A
    end,
    ExpB = case RsB#role.coliseum of
        undefined -> 0;
        [] -> 0;
        [_,_,B,_,_,_,_,_] -> B
    end,
    V = ExpB - ExpA,
    VV = case V > 0 of
        true -> V;
        false -> 0
    end,
    %% 日志
    ?LOG({honor, RsA#role.id, LogType, VV, ExpB}),
    RsB;

%% add_attr_ok(luck, LogType, RsA, RsB) ->
%%     {LuckStar1, _, _, _} = RsB#role.luck,
%%     {LuckStar2, _, _, _} = RsA#role.luck,
%%     V = LuckStar1 - LuckStar2,
%%     %% 幸运星产出统计
%%     gen_server:cast(admin, {luck_add, V}),
%%     %% 日志
%%     ?LOG({luck, RsA#role.id, LogType, V, RsB#role.luck}),
%%     RsB;

%% add_attr_ok(horn, LogType, RsA, RsB) ->
%%     V = RsB#role.horn - RsA#role.horn,
%%     ?LOG({horn, RsA#role.id, LogType, V, RsB#role.horn});

add_attr_ok(Type, _LogType, _RsA, RsB) ->
    ?ERR("ERROR TYPE: ~w", [Type]),
    RsB.
%%.


notice(Rs) ->
    #role{pid_sender = Sender,
        diamond = Diamond, gold = Gold} = Rs,
    sender:pack_send(Sender, 11006, [Diamond]),
    sender:pack_send(Sender, 11005, [Gold]).


notice(horn, Rs) ->
    #role{pid_sender = Sender, horn = V} = Rs,
    sender:pack_send(Sender, 11009, [V]);

notice(honor, Rs) ->
    [_,_,Exp,_,_,_,_,_] = Rs#role.coliseum,
    #role{pid_sender = Sender} = Rs,
    sender:pack_send(Sender, 11004, [Exp]);

notice(luck, Rs) ->
    {LuckStar, _, _, _} = Rs#role.luck,
    #role{pid_sender = Sender} = Rs,
    sender:pack_send(Sender, 11008, [LuckStar]);

notice(diamond, Rs) ->
    #role{pid_sender = Sender, diamond = V} = Rs,
    sender:pack_send(Sender, 11006, [V]);
notice(gold, Rs) ->
    #role{pid_sender = Sender, gold = V} = Rs,
    sender:pack_send(Sender, 11005, [V]).

notice(diamond, Sender, V) ->
    sender:pack_send(Sender, 11006, [V]);
notice(gold, Sender, V) ->
    sender:pack_send(Sender, 11005, [V]).

exec_cmd([{M, F, A} | T]) ->
    erlang:apply(M, F, A),
    exec_cmd(T);
exec_cmd([]) ->
    ok.

get_new_id(hero, Rs) ->
    Id = Rs#role.max_hero_id + 1,
    {ok, Id, Rs#role{max_hero_id = Id}};
get_new_id(item, Rs) ->
    Id = Rs#role.max_item_id + 1,
    {ok, Id, Rs#role{max_item_id = Id}}.

%% @doc 获取角色PID
-spec get_role_pid(KeyType, Key) ->
    false | pid() when
    KeyType :: role_id | account_id | name,
    Key :: integer() | binary().

get_role_pid(role_id, 0) -> ?WARN("role_id=0", []), false;
get_role_pid(KeyType, Key) ->
    case get_role_pid_from_ets(KeyType, Key) of
        false ->
            case KeyType of
                name ->
                    RoleId = get_rid(Key),
                    get_role_pid(role_id, RoleId);
                _ ->
                    case role:create(offline, KeyType, Key) of
                        {ok, Pid} -> Pid;
                        _Else ->
                            ?WARN("~w", [_Else]),
                            false
                    end
            end;
        {_, Pid} -> Pid
    end.

%% -> false | {TableName, Pid}
get_role_pid_from_ets(Type, Id) ->
    case get_online_pid(Type, Id) of
        false ->
            case get_offline_pid(Type, Id) of
                false -> false;
                Pid -> {offline, Pid}
            end;
        Pid -> {online, Pid}
    end.

%% 离线表中查找
get_offline_pid(account_id, AccountId) ->
    case ets:lookup(offline, AccountId) of
        [] ->
            false;
        [R] ->
            Pid = R#offline.pid,
            case is_process_alive(Pid) of
                true ->
                    ?DEBUG("from offline:~w", [Pid]),
                    Pid ! {set_stop_timer, ?OFFLINE_CACHE_TIME},
                    Pid;
                false ->
                    ?WARN("Not alive pid in offline table, Rid:~w, Pid: ~w",
                        [R#offline.id, Pid]),
                    ets:delete(offline, AccountId),
                    false
            end
    end;
get_offline_pid(role_id, Rid) ->
    %% 离线表中查找
    MatchSpec = [{
            #offline{pid='$1', id='$2', account_id='$3', _='_'}
            ,[{'==','$2',Rid}]
            ,[['$1', '$3']]
        }],
    case ets:select(offline, MatchSpec) of
        [] ->
            false;
        [[Pid, AccountId]] ->
            case is_process_alive(Pid) of
                true ->
                    ?DEBUG("from offline:~w", [Pid]),
                    Pid;
                false ->
                    ?WARNING("Not alive pid in offline table, Rid:~w, Pid: ~w",
                        [Rid, Pid]),
                    ets:delete(offline, AccountId),
                    false
            end;
        _Else ->
            ?WARNING("unexpected data:~w", [_Else]),
            false
    end;
get_offline_pid(name, Name) ->
    %% 离线表中查找
    MatchSpec = [{
            #offline{pid='$1', name='$2', account_id='$3', id='$4'}
            ,[{'==','$2',Name}]
            ,[['$1', '$3', '$4']]
        }],
    case ets:select(offline, MatchSpec) of
        [] -> false;
        [[Pid, AccountId, Rid]] ->
            case is_process_alive(Pid) of
                true ->
                    ?DEBUG("from offline:~w", [Pid]),
                    Pid;
                false ->
                    ?WARNING("Not alive pid in offline table, Rid:~w, Pid: ~w",
                        [Rid, Pid]),
                    ets:delete(offline, AccountId),
                    false
            end;
        _Else ->
            ?WARNING("unexpected data:~w", [_Else]),
            false
    end.

%% 在线表中查找角色Pid
get_online_pid(account_id, AccountId) ->
    MatchSpec = [{
            #online{pid='$1', account_id='$2', id='$3', _ = '_'}
            ,[{'==','$2',AccountId}]
            ,[['$1', '$3']]
        }],
    case ets:select(online, MatchSpec) of
        [] ->
            false;
        [[Pid, Rid]] ->
            case is_process_alive(Pid) of
                true ->
                    ?DEBUG("from online:~w", [Pid]),
                    Pid;
                false ->
                    ?WARNING("Not alive pid in online table, Rid:~w, Pid: ~w", [Rid, Pid]),
                    ets:delete(online, Rid),
                    false
            end;
        _Else ->
            ?WARNING("unexpected data: ~w", [_Else]),
            false
    end;
get_online_pid(role_id, Rid) ->
    case ets:lookup(online, Rid) of
        [] ->
            false;
        [R] ->
            #online{pid = Pid} = R,
            case is_process_alive(Pid) of
                true ->
                    ?DEBUG("from online:~w", [Pid]),
                    Pid;
                false ->
                    ?WARNING("Not alive pid in online table, Rid:~w, Pid: ~w", [Rid, Pid]),
                    ets:delete(online, Rid),
                    false
            end
    end;
get_online_pid(name, Name) ->
    MatchSpec = [{
            #online{pid='$1', name='$2', id='$3', _ = '_'}
            ,[{'==','$2',Name}]
            ,[['$1', '$3']]
        }],
    case ets:select(online, MatchSpec) of
        [] ->
            false;
        [[Pid, Rid]] ->
            case is_process_alive(Pid) of
                true ->
                    ?DEBUG("from online:~w", [Pid]),
                    Pid;
                false ->
                    ?WARNING("Not alive pid in online table, Rid:~w, Pid: ~w", [Rid, Pid]),
                    ets:delete(online, Rid),
                    false
            end;
        _Else ->
            ?WARNING("unexpected data: ~w", [_Else]),
            false
    end.

init_skills(Data) ->
    Skill1   = util:get_val(skill1    , Data, 0),
    Skill2   = util:get_val(skill2    , Data, 0),
    Skill3   = util:get_val(skill3    , Data, 0),
    [S || S <- [Skill1, Skill2, Skill3], S > 0].

get_rid(Name) when is_list(Name) ->
    Sql = lists:concat(["select id from role where name like '", Name, "' limit 10"]),
    get_rid1(Sql);

get_rid(Name1) when is_binary(Name1) ->
    Name = binary_to_list(Name1),
    Sql = lists:concat(["select id from role where name like '", Name, "' limit 10"]),
    get_rid1(Sql);

get_rid(Aid) when is_integer(Aid) ->
    Sql = lists:concat(["select id from role where aid = '", Aid, "' limit 10"]),
    get_rid1(Sql);

get_rid({aid, Aid}) ->
    Sql = lists:concat(["select id from role where aid = '", Aid, "' limit 10"]),
    get_rid1(Sql).

get_rid1(Sql) ->
    {ok, Data} = db:get_all(Sql),
    get_rid2(Data).

get_rid2([[Id]]) -> Id;
get_rid2([]) -> 0;
get_rid2(Data) ->
    ?WARNING("unexpected data when get_rid/1. (~w)]", [Data]),
    0.

%%' 数据库相关操作

-spec db_init(Key, Val, Rs) -> {ok, NewRs} | {error, Reason} when
    Key :: account_id | role_id | name,
    Val :: integer() | binary(),
    Rs :: NewRs,
    NewRs :: #role{},
    Reason :: term().

db_init(Key, Val, Rs) ->
    {K, V} = case Key of
        account_id -> {<<"aid">>, ?ESC_SINGLE_QUOTES(Val)};
        role_id -> {<<"id">>, integer_to_list(Val)};
        name -> {<<"name">>, ?ESC_SINGLE_QUOTES(Val)}
    end,
    Sql = list_to_binary([
            <<"select id, aid, name, gold, diamond, tollgate_id, tollgate_newid, combat, kvs from role where ">>
            ,K,<<" = '">>,V,<<"'">>
        ]),
    ?DEBUG("Sql:~s", [Sql]),
    case db:get_row(Sql) of
        {ok, [Rid, AccountId, Name, Gold, Diamond, TollgateId, TollgateNewId, Combat, KvsBin]} ->
            Rs1 = unzip_kvs(KvsBin, Rs),
            Rs2 = Rs1#role{
                id = Rid
                ,account_id = AccountId
                ,name = Name
                ,gold = Gold
                ,diamond = Diamond
                ,tollgate_id = TollgateId
                ,tollgate_newid = TollgateNewId
                ,combat = Combat
            },
            db_init1(hero, Rs2);
        {error, null} -> {error, no_reg};
        {error, Error} -> {error, Error}
    end.

db_init1(hero, Rs) ->
    case mod_hero:db_init(Rs) of
        {ok, Rs1} -> db_init1(item, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(item, Rs) ->
    case mod_item:db_init(Rs) of
        {ok, Rs1} -> db_init1(arena, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(arena, Rs) ->
    case mod_arena:db_init(Rs) of
        {ok, Rs1} -> db_init1(arena2, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(arena2, Rs) ->
    case mod_arena:db_init2(Rs) of
        {ok, Rs1} -> db_init1(arena_init, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(arena_init, Rs) ->
    case mod_arena:arena_init(Rs) of
        {ok, Rs1} -> db_init1(attain, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(attain, Rs) ->
    case mod_attain:attain_init(Rs) of
        {ok, Rs1} -> db_init1(sign, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(sign, Rs) ->
    case mod_sign:sign_init(Rs) of
        {ok, Rs1} -> db_init1(fbinfo, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(fbinfo, Rs) ->
    case mod_combat:db_init_fb(Rs) of
        {ok, Rs1} -> db_init1(fest, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(fest, Rs) ->
    case mod_fest:activity_init(Rs) of
        {ok, Rs1} -> db_init1(coliseum, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(coliseum, Rs) ->
    case mod_colosseum:init_coliseum(Rs) of
        {ok, Rs1} -> db_init1(pictorial, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(pictorial, Rs) ->
    case mod_hero:init_pictorial(Rs) of
        {ok, Rs1} -> db_init1(vip, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(vip, Rs) ->
    case mod_vip:init_vip(Rs) of
        {ok, Rs1} -> db_init1(paydouble, Rs1);
        {error, Reason} -> {error, Reason}
    end;
db_init1(paydouble, Rs) ->
    mod_fest:init_pay_double(Rs).

-spec db_update(Rs) -> Result when
    Rs :: #role{},
    Result :: integer() | {error, Reason},
    Reason :: term().

db_update(Rs) ->
    %% mod_arena:db_update(Rs),
    #role{
        id = Rid
        ,gold = Gold
        ,diamond = Diamond
        ,tollgate_id = TollgateId
        ,tollgate_newid = TollgateNewId
        ,combat = Combat
    } = Rs,
    DiamondSum = mod_rank:diamond_sum(Rs#role.attain),
    KvsBin = ?ESC_SINGLE_QUOTES(zip_kvs(Rs)),
    Sql = list_to_binary([
            <<"update role set">>
            ,<<" gold = ">>,integer_to_list(Gold)
            ,<<",diamond = ">>,integer_to_list(Diamond)
            ,<<",diamond_sum = ">>,integer_to_list(DiamondSum)
            ,<<",tollgate_id = ">>,integer_to_list(TollgateId)
            ,<<",tollgate_newid = ">>,integer_to_list(TollgateNewId)
            ,<<",combat = ">>,integer_to_list(Combat)
            ,<<",kvs = '">>,KvsBin,<<"'">>
            ,<<" where id = ">>,integer_to_list(Rid)
        ]),
    db:execute(Sql).

-define(KVS_ZIP_VERSION, 18).

zip_kvs(Rs) ->
    #role{
        power              = Power
        ,power_time        = PowerTime
        ,growth            = Growth
        ,bag_mat_max       = BagMatMax
        ,bag_prop_max      = BagPropMax
        ,bag_equ_max       = BagEquMax
        ,arena_time        = ArenaTime
        ,arena_honor       = ArenaHonor
        ,arena_wars        = ArenaWars
        ,arena_chance      = ArenaChance
        ,arena_rank_box    = ArenaBox
        ,arena_combat_box1 = ArenaBox1
        ,arena_combat_box2 = ArenaBox2
        ,arena_revenge     = ArenaRev
        ,arena_prize       = ArenaPrize
        ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
        ,loginsign_time    = LoginSignTime
        ,loginsign_type    = LoginSignType
        ,buy_power         = BuyPower
        ,buy_power_time    = BuyPowerTime
        ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
        ,fb_buys_time      = FbBuysTime
        ,guide             = {GuideType, GuideValue}
        ,givehero          = GiveHero
        ,horn              = Horn
        ,tollgate_prize    = TollgatePrize
        ,herotab           = HeroTab
        ,identifier        = Identifier
    } = Rs,
    <<?KVS_ZIP_VERSION:8, Growth:8, Power:16, PowerTime:32
    ,BagMatMax:16, BagPropMax:16, BagEquMax:16
    ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
    ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
    ,ArenaRev:8, ArenaPrize:8, LuckStar:32
    ,LuckDia:32, LuckUsed:32, ValSum:32
    ,LoginSignTime:32, LoginSignType:8
    ,BuyPower:16, BuyPowerTime:32
    ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
    ,GuideType:8, GuideValue:8, GiveHero:8, Horn:32
    ,TollgatePrize:8, HeroTab:8, Identifier:32>>.

unzip_kvs(<<>>, Rs) -> Rs;
unzip_kvs(Bin, Rs) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        10 ->
            <<Growth:8, Power:16, PowerTime:32, _SignDays:8, _SignTime:32
            ,_SignOldDays:8, BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8 ,ArenaChance:8
            ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32, LoginSignTime:32, LoginSignType:8
            ,BuyPower:16, BuyPowerTime:32>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
            };
        11 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32, LoginSignTime:32, LoginSignType:8
            ,BuyPower:16, BuyPowerTime:32>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
            };
        12 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
            };
        13 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
            ,GuideType:8, GuideValue:8>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
                ,guide             = {GuideType, GuideValue}
            };
        14 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
            ,GuideType:8, GuideValue:8, GiveHero:8>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
                ,guide             = {GuideType, GuideValue}
                ,givehero          = GiveHero
            };
        15 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
            ,GuideType:8, GuideValue:8, GiveHero:8, Horn:32>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
                ,guide             = {GuideType, GuideValue}
                ,givehero          = GiveHero
                ,horn              = Horn
            };
        16 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
            ,GuideType:8, GuideValue:8, GiveHero:8, Horn:32
            ,TollgatePrize:8>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
                ,guide             = {GuideType, GuideValue}
                ,givehero          = GiveHero
                ,horn              = Horn
                ,tollgate_prize    = TollgatePrize
            };
        17 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
            ,GuideType:8, GuideValue:8, GiveHero:8, Horn:32
            ,TollgatePrize:8, HeroTab:8>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
                ,guide             = {GuideType, GuideValue}
                ,givehero          = GiveHero
                ,horn              = Horn
                ,tollgate_prize    = TollgatePrize
                ,herotab           = HeroTab
            };
        18 ->
            <<Growth:8, Power:16, PowerTime:32
            ,BagMatMax:16, BagPropMax:16, BagEquMax:16
            ,ArenaTime:32 ,ArenaHonor:32 ,ArenaWars:8
            ,ArenaChance:8 ,ArenaBox:8 ,ArenaBox1:8, ArenaBox2:8
            ,ArenaRev:8, ArenaPrize:8, LuckStar:32
            ,LuckDia:32, LuckUsed:32, ValSum:32
            ,LoginSignTime:32, LoginSignType:8 ,BuyPower:16, BuyPowerTime:32
            ,FbBuys1:8, FbBuys2:8, FbBuys3:8, FbBuysTime:32
            ,GuideType:8, GuideValue:8, GiveHero:8, Horn:32
            ,TollgatePrize:8, HeroTab:8, Identifier:32>> = Bin1,
            Rs#role{
                power              = Power
                ,power_time        = PowerTime
                ,growth            = Growth
                ,bag_mat_max       = BagMatMax
                ,bag_prop_max      = BagPropMax
                ,bag_equ_max       = BagEquMax
                ,arena_time        = ArenaTime
                ,arena_honor       = ArenaHonor
                ,arena_wars        = ArenaWars
                ,arena_chance      = ArenaChance
                ,arena_rank_box    = ArenaBox
                ,arena_combat_box1 = ArenaBox1
                ,arena_combat_box2 = ArenaBox2
                ,arena_revenge     = ArenaRev
                ,arena_prize       = ArenaPrize
                ,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
                ,loginsign_time    = LoginSignTime
                ,loginsign_type    = LoginSignType
                ,buy_power         = BuyPower
                ,buy_power_time    = BuyPowerTime
                ,fb_buys           = {FbBuys1, FbBuys2, FbBuys3}
                ,fb_buys_time      = FbBuysTime
                ,guide             = {GuideType, GuideValue}
                ,givehero          = GiveHero
                ,horn              = Horn
                ,tollgate_prize    = TollgatePrize
                ,herotab           = HeroTab
                ,identifier        = Identifier
            }
    end.
%%.

tracer(Aid) when is_list(Aid) ->
    tracer(list_to_binary(Aid));
tracer(Aid) ->
    case get_role_pid_from_ets(account_id, Aid) of
        {From, Pid} ->
            dbg:tracer(),
            dbg:p(Pid, [m]),
            {From, Pid};
        false -> false
    end.

%%' 检测在线情况
online_check() ->
    Size1 = ets:info(online, size),
    Size2 = ets:info(offline, size),
    Size = Size1 + Size2,
    {Msg, Arg} = case Size > 0 of
        true ->
            M = "~n>>> NOTICE: ~w (~w + ~w) ROLES ONLINE <<<~n",
            A = [Size, Size1, Size2],
            {M, A};
        false ->
            {"~n>>> NOW, ON ROLES ONLINE! <<<~n", []}
    end,
    io:format(Msg, Arg).
%%.

%%' 强制让所有玩家下线
stop() ->
    ?INFO("logout ...", []),
    do_stop_all1().

do_stop_all1() ->
    case ets:first(online) of
        '$end_of_table' ->
            util:sleep(500),
            do_stop_all2();
        Rid ->
            util:sleep(500),
            io:format("-"),
            send_shutdown1(Rid),
            do_stop_all1()
    end.

do_stop_all2() ->
    case ets:first(offline) of
        '$end_of_table' ->
            online_check();
        Aid ->
            util:sleep(500),
            io:format(">"),
            send_shutdown2(Aid),
            do_stop_all2()
    end.

send_shutdown1(Rid) ->
    case ets:lookup(online, Rid) of
        [R] -> R#online.pid ! {shutdown, undefined};
        [] -> false
    end.

send_shutdown2(Aid) ->
    case ets:lookup(offline, Aid) of
        [R] -> R#offline.pid ! {shutdown, undefined};
        [] -> false
    end.
%%.

%% @doc 保存宝珠状态数据到数据库
-spec jewel_update(Rs) -> ok | error when
    Rs :: #role{}.

jewel_update(Rs) ->
    case Rs#role.jewel =:= [] of
        true -> {ok, 0};
        false ->
            Bin = zip_jewel(Rs#role.jewel),
            Sql = list_to_binary([
                    "update jewel set jewel = '",
                    Bin, "' where role_id = ", integer_to_list(Rs#role.id)
                ]),
            case db:execute(Sql) of
                {ok, 0} -> jewel_insert(Rs#role.id, Bin);
                {ok, Rows} -> {ok, Rows};
                {error, Reason} -> {error, Reason}
            end
    end.

jewel_insert(Rid, Bin) ->
    Sql = "select count(*) from jewel where role_id = ~s;",
    case db:get_one(Sql, [Rid]) of
        {ok, 0} ->
            Sql2 = "insert into jewel (role_id, jewel) values(~s, ~s)",
            case db:execute(Sql2, [Rid, Bin]) of
                {ok, Rows} -> {ok, Rows};
                {error, Reason} -> {error, Reason}
            end;
        {ok, _} -> {ok, 0};
        {error, Reason} -> {error, Reason}
    end.

%% @doc 初始化宝珠状态数据
-spec jewel_init(Rs) -> NewRs when
    Rs :: NewRs,
    NewRs :: #role{}.

jewel_init(Rs) ->
    case Rs#role.jewel =:= [] of
        true ->
            %% 末初始化宝珠抽取状态
            Sql = list_to_binary([
                    "select jewel from jewel where role_id = ", integer_to_list(Rs#role.id)
                ]),
            case db:get_one(Sql) of
                {ok, JewelBin} ->
                    Rs#role{jewel = unzip_jewel(JewelBin)};
                {error, null} ->
                    Jewel = [{1, 1}, {2, 0}, {3, 0}, {4, 0}, {5, 0}],
                    Rs#role{jewel = Jewel};
                {error, Reason} ->
                    ?WARN("Error When [jewel_init/1]: ~w", [Reason]),
                    Rs
            end;
        false ->
            Rs
    end.

-define(JEWEL_ZIP_VERSION, 1).

zip_jewel([{N1, S1}, {N2, S2}, {N3, S3}, {N4, S4}, {N5, S5}]) ->
    <<?JEWEL_ZIP_VERSION:8, N1:8, S1:8, N2:8, S2:8, N3:8, S3:8, N4:8, S4:8, N5:8, S5:8>>.

unzip_jewel(<<1:8, N1:8, S1:8, N2:8, S2:8, N3:8, S3:8, N4:8, S4:8, N5:8, S5:8>>) ->
    [{N1, S1}, {N2, S2}, {N3, S3}, {N4, S4}, {N5, S5}];
unzip_jewel(Else) ->
    ?WARN("Error Jewel Binary Data: ~w", [Else]),
    [].


%% @doc Rs里的数据回存到数据库
%%'save_to_db
-spec save_to_db(Rs, Save) ->
    {true, NewRs} | {false, NewRs} when
    Rs :: NewRs,
    NewRs :: #role{},
    Save :: role | items | heroes | tavern
    | jewel | sign | attain | arena | fbinfo
    | fest | coliseum | pictorial | vip
    | paydouble.

save_to_db(Rs, []) ->
    {true, Rs#role{save = []}};

save_to_db(Rs, [items | S]) ->
    T = erlang:now(),
    #role{id = Rid, items = Items} = Rs,
    {Status, Items1} = mod_item:db_update(Rid, Items),
    Rs1 = Rs#role{items = Items1},
    case Status of
        true ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save items: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs1, S);
        false ->
            %% 保存失败，把标识转移到save_delay
            %% save置空
            Rs2 = role:save_delay([items | S], Rs1),
            {false, Rs2#role{save = []}}
    end;

%% 保存英雄数据
save_to_db(Rs, [heroes | S]) ->
    T = erlang:now(),
    #role{id = Rid, heroes = Heroes} = Rs,
    {Status, Heroes1} = mod_hero:db_update(Rid, Heroes),
    Rs1 = Rs#role{heroes = Heroes1},
    case Status of
        true ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save heroes: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs1, S);
        false ->
            Rs2 = role:save_delay([heroes | S], Rs1),
            {false, Rs2#role{save = []}}
    end;

%% 保存角色数据
save_to_db(Rs, [role | S]) ->
    T = erlang:now(),
    case lib_role:db_update(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save role: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([role | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存酒馆数据
save_to_db(Rs, [tavern | S]) ->
    T = erlang:now(),
    case mod_hero:db_update_tavern(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save tavern: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            %% 保存出错，
            %% 不再继续执行保存操作，
            %% 将tavern标识转存到save_delay中，
            %% 进程退出时再尝试保存
            Rs2 = role:save_delay([tavern | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存成就数据
save_to_db(Rs, [attain | S]) ->
    T = erlang:now(),
    case mod_attain:attain_stores(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save attain: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([attain | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存竞技场数据
save_to_db(Rs, [arena | S]) ->
    T = erlang:now(),
    case mod_arena:arena_stores(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save arena: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([arena | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存宝珠状态数据
save_to_db(Rs, [jewel | S]) ->
    T = erlang:now(),
    case lib_role:jewel_update(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save jewel: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, Reason} ->
            ?WARN("Error When [jewel_update/1]: ~w", [Reason]),
            Rs2 = role:save_delay([jewel | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存签到数据
save_to_db(Rs, [sign | S]) ->
    T = erlang:now(),
    case mod_sign:sign_stores(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save sign: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([sign | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存副本数据
save_to_db(Rs, [fbinfo | S]) ->
    T = erlang:now(),
    case mod_combat:db_stores_fb(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save fb info: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([fbinfo | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存活动数据
save_to_db(Rs, [fest | S]) ->
    T = erlang:now(),
    case mod_fest:activity_stores(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save fest info: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([fest | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存活动数据
save_to_db(Rs, [coliseum | S]) ->
    T = erlang:now(),
    case mod_colosseum:stores_coliseum(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save coliseum info: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([coliseum | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存图鉴数据
save_to_db(Rs, [pictorial | S]) ->
    T = erlang:now(),
    case mod_hero:update_pictorial(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save pictorialial info: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([pictorial | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存vip数据
save_to_db(Rs, [vip | S]) ->
    T = erlang:now(),
    case mod_vip:stores_vip(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save vip info: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([vip | S], Rs),
            {false, Rs2#role{save = []}}
    end;

%% 保存paydouble数据
save_to_db(Rs, [paydouble | S]) ->
    T = erlang:now(),
    case mod_fest:update_pay_double(Rs) of
        {ok, _} ->
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, save paydouble info: ~w ms", [Rs#role.id, DT]),
            save_to_db(Rs, S);
        {error, _} ->
            Rs2 = role:save_delay([paydouble | S], Rs),
            {false, Rs2#role{save = []}}
    end;

save_to_db(Rs, [Type | S]) ->
    %% 发现未定义的保存标识，写错了？这个严重了...报个错！
    ?ERR("undefined save type: ~w, S: ~w, Rid: ~w", [Type, S, Rs#role.id]),
    save_to_db(Rs, S).
%%.

%%% vim: set foldmethod=marker foldmarker=%%',%%.:
