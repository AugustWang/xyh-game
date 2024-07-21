%%----------------------------------------------------
%% Robot handle
%%
%% @author Rolong<erlang6@qq.com>
%%----------------------------------------------------
-module(robot_handle_p).
-export([handle/3]).

-include("common.hrl").
-include("robot.hrl").

%%' 10协议_登陆认证

handle(11000, [LoginState, Growth, Rid], R) ->
    %% ?INFO("11001:~w", [[LoginState, Growth, Rid]]),
    case LoginState of
        10 ->
            %% 注册成功，正常登陆
            io:format("1"),
            robot ! {login_ok, R#robot.aid, Rid, self()},
            R#robot.pid_sender ! {cmd, 11003, []},
            R#robot.pid_sender ! {cmd, 25002, []},
            R#robot{id = Rid, pid = self()};
        20 ->
            %% 正常登陆
            io:format("2"),
            robot ! {login_ok, R#robot.aid, Rid, self()},
            R#robot.pid_sender ! {cmd, 11003, []},
            R#robot.pid_sender ! {cmd, 25002, []},
            R#robot{id = Rid, pid = self()};
        22 ->
            %% 帐号不存在，进行注册
            %% 创建角色
            %% Sex = util:rand(1, 2),
            %% SexS = case Sex of
            %%     1 -> <<"男">>;
            %%     2 -> <<"女">>;
            %%     _ -> <<"未知">>
            %% end,
            %% Name = list_to_binary([?AID_PREFIX, integer_to_list(R#robot.aid)]),
            %% ?INFO("Reg:~s - ~s", [SexS, Name]),
            %% R#robot.pid_sender ! {cmd, 11002, [Name, Sex]},
            %% R#robot{sex = Sex, name = Name};
            %% 创建角色
            AidB = list_to_binary([?AID_PREFIX, integer_to_list(R#robot.aid)]),
            Key = "23d7f859778d2093",
            Rand = util:rand(0, 255),
            Signature = util:md5(list_to_binary([
                        "1"
                        ,integer_to_list(Rand)
                        ,Key
                        ,AidB
                    ])),
            %% Server = env:get(server_id),
            Platform = <<"ios">>,
            R#robot.pid_sender ! {cmd, 11000, [1, Rand, 1, Platform, AidB, AidB, Signature]},
            ?DEBUG("[REG] Rid:~w AccId:~s", [Rid, AidB]),
            %% R#robot.pid_sender ! {cmd, 11002, [<<>>, 0]},
            R#robot.pid_sender ! {cmd, 11003, []},
            R#robot.pid_sender ! {cmd, 25002, []},
            R#robot{sex = 0, name = <<>>};
        _ ->
            io:format("login failure! ~w~n", [[LoginState, Growth, Rid]]),
            R
    end;
%%.

%%' login protocol
%% handle(11001, [LoginState, Growth, Rid], R) ->
%%     ?INFO("11001:~w", [[LoginState, Growth, Rid]]),
%%     case LoginState of
%%         0 ->
%%             case Growth of
%%                 0 ->
%%                     %% 创建角色
%%                     %% Sex = util:rand(1, 2),
%%                     %% SexS = case Sex of
%%                     %%     1 -> <<"男">>;
%%                     %%     2 -> <<"女">>;
%%                     %%     _ -> <<"未知">>
%%                     %% end,
%%                     %% Name = list_to_binary([?AID_PREFIX, integer_to_list(R#robot.aid)]),
%%                     %% ?INFO("Reg:~s - ~s", [SexS, Name]),
%%                     %% R#robot.pid_sender ! {cmd, 11002, [Name, Sex]},
%%                     %% R#robot{sex = Sex, name = Name};
%%                     %% 创建角色
%%                     Name = list_to_binary([?AID_PREFIX, integer_to_list(R#robot.aid)]),
%%                     ?DEBUG("[REG] Rid:~w AccId:~s", [Rid, Name]),
%%                     R#robot.pid_sender ! {cmd, 11002, [<<>>, 0]},
%%                     R#robot{sex = 0, name = <<>>};
%%                 _ ->
%%                     %% 正常登陆
%%                     io:format("+"),
%%                     robot ! {login_ok, R#robot.aid, Rid, self()},
%%                     %% 赠送英雄
%%                     R#robot.pid_sender ! {cmd, 14023, [30005]},
%%                     %% 请求基础数据
%%                     R#robot.pid_sender ! {cmd, 11003, []},
%%                     %% 请求玩家所有英雄
%%                     R#robot.pid_sender ! {cmd, 14002, []},
%%                     R#robot{id = Rid, pid = self()}
%%             end;
%%         1 ->
%%             io:format("login failure! ~w~n", [[LoginState, Growth, Rid]]),
%%             R
%%     end;
%%.

%% handle(11002, [0], _R) ->
%%     ?INFO("Create ok!"),
%%     %% 创建角色成功
%%     ok;

%% handle(11002, [1], _R) ->
%%     ?INFO("Please rename!"),
%%     ok;

handle(11027, [Code,Power,Num], _R) ->
    ?INFO("buy power Code:~w,Power:~w,Num:~w",[Code,Power,Num]),
    ok;

%% 钻石
%% 金币
%% 关卡ID
%% 疲劳
%% 装备背包格子数
%% 道具背包格子数
%% 材料背包格子数
%% 竞技场名字
%% 竞技场头像id
handle(11003, [Diamond, Gold, Gid, Power
        ,BagEqu, BagProp, BagMat, Name
        ,Pic, LuckNum, Horn, _ChatTime
        ,TollgatePrize, Verify, _Rank
        ,_HeroTab, _VipLev, _Fp], R) ->
    %% ?INFO("===*=== Diamond:~w, Gold:~w ===*===", [Diamond, Gold]),
    Aid = list_to_binary([?AID_PREFIX, integer_to_list(R#robot.aid)]),
    case Diamond < 500 of
        true ->
            timer:apply_after(100,
                lib_admin, add_diamond, [R#robot.id, 500000]);
        false ->
            ok
    end,
    case Gold < 20000 of
        true ->
            timer:apply_after(100,
                lib_admin, add_gold, [R#robot.id, 1000000]);
        false ->
            ok
    end,
    case Gid < 50 of
        true ->
            timer:apply_after(100,
                lib_admin, set_tollgate, [R#robot.id, 260]);
        false ->
            ok
    end,
    case Name of
        <<>> ->
            %% 名字为空，则去竞技场注册
            NewPic = util:rand(1, 8),
            erlang:send_after(util:rand(1000, 3000),
                R#robot.pid_sender, {cmd, 33001, [Aid, NewPic]}),
            ok;
        _ ->
            ok
    end,
    %% bag opne
    lists:foreach(fun(X) ->
                R#robot.pid_sender ! {cmd, 13027, [1, X, 5]}
        end, lists:seq(3,15)),
    lists:foreach(fun(X) ->
                R#robot.pid_sender ! {cmd, 13027, [1, X, 2]}
        end, lists:seq(3,15)),
    lists:foreach(fun(X) ->
                R#robot.pid_sender ! {cmd, 13027, [1, X, 1]}
        end, lists:seq(3,15)),
    %% 赠送英雄
    timer:apply_after(100,
        lib_admin, add_hero, [R#robot.id, 30016]),
    timer:apply_after(100,
        lib_admin, add_hero, [R#robot.id, 30017]),
    timer:apply_after(100,
        lib_admin, add_hero, [R#robot.id, 30019]),
    timer:apply_after(100,
        lib_admin, add_hero, [R#robot.id, 30020]),
    timer:apply_after(100,
        lib_admin, add_heroes_exp, [R#robot.id, 5000000]),
    timer:apply_after(100,
        lib_admin, add_item, [R#robot.id, 999999, 1]),
    timer:apply_after(3000,
        lib_admin, add_item, [R#robot.id, 15001, 50]),
    timer:apply_after(3000,
        lib_admin, add_item, [R#robot.id, 15002, 50]),
    timer:apply_after(3000,
        lib_admin, add_item, [R#robot.id, 15003, 50]),
    timer:apply_after(100,
        lib_admin, add_power, [R#robot.id, 1000]),
    R#robot{
        gold            = Gold
        ,diamond        = Diamond
        ,bag_equ_max    = BagEqu
        ,bag_prop_max   = BagProp
        ,bag_mat_max    = BagMat
        ,power          = Power
        ,tollgateid     = Gid
        ,name           = Name
        ,picture        = Pic
        ,luck           = {LuckNum, 0, 0, 0}
        ,horn           = Horn
        ,tollgate_prize = TollgatePrize
        ,verify         = Verify
    };

%% 测试物品
handle(13001, [1, Equs, Props], R) ->
    R#robot.pid_sender ! {cmd, 13001, [2]},
    %% EquIds = util:rand_element(3, [Id || [Id|_] <- Equs]),
    %% GemIds = util:rand_element(3, [Id || [Id|_] <- Props]),
    EquIds = util:rand_element(3, get_equids(Equs, [])),
    GemIds = util:rand_element(3, get_gemids(Props, [])),
    JewIds = util:rand_element(3, get_jewids(Props, [])),
    ShopIds = util:rand_element(3, data_shop:get(ids)),
    %% ?INFO("EquIds:~w", [EquIds]),
    lists:foreach(fun(GemId) ->
                lists:foreach(fun(Id)->
                            %% ?INFO("strengthen:~w", [Id]),
                            %% Pay = util:rand(0, 1),
                            Pay = 1,
                            R#robot.pid_sender ! {cmd, 13005, [Id, GemId, 0, 0, Pay]}
                    end, EquIds)
        end, GemIds),
    lists:foreach(fun(JewId)->
                lists:foreach(fun(EquId)->
                            R#robot.pid_sender ! {cmd, 13010, [EquId, JewId]}
                    end, EquIds)
        end, JewIds),
    %% 购买商品
    lists:foreach(fun(ShopId)->
                R#robot.pid_sender ! {cmd, 13021, [ShopId]}
        end, ShopIds),
    %% 签到
    R#robot.pid_sender ! {cmd, 13052, []},
    R#robot.pid_sender ! {cmd, 13056, [1]},
    ok;

handle(13003, Data, _R) ->
    ?INFO("[set equ 13003] ~w", [Data]),
    ok;

handle(13005, [Code, Id, Lev, Time], _R) ->
    ?INFO("[Code:~w, Id:~w, Lev:~w, Time:~w]", [Code, Id, Lev, Time]),
    ok;

handle(13010, Data, _R) ->
    ?INFO("[13010] ~w", [Data]),
    ok;

handle(13021, Data, _R) ->
    ?INFO("[shop] ~w", [Data]),
    ok;

handle(13027, Data, _R) ->
    ?INFO("[open bag 13027] ~w", [Data]),
    ok;

handle(13028, Data, _R) ->
    ?INFO("[sell item 13028] ~w", [Data]),
    ok;

handle(14001, _Data, R) ->
    %% ?INFO("[set_pos] ~w", [Data]),
    ?DEBUG("布阵OK，请求进入主线战斗", []),
    R#robot.pid_sender ! {cmd, 22002, [1, 1, 0]},
    ok;

handle(14002, [Heroes], R) ->
    ?DEBUG("收到所有英雄", []),
    Heroes1 = util:rand_element(5, Heroes),
    %% ?INFO("~w", [Heroes]),
    %% 净化
    lists:foreach(fun([Id | _]) ->
                          %% ?INFO("Purge Hero Id: ~w", [Id]),
                          R#robot.pid_sender ! {cmd, 14010, [Id]}
                  end, Heroes1),
    %% 装备
    lists:foreach(fun([Id|_]) ->
                lists:foreach(fun(X) ->
                            R#robot.pid_sender ! {cmd, 13003, [[[Id, 1, X]]]}
                    end, lists:seq(1,30))
        end, Heroes1),
    %% 布阵
    SetPosF = fun(I, {[[Id | _] | HT], Rt}) ->
            {ok, {HT, [[Id, I] | Rt]}}
    end,
    {ok, {_, Poses}} = util:for(11, length(Heroes1)+10, SetPosF, {Heroes1, []}),
    ?DEBUG("布阵:~w", [Poses]),
    R#robot.pid_sender ! {cmd, 14001, [Poses]},
    case Heroes of
        [[Hid | _] | _] ->
            R#robot.pid_sender ! {cmd, 14034, [Hid]};
        _ -> ok
    end,
    ForgeIds = util:rand_element(3, data_forge:get(ids)),
    lists:foreach(fun(Id)->
                R#robot.pid_sender ! {cmd, 13012, [[[Id]]]}
        end, ForgeIds),
    %% 请求英雄酒馆
    %% TavernHeroIds = util:rand_element(3, data_tavern:get(ids)),
    TavernHeroIds = lists:duplicate(10, 1),
    lists:foreach(fun(Id)->
                R#robot.pid_sender ! {cmd, 14020, [Id]}
        end, TavernHeroIds),
    ok;

handle(14020, _Data, _R) ->
    %% ?INFO("[14020] ~w", [_Data]),
    %% R#robot.pid_sender ! {cmd, 14022, [1]},
    ok;

handle(14022, Data, _R) ->
    ?INFO("[14022] ~w", [Data]),
    ok;

%% handle(22002, [0, 0, 0, 0, [], [], [], [], []], _R) ->
%%     ok;

handle(22002, [Power|_], R) ->
    Time = case Power > 10 of
        true -> util:rand(60, 180) * 1000;
        false -> util:rand(2800, 3600) * 1000
    end,
    %% case Power < 10 of
    %%     true ->
    %%         erlang:send_after(Time, R#robot.pid_sender , {cmd, 11027, []});
    %%     false -> ok
    %% end,
    case Power < 10 of
        true ->
            erlang:send_after(util:rand(360,1200) * 1000, self(), stop),
            timer:apply_after(Time,
                lib_admin, add_power, [R#robot.id, 1000]);
        false ->
            Type = util:rand_element([1,2,5]),
            Gate = case Type of
                1 -> util:rand(1,250);
                2 -> util:rand(1001,1026);
                5 -> util:rand(20001,20088)
            end,
            erlang:send_after(1000, R#robot.pid_sender, {cmd, 22002, [Type, Gate, 2]})
    end,
    %% lists:foreach(fun(Id) ->
    %%             erlang:send_after(Time, R#robot.pid_sender, {cmd, 22002, [1, Id, 2]})
    %%     end, lists:seq(1,250)),
    %% lists:foreach(fun(Id) ->
    %%             erlang:send_after(Time, R#robot.pid_sender, {cmd, 22002, [5, Id, 2]})
    %%     end, lists:seq(20001,20088)),
    %% lists:foreach(fun(Id) ->
    %%             erlang:send_after(Time, R#robot.pid_sender, {cmd, 22002, [2, Id, 2]})
    %%     end, lists:seq(1001,1026)),
    %% lists:foreach(fun(Id) ->
    %%             List = util:rand_element(20,lists:seq(1,1000)),
    %%             erlang:send_after(Time, R#robot.pid_sender, {cmd, 13028, [Id, List]})
    %%     end, [1,2,5]),
    %% erlang:send_after(util:rand(360,1200) * 1000, self(), stop),
    ok;

handle(25002, _Data, R) ->
    R#robot.pid_sender ! {cmd, 25030, []},
    R#robot.pid_sender ! {cmd, 25031, []},
    R#robot.pid_sender ! {cmd, 25032, []},
    R#robot.pid_sender ! {cmd, 25033, []},
    lists:foreach(fun(Id) ->
                R#robot.pid_sender ! {cmd, 29010, [Id]}
        end, lists:seq(1,4)),
    %% 宝珠抽取
    lists:foreach(fun(Id)->
                R#robot.pid_sender ! {cmd, 13022, [Id]}
        end, [1,2,3,4,5]),
    R#robot.pid_sender ! {cmd, 33037, []},
    %% 请求玩家所有英雄
    R#robot.pid_sender ! {cmd, 14002, []},
    ok;

handle(Cmd, Data, _R) ->
    ShowCmdList = [
        1
        %% ,14020
        %% ,14022
        %% ,13022
        %% ,13024
        %% ,22002 %% 战斗
    ],
    case lists:member(Cmd, ShowCmdList) of
        true -> io:format("Recv [Cmd:~w Data:~w]~n", [Cmd, Data]);
        false -> ok
    end.

get_equids([], Rt) -> Rt;
get_equids([[Id, _Pos, Tid, _, _Atk, _hp, _Agi, _Lev | _] | Items], Rt) ->
    Sort = itemtid2sort(Tid),
    case lists:member(Sort, lists:seq(1,21)) of
        true -> get_equids(Items, [Id | Rt]);
        false -> get_equids(Items, Rt)
    end.

get_jewids([], Rt) -> Rt;
get_jewids([[Id, Tid | _] | Items], Rt) ->
    Sort = itemtid2sort(Tid),
    case lists:member(Sort, [4]) of
        true -> get_jewids(Items, [Id | Rt]);
        false -> get_jewids(Items, Rt)
    end.

get_gemids([], Rt) -> Rt;
get_gemids([[Id, Tid | _] | Items], Rt) ->
    Sort = itemtid2sort(Tid),
    case lists:member(Sort, [1]) of
        true -> get_gemids(Items, [Id | Rt]);
        false -> get_gemids(Items, Rt)
    end.

itemtid2sort(Tid) ->
    Item = case data_equ:get(Tid) of
        undefined ->
            data_prop:get(Tid);
        T -> T
    end,
    util:get_val(sort, Item, 0).

%%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
