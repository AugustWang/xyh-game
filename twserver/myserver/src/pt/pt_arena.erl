%%----------------------------------------------------
%% $Id: pt_arena.erl 12953 2014-05-22 09:32:28Z piaohua $
%% @doc 协议23 - 竞技场
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_arena).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_convert_test() ->
    Ids = data_convert:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_convert:get(Id),
                ?assertMatch(ok,case Id < ?MIN_EQU_ID of
                        true ->
                            ?assert(data_prop:get(Id) =/= undefined),
                            ok;
                        false ->
                            ?assert(data_equ:get(Id) =/= undefined),
                            ok
                    end),
                ?assert(util:get_val(price, Data, 0) > 0)
        end, Ids),
    ok.
-endif.

%% 竞技场创建名字
handle(23001, [Name, Picture], Rs) ->
    %% ?DEBUG("Name:~s, Picture:~w~n", [Name, Picture]),
    Sql = list_to_binary([<<"SELECT count(*) FROM `arena` WHERE name = '">>, Name, <<"';">>]),
    case Rs#role.tollgate_id >= data_config:get(arenaGuide) of
        true ->
            case db:get_one(Sql) of
                {ok, 0} ->
                    Rid = Rs#role.id,
                    ArenaHeroes = mod_arena:fix_arena_pos(Rs#role.heroes),
                    Power = mod_hero:calc_power(ArenaHeroes),
                    HeroesBin = mod_arena:zip_heroes(ArenaHeroes),
                    %% ?DEBUG("HeroesBin:~w", [HeroesBin]),
                    Sql1 = "UPDATE `role` SET `name` = ~s WHERE `id` = ~s;",
                    Sql2 = "INSERT arena(`robot` , `rid` , `lev` , `exp`, `power`, `picture`, `name`, `s`"
                    ") VALUES (0, ~s, 1, 0, ~s, ~s, ~s, ~s);",
                    Rt1 = db:execute(Sql1, [Name, Rid]),
                    Rt2 = db:execute(Sql2, [Rid, Power, Picture, Name, HeroesBin]),
                    case {Rt1, Rt2} of
                        {{ok, 1}, {ok, 1}} ->
                            Rs1 = Rs#role{name = Name},
                            Rs2 = mod_attain:attain_state(17,1,Rs1),
                            case mod_arena:db_init(Rs2) of
                                {ok, Rs3} -> {ok, [0], Rs3};
                                {error, Reason} ->
                                    ?WARN("Arena db_init error:~w", [Reason]),
                                    {ok, [128]}
                            end;
                        Else ->
                            ?WARN("Arena Reg:~w", [Else]),
                            {ok, [127]}
                    end;
                {ok, 1} -> {ok, [1]};
                {error, Reason} ->
                    ?WARN("Arena Reg:~w", [Reason]),
                    {ok, [1]}
            end;
        false -> {ok, [2]}
    end;

%% 竞技场信息
handle(23004, [], Rs) ->
    #role{arena_rank=Rank, arena_exp=Exp, arena_honor=Honor, arena_lev=Level} = Rs,
    {ok, [Rank, Exp, Honor, Level]};

%% 竞技场挑战(对手基本信息)
handle(23015, [], Rs) ->
    %% ?DEBUG("arena:~w", [Rs#role.arena]),
    #role{arena_wars = Combats, arena_chance = BuyChances,
        arena_combat_box1 = Team1, arena_combat_box2 = Team2} = Rs,
    T = util:unixtime() - Rs#role.arena_time,
    Time = case Rs#role.arena_time == 0 of
        true -> 40*60;
        false ->
            case T > 40*60 of
                true -> 0;
                false -> 40*60 - T
            end
    end,
    case Rs#role.arena == [] of
        true ->
            Ids = mod_arena:get_team1(Rs#role.arena_id) ++ mod_arena:get_team2(Rs#role.arena_id),
            IdsData = [[Id, Name, Picture, 0] || [Id, Name, Picture] <- Ids, Id > 0],
            Rs1 = Rs#role{arena_time = util:unixtime(), arena = IdsData},
            %% ?DEBUG("Id: ~w, IdsData: ~w Ids:~w", [Rs#role.id, IdsData, Ids]),
            Rs2 = role:save_delay(arena, Rs1),
            {ok, [Combats, Time, BuyChances, Team1, Team2, IdsData], Rs2};
        false ->
            {ok, [Combats, Time, BuyChances, Team1, Team2, Rs#role.arena], Rs}
    end;

%% 竞技场兑换
handle(23012, [Id], Rs) ->
    case data_convert:get(Id) of
        [{price, Price}] ->
            Honor = Rs#role.arena_honor - Price,
            case Honor >= 0 of
                true ->
                    case mod_item:add_item(Rs, Id, 1) of
                        {ok, Rs1, PA, EA} ->
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            Rs2 = Rs1#role{arena_honor = Honor},
                            lib_role:notice(honor, Rs2),
                            {ok, [0], Rs2#role{save = [items]}};
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id, 0, 55, Title, Body, [{Id, 1}]),
                            Rs1 = Rs#role{arena_honor = Honor},
                            lib_role:notice(honor, Rs1),
                            {ok, [3], Rs1};
                        {error, _} ->
                            {ok, [128]}
                    end;
                false ->
                    {ok, [1]}
            end;
        undefined ->
            {ok, [127]}
    end;

%% 竞技场战报
handle(23014, [], Rs) ->
    {ok, [Rs#role.arena_lost_report]};

%% 竞技场排行榜
handle(23016, [], Rs) ->
    arena ! {send_rank, Rs#role.pid_sender, Rs#role.arena_lev},
    {ok};

%% 发布悬赏挑战
handle(23017, [], Rs) ->
    Revenges = data_config:get(arena_revenge),
    case Rs#role.arena_revenge < Revenges of
        true ->
            case Rs#role.produce_pass of
                {3, _, {Id, Name2}} ->
                    Name1 = Rs#role.name,
                    %% RevNum = Rs#role.arena_revenge,
                    gen_server:cast(arena, {add_offer_report, Rs#role.pid_sender, Id, Name1, Name2}),
                    %% Rs1 = Rs#role{arena_revenge = RevNum + 1},
                    {ok};
                E ->
                    ?WARN("error arena produce_pass:", [E]),
                    {ok, [127]}
            end;
        false ->
            {ok, [1]}
    end;

%% 悬赏挑战榜
handle(23018, [], Rs) ->
    arena ! {send_offer_report, Rs#role.pid_sender, Rs#role.name},
    {ok};

%% 竞技场挑战机会次数购买
handle(23024, [], Rs) ->
    #role{arena_chance = Chances, arena_wars = ArenaNum} = Rs,
    Diamond = Chances * 15 + Chances * Chances + 5,
    case lib_role:spend(diamond, Diamond, Rs) of
        {ok, Rs1} ->
            lib_role:notice(Rs1),
            Rs2 = Rs1#role{arena_chance = Chances + 1, arena_wars = ArenaNum + 5},
            Rs0 = lib_role:spend_ok(diamond, 20, Rs, Rs2),
            {ok, [0, Chances + 1], Rs0};
        {error, _} ->
            {ok, [1, 0]}
    end;

%% 竞技场排行榜宝箱领取
handle(23028, [], Rs) ->
    case Rs#role.arena_rank_box =:= 0 of
        true ->
            Myrank = Rs#role.arena_rank,
            %% ?DEBUG("Myrank: ~w", [Myrank]),
            case Myrank =< 100 andalso Myrank >= 1 of
                true ->
                    #role{arena_lev = Lev, arena_honor = Honor} = Rs,
                    %% Gold = util:ceil((Lev + + 3)/7*6000*50/Rank),
                    %% NewHonor = util:ceil(150*(Lev + 3)/7) + Honor,
                    Gold = util:ceil((Lev + 3)/7*6000*50/(Myrank + 5)),
                    NewHonor = util:ceil(100*(Lev + 3)/7),
                    Rs1 = Rs#role{arena_honor = NewHonor + Honor, arena_rank_box = 1},
                    Rs2 = lib_role:add_attr(gold, Gold, Rs1),
                    Rs0 = lib_role:add_attr_ok(gold, 16, Rs, Rs2),
                    lib_role:notice(Rs0),
                    lib_role:notice(honor, Rs0),
                    {ok, [0, Gold, NewHonor], Rs0};
                false ->
                    {ok, [2, 0, 0]}
            end;
        false -> {ok, [1, 0, 0]}
    end;

%% 竞技场挑战宝箱
%% # 消息代码：
%% # Code:
%% # 0 = 成功
%% # 1 = 已经领取
%% # 2 = 失败(不满足领取条件)
%% # >=127 = 程序异常
handle(23029, [Type], Rs) ->
    if
        Type =:= 1 ->
            Team = lists:sublist(Rs#role.arena, 1, 4),
            TeamTuple = [list_to_tuple([A,B,C,D]) || [A,B,C,D] <- Team],
            case lists:keymember(0, 4, TeamTuple) of
                true ->
                    {ok, [2, 0, 0, 0]};
                false ->
                    case Rs#role.arena_combat_box1 of
                        0 ->
                            %% Exp = Rs#role.arena_exp + 10,
                            Honor = Rs#role.arena_honor + 100,
                            Rs1 = Rs#role{arena_honor = Honor, arena_combat_box1 = 1},
                            Rs2 = lib_role:add_attr(gold, 1500, Rs1),
                            Rs3 = lib_role:add_attr_ok(gold, 16, Rs, Rs2),
                            case Rs3#role.arena_combat_box2 of
                                1 ->
                                    Pid = lib_role:get_role_pid(role_id, Rs3#role.id),
                                    Pid ! {pt, 2038, []};
                                0 ->
                                    ok
                            end,
                            %% 统一接口加Exp
                            {_Lev1, _Exp1, Rs0} = mod_arena:add_arena_exp(10, Rs3),
                            lib_role:notice(Rs0),
                            lib_role:notice(honor, Rs0),
                            {ok, [0, 1500, 100, 10], Rs0};
                        1 ->
                            {ok, [1, 0, 0, 0]}
                    end
            end;
        Type =:= 2 ->
            Team = lists:sublist(Rs#role.arena, 5, 4),
            TeamTuple = [list_to_tuple([A,B,C,D]) || [A,B,C,D] <- Team],
            case lists:keymember(0, 4, TeamTuple) of
                true ->
                    {ok, [2, 0, 0, 0]};
                false ->
                    case Rs#role.arena_combat_box2 of
                        0 ->
                            %% Exp = Rs#role.arena_exp + 5,
                            Honor = Rs#role.arena_honor + 50,
                            Rs1 = Rs#role{arena_honor = Honor, arena_combat_box2 = 1},
                            Rs2 = lib_role:add_attr(gold, 1000, Rs1),
                            Rs3 = lib_role:add_attr_ok(gold, 16, Rs, Rs2),
                            case Rs3#role.arena_combat_box1 of
                                1 ->
                                    Pid = lib_role:get_role_pid(role_id, Rs3#role.id),
                                    Pid ! {pt, 2038, []};
                                0 ->
                                    ok
                            end,
                            {_Lev1, _Exp1, Rs0} = mod_arena:add_arena_exp(5, Rs3),
                            lib_role:notice(Rs0),
                            lib_role:notice(honor, Rs0),
                            {ok, [0, 1000, 50, 5], Rs0};
                        1 ->
                            {ok, [1, 0, 0, 0]}
                    end
            end;
        true ->
            {ok, [127, 0, 0, 0]}
    end;


%% 竞技场刷新目标
handle(23022, [], Rs) ->
    Time = util:unixtime(),
    Arena_time = Rs#role.arena_time,
    Diamond = case (Time - Arena_time) < 40*60 of
        true ->
            lib_role:time2diamond(40*60 - (Time - Arena_time));
        false -> 0
    end,
    %% ?DEBUG("Time:~w, arena_time:~w, Diamond:~w", [Time, Arena_time, Diamond]),
    case lib_role:spend(diamond, Diamond, Rs) of
        {ok, Rs1} ->
            Ids = mod_arena:get_team1(Rs1#role.arena_id) ++ mod_arena:get_team2(Rs1#role.arena_id),
            IdsData = [[Id, Name, Picture, 0] || [Id, Name, Picture] <- Ids, Id > 0],
            Rs2 = Rs1#role{arena_time = util:unixtime(), arena = IdsData, arena_combat_box1 = 0, arena_combat_box2 = 0},
            Rs0 = lib_role:spend_ok(diamond, 19, Rs, Rs2),
            lib_role:notice(Rs0),
            {ok, [0, 40*60, 0, 0, IdsData], Rs0};
        {error, _} ->
            {ok, [1, 0, 0, 0, []]}
    end;

%% 竞技场挑战对手信息
handle(23025, [Id, Type], Rs) ->
    %% ?DEBUG("ID:~w, ~w", [Id, Type]),
    #role{arena_wars = WarsNum, arena_prize = PrizeNum} = Rs,
    if
        WarsNum < 1 ->
            %% 挑战次数不足
            {ok, [1, []]};
        Type =:= 3, PrizeNum > 5 ->
            %% 揭榜次数不足
            {ok, [2, []]};
        Rs#role.arena_id =:= Id ->
            %% 不能挑自己
            {ok, [3, []]};
        true ->
            case mod_arena:get_data(Id) of
                {1, _Rid, _Lev, _Exp, _Name, S} ->
                    Heroes = mod_combat:init_monster(S),
                    Data = [[Tid, Lev, Hp, Pos, 0] || #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos} <- Heroes],
                    ?DEBUG("MON:23025:~w", [Data]),
                    Rs1 = Rs#role{produce_pass = {3, Type}},
                    {ok, [0, Data], Rs1};
                {0, _Rid, _Lev, _Exp, _Name, S} ->
                    ?DEBUG("Role  ******************  **", []),
                    Heroes = mod_arena:fix_arena_pos(S),
                    F = fun(EquGrids) ->
                            EquId = element(1, EquGrids),
                            case EquId < 99999 of
                                true -> 0;
                                false -> EquId
                            end
                    end,
                    Data = [[Tid, Lev, Hp, Pos, F(EquGrids)] ||
                        #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos, equ_grids = EquGrids}
                        <- Heroes],
                    ?DEBUG("ROLE:20025:~w", [Data]),
                    Rs1 = Rs#role{produce_pass = {3, Type}},
                    {ok, [0, Data], Rs1};
                {error, Reason} ->
                    ?WARN("23025 ERROR:~w", [Reason]),
                    {ok, [127, []]}
            end
    end;




handle(23033, [], Rs) ->
    %% 胜利：竞技积分获得公式：10＋（对方的段位级别－我对方的段位级别）
    %% 失败：竞技积分获得公式：－10＋（对方的段位级别－我对方的段位级别）
    case Rs#role.produce_pass of
        {3, Data, _} -> {ok, Data};
        E ->
            ?WARN("error arena produce_pass:~w", [E]),
            {ok, [0, 0, 0, 0]}
    end;

%% 查看英雄之家
%% handle(23035, [Id], Rs) ->
%%     Data = [mod_hero:pack_hero(X) || X <- Rs#role.heroes],
%%     {ok, [Data]};

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===
%% @doc 刷新竞技场对手信息
%% -spec refresh(Rs) -> NewRs when
%%     Rs :: #role{},
%%     NewRs :: #role{}.
%% refresh(Rs) ->
%%     Arena = Rs#role.arena,
%%     case lists:all(fun([_,_,_,X]) -> X =:= 1 end, Arena) of
%%         true ->
%%             Ids = mod_arena:get_team1(Rs#role.arena_id) ++ mod_arena:get_team2(Rs#role.arena_id),
%%             IdsData = [[Id, Name, Picture, 0] || [Id, Name, Picture] <- Ids, Id > 0],
%%             #role{arena_wars = Combats, arena_chance = BuyChances} = Rs,
%%             sender:pack_send(Rs#role.pid_sender, 23015, [Combats, 40 * 60, BuyChances, 0, 0, IdsData]),
%%             Rs#role{arena = IdsData, arena_time = util:unixtime(), arena_combat_box1 = 0, arena_combat_box2 = 0};
%%         false ->
%%             Rs
%%     end.


%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
