%%----------------------------------------------------
%% $Id: pt_coliseum.erl 13256 2014-06-18 05:40:49Z rolong $
%% @doc 协议33 - 新版竞技场
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_coliseum).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_coliseum_test() ->
    Ids = data_coliseum:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_coliseum:get(Id),
                Num = util:get_val(num,Data,0),
                Down = util:get_val(down,Data,0),
                Show = util:get_val(show,Data,0),
                Produce = util:get_val(produce,Data,undefined),
                ?assert(Num > 0),
                ?assert(case Id == 6 of
                        true -> Down == 0;
                        false -> Down > 0
                    end),
                ?assert(Show > 0),
                ?assert(Produce =/= undefined)
        end, Ids),
    ok.
-endif.


%% 竞技场创建名字
handle(33001, [Name, Picture], Rs) ->
    %% ?DEBUG("Name:~s, Picture:~w~n", [Name, Picture]),
    Sql = list_to_binary([<<"SELECT count(*) FROM `arena` WHERE name = '">>, Name, <<"';">>]),
    %% case Rs#role.tollgate_id >= data_config:get(arenaGuide) of
    case Rs#role.tollgate_newid >= data_config:get(arenaGuide) of
        true ->
            case db:get_one(Sql) of
                {ok, 0} ->
                    Rid = Rs#role.id,
                    ArenaHeroes = mod_colosseum:fix_coliseum_pos(Rs#role.heroes),
                    Power = mod_hero:calc_power(ArenaHeroes),
                    HeroesBin = mod_colosseum:zip_heroes(ArenaHeroes),
                    %% ?DEBUG("HeroesBin:~w", [HeroesBin]),
                    Sql1 = "UPDATE `role` SET `name` = ~s WHERE `id` = ~s;",
                    Sql2 = "INSERT arena(`robot` , `rid` , `newexp`, `power`, `picture`, `name`, `s`"
                    ") VALUES (0, ~s, 0, ~s, ~s, ~s, ~s);",
                    Rt1 = db:execute(Sql1, [Name, Rid]),
                    Rt2 = db:execute(Sql2, [Rid, Power, Picture, Name, HeroesBin]),
                    case {Rt1, Rt2} of
                        {{ok, 1}, {ok, 1}} ->
                            Rs1 = Rs#role{name = Name},
                            Rs2 = mod_attain:attain_state(17,1,Rs1),
                            case mod_colosseum:init_coliseum(Rs2) of
                                {ok, Rs3} ->
                                    case Rs3#role.coliseum == [] of
                                        true -> {ok, [129]};
                                        false ->
                                            #role{coliseum = [Id,_Lev1,_Exp1,_Pic1,_Num1,_HighR,_PrizeT,_Report1]} = Rs3,
                                            %% ?INFO("-==coliseum:~w", [Rs3#role.coliseum]),
                                            gen_server:cast(coliseum, {set_coliseum_rank,self(),Id,Rid,Name,Picture,Power}),
                                            {ok, [0], Rs3}
                                    end;
                                {error, Reason} ->
                                    ?WARN("Coliseum db_init error:~w", [Reason]),
                                    {ok, [128]}
                            end;
                        Else ->
                            ?WARN("Coliseum Reg:~w", [Else]),
                            {ok, [127]}
                    end;
                {ok, 1} -> {ok, [1]};
                {error, Reason} ->
                    ?WARN("Coliseum Reg:~w", [Reason]),
                    {ok, [1]}
            end;
        false -> {ok, [2]}
    end;

%% 领取荣誉值
%% handle(33010, [], Rs) ->
%%     case Rs#role.coliseum of
%%         [] -> {ok, [127]};
%%         [Id,_Lev,_Exp,_Pic,_Num,_HighRank,Time,_Report] ->
%%             TimeNow = util:unixtime(),
%%             TimeNine = util:unixtime(today) + 21 * 3600,
%%             case Time < TimeNine andalso TimeNow > TimeNine of
%%                 true ->
%%                     coliseum ! {add_exp, self(), Rs#role.pid_sender, Id};
%%                 false ->
%%                     {ok, [1]}
%%             end
%%     end;

%% 竞技场兑换
handle(33012, [Id], Rs) ->
    %% ?INFO("==Id:~w", [Id]),
    #role{coliseum = Coliseum} = Rs,
    case Coliseum == [] of
        true -> {ok, [129]};
        false ->
            [Id1,Lev1,Exp1,Pic1,Num1,HighR1,PrizeT1,Report1] = Coliseum,
            case data_new_convert:get(Id) of
                [{price, Price}, {newlev, NewLev}] ->
                    Honor = Exp1 - Price,
                    ?DEBUG("Id:~w, Honor:~w, Lev1:~w, NewLev:~w", [Id, Honor, Lev1, NewLev]),
                    case Honor >= 0 andalso Lev1 =< NewLev of
                        true ->
                            case mod_item:add_item(Rs, Id, 1) of
                                {ok, Rs1, PA, EA} ->
                                    mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                                    Rs2 = Rs1#role{coliseum = [Id1,Lev1,Honor,Pic1,Num1,HighR1,PrizeT1,Report1]},
                                    lib_role:notice(honor, Rs2),
                                    ?LOG({honor, Rs#role.id, Id, Exp1, Honor}),
                                    {ok, [0], Rs2#role{save = [items, coliseum]}};
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 55, Title, Body, [{Id, 1}]),
                                    Rs1 = Rs#role{coliseum = [Id1,Lev1,Honor,Pic1,Num1,HighR1,PrizeT1,Report1]},
                                    lib_role:notice(honor, Rs1),
                                    ?LOG({honor, Rs#role.id, Id, Exp1, Honor}),
                                    {ok, [3], Rs1#role{save = [coliseum]}};
                                {error, _} ->
                                    {ok, [128]}
                            end;
                        false ->
                            {ok, [1]}
                    end;
                undefined ->
                    {ok, [127]}
            end
    end;

%% 竞技场战报
handle(33014, [], Rs) ->
    #role{coliseum = Coliseum} = Rs,
    case Coliseum == [] of
        true -> {ok, [[]]};
        false ->
            [Id1,Lev1,Exp1,Pic1,Num1,HighR1,PrizeT1,Report1] = Coliseum,
            F1 = fun({A,B,C}) ->
                    case (util:unixtime() - C) < 86400 of
                        true -> [A,B];
                        false -> []
                    end
            end,
            F2 = fun({A,B,C}) ->
                    case (util:unixtime() - C) < 86400 of
                        true -> {A,B,C};
                        false -> []
                    end
            end,
            Report2 = [F1(L) || L <- Report1, F1(L) =/= []],
            Report3 = [F2(L) || L <- Report1, F2(L) =/= []],
            {ok, [Report2], Rs#role{coliseum = [Id1,Lev1,Exp1,Pic1,Num1,HighR1,PrizeT1,Report3]}}
    end;

%% 竞技场挑战机会次数购买
handle(33024, [], Rs) ->
    %% #role{arena_chance = Chances, arena_wars = ArenaNum} = Rs,
    #role{arena_chance = Chances, coliseum = Coliseum} = Rs,
    case Coliseum == [] of
        true -> {ok, [127, 0, 0]};
        false ->
            [Id1,Lev1,Exp1,Pic1,Num1,HighR1,PrizeT1,Report1] = Coliseum,
            %% Diamond = Chances * 15 + Chances * Chances + 5,
            Diamond = util:ceil(data_fun:coliseum_buys(Chances)),
            case mod_vip:vip_privilege_check(buys2, Rs) of
                true ->
                    case lib_role:spend(diamond, Diamond, Rs) of
                        {ok, Rs1} ->
                            Buys = data_config:get(arenaBuy),
                            Coliseum2 = [Id1,Lev1,Exp1,Pic1,Num1+Buys,HighR1,PrizeT1,Report1],
                            Rs2 = lib_role:spend_ok(diamond, 20, Rs, Rs1),
                            lib_role:notice(diamond, Rs2),
                            %% Rs0 = mod_vip:set_vip(buys2, 1, util:unixtime(), Rs2),
                            Rs0 = mod_vip:set_vip2(buys2, Chances + 1, util:unixtime(), Rs2),
                            {ok, [0, Chances + 1, Num1 + Buys], Rs0#role{arena_chance = Chances + 1, coliseum = Coliseum2, save = [vip]}};
                        {error, _} ->
                            {ok, [1, 0, 0]}
                    end;
                false -> {ok, [4, 0, 0]}
            end
    end;

handle(33025, [Id, Type, Index], Rs) ->
    #role{coliseum = Coliseum} = Rs,
    case Coliseum == [] of
        true -> {ok, [128, 0, []]};
        false ->
            [Id1,_Lev1,_Exp1,_Pic1,Num1,_HighR1,_PrizeT1,_Report1] = Coliseum,
            PidSender = Rs#role.pid_sender,
            if
                Num1 < 1 andalso Type =/= 2 -> {ok, [1, Id, []]};
                Id =:= Id1 -> {ok, [2, Id, []]};
                Type =/= 2 ->
                    coliseum ! {is_combat,Id,Id1,PidSender,Type,Index,self()},
                    {ok};
                true ->
                    case mod_colosseum:get_data(Id) of
                        {2, Rid, _Lev, _Exp, _Name, _S} ->
                            Heroes = mod_colosseum:init_new_robot(Rid),
                            Data = [[Tid, Lev, Hp, Pos, 0] || #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos} <- Heroes],
                            ?DEBUG("MON:33025:~w", [Data]),
                            Rs1 = Rs#role{produce_pass = {3, Type}},
                            {ok, [0, Id, Data], Rs1};
                        {1, _Rid, _Lev, _Exp, _Name, S} ->
                            Heroes = mod_combat:init_monster(S),
                            Data = [[Tid, Lev, Hp, Pos, 0] || #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos} <- Heroes],
                            ?DEBUG("MON:33025:~w", [Data]),
                            Rs1 = Rs#role{produce_pass = {3, Type}},
                            {ok, [0, Id, Data], Rs1};
                        {0, _Rid, _Lev, _Exp, _Name, S} ->
                            ?DEBUG("Role  ******************  **", []),
                            Heroes = mod_colosseum:fix_coliseum_pos(S),
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
                            ?DEBUG("ROLE:33025:~w", [Data]),
                            Rs1 = Rs#role{produce_pass = {3, Type}},
                            {ok, [0, Id, Data], Rs1};
                        {error, Reason} ->
                            ?WARN("33025 ERROR:~w", [Reason]),
                            {ok, [127, Id, []]}
                    end
            end
    end;

%% 查看英雄(机器人不可查看英雄之家,前端做限制)
handle(33035, [Id], Rs) ->
    case lib_role:get_role_pid(role_id, Id) of
        false -> {ok, []};
        Pid ->
            case Pid =:= self() of
                true ->
                    Data1 = mod_hero:get_see_heroes(Rs#role.heroes, Rs#role.items),
                    Data2 = [mod_hero:pack_hero(X) || X <- Data1],
                    Data3 = get_hero_equ_tid(Data2, Rs#role.items),
                    {ok, [Data3]};
                false ->
                    case catch gen_server:call(Pid, get_state) of
                        {ok, Rs2} ->
                            %% Heroes1 = [mod_hero:pack_hero(X) || X <- Rs2#role.heroes],
                            Heroes1 = mod_hero:get_see_heroes(Rs2#role.heroes, Rs2#role.items),
                            Heroes2 = [mod_hero:pack_hero(X) || X <- Heroes1],
                            Heroes3 = get_hero_equ_tid(Heroes2, Rs2#role.items),
                            {ok, [Heroes3]};
                        {'EXIT', Reason} ->
                            ?WARN("call pid_sender error: ~w", [Reason]),
                            {ok, []}
                    end
            end
    end;

%% 请求排行榜数据
handle(33037, [], Rs) ->
    #role{pid_sender = PidSender, coliseum = Coliseum
        ,arena_chance = Chances} = Rs,
    case Coliseum == [] of
        true -> {ok, [0, 0, 0, 0, 0, 0, []]};
        false ->
            T = util:unixtime(today) + 75600 - util:unixtime(),
            Time = case T > 0 of
                true -> T;
                false -> 86400 - abs(T)
            end,
            [Id,_,Exp,Pic,Num,_,_,_] = Coliseum,
            MyRank = [Id,Rs#role.id,Rs#role.name,Pic,Rs#role.combat],
            coliseum ! {get_coliseum_rank,self(),PidSender,Id,Exp,Num,Chances,Time,MyRank},
            {ok}
    end;

%%' 竞技场挑战对手信息stop using
%% handle(33025, [Id, Type], Rs) ->
%%     %% ?DEBUG("ID:~w, ~w", [Id, Type]),
%%     %% #role{arena_wars = WarsNum, arena_prize = PrizeNum} = Rs,
%%     #role{coliseum = Coliseum} = Rs,
%%     case Coliseum == [] of
%%         true -> {ok, [128, Id, []]};
%%         false ->
%%             [Id1, Lev1, _Exp1, _Pic1, Num1, _Report1] = Coliseum,
%%             MyIndex = mod_coliseum:get_rank_pos(Id1, Lev1),
%%             UsIndex = mod_coliseum:get_rank_pos(Id, Lev1),
%%             ?DEBUG("==MyIndex:~w, UsIndex:~w", [MyIndex, UsIndex]),
%%             %% IsCombat = catch gen_server:call(coliseum, {is_combat, Lev1, MyIndex}),
%%             if
%%                 Num1 < 1 ->
%%                     %% 挑战次数不足
%%                     {ok, [1, Id, []]};
%%                 %% Type =:= 3, PrizeNum > 5 ->
%%                 %%     %% 揭榜次数不足
%%                 %%     {ok, [2, Id, []]};
%%                 Id =:= Id1 ->
%%                     %% 不能挑自己
%%                     {ok, [3, Id, []]};
%%                 MyIndex < UsIndex andalso Type =/= 2 ->
%%                     %% 不能挑战低段位玩家
%%                     {ok, [4, Id, []]};
%%                 UsIndex =< 10 andalso IsCombat == false andalso Type =/= 2 ->
%%                     %% 就是不能挑战
%%                     {ok, [5, Id, []]};
%%                 true ->
%%                     case mod_coliseum:get_data(Id) of
%%                         {1, _Rid, _Lev, _Exp, _Name, S} ->
%%                             Heroes = mod_combat:init_monster(S),
%%                             Data = [[Tid, Lev, Hp, Pos, 0] || #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos} <- Heroes],
%%                             ?DEBUG("MON:33025:~w", [Data]),
%%                             Rs1 = Rs#role{produce_pass = {3, Type}},
%%                             {ok, [0, Id, Data], Rs1};
%%                         {0, _Rid, _Lev, _Exp, _Name, S} ->
%%                             ?DEBUG("Role  ******************  **", []),
%%                             Heroes = mod_coliseum:fix_coliseum_pos(S),
%%                             F = fun(EquGrids) ->
%%                                     EquId = element(1, EquGrids),
%%                                     case EquId < 99999 of
%%                                         true -> 0;
%%                                         false -> EquId
%%                                     end
%%                             end,
%%                             Data = [[Tid, Lev, Hp, Pos, F(EquGrids)] ||
%%                                 #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos, equ_grids = EquGrids}
%%                                 <- Heroes],
%%                             ?DEBUG("ROLE:33025:~w", [Data]),
%%                             Rs1 = Rs#role{produce_pass = {3, Type}},
%%                             {ok, [0, Id, Data], Rs1};
%%                         {error, Reason} ->
%%                             ?WARN("33025 ERROR:~w", [Reason]),
%%                             {ok, [127, Id, []]}
%%                     end
%%             end
%%     end;
%%.

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===
get_hero_equ_tid(List, Items) ->
    get_hero_equ_tid(List, Items, []).
get_hero_equ_tid([], _Items, Rt) -> Rt;
get_hero_equ_tid([H | T], Items, Rt) ->
    {A, B} = lists:split(length(H) - 5, H),
    B2 = get_item_tid(B, Items),
    get_hero_equ_tid(T, Items, [A ++ B2 | Rt]).

get_item_tid(B, Items) ->
    get_item_tid(B, Items, []).
get_item_tid([], _Items, Rt1) ->
    %% Rt2 = lists:reverse(Rt1),
    %% lists:flatten(Rt2);
    lists:reverse(Rt1);
get_item_tid([H1 | T1], Items, Rt1) ->
    case H1 == 0 of
        true -> get_item_tid(T1, Items, [H1 | Rt1]);
        false ->
            case mod_item:get_item(H1, Items) of
                false -> get_item_tid(T1, Items, [0 | Rt1]);
                Item ->
                    get_item_tid(T1, Items, [Item#item.tid | Rt1])
            end
    end.
%% get_item_tid([], _Items, Rt1) ->
%%     Rt2 = lists:reverse(Rt1),
%%     lists:flatten(Rt2);
%% get_item_tid([H1 | T1], Items, Rt1) ->
%%     case H1 == 0 of
%%         true -> get_item_tid(T1, Items, [[H1, 0] | Rt1]);
%%         false ->
%%             case mod_item:get_item(H1, Items) of
%%                 false -> get_item_tid(T1, Items, [[0, 0] | Rt1]);
%%                 Item ->
%%                     Lev = case is_record(Item#item.attr, equ) of
%%                         true -> Item#item.attr#equ.lev;
%%                         false -> 0
%%                     end,
%%                     get_item_tid(T1, Items, [[Item#item.tid, Lev] | Rt1])
%%             end
%%     end.


%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
