%%----------------------------------------------------
%% $Id: pt_fest.erl 13170 2014-06-04 09:21:26Z piaohua $
%% @doc 协议25 - 节日活动
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_fest).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").

-define(FIRSTPAY, 60).
-define(GIVEDIAMOND, 61).
-define(WEIXINSHARE, 62).
-define(INVITE, 63).
-define(GRADE, 64).
-define(LOGINFRIEND, 65).
-define(BINDING, 66).
-define(CDKEY, 67).
-define(FACEBOOKSHARE, 68).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
-endif.


%% 活动开启
handle(25001, [], Rs) ->
    Id = case lib_system:fest_id() of
        0 -> [];
        V -> [V]
    end,
    Rs1 = repeat_init(Rs),
    #role{activity = ActIds} = Rs1,
    List1 = off_activity(?FIRSTPAY, ActIds),
    List2 = screen_activity(List1),
    List3 = activity_list(List2),
    Id2 = [[Id3] || {Id3, _, _, _} <- List3],
    {ok, [Id ++ Id2], Rs1};

%% 钻石大放送活动信息
handle(25002, [], Rs) ->
    GradeAddr = list_to_binary(env:get(activity_grade)),
    DownloadAddr = list_to_binary(env:get(activity_download)),
    %% ?DEBUG("GradeAddr:~w, DownloadAddr:~w", [GradeAddr, DownloadAddr]),
    Rs0 = repeat_init(Rs),
    Rs1 = activity_rank_num(?LOGINFRIEND, Rs0),
    Rs2 = activity_invite_friend(?INVITE, Rs1),
    %% 微信分享V换成cd时间
    {Cd, St} = weixin_share_cd(Rs2),
    #role{activity = ActIds, verify = Verify} = Rs2,
    List2 = lists:keyreplace(?WEIXINSHARE,1,ActIds,{?WEIXINSHARE,Cd,1,St}),
    List3 = off_activity(?BINDING, List2),
    List4 = off_activity(?GRADE, List3),
    List5 = screen_activity(List4),
    List6 = activity_num(List5),
    {FCd, FSt} = facebook_share_cd(Rs2),
    List7 = lists:keyreplace(?FACEBOOKSHARE,1,List6,{?FACEBOOKSHARE,FCd,1,FSt}),
    {ok, [Verify, DownloadAddr, GradeAddr, List7], Rs2};

%% 活动奖励兑换
handle(25004, [Id], Rs) ->
    Ids = data_fest_swap:get(ids),
    case lists:member(Id, Ids) of
        true ->
            Data = data_fest_swap:get(Id),
            DelIds = util:get_val(mat, Data),
            Item = util:get_val(item, Data),
            %% AddItem = rate_add_item(Item),
            AddItem = util:weight_extract(Item),
            Items = Rs#role.items,
            case mod_item:del_items(by_id, DelIds, Items) of
                {ok, Items1, Notice} ->
                    case mod_item:add_items(Rs, AddItem) of
                        {ok, Rs1, PA, EA} ->
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            Rs2 = Rs1#role{items=Items1},
                            %% 物品删除通知
                            mod_item:send_notice(Rs2#role.pid_sender, Notice),
                            %% 通知钱币更新
                            lib_role:notice(Rs2),
                            %% 一切都OK后，从数据库中删除物品
                            mod_item:del_items_from_db(Rs2#role.id, Notice),
                            Rs0 = role:save_delay(fest, Rs2),
                            {ok, [0, AddItem], Rs0};
                        {error, full} ->
                            %% Title = data_text:get(2),
                            %% Body = data_text:get(4),
                            %% mod_mail:new_mail(Rs#role.id, 0, Title, Body, V),
                            {ok, [3, []]};
                        {error, _} ->
                            {ok, [128, []]}
                    end;
                {error, _} ->
                    {ok, [1, []]}
            end;
        false ->
            {ok, [127, []]}
    end;

%% 微信分享
%% Id=?WEIXINSHARE
%% Id=?FACEBOOKSHARE
handle(25030, [Id], Rs) ->
    #role{activity = ActIds} = Rs,
    case lists:keyfind(Id,1,ActIds) of
        {Id,V,N,_St} when Id == ?WEIXINSHARE orelse Id == ?FACEBOOKSHARE ->
            WeixinCD = case Id of
                ?WEIXINSHARE ->
                    data_config:get(weixinShare);
                _ -> 0
            end,
            T = WeixinCD - (util:unixtime() - V),
            case T > 0 of
                true -> {ok, [1,T,0]};
                false ->
                    ShareTime = util:unixtime(),
                    St2 = case Id of
                        ?FACEBOOKSHARE ->
                            case V < util:unixtime(today) of
                                true -> 1;
                                false -> 0
                            end;
                        _ -> 1
                    end,
                    List2 = lists:keyreplace(Id,1,ActIds,{Id, ShareTime, N, St2}),
                    Rs1 = role:save_delay(fest, Rs),
                    Rs2 = case Id of
                        ?FACEBOOKSHARE ->
                            mod_task:set_task(14,{1,1},Rs1);
                        _ -> Rs1
                    end,
                    {ok, [0,Id,WeixinCD], Rs2#role{activity = List2}}
            end;
        _ -> {ok, [127,Id,0]}
    end;

%% 微信分享领奖
handle(25031, [Id], Rs) ->
    #role{activity = ActIds} = Rs,
    case lists:keyfind(Id,1,ActIds) of
        {Id,V,N,1} when Id == ?WEIXINSHARE orelse Id == ?FACEBOOKSHARE ->
            case data_fest_prize:get({Id, N}) of
                undefined -> {ok, [127,Id,0]};
                Data ->
                    Tid = util:get_val(tid, Data),
                    case mod_item:add_items(Rs, Tid) of
                        {ok, Rs1, PA, EA} ->
                            WeixinCD = data_config:get(weixinShare),
                            T = WeixinCD - (util:unixtime() - V),
                            Cd = case T > 0 of
                                true -> T;
                                false -> WeixinCD
                            end,
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            Rs2 = lib_role:add_attr_ok(batch, 53, Rs, Rs1),
                            lib_role:notice(Rs2),
                            lib_role:notice(luck, Rs2),
                            NewAct = lists:keyreplace(Id,1,ActIds,{Id,V,N,2}),
                            Rs3 = role:save_delay(fest, Rs2),
                            {ok, [0,Id,Cd], Rs3#role{activity = NewAct, save = [items]}};
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id, 0, 53, Title, Body, Tid),
                            WeixinCD = data_config:get(weixinShare),
                            T = WeixinCD - (util:unixtime() - V),
                            Cd = case T > 0 of
                                true -> T;
                                false -> WeixinCD
                            end,
                            NewAct = lists:keyreplace(Id,1,ActIds,{Id,V,N,2}),
                            Rs1 = role:save_delay(fest, Rs),
                            {ok, [3,Id,Cd], Rs1#role{activity = NewAct}};
                        {error, _} ->
                            {ok, [129,Id,0]}
                    end
            end;
        _ -> {ok, [1,Id,0]}
    end;

%% 首充活动状态
handle(25032, [], Rs) ->
    #role{attain = Attain, activity = Activity} = Rs,
    Cond = case lists:keyfind(33, 3, Attain) of
        {_, _, 33, C, _} -> C;
        false -> 0
    end,
    %% ?INFO("====Cond:~w, Power:~w", [Cond, Rs#role.power]),
    case lists:keyfind(?FIRSTPAY, 1, Activity) of
        {?FIRSTPAY, _Val, _N, St} ->
            case St =:= 0 of
                true ->
                    case Cond > 0 of
                        true ->
                            NewAct = lists:keyreplace(?FIRSTPAY, 1, Activity, {?FIRSTPAY, 0, 1, 1}),
                            Rs1 = role:save_delay(fest, Rs),
                            {ok, [0], Rs1#role{activity = NewAct}};
                        false -> {ok, [1]}
                    end;
                false ->
                    case St =:= 1 of
                        true -> {ok, [0]};
                        false -> {ok, [2]}
                    end
            end;
        false -> {ok, [127]}
    end;

%% 首充活动领奖
handle(25033, [], Rs) ->
    ActList = Rs#role.activity,
    case lists:keyfind(?FIRSTPAY, 1, ActList) of
        {?FIRSTPAY, _V, _N, St} ->
            case St =:= 1 of
                true ->
                    case data_first_pay:get(ids) of
                        undefined -> {ok, [128]};
                        ListIds ->
                            F1 = fun(Id) ->
                                    Data = data_first_pay:get(Id),
                                    Tid  = util:get_val(tid, Data),
                                    Num  = util:get_val(num, Data),
                                    {Tid, Num}
                            end,
                            V = [F1(Id1) || Id1 <- ListIds],
                            case mod_item:add_items(Rs, V) of
                                {ok, Rs1, PA, EA} ->
                                    mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                                    lib_role:notice(Rs1),
                                    lib_role:notice(luck, Rs1),
                                    NewAct = lists:keyreplace(?FIRSTPAY, 1, ActList, {?FIRSTPAY, 1, 1, 2}),
                                    Rs2 = role:save_delay(fest, Rs1),
                                    Rs3 = lib_role:add_attr_ok(batch, 40, Rs, Rs2),
                                    {ok, [0], Rs3#role{activity = NewAct, save = [items]}};
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 40, Title, Body, V),
                                    NewAct = lists:keyreplace(?FIRSTPAY, 1, ActList, {?FIRSTPAY, 1, 1, 2}),
                                    Rs1 = role:save_delay(fest, Rs),
                                    %% Rs2 = lib_role:add_attr_ok(batch, 40, Rs, Rs1),
                                    {ok, [3], Rs1#role{activity = NewAct}};
                                {error, _} ->
                                    {ok, [129]}
                            end
                    end;
                false -> {ok, [2]}
            end;
        false ->
            {ok, [127]}
    end;

%% 邀请用户数领奖
handle(25034, [], Rs) ->
    ActList = Rs#role.activity,
    case lists:keyfind(?INVITE, 1, ActList) of
        {?INVITE, V, N, St} ->
            case data_fest_prize:get({?INVITE, N}) of
                undefined -> {ok, [2, 0, 0]};
                Data ->
                    Cond = util:get_val(condition, Data),
                    Tid = util:get_val(tid, Data),
                    case V >= Cond andalso St =:= 1 of
                        true ->
                            case mod_item:add_items(Rs, Tid) of
                                {ok, Rs1, PA, EA} ->
                                    mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                                    lib_role:notice(Rs1),
                                    lib_role:notice(luck, Rs1),
                                    {Next, State, Rs2} = invite_next_point(V, N, Rs1),
                                    Rs3 = role:save_delay(fest, Rs2),
                                    Rs4 = lib_role:add_attr_ok(batch, 41, Rs, Rs3),
                                    {ok, [0, Next, State], Rs4#role{save = [items]}};
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 41, Title, Body, Tid),
                                    {Next, State, Rs1} = invite_next_point(V, N, Rs),
                                    Rs2 = role:save_delay(fest, Rs1),
                                    {ok, [3, Next, State], Rs2};
                                {error, _} ->
                                    {ok, [129, 0, 0]}
                            end;
                        false -> {ok, [1, 0, 0]}
                    end
            end;
        false -> {ok, [127]}
    end;

%% 评星状态
handle(25035, [], Rs) ->
    ActList = Rs#role.activity,
    case lists:keyfind(?GRADE, 1, ActList) of
        {?GRADE, _V, N, St} ->
            case St =:= 0 of
                true ->
                    NewAct = lists:keyreplace(?GRADE, 1, ActList, {?GRADE, 1, N, 1}),
                    Rs1 = role:save_delay(fest, Rs),
                    {ok, [0], Rs1#role{activity = NewAct}};
                false ->
                    case St =:= 1 of
                        true -> {ok, [0]};
                        false -> {ok, [1]}
                    end
            end;
        false -> {ok, [127]}
    end;

%% 评星领奖
handle(25036, [], Rs) ->
    ActList = Rs#role.activity,
    case lists:keyfind(?GRADE, 1, ActList) of
        {?GRADE, _V, N, St} ->
            case St =:= 1 of
                true ->
                    Data = data_fest_prize:get({?GRADE, 1}),
                    Tid = util:get_val(tid, Data),
                    case mod_item:add_items(Rs, Tid) of
                        {ok, Rs1, PA, EA} ->
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            Rs2 = lib_role:add_attr_ok(batch, 54, Rs, Rs1),
                            lib_role:notice(Rs2),
                            lib_role:notice(luck, Rs2),
                            NewAct = lists:keyreplace(?GRADE, 1, ActList, {?GRADE, 1, N, 2}),
                            Rs3 = role:save_delay(fest, Rs2),
                            {ok, [0], Rs3#role{activity = NewAct, save = [items]}};
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id, 0, 54, Title, Body, Tid),
                            NewAct = lists:keyreplace(?GRADE, 1, ActList, {?GRADE, 1, N, 2}),
                            Rs2 = role:save_delay(fest, Rs),
                            {ok, [3], Rs2#role{activity = NewAct}};
                        {error, _} ->
                            {ok, [128]}
                    end;
                false ->
                    {ok, [1]}
            end;
        false ->
            {ok, [127]}
    end;

%% 好友登录数领奖
%% 修改:每天都可以领取奖励
handle(25038, [], Rs) ->
    ActList = Rs#role.activity,
    case lists:keyfind(?LOGINFRIEND, 1, ActList) of
        {?LOGINFRIEND, V, N, St} ->
            case data_fest_prize:get({?LOGINFRIEND, N}) of
                undefined -> {ok, [2, 0, 0]};
                Data ->
                    Cond = util:get_val(condition, Data),
                    Tid = util:get_val(tid, Data),
                    case V >= Cond andalso St =:= 1 of
                        true ->
                            case mod_item:add_items(Rs, Tid) of
                                {ok, Rs1, PA, EA} ->
                                    mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                                    lib_role:notice(Rs1),
                                    lib_role:notice(luck, Rs1),
                                    {Next, State, Rs2} = login_friend_next_point(V, N, Rs1),
                                    Rs3 = role:save_delay(fest, Rs2),
                                    Rs4 = lib_role:add_attr_ok(batch, 42, Rs, Rs3),
                                    {ok, [0, Next, State], Rs4#role{save = [items]}};
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 42, Title, Body, Tid),
                                    {Next, State, Rs1} = login_friend_next_point(V, N, Rs),
                                    Rs2 = role:save_delay(fest, Rs1),
                                    {ok, [0, Next, State], Rs2#role{save = [items]}};
                                {error, _} ->
                                    {ok, [128, 0, 0]}
                            end;
                        false -> {ok, [1, 0, 0]}
                    end
            end;
        false -> {ok, [127, 0, 0]}
    end;

%% 绑定激活码登录
%% handle(25040, [Verify], Rs) ->
%%     #role{verify = MyVerify, activity = Activity} = Rs,
%%     case is_integer(Verify) andalso Verify =/= MyVerify of
%%         true ->
%%             case lists:keyfind(?BINDING, 1, Activity) of
%%                 {?BINDING, V, N, St} ->
%%                     case St =:= 0 of
%%                         true ->
%%                             case mod_fest:activity_verify_check(Rs, Verify) of
%%                                 {_, null} -> {ok, [2]};
%%                                 {_, error} -> {ok, [128]};
%%                                 {Rs1, _Rid} ->
%%                                     NewAct = lists:keyreplace(?BINDING, 1, Activity, {?BINDING, V, N, 1}),
%%                                     Rs2 = role:save_delay(fest, Rs1),
%%                                     {ok, [0], Rs2#role{activity = NewAct}}
%%                             end;
%%                         false ->
%%                             {ok, [1]}
%%                     end;
%%                 false ->
%%                     {ok, [127]}
%%             end;
%%         false ->
%%             {ok, [2]}
%%     end;

%% 绑定激活码登录
handle(25040, [Verify], Rs) ->
    ?DEBUG("Verify:~w", [Verify]),
    #role{verify = MyVerify, activity = Activity} = Rs,
    case is_integer(Verify) andalso Verify =/= MyVerify of
        true ->
            case lists:keyfind(?BINDING, 1, Activity) of
                {?BINDING, _V, _N, St} ->
                    case St =:= 0 of
                        true ->
                            ToRid = Verify div 1000,
                            case sender:send_info(ToRid, 2040, [Rs#role.id, Rs#role.pid, Verify]) of
                                ok -> {ok};
                                error -> {ok, [128]}
                            end;
                        false ->
                            {ok, [1]}
                    end;
                false ->
                    {ok, [127]}
            end;
        false ->
            {ok, [2]}
    end;

%% 绑定激活码领奖
handle(25041, [], Rs) ->
    #role{activity = Activity} = Rs,
    case lists:keyfind(?BINDING, 1, Activity) of
        {?BINDING, _V, _N, St} ->
            case St =:= 1 of
                true ->
                    Data = data_fest_prize:get({?BINDING, 1}),
                    Tid = util:get_val(tid, Data),
                    case mod_item:add_items(Rs, Tid) of
                        {ok, Rs1, PA, EA} ->
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            lib_role:notice(Rs1),
                            lib_role:notice(luck, Rs1),
                            NewAct = lists:keyreplace(?BINDING, 1, Activity, {?BINDING, 1, 1, 2}),
                            Rs2 = role:save_delay(fest, Rs1),
                            Rs3 = lib_role:add_attr_ok(batch, 43, Rs, Rs2),
                            {ok, [0], Rs3#role{activity = NewAct, save = [items]}};
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id, 0, 43, Title, Body, Tid),
                            NewAct = lists:keyreplace(?BINDING, 1, Activity, {?BINDING, 1, 1, 2}),
                            Rs1 = role:save_delay(fest, Rs),
                            {ok, [3], Rs1#role{activity = NewAct}};
                        {error, _} ->
                            {ok, [127]}
                    end;
                false -> {ok, [1]}
            end
    end;

%% 绑定营运激活码领奖
handle(25044, [Key], Rs) ->
    #role{activity = Act} = Rs,
    case lists:keyfind(?CDKEY, 1, Act) of
        false -> {ok, [127]};
        {?CDKEY,_V,_N,St} ->
            %% Type < 30
            {Code, Type} = mod_fest:cdkey_check(Key),
            case keyborband(1,St,Type) of
                0 ->
                    case Code == 0 andalso Type =/= 0 of
                        true ->
                            Data = data_fest_prize:get({?CDKEY,Type}),
                            Tid = util:get_val(tid, Data, []),
                            Title = data_text:get(2),
                            Body = data_text:get(18),
                            mod_mail:new_mail(Rs#role.id, 0, 48, Title, Body, Tid),
                            St2 = keyborband(2,St,Type),
                            %% NewAct = lists:keyreplace(?CDKEY, 1, Act, {?CDKEY,1,1,2}),
                            NewAct = lists:keyreplace(?CDKEY, 1, Act, {?CDKEY,1,1,St2}),
                            Rs1 = role:save_delay(fest, Rs),
                            mod_fest:cdkey_check_ok(Key, Rs#role.id),
                            Rs0 = Rs1#role{activity = NewAct},
                            %% Rs0 = case mod_item:add_items(Rs, Tid) of
                            %%     {ok, Rs1, PA, EA} ->
                            %%         mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            %%         lib_role:notice(Rs1),
                            %%         lib_role:notice(luck, Rs1),
                            %%         NewAct = lists:keyreplace(?CDKEY, 1, Act, {?CDKEY,1,1,2}),
                            %%         Rs2 = role:save_delay(fest, Rs1),
                            %%         Rs3 = lib_role:add_attr_ok(batch, 48, Rs, Rs2),
                            %%         mod_fest:cdkey_check_ok(Key, Rs#role.id),
                            %%         Rs3#role{activity = NewAct, save = [items]};
                            %%     {error, full} ->
                            %%         Title = data_text:get(2),
                            %%         Body = data_text:get(4),
                            %%         mod_mail:new_mail(Rs#role.id, 0, 48, Title, Body, Tid),
                            %%         NewAct = lists:keyreplace(?CDKEY, 1, Act, {?CDKEY,1,1,2}),
                            %%         Rs1 = role:save_delay(fest, Rs),
                            %%         mod_fest:cdkey_check_ok(Key, Rs#role.id),
                            %%         Rs1#role{activity = NewAct};
                            %%     {error, _} ->
                            %%         Rs
                            %% end,
                            {ok, [0], Rs0};
                        false ->
                            {ok, [Code]}
                    end;
                _ ->
                    {ok, [4]}
            end
    end;

%% pay double info
handle(25046, [], Rs) ->
    %% #role{paydouble = PayDouble} = Rs,
    %% Ids = data_diamond_shop:get(ids),
    %% List = case PayDouble == [] of
    %%     true ->
    %%         F1 = fun(Id) ->
    %%                 Data = data_diamond_shop:get(Id),
    %%                 DoubleId = util:get_val(shopid,Data,0),
    %%                 Double = util:get_val(double,Data,0),
    %%                 case Double > 0 of
    %%                     true -> DoubleId;
    %%                     false -> 0
    %%                 end
    %%         end,
    %%         [F1(X) || X <- Ids, F1(X) =/= 0];
    %%     false ->
    %%         F2 = fun(Id) ->
    %%                 Data = data_diamond_shop:get(Id),
    %%                 DoubleId = util:get_val(shopid,Data,0),
    %%                 Double = util:get_val(double,Data,0),
    %%                 case lists:keyfind(DoubleId,1,PayDouble) of
    %%                     false ->
    %%                         case Double > 0 of
    %%                             true -> DoubleId;
    %%                             false -> 0
    %%                         end;
    %%                     {_,Num} ->
    %%                         case Num < Double of
    %%                             true -> DoubleId;
    %%                             false -> 0
    %%                         end
    %%                 end
    %%         end,
    %%         [F2(X1) || X1 <- Ids, F2(X1) =/= 0]
    %% end,
    List = mod_fest:pay_double_info(Rs),
    {ok, [List]};

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

%% 关闭活动
off_activity(ActId, List) ->
    case lists:keyfind(ActId, 1, List) of
        {ActId, _, _, St} ->
            case St =:= 2 of
                true -> lists:keydelete(ActId, 1, List);
                false -> List
            end;
        false -> List
    end.

%% 屏蔽活动
screen_activity(List) ->
    screen_activity(List, []).
screen_activity([], Rt) -> Rt;
screen_activity([{Id,V,N,S}|T], Rt) ->
    List = [?INVITE,?GRADE,?LOGINFRIEND,?BINDING],
    case lists:member(Id, List) of
        true ->
            screen_activity(T, Rt);
        false ->
            screen_activity(T, [{Id,V,N,S}|Rt])
    end.

%% 初始化失败,重新初始化
repeat_init(Rs) ->
    #role{activity = Act} = Rs,
    case Act == [] of
        true ->
            case mod_fest:activity_init(Rs) of
                {ok, Rs1} ->
                    Rs2 = role:save_delay(fest, Rs1),
                    Rs2;
                {error, Reason} ->
                    ?INFO("repeat init error:~w", [Reason]),
                    Rs
            end;
        false -> Rs
    end.

%% 节日活动兑换物品
%% rate_add_item([{Mat, Num, Rate} | T]) ->
%%     case util:rate(Rate) of
%%         true -> [{Mat, Num}];
%%         false ->
%%             rate_add_item(T)
%%     end;
%%
%% rate_add_item([]) -> [].

%% 微信cd
weixin_share_cd(Rs) ->
    #role{activity = ActIds} = Rs,
    WeixinCD = data_config:get(weixinShare),
    case lists:keyfind(?WEIXINSHARE, 1, ActIds) of
        {?WEIXINSHARE, V, _N, St} ->
            case V =:= 0 of
                true -> {0, 0};
                false ->
                    T = WeixinCD - (util:unixtime() - V),
                    case T > 0 of
                        true -> {T, St};
                        false -> {0, St}
                    end
            end;
        false -> {0, 0}
    end.

%% facebook cd
facebook_share_cd(Rs) ->
    #role{activity = ActIds} = Rs,
    %% WeixinCD = data_config:get(weixinShare),
    %% Time = util:unixtime(today),
    case lists:keyfind(?FACEBOOKSHARE, 1, ActIds) of
        {?FACEBOOKSHARE,V,_N,St} ->
            St2 = case St of
                1 -> St;
                _ -> 0
            end,
            {V,St2};
        false -> {0,0}
    end.

%% 统计昨日登录好友
activity_rank_num(ActId, Rs) ->
    #role{activity = ActIds} = Rs,
    %% ?INFO("ActIds:~w", [ActIds]),
    {ActId, _V, N, St} = lists:keyfind(ActId, 1, ActIds),
    %% ?INFO("ActId:~w, N:~w", [ActId, N]),
    case data_fest_prize:get({ActId, N}) of
        undefined -> Rs;
        Data ->
            Cond = util:get_val(condition, Data),
            case mod_fest:activity_friend_login_count(Rs) of
                {ok, Num} ->
                    case Num >= Cond andalso St =/= 2 of
                        true ->
                            NewActIds = lists:keyreplace(ActId, 1, ActIds, {ActId, Num, N, 1}),
                            Rs1 = role:save_delay(fest, Rs),
                            Rs1#role{activity = NewActIds};
                        false -> Rs
                    end;
                {error, Reason} ->
                    ?WARN("activity select wrong:~w", [Reason]),
                    Rs
            end
    end.

%% 邀请好友
activity_invite_friend(ActId, Rs) ->
    #role{activity = ActIds, friends = Fri} = Rs,
    {ActId, _V, N, St} = lists:keyfind(ActId, 1, ActIds),
    case data_fest_prize:get({ActId, N}) of
        undefined -> Rs;
        Data ->
            Num = erlang:length(Fri),
            Cond = util:get_val(condition, Data),
            case Num >= Cond andalso St =/= 2 of
                true ->
                    NewActIds = lists:keyreplace(ActId, 1, ActIds, {ActId, Num, N, 1}),
                    Rs1 = role:save_delay(fest, Rs),
                    Rs1#role{activity = NewActIds};
                false ->
                    NewActIds2 = lists:keyreplace(ActId, 1, ActIds, {ActId, Num, N, St}),
                    Rs#role{activity = NewActIds2}
            end
    end.

login_friend_next_point(V, N, Rs) ->
    ActList = Rs#role.activity,
    case data_fest_prize:get({?LOGINFRIEND, N + 1}) of
        undefined ->
            NewAct = lists:keyreplace(?LOGINFRIEND, 1, ActList, {?LOGINFRIEND, V, N, 2}),
            {N, 2, Rs#role{activity = NewAct}};
        Data ->
            Cond = util:get_val(condition, Data),
            case V >= Cond of
                true ->
                    NewAct = lists:keyreplace(?LOGINFRIEND, 1, ActList, {?LOGINFRIEND, V, N + 1, 1}),
                    {N + 1, 1, Rs#role{activity = NewAct}};
                false ->
                    NewAct = lists:keyreplace(?LOGINFRIEND, 1, ActList, {?LOGINFRIEND, V, N + 1, 0}),
                    {N + 1, 0, Rs#role{activity = NewAct}}
            end
    end.

invite_next_point(V, N, Rs) ->
    ActList = Rs#role.activity,
    case data_fest_prize:get({?INVITE, N + 1}) of
        undefined ->
            NewAct = lists:keyreplace(?INVITE, 1, ActList, {?INVITE, V, N, 2}),
            {N, 2, Rs#role{activity = NewAct}};
        Data ->
            Cond = util:get_val(condition, Data),
            case V >= Cond of
                true ->
                    NewAct = lists:keyreplace(?INVITE, 1, ActList, {?INVITE, V, N + 1, 1}),
                    {N + 1, 1, Rs#role{activity = NewAct}};
                false ->
                    NewAct = lists:keyreplace(?INVITE, 1, ActList, {?INVITE, V, N + 1, 0}),
                    {N + 1, 0, Rs#role{activity = NewAct}}
            end
    end.

activity_list(List) ->
    activity_list(List, []).
activity_list([], Rt) -> Rt;
activity_list([{A,B,C,D}|Rest],Rt) ->
    ActIds = data_activity_list:get(ids),
    case lists:member(A,ActIds) of
        true ->
            activity_list(Rest,[{A,B,C,D}|Rt]);
        false ->
            activity_list(Rest, Rt)
    end.

activity_num(List) ->
    activity_num(List, []).
activity_num([], Rt) -> Rt;
activity_num([{A,B,C,D}|Rest],Rt) ->
    ActIds = data_activity_num:get(ids),
    case lists:member(A,ActIds) of
        true ->
            activity_num(Rest,[{A,B,C,D}|Rt]);
        false ->
            activity_num(Rest, Rt)
    end.

keyborband(S,St,Type) ->
    Num = case Type of
        1 -> 1;
        2 -> 2;
        %% 3 -> 4;
        %% 4 -> 8;
        %% 5 -> 16;
        %% 6 -> 32;
        %% 7 -> 64;
        %% 8 -> 128;
        N when N =/=0 andalso N < 30 -> erlang:trunc(math:pow(2, (Type - 1)));
        _ -> 0
    end,
    case S of
        1 ->
            St band Num;
        2 ->
            St bor Num;
        _ -> 0
    end.



%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
