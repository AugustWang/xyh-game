%%----------------------------------------------------
%% $Id: pt_role.erl 13256 2014-06-18 05:40:49Z rolong $
%% @doc 协议11 - 角色相关
%% @author Rolong<erlang6@qq.com>
%% @end
%%----------------------------------------------------

-module(pt_role).
-export([handle/3]).

-include("common.hrl").

handle(11111, [Aid], _Rs) ->
    case lib_role:send_verify_code(Aid) of
        {ok, _} -> {ok, [0]};
        {error, aid} -> {ok, [1]};
        {error, phone} -> {ok, [2]};
        {error, waiting} -> {ok, [3]};
        {error, Reason} ->
            ?WARN("send_verify_code: ~w", [Reason]),
            {ok, [127]}
    end;

handle(11112, [Aid, VerifyCode, Password], _Rs) ->
    case lib_role:reset_password(Aid, VerifyCode, Password) of
        {ok, _} -> {ok, [0]};
        {error, aid} -> {ok, [1]};
        {error, phone} -> {ok, [2]};
        {error, timeout} -> {ok, [3]};
        {error, verify} -> {ok, [4]};
        {error, Reason} ->
            ?WARN("send_verify_code: ~w", [Reason]),
            {ok, [127]}
    end;

%% 帐号方式 登陆/注册
%%
%% 登陆/注册验证说明：
%%
%% 服务器ID(sid) ：1
%% 随机数(rand)  ：0~255的一个随机数字
%% 当前加密KEY   ：23d7f859778d2093
%% 签名算法      ：md5(sid + rand + key + account)
%%
%% TODO:
%%     1、密码要MD5后保存
%%     2、随机数改为当前时间，每次登陆时间不能一样
%%     3、不同的服务器需要不同的KEY
%%     4、修改密码功能
%%
handle(11000, [Type, Rand, Sid, Aid, Password, Signature], Rs) ->
    ?DEBUG("LOGIN(11000): ~w, ~w, ~w, ~s, ~s, ~s", [Type, Rand, Sid, Aid, Password, Signature]),
    SignatureChkStr = list_to_binary([
            integer_to_list(Sid)
            ,integer_to_list(Rand)
            ,env:get(server_key)
            ,Aid
        ]),
    SignatureChk = util:md5(SignatureChkStr),
    if
        Signature =/= SignatureChk ->
            %% 签名不正确
            ?DEBUG("Signature1:~s", [Signature]),
            ?DEBUG("Signature2:~s", [SignatureChk]),
            {ok, [127, 0, 0]};
        Rs#role.status > 0 ->
            %% self() !
            {ok, [20, Rs#role.growth, Rs#role.id]};
            %% {ok, [129, 0, 0]};
        true ->
            case Type of
                1 ->
                    %% 注册
                    case db:get_one("select count(*) from role where aid = ~s limit 1", [Aid]) of
                        {ok, 0} ->
                            Rs1 = Rs#role{
                                sex = 0
                                ,growth = 1
                            },
                            Gold = data_config:get(init_gold),
                            Diamond = data_config:get(init_diamond),
                            Name1 = <<>>,
                            AccountId1 = ?ESC_SINGLE_QUOTES(Aid),
                            Password1 = util:md5(Password),
                            Kvs = lib_role:zip_kvs(Rs1),
                            Sql = list_to_binary([
                                    <<"insert into role(gold, diamond, aid, password, name, tollgate_id, tollgate_newid, ctime, kvs) values(">>
                                    ,integer_to_list(Gold)
                                    ,<<",">>,integer_to_list(Diamond)
                                    ,<<",'">>,AccountId1,<<"'">>
                                    ,<<",'">>,Password1,<<"'">>
                                    ,<<",'">>,Name1,<<"'">>
                                    ,<<",">>,integer_to_list(Rs#role.tollgate_id)
                                    ,<<",">>,integer_to_list(Rs#role.tollgate_newid)
                                    ,<<",">>,integer_to_list(util:unixtime())
                                    ,<<",'">>,Kvs,<<"'">>
                                    ,<<")">>
                                ]),
                            case db:execute(Sql) of
                                {ok, 1} ->
                                    case account_login(Aid, Rs1, true) of
                                        {ok, Rid, Growth, Rs2} ->
                                            {ok, [10, Growth, Rid], Rs2};
                                        {error, Reason} ->
                                            %% 注册失败3
                                            ?WARN("REG ERROR: ~w", [Reason]),
                                            {ok, [133, 0, 0], Rs}
                                    end;
                                {error, Reason} ->
                                    %% 注册失败2
                                    case is_binary(Reason) of
                                        true -> ?WARN("REG ERROR: ~s", [Reason]);
                                        false -> ?WARN("REG ERROR: ~w", [Reason])
                                    end,
                                    {ok, [132, 0, 0], Rs}
                            end;
                        {ok, _} ->
                            ?DEBUG("[Repeat Reg] account_id: ~s", [Aid]),
                            %% 帐号已存在
                            {ok, [11, 0, 0]};
                        {error, Reason} ->
                            %% 注册失败1
                            ?WARN("REG ERROR: ~w", [Reason]),
                            {ok, [131, 0, 0]}
                    end;
                2 ->
                    %% 登陆
                    case check_password(Rs, Aid, Password) of
                        {ok, Rs1} ->
                            case account_login(Aid, Rs1, false) of
                                {ok, Rid, Growth, Rs2} ->
                                    %% 登陆成功
                                    ?DEBUG("***** LOGIN GROWTH: ~w Rid:~w *****", [Growth, Rid]),
                                    {ok, [20, Growth, Rid], Rs2};
                                {error, no_reg} ->
                                    %% 帐号不存在
                                    {ok, [21, 0, 0]};
                                {error, Reason} ->
                                    %% 登陆失败2
                                    case is_binary(Reason) of
                                        true -> ?WARN("LOGIN ERROR: ~s", [Reason]);
                                        false -> ?WARN("LOGIN ERROR: ~w", [Reason])
                                    end,
                                    {ok, [142, 0, 0]}
                            end;
                        {error, error} ->
                            %% 帐号或密码不正确
                            ?DEBUG("Password ERROR", []),
                            {ok, [22, 0, 0]};
                        {error, empty} ->
                            %% 密码不能为空
                            ?DEBUG("Password ERROR", []),
                            {ok, [23, 0, 0]};
                        {error, Reason} ->
                            %% 登陆失败1
                            ?DEBUG("Password ERROR: ~w", [Reason]),
                            {ok, [141, 0, 0]}
                    end;
                Else ->
                    %% 错误的登陆方式
                    ?WARN("ERROR TYPE:~w", [Else]),
                    {ok, [128, 0, 0]}
            end
    end;

%%' 角色登录
%% handle(11001, [Bin], Rs) ->
%%     ?DEBUG("11001 Login:~s", [Bin]),
%%     %% ?DEBUG("Login:~w", [Bin]),
%%     Qs = util:parse_qs(Bin),
%%     case lists:keyfind(<<"account_id">>, 1, Qs) of
%%         {_, AccountId} ->
%%             case account_login(AccountId, Rs, false) of
%%                 {ok, Rid, Growth, Rs1} ->
%%                     ?DEBUG("***** LOGIN GROWTH: ~w Rid:~w *****", [Growth, Rid]),
%%                     {ok, [0, Growth, Rid], Rs1};
%%                 {error, no_reg} ->
%%                     {ok, [0, 0, 0], Rs#role{account_id = AccountId}};
%%                 {error, _} ->
%%                     {ok, [1, 0, 0]}
%%             end;
%%         _Other -> {ok, [1, 0, 0]}
%%     end;
%%
%% %% 创建角色
%% handle(11002, [_Name, _Sex], Rs) ->
%%     %% Name = list_to_binary(integer_to_list(util:unixtime()) ++ "_" ++ integer_to_list(util:rand(1, 99999))),
%%     Name = <<>>,
%%     Sex = 0,
%%     ?DEBUG("11002:~w", [[Name, Sex]]),
%%     #role{account_id = AccountId, ip = _Ip} = Rs,
%%     IsReged1 = db:get_one("select id from role where aid = ~s limit 1", [AccountId]),
%%     if
%%         AccountId =:= undefined ->
%%             ?DEBUG("No login!", []),
%%             %% 没有登陆
%%             {ok, [5]};
%%         IsReged1 =/= null ->
%%             ?DEBUG("Repeat reg! account_id:~w", [AccountId]),
%%             %% 已创建角色
%%             {ok, [6]};
%%         true ->
%%             Rs1 = Rs#role{
%%                 sex = Sex
%%                 ,growth = 1
%%             },
%%             Gold = data_config:get(init_gold),
%%             Diamond = data_config:get(init_diamond),
%%             Name1 = ?ESC_SINGLE_QUOTES(Name),
%%             AccountId1 = ?ESC_SINGLE_QUOTES(AccountId),
%%             Kvs = lib_role:zip_kvs(Rs1),
%%             Lev = 1,
%%             Sql = list_to_binary([
%%                     <<"insert into role(gold, diamond, essence, aid, name, lev, tollgate_id, kvs) values(">>
%%                     ,integer_to_list(Gold)
%%                     ,<<",">>,integer_to_list(Diamond)
%%                     ,<<",0">>
%%                     ,<<",'">>,AccountId1,<<"'">>
%%                     ,<<",'">>,Name1,<<"'">>
%%                     ,<<",">>,integer_to_list(Lev)
%%                     ,<<",">>,integer_to_list(Rs#role.tollgate_id)
%%                     ,<<",'">>,Kvs,<<"'">>
%%                     ,<<")">>
%%                 ]),
%%             db:execute(Sql),
%%             case account_login(AccountId, Rs1, true) of
%%                 {ok, Rid, Growth, Rs2} ->
%%                     sender:pack_send(Rs#role.pid_sender, 11001,
%%                         [0, Growth, Rid]),
%%                     {ok, [0], Rs2};
%%                 {error, Reason} ->
%%                     ?ERR("REG ERROR: ~w", [Reason]),
%%                     {ok, [127], Rs}
%%             end
%%     end;
%%.

%% 角色信息
handle(11003, [], Rs) ->
    #role{diamond        = Diamond
        ,gold            = Gold
        %% ,tollgate_id     = TollgateId
        ,tollgate_newid     = TollgateId
        ,power           = Power
        ,bag_mat_max     = BagMatMax
        ,bag_prop_max    = BagPropMax
        ,bag_equ_max     = BagEquMax
        ,name            = Name
        %% ,arena_picture   = Picture
        ,luck            = {LuckNum, _B, _C, _D}
        ,horn            = Horn
        ,tollgate_prize  = TollgatePrize
        ,verify          = Verify
        ,coliseum        = Coliseum
        ,heroes          = Heroes
        ,herotab         = HeroTab
        ,vip             = [Vip,_VT,_VA]
    } = Rs,
    case Rs#role.coliseum of
        [] -> ok;
        [IdL,_,_,_,_,_,_,_] ->
            coliseum ! {get_coliseum_level, self(), IdL}
    end,
    {Level, Picture} = case Coliseum == [] of
        true -> {length(data_coliseum:get(ids)), 0};
        false ->
            [_,Lev,_,Pic,_,_,_,_] = Coliseum,
            {Lev, Pic}
    end,
    HeroTab2 = case HeroTab < length(Heroes) of
        true -> length(Heroes);
        false -> HeroTab
    end,
    ChatTime = case mod_vip:vip_privilege_check(Rs) of
        true ->
            VIPData = data_vip:get(Vip),
            VIPCHAT = util:get_val(chat, VIPData),
            %% VIPFAST = util:get_val(fast, VIPData),
            %% {VIPFAST, VIPCHAT};
            VIPCHAT;
        false ->
            data_config:get(chatTime)
    end,
    FirstPay = mod_fest:is_firstpay(Rs),
    {ok, [Diamond
          ,Gold
          ,TollgateId
          ,Power
          ,BagEquMax
          ,BagPropMax
          ,BagMatMax
          ,Name
          ,Picture
          ,LuckNum
          ,Horn
          ,ChatTime
          ,TollgatePrize
          ,Verify
          ,Level
          ,HeroTab2
          ,Vip - 1
          ,FirstPay
      ]};

%% 更新Power
handle(11007, [], Rs) ->
    Rs1 = lib_role:time2power(Rs),
    #role{power = Power, buy_power = Buys, buy_power_time = BuyTime, power_time = Time} = Rs1,
    TiredPower = data_config:get(tired_power),
    Rest = case Time == 0 of
        true -> TiredPower;
        false -> util:floor(TiredPower - (util:unixtime() - Time))
    end,
    NewBuys = case BuyTime < util:unixtime(today) of
        true -> 0;
        false -> Buys
    end,
    {ok, [Power, NewBuys, Rest], Rs1};

%% 购买Power
handle(11027, [], Rs) ->
    #role{power = Power, buy_power = Buys, buy_power_time = Time} = Rs,
    case Power < data_config:get(tired_max) of
        true ->
            NewBuys = case Time < util:unixtime(today) of
            %% NewBuys = case (util:unixtime() - Time) > 5 * 60 of
                true -> 0;
                false -> Buys
            end,
            case mod_vip:vip_privilege_check(buys1, Rs) of
                true ->
                    Diamond = util:ceil(data_fun:power_buy(NewBuys)),
                    case lib_role:spend(diamond, Diamond, Rs) of
                        {ok, Rs1} ->
                            NewPower = data_config:get(tired_max),
                            Rs2 = Rs1#role{power = NewPower, buy_power = NewBuys + 1, buy_power_time = util:unixtime()},
                            Rs3 = lib_role:spend_ok(diamond, 33, Rs, Rs2),
                            lib_role:notice(Rs3),
                            %% Rs4 = mod_attain:attain_state(52, 1, Rs3),
                            %% Rs0 = mod_vip:set_vip(buys1, 1, util:unixtime(), Rs4),
                            Rs0 = mod_vip:set_vip2(buys1, NewBuys, util:unixtime(), Rs3),
                            {ok, [0, NewPower, NewBuys + 1], Rs0#role{save = [vip]}};
                        {error, _} ->
                            {ok, [1, 0, 0]}
                    end;
                false -> {ok, [4, 0, 0]}
            end;
        false -> {ok, [2, 0, 0]}
    end;

%%' 购买Power
%% handle(11027, [], Rs) ->
%%     #role{power = Power, buy_power = Buys, buy_power_time = Time} = Rs,
%%     case Power < data_config:get(tired_max) of
%%         true ->
%%             NewBuys = case Time < util:unixtime(today) of
%%                 true -> 0;
%%                 false -> Buys
%%             end,
%%             Diamond = util:ceil(data_fun:power_buy(NewBuys)),
%%             case lib_role:spend(diamond, Diamond, Rs) of
%%                 {ok, Rs1} ->
%%                     NewPower = data_config:get(tired_max),
%%                     Rs2 = Rs1#role{power = NewPower, buy_power = NewBuys + 1, buy_power_time = util:unixtime()},
%%                     Rs3 = lib_role:spend_ok(diamond, 33, Rs, Rs2),
%%                     lib_role:notice(Rs3),
%%                     Rs0 = mod_attain:attain_state(52, 1, Rs3),
%%                     {ok, [0, NewPower, NewBuys + 1], Rs0};
%%                 {error, _} ->
%%                     {ok, [1, 0, 0]}
%%             end;
%%         false -> {ok, [2, 0, 0]}
%%     end;
%%.

%% 设置成长进度 (成长进度只能设置为大于或等于当前值)
handle(11010, [Growth], Rs) ->
    ?DEBUG("set growth:~w -> ~w", [Rs#role.growth, Growth]),
    case Growth >= Rs#role.growth of
        true ->
            Rs1 = Rs#role{growth = Growth},
            {ok, [0], Rs1};
        false ->
            {ok, [1]}
    end;

%% 引导完成情况
handle(11011, [Type, Value], Rs) ->
    ?DEBUG("Type:~w, Value:~w", [Type, Value]),
    #role{guide = {T, V}} = Rs,
    case lists:member(Type, [1,2,3,4]) of
        true ->
            case Type > T of
                true ->
                    case Value =< 4 of
                        true ->
                            Rs1 = Rs#role{guide = {Type, Value}},
                            {ok, [0], Rs1};
                        false ->
                            {ok, [1]}
                    end;
                false ->
                    case Value >= V andalso Value =< 4 of
                        true ->
                            Rs1 = Rs#role{guide = {Type, Value}},
                            {ok, [0], Rs1};
                        false ->
                            {ok, [1]}
                    end
            end;
        false ->
            {ok, [1]}
    end;

%% 验证角色名字
%% handle(11100, [Name], _Rs) ->
%%     ?DEBUG("10005:~s", [Name]),
%%     case db:get_one("select id from role where name = ~s", [Name]) of
%%         null -> {ok, [0]};
%%         _ -> {ok, [1]}
%%     end;

%% 用帐号登陆
%% handle(11101, [AccountId, Password], Rs) ->
%%     ?DEBUG("account_id:~s, Password:~s", [AccountId, Password]),
%%     case check_password(AccountId, Password) of
%%         true ->
%%             case account_login(AccountId, Rs, false) of
%%                 {ok, Rid, Growth, Rs1} ->
%%                     {ok, [0, Growth, Rid], Rs1};
%%                 {error, no_reg} ->
%%                     ?DEBUG("NO REG", []),
%%                     {ok, [1, 0, 0], Rs#role{account_id = AccountId}};
%%                 {error, _} ->
%%                     ?DEBUG("ERROR", []),
%%                     {ok, [1, 0, 0]}
%%             end;
%%         false ->
%%             ?DEBUG("Password ERROR", []),
%%             {ok, [1, 0, 0]}
%%     end;

%% 注册帐号
%% handle(11102, [Aid, Password], Rs) ->
%%     ?DEBUG("account_id:~w", [Rs#role.account_id]),
%%     ?DEBUG("account_id:~s", [Rs#role.account_id]),
%%     case check_account(Aid) of
%%         true ->
%%             case db:execute("UPDATE `role` SET `aid` = ~s, `password` = ~s WHERE `id` = ~s;",
%%                     [Aid, Password, Rs#role.id]) of
%%                 1 -> {ok, [0]};
%%                 {error, _} -> {ok, [127]}
%%             end;
%%         false ->
%%             {ok, [1]}
%%     end;

%% 获取玩家所有数据数据，按顺序：1.游戏基础数据；2.玩家道具；3.玩家英雄
%% 服务器推送完成所有数据后再返回本协议
handle(11104, [], Rs) ->
    #role{diamond       = Diamond
        ,gold           = Gold
        ,tollgate_id    = TollgateId
        ,tollgate_newid = TollgateNewId
        ,power          = Power
        ,bag_mat_max    = BagMatMax
        ,bag_prop_max   = BagPropMax
        ,bag_equ_max    = BagEquMax
        ,name           = Name
        ,identifier     = Identifier
        %% ,arena_picture  = Picture
        ,items          = Items
        ,heroes         = Heroes
        ,pid_sender     = Sender
        ,luck           = {LuckNum, _B, _C, _D}
        ,guide          = {Type, Value}
        ,horn           = Horn
        %% ,tollgate_prize = TollgatePrize
        ,verify         = Verify
        ,coliseum       = Coliseum
        ,pictorialial   = Pictorial
        ,herotab        = HeroTab
        ,vip            = [Vip,_VT,_VA]
    } = Rs,
    case Rs#role.coliseum of
        [] -> ok;
        [IdL,_,_,_,_,_,_,_] ->
            coliseum ! {get_coliseum_level, self(), IdL}
    end,
    ChatTime = case mod_vip:vip_privilege_check(Rs) of
        true ->
            VIPData = data_vip:get(Vip),
            VIPCHAT = util:get_val(chat, VIPData),
            %% VIPFAST = util:get_val(fast, VIPData),
            %% {VIPFAST, VIPCHAT};
            VIPCHAT;
        false ->
            %% {10, data_config:get(chatTime)}
            data_config:get(chatTime)
    end,
    {Level, Picture} = case Coliseum == [] of
        true -> {length(data_coliseum:get(ids)), 0};
        false ->
            [_,Lev,_,Pic,_,_,_,_] = Coliseum,
            {Lev, Pic}
    end,
    HeroTab2 = case HeroTab < length(Heroes) of
        true -> length(Heroes);
        false -> HeroTab
    end,
    Rs0 = case TollgateNewId == 1 of
        true -> Rs#role{tollgate_prize = 1};
        false -> Rs
    end,
    #role{tollgate_prize = TollgatePrize} = Rs0,
    FirstPay = mod_fest:is_firstpay(Rs),
    Data11003 = [Diamond, Gold, TollgateNewId
                ,Power, BagEquMax, BagPropMax
                ,BagMatMax, Name, Picture
                ,LuckNum, Horn, ChatTime
                ,TollgatePrize, Verify, Level
                ,HeroTab2, Vip - 1, FirstPay],
    sender:pack_send(Sender, 11003, Data11003),
    F = fun(I, {Es, Ps}) ->
            case I#item.tid > 99999 of
                true -> {[mod_item:pack_equ(I)|Es], Ps};
                false -> {Es, [mod_item:pack_prop(I)|Ps]}
            end
    end,
    {Data1, Data2} = lists:foldl(F, {[],[]}, Items),
    Data13001 = [1, Data1, Data2],
    sender:pack_send(Sender, 13001, Data13001),
    Data14002 = [mod_hero:pack_hero(X) || X <- Heroes],
    sender:pack_send(Sender, 14002, [Data14002]),
    gen_server:cast(admin, {send_new_notice, Sender}),
    %% 登录签到推送(有奖励可以领取就推送)
    Rs2 = case mod_sign:send_sign(Rs0) of
        {[_,_,_,_,E], Rs1} ->
            F1 = fun({_X, Y}) -> Y =:= 1 end,
            case lists:any(F1, E) of
                true ->
                    sender:pack_send(Sender, 13051, [1]),
                    Rs1;
                false ->
                    Rs1
            end;
        {Reason, Rs1} ->
            ?WARN("login sign error:~w", [Reason]),
            Rs1
    end,
    %% 登录推送引导信息
    ?DEBUG("==Type:~w, Value:~w", [Type, Value]),
    case Value =:= 4 of
        true -> ok;
        false ->
            sender:pack_send(Sender, 11013, [Type, Value])
    end,
    %% 活动id推送
    %% FestIds = mod_fest:activity_send(Rs2),
    %% FestIds = [[60],[61],[62],[63],[64],[65],[66]],
    %% sender:pack_send(Sender, 25001, [FestIds]),
    %% sender:pack_send(Sender, 25002, []),
    %% 新邮件通知
    case env:get('@new_email') of
        undefined -> ok;
        1 ->
            sender:pack_send(Sender, 26001, []),
            erase('@new_email')
    end,
    %% 关卡礼包通知
    Ids = data_tollgate_prize:get(ids),
    {TollgatePrize2, TollgateId2} =
    case lists:keyfind(TollgatePrize, 1, Ids) of
        false -> {0, 0};
        R -> R
    end,
    case TollgatePrize2 =/= 0 andalso TollgateNewId > TollgateId2 of
        true ->
            sender:pack_send(Sender, 13058, [TollgatePrize]);
        false -> ok
    end,
    %% 图鉴
    Rs3 = case Pictorial == [] of
        true ->
            Pictorial1 = [lists:nth(2, L) || L <- Data14002],
            Pictorial2 = util:del_repeat_element(Pictorial1),
            Rs2#role{pictorialial = Pictorial2, save = [pictorial]};
            %% role:save_delay(pictorial, Rs2);
        false -> Rs2
    end,
    %% 邮件定时奖励活动
    ValList = timeing:get(),
    timeing_send_mail(ValList, Rs#role.id),
    %% 自定义活动奖励
    ValCustom = custom:get(),
    custom_send_mail(ValCustom, Rs, []),
    %% month card prize
    Rs4 = mod_vip:send_mcard(Rs3),
    %% add coliseum honor
    self() ! {pt, 2044, []},
    %% &1=new tollgate_newid reward
    Rs5 = case util:keyborband(1,Identifier,1) of
        0 ->
            case TollgateId =/= 1 of
                true -> Rs4;
                false ->
                    Title = data_text:get(2),
                    Body = data_text:get(19),
                    Prize = [{2, TollgateId * 3}, {7, TollgateId * 3}],
                    mod_mail:new_mail(Rs#role.id, 0, 63, Title, Body, Prize),
                    Identifier2 = util:keyborband(2,Identifier,1),
                    Rs4#role{identifier = Identifier2}
            end;
        _ -> Rs4
    end,
    {ok, [0], Rs5};

%% 检查帐号是否可注册
handle(11103, [AccountId], _Rs) ->
    case check_account(AccountId) of
        true ->
            {ok, [0]};
        false ->
            {ok, [1]}
    end;

handle(_Cmd, _Data, _RoleState) ->
    {error, bad_request}.

%% === 私有函数 ===

%% @doc check_password
-spec check_password(Rs, AccountId, Password) -> {ok, NewRs} | {error, Reason} when
    Rs :: #role{},
    NewRs :: #role{},
    Reason :: term(),
    AccountId :: binary(),
    Password :: binary().

check_password(Rs, AccountId, Password) ->
    Password1 = get_password_from_ets(AccountId),
    Pw = util:md5(Password),
    if
        Password =:= <<>> ->
            ?WARN("Password is empty! (AccountId:~s)", [AccountId]),
            {error, empty};
        Password1 =/= false andalso Password1 =:= Pw ->
            ?DEBUG("[~s] Rs#role.password =:= Password", [AccountId]),
            {ok, Rs};
        true ->
            Sql = "select count(id) from role where aid = ~s and password = ~s",
            case db:get_one(Sql, [AccountId, Pw]) of
                {ok, 1} ->
                    {ok, Rs#role{account_id = AccountId, password = Pw}};
                {ok, C} ->
                    ?DEBUG("Password Error! AccountId:~w, Count:~w", [AccountId, C]),
                    {error, error};
                {error, null} ->
                    {error, error};
                {error, Reason} ->
                    ?DEBUG("Password Error:~w", [Reason]),
                    {error, Reason}
            end
    end.

get_password_from_ets(AccountId) ->
     case lib_role:get_role_pid_from_ets(account_id, AccountId) of
         false -> false;
         {_, Pid} ->
             case catch gen_server:call(Pid, get_state) of
                 {ok, Rs} -> Rs#role.password;
                 _ -> false
             end
     end.

%% @doc check_account
-spec check_account(AccountId) -> true | false when
    AccountId :: binary().

check_account(AccountId) ->
    case db:get_one("select id from role where aid = ~s",
            [AccountId]) of
        {error, null} -> true;
        _ -> false
    end.

%% @doc account_login
-spec account_login(AccountId, Rs, IsFirst) ->
    {ok, Rid, Growth, NewRs} | {error, no_reg} | {error, fix_conn} | {error, repeat_login} when
    AccountId :: binary(),
    Rs :: NewRs,
    NewRs :: #role{},
    IsFirst :: true | false,
    Growth :: integer(),
    Rid :: integer().

account_login(AccountId, Rs, IsFirst) ->
    %% 先检查角色是否仍驻留在内存中
    case lib_role:get_role_pid_from_ets(account_id, AccountId) of
        false ->
            %% 不在内存中，则从数据库加载
            case lib_role:db_init(account_id, AccountId, Rs) of
                {ok, Rs1} ->
                    Rs2 = Rs1#role{status = 1},
                    #role{
                        id = Rid
                        ,ip = Ip
                        ,pid = Pid
                        ,growth = Growth
                    } = Rs2,
                    gen_server:cast(myevent, {login, Rid, Pid}),
                    ?LOG({login, Rid, Ip}),
                    Rs3 = is_first(IsFirst, Rs2),
                    {ok, Rid, Growth, Rs3};
                {error, no_reg} ->
                    {error, no_reg};
                {error, Reason} ->
                    {error, Reason}
            end;
        {_From, Pid} when Pid =:= Rs#role.pid ->
            {error, repeat_login};
        {From, Pid} ->
            #role{
                pid_conn = PidConn
                ,pid_sender = PidSerder
                ,socket = Socket
                ,ip = Ip
                ,port = Port
            } = Rs,
            case catch role:fix_conn(Pid, PidConn, PidSerder, Socket, Ip, Port) of
                {'EXIT', Error} ->
                    ?WARN("Error when fix_conn: ~w", [Error]),
                    {error, fix_conn};
                FixRs ->
                    case From of
                        offline -> ets:delete(offline, AccountId);
                        _ -> ok
                    end,
                    Rs#role.pid ! stop,
                    #role{
                        id = FixId
                        ,growth = Growth
                    } = FixRs,
                    {ok, FixId, Growth, Rs}
            end
    end.

is_first(false, Rs) ->
    Rs;
%% is_first(true, Rs) ->
%%     #role{id = Rid, account_id = Aid, ip = Ip} = Rs,
%%     ?LOG({reg, Rid, Aid, Ip}),
%%     {ok, NewRs, _, _} = mod_item:add_items(Rs, [113001, 13001]),
%%     NewRs.
is_first(true, Rs) ->
    #role{id = Rid, account_id = Aid, ip = Ip} = Rs,
    ?LOG({reg, Rid, Aid, Ip}),
    %% {ok, NewRs, _, _} = mod_item:add_items(Rs, [113001, 13001]),
    List = data_reg_prize:get(ids),
    case length(List) == 0 of
        true -> Rs;
        false ->
            Data = data_reg_prize:get(1),
            Prize = util:get_val(prize, Data, []),
            {ok, NewRs, PA, EA} = mod_item:add_items(Rs, Prize),
            NewRsB = lib_role:add_attr_ok(batch, 45, Rs, NewRs),
            mod_item:send_notice(Rs#role.pid_sender, PA, EA),
            NewRsB
    end.

%% 检测定时邮件奖励发放
timeing_send_mail([], _Rid) -> ok;
timeing_send_mail([{Key,Val}|Last], Rid) ->
    {_S,_E,SL,UL,T,B,I} = Val,
    case lists:member(Rid, SL) of
        true ->
            case lists:member(Rid, UL) of
                true -> timeing_send_mail(Last, Rid);
                false ->
                    mod_mail:new_mail(Rid, 0, 50, T,B,I),
                    timeing:set_use(Key, Rid),
                    timeing_send_mail(Last, Rid)
            end;
        false -> timeing_send_mail(Last, Rid)
    end.

%% 检测自定义活动奖励发放
custom_send_mail([], Rs, Rt) ->
    case Rt == [] of
        true -> ok;
        false ->
            custom_send_mail3(Rt, Rs)
    end;
custom_send_mail([{Key,Val,Content,Items,List}| T], Rs, Rt) ->
    case lists:member(Rs#role.id, List) of
        true -> custom_send_mail(T, Rs, Rt);
        false ->
            case custom_send_mail2(Val, Rs) andalso Val =/= [] of
                true -> custom_send_mail(T, Rs, [{Key,Val,Content,Items,List}|Rt]);
                false -> custom_send_mail(T, Rs, Rt)
            end
    end.
custom_send_mail2([], _Rs) -> true;
custom_send_mail2([{Fun, Arg1, Arg2}| T], Rs) ->
    case custom_check(Fun, Arg1, Arg2, Rs) of
        true -> custom_send_mail2(T, Rs);
        false -> false
    end.

custom_send_mail3([], _Rs) -> ok;
custom_send_mail3([{Key,_Val,Content,Items,_List}|Rt], Rs) ->
    Title = data_text:get(3),
    mod_mail:new_mail(Rs#role.id, 0, 51, Title, Content, Items),
    custom:set_use(Key, Rs#role.id),
    custom_send_mail3(Rt, Rs).

custom_check(custom_register, Arg1, Arg2, Rs) ->
    Sql = list_to_binary([<<"SELECT `ctime` FROM `role` WHERE `id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:get_one(Sql) of
        {ok, Ctime} ->
            Ctime > Arg1 andalso Ctime < Arg2;
        {error, _} -> false
    end;
custom_check(custom_login, Arg1, Arg2, _Rs) ->
    LoginTime = util:unixtime(),
    LoginTime > Arg1 andalso LoginTime < Arg2;
    %% Sql = list_to_binary([<<"SELECT `login_time` FROM `role` WHERE `id` = ">>
    %%         ,integer_to_list(Rs#role.id)]),
    %% case db:get_one(Sql) of
    %%     {ok, LoginTime} ->
    %%         LoginTime > Arg1 andalso LoginTime < Arg2;
    %%     {error, _} -> false
    %% end;
custom_check(custom_tollgate, Arg1, Arg2, Rs) ->
    %% Tollgate = Rs#role.tollgate_id,
    Tollgate = Rs#role.tollgate_newid,
    Tollgate > Arg1 andalso Tollgate < Arg2;
%% TODO:连续登录天数条件实现
%% custom_check(custom_login_days, Arg1, Arg2, Rs) ->
%%     Sql = list_to_binary([<<"">>])
custom_check(custom_shop_diamond, Arg1, Arg2, Rs) ->
    Sql = list_to_binary([<<"SELECT SUM(`diamond`) FROM `app_store` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:get_one(Sql) of
        {ok, Diamond} ->
            Diamond > Arg1 andalso Diamond < Arg2;
        {error, _} -> false
    end;
custom_check(_,_,_,_) -> false.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
