%%----------------------------------------------------
%% $Id: mod_hero.erl 13274 2014-06-21 04:48:00Z rolong $
%%
%% @doc Hero
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(mod_hero).
-export([
        add_hero/2
        ,add_hero/3
        ,get_hero/2
        ,set_hero/2
        ,set_pos/2
        ,get_combat_heroes/2
        ,get_see_heroes/2
        ,db_init/1
        ,db_update/2
        ,db_insert/2
        ,db_delete/2
        ,add_hero_exp/3
        ,add_hero_exp/2
        %% ,del_hero/2
        ,init_hero/1
        ,init_hero/2
        ,init_hero/3
        ,hero_notice/2
        ,upgrade_quality/1
        ,pack_hero/1
        ,tavern_rest_time/1
        ,zip/1
        ,unzip/1
        ,calc_power/1
        ,calc_power/2
        ,calc_power1/1
        ,tavern_refresh/1
        ,db_init_tavern/1
        ,db_insert_tavern/1
        ,db_update_tavern/1
        ,add_heroes_exp/3
        ,tavern_guide/1
        ,init_pictorial/1
        ,update_pictorial/1
        ,zip_pictorial/1
        ,unzip_pictorial/1
    ]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("s.hrl").


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_hero_test() ->
    ?assert(undefined == data_hero:get(0)),
    Ids = data_hero:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_hero:get(Id),
                ?assert(util:get_val(job, Data, 0) > 0),
                ?assert(util:get_val(sort, Data, 0) > 0),
                ?assert(util:get_val(atk_type, Data, 0) > 0),
                ?assert(util:get_val(rare, Data, 0) > 0),
                ?assert(util:get_val(atk, Data, 0) > 0),
                ?assert(util:get_val(hp, Data, 0) > 0),
                ?assert(util:get_val(def, Data, 0) > 0),
                ?assert(util:get_val(pun, Data, 0) > 0),
                ?assert(util:get_val(hit, Data, 0) > 0),
                ?assert(util:get_val(dod, Data, 0) > 0),
                ?assert(util:get_val(crit, Data, 0) > 0),
                ?assert(util:get_val(crit_num, Data, 0) > 0),
                ?assert(util:get_val(crit_anti, Data, 0) > 0),
                ?assert(util:get_val(tou, Data, undefined) =/= undefined),
                ?assert(util:get_val(skill1, Data, 0) >= 0),
                ?assert(util:get_val(skill2, Data, 0) >= 0),
                ?assert(util:get_val(skill3, Data, 0) >= 0),
                %% ?assert(util:get_val(skill1, Data) /= undefined),
                %% ?assert(util:get_val(skill2, Data) /= undefined),
                %% ?assert(util:get_val(skill3, Data) /= undefined),
                Items = util:get_val(items,Data,[]),
                ?assert(Items =/= []),
                lists:foreach(fun({Id2,Num}) ->
                            ?assertMatch(ok,case Id2 < ?MIN_EQU_ID of
                                    true ->
                                        ?assert(data_prop:get(Id2) =/= undefined),
                                        ?assert(Num > 0),
                                        ok;
                                    false ->
                                        ?assert(data_equ:get(Id2) =/= undefined),
                                        ?assert(Num > 0),
                                        ok
                                end) end, Items),
                ?assert(util:get_val(foster, Data, 0) > 0)
        end, Ids),
    ok.

data_hero_rare_test() ->
    ?assert(length(data_hero_rare:get(ids)) > 0),
    Ids = data_hero_rare:get(ids),
    {_R1, R2} = data_hero_rare:get(range),
    lists:foreach(fun(Id) ->
                {_R3, R4} = Id,
                {Rate} = data_hero_rare:get(Id),
                ?assert(Rate > 0),
                ?assert(R4 =< R2)
        end, Ids),
    ok.
-endif.

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

%%' add_heroes_exp
add_heroes_exp(_CombatHeroes, 0, Heroes) ->
    {Heroes, []};
add_heroes_exp(CombatHeroes, SumExp, Heroes) ->
    add_heroes_exp1(CombatHeroes, SumExp, Heroes, []).

add_heroes_exp1([], _Exp, Heroes, Rt) -> {Heroes, Rt};
add_heroes_exp1([#hero{id = Id} | T], Exp, Heroes, Rt) ->
    Hero = mod_hero:get_hero(Id, Heroes),
    Hero1 = mod_hero:add_hero_exp(Hero, Exp),
    #hero{pos = Pos, lev = Lev, exp = Exp1} = Hero1,
    Rt1 = [[Pos, Lev, Exp1] | Rt],
    Heroes1 = mod_hero:set_hero(Hero1, Heroes),
    add_heroes_exp1(T, Exp, Heroes1, Rt1).
%%.


%%' 战斗力=INT((10000+暴击+闪避+命中+抗暴+暴击提成+防御+穿刺+韧性*2)/10000*(血量/7+攻击))

-spec calc_power(Heroes :: [#hero{}]) ->
    Power :: integer().

calc_power(Heroes) ->
    calc_power(Heroes, 0).

calc_power([H | T], Power) ->
    Power1 = calc_power1(H) + Power,
    calc_power(T, Power1);
calc_power([], Power) ->
    Power.

calc_power1(Hero) ->
    case Hero of
        #hero{
            hp        = Hp
            ,atk       = Atk
            ,def       = Def
            ,pun       = Pun
            ,hit       = Hit
            ,dod       = Dod
            ,crit = Crit
            ,crit_num  = CritNum
            ,crit_anti = CritAnit
            ,tou       = Tou
        } ->
            util:ceil((10000 + Crit + Dod + Hit + CritAnit + CritNum + Def + Pun + Tou * 2) / 10000 * (Hp / 7 + Atk));
        #s{
            hp        = Hp
            ,atk       = Atk
            ,def       = Def
            ,pun       = Pun
            ,hit       = Hit
            ,dod       = Dod
            ,crit      = Crit
            ,crit_num  = CritNum
            ,crit_anti = CritAnit
            ,tou       = Tou
        } ->
            util:ceil((10000 + Crit + Dod + Hit + CritAnit + CritNum + Def + Pun + Tou * 2) / 10000 * (Hp / 7 + Atk))
    end.
%%.

%%' 增加英雄
-spec add_hero(Rs, Tid) -> {ok, NewRs, NewHero} when
    Rs :: #role{},
    NewRs :: #role{},
    NewHero :: #hero{},
    Tid :: integer().

add_hero(Rs, Tid) ->
    #role{pictorialial = Pictorial} = Rs,
    {ok, Id, Rs1} = lib_role:get_new_id(hero, Rs),
    Hero = init_hero(Id, Tid),
    db_insert(Rs#role.id, Hero),
    %% 图鉴功能记录
    Pictorial2 = util:del_repeat_element([Tid | Pictorial]),
    Rs2 = Rs1#role{pictorialial = Pictorial2},
    Rs3 = mod_attain:attain_state2(61, length(Pictorial2), Rs2),
    Rs4 = role:save_delay(pictorial, Rs3),
    %% ?INFO("====Pictorial2:~w", [Pictorial2]),
    {ok, Rs4#role{heroes = [Hero | Rs#role.heroes]}, Hero}.

add_hero(Rs, Tid, Quality) ->
    #role{pictorialial = Pictorial} = Rs,
    {ok, Id, Rs1} = lib_role:get_new_id(hero, Rs),
    Hero = init_hero(Id, Tid, Quality),
    db_insert(Rs#role.id, Hero),
    %% 图鉴功能记录
    Pictorial2 = util:del_repeat_element([Tid | Pictorial]),
    Rs2 = Rs1#role{pictorialial = Pictorial2},
    Rs3 = mod_attain:attain_state2(61, length(Pictorial2), Rs2),
    Rs4 = role:save_delay(pictorial, Rs3),
    %% ?INFO("====Pictorial2:~w", [Pictorial2]),
    {ok, Rs4#role{heroes = [Hero | Rs#role.heroes]}, Hero}.

%%.

%% 计算酒馆刷新剩余秒数
tavern_rest_time(Rs) ->
    #role{tavern_time = TavernTime} = Rs,
    case is_integer(TavernTime) andalso TavernTime > 0 of
        true ->
            CurTime = util:unixtime(),
            Max = data_config:get(refresh_time),
            max(0, Max - (CurTime - TavernTime));
        false -> 0
    end.

pack_hero(Hero) ->
    #hero{
        id         = Id
        ,tid       = Tid
        ,hp        = Hp
        ,atk       = Atk
        ,def       = Def
        ,pun       = Pun
        ,hit       = Hit
        ,dod       = Dod
        ,crit      = Crit
        ,crit_num  = CritNum
        ,crit_anti = CritAnit
        ,tou       = Tou
        ,pos       = Pos
        ,exp       = Exp
        ,foster    = Foster
        ,lev       = Lev
        ,quality   = Quality
        ,equ_grids = {Pos1, Pos2, Pos3, Pos4, Pos5, _Pos6}
    } = Hero,
    [
        Id
        ,Tid
        ,Pos
        ,Quality
        ,Lev
        ,Exp
        ,Foster
        % --- Base ---
        ,Hp
        ,Atk
        ,Def
        ,Pun
        ,Hit
        ,Dod
        ,Crit
        ,CritNum
        ,CritAnit
        ,Tou
        ,Pos1
        ,Pos2
        ,Pos3
        ,Pos4
        ,Pos5
    ].

hero_notice(Sender, Hero) ->
    Data = pack_hero(Hero),
    sender:pack_send(Sender, 14025, Data).

%% quality2string(1) ->   d;
%% quality2string(2) ->   c;
%% quality2string(3) ->   b;
%% quality2string(4) ->   a;
%% quality2string(5) ->   s;
%% quality2string(6) ->  ss;
%% quality2string(7) -> sss;
%% quality2string(_) -> undefined.

%% del_hero(Rs, HeroId) ->
%%     #role{id = Rid, heroes = Heroes} = Rs,
%%     case get_hero(HeroId, Heroes) of
%%         false -> {error, no_hero};
%%         Hero ->
%%             #hero{tid = Tid, step = Step} = Hero,
%%             case data_purge:get({Tid, Step}) of
%%                 [{_EssenceMax, _Skill, _ToEssence, _HpMaxP, _AtkP}] ->
%%                     Heroes1 = lists:keydelete(HeroId, 2, Heroes),
%%                     Rs1 = Rs#role{heroes = Heroes1},
%%                     case db_delete(Rid, HeroId) of
%%                         {ok, 1} -> {ok, Rs1};
%%                         {ok, 0} -> {error, no_hero};
%%                         {error, Reason} -> {error, Reason}
%%                     end;
%%                 undefined ->
%%                     {error, no_data};
%%                 _Data ->
%%                     ?WARN("undefined purge data: ~w", [_Data]),
%%                     {error, no_data}
%%             end
%%     end.

%% 获取英雄所穿戴的装备属性
get_equs([0 | EquIds], Hero, Items) ->
    get_equs(EquIds, Hero, Items);
get_equs([EquId | EquIds], Hero, Items) ->
    case mod_item:get_item(EquId, Items) of
        #item{attr = Equ} ->
            Equ1 = set_embed_attr(Equ#equ.embed, Equ),
            %% ?DEBUG("Equ Jewel Add:", []),
            %% lib_debug:print_equ([Item, Item#item{attr = Equ1}]),
            #equ{
                hp        = Hp
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
            } = Equ1,
            Hero1 = Hero#hero{
                hp         = Hero#hero.hp        + Hp
                ,atk       = Hero#hero.atk       + Atk
                ,def       = Hero#hero.def       + Def
                ,pun       = Hero#hero.pun       + Pun
                ,hit       = Hero#hero.hit       + Hit
                ,dod       = Hero#hero.dod       + Dod
                ,crit      = Hero#hero.crit      + Crit
                ,crit_num  = Hero#hero.crit_num  + CritNum
                ,crit_anti = Hero#hero.crit_anti + CritAnit
                ,tou       = Hero#hero.tou       + Tou
            },
            get_equs(EquIds, Hero1, Items);
        Else ->
            ?WARN("Error Equ: ~w, EquId:~w, Hero:~w", [EquId, Else, Hero]),
            get_equs(EquIds, Hero, Items)
    end;
get_equs([], Hero, _Items) -> Hero.

%% 将附在装备上的宝珠属性累加到装备属性上
set_embed_attr([{_, ?hp      , V, _, _} | T], Equ) -> Equ1 = Equ#equ{hp       = Equ#equ.hp       + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?atk     , V, _, _} | T], Equ) -> Equ1 = Equ#equ{atk      = Equ#equ.atk      + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?def     , V, _, _} | T], Equ) -> Equ1 = Equ#equ{def      = Equ#equ.def      + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?pun     , V, _, _} | T], Equ) -> Equ1 = Equ#equ{pun      = Equ#equ.pun      + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?hit     , V, _, _} | T], Equ) -> Equ1 = Equ#equ{hit      = Equ#equ.hit      + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?dod     , V, _, _} | T], Equ) -> Equ1 = Equ#equ{dod      = Equ#equ.dod      + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?crit    , V, _, _} | T], Equ) -> Equ1 = Equ#equ{crit     = Equ#equ.crit     + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?crit_num, V, _, _} | T], Equ) -> Equ1 = Equ#equ{crit_num = Equ#equ.crit_num + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?crit_anti, V, _, _} | T], Equ) -> Equ1 = Equ#equ{crit_anti = Equ#equ.crit_anti + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, ?tou, V, _, _} | T], Equ) -> Equ1 = Equ#equ{tou = Equ#equ.tou + V}, set_embed_attr(T, Equ1);
set_embed_attr([{_, K, V, _, _} | T], Equ) ->
    ?ERR("Error Attr Id: ~w (~w)", [K, V]),
    set_embed_attr(T, Equ);
set_embed_attr([], Equ) -> Equ.

%% 获取出战的英雄并计算属性
%% (英雄基础属性 * 品质系数 + 英雄基础属性 * 品质系数 * LV/25) * f(培养阶段) + 装备属性
%% 客户端公式: (收到的值 + 收到的值 * LV/25) * f(培养阶段) + 装备属性
get_combat_heroes(Heroes, Items) ->
    F = fun(H) ->
            #hero{
                hp         = Hp
                ,lev       = Lev
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,equ_grids = EquIds
                ,quality   = Quality
                ,foster    = Foster
            } = H,
            Arg1 = get_quality_arg(Quality),
            Arg2 = data_fun:hero_foster(Foster),
            H1 = H#hero{
                %% hp         = util:floor(Hp       * (Lev/30 - Lev*Lev/3600) * 0.75 + Hp      )
                %% ,atk       = util:floor(Atk      * (Lev/30 - Lev*Lev/3600) * 0.75 + Atk     )
                %% ,def       = util:floor(Def      * Lev*Lev/3600 * 0.75 + Def     )
                %% ,pun       = util:floor(Pun      * Lev*Lev/3600 * 0.75 + Pun     )
                %% ,hit       = util:floor(Hit      * Lev*Lev/3600 * 0.75 + Hit     )
                %% ,dod       = util:floor(Dod      * Lev*Lev/3600 * 0.75 + Dod     )
                %% ,crit      = util:floor(Crit     * Lev*Lev/3600 * 0.75 + Crit    )
                %% ,crit_num  = util:floor(CritNum  * Lev*Lev/3600 * 0.75 + CritNum )
                %% ,crit_anti = util:floor(CritAnit * Lev*Lev/3600 * 0.75 + CritAnit)
                %% ,tou       = util:floor(Tou      * Lev*Lev/3600 * 0.75 + Tou     )
                hp         = util:floor((Hp       * Lev/25 * Arg1 + Hp      ) * Arg2 )
                ,atk       = util:floor((Atk      * Lev/25 * Arg1 + Atk     ) * Arg2 )
                ,def       = util:floor((Def      * Lev/25 * Arg1 + Def     ) * Arg2 )
                ,pun       = util:floor((Pun      * Lev/25 * Arg1 + Pun     ) * Arg2 )
                ,hit       = util:floor((Hit      * Lev/25 * Arg1 + Hit     ) * Arg2 )
                ,dod       = util:floor((Dod      * Lev/25 * Arg1 + Dod     ) * Arg2 )
                ,crit      = util:floor((Crit     * Lev/25 * Arg1 + Crit    ) * Arg2 )
                ,crit_num  = util:floor((CritNum  * Lev/25 * Arg1 + CritNum ) * Arg2 )
                ,crit_anti = util:floor((CritAnit * Lev/25 * Arg1 + CritAnit) * Arg2 )
                ,tou       = util:floor((Tou      * Lev/25 * Arg1 + Tou     ) * Arg2 )
            },
            %% ?DEBUG("Hero Lev Add:", []),
            %% lib_debug:print_hero([H, H1]),
            get_equs(tuple_to_list(EquIds), H1, Items)
    end,
    Heroes1 = [F(Hero) || Hero <- Heroes, Hero#hero.pos > 0],
    case length(Heroes1) > 9 of
        true -> util:rand_element(9, Heroes1);
        false -> Heroes1
    end.

%% 查看对方的英雄并计算属性
get_see_heroes(Heroes, Items) ->
    F = fun(H) ->
            #hero{
                hp         = Hp
                ,lev       = Lev
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,equ_grids = EquIds
                ,quality   = Quality
                ,foster    = Foster
            } = H,
            Arg1 = get_quality_arg(Quality),
            Arg2 = data_fun:hero_foster(Foster),
            H1 = H#hero{
                %% hp         = util:floor(Hp       * (Lev/30 - Lev*Lev/3600) * 0.75 + Hp      )
                %% ,atk       = util:floor(Atk      * (Lev/30 - Lev*Lev/3600) * 0.75 + Atk     )
                %% ,def       = util:floor(Def      * Lev*Lev/3600 * 0.75 + Def     )
                %% ,pun       = util:floor(Pun      * Lev*Lev/3600 * 0.75 + Pun     )
                %% ,hit       = util:floor(Hit      * Lev*Lev/3600 * 0.75 + Hit     )
                %% ,dod       = util:floor(Dod      * Lev*Lev/3600 * 0.75 + Dod     )
                %% ,crit      = util:floor(Crit     * Lev*Lev/3600 * 0.75 + Crit    )
                %% ,crit_num  = util:floor(CritNum  * Lev*Lev/3600 * 0.75 + CritNum )
                %% ,crit_anti = util:floor(CritAnit * Lev*Lev/3600 * 0.75 + CritAnit)
                %% ,tou       = util:floor(Tou      * Lev*Lev/3600 * 0.75 + Tou     )
                hp         = util:floor((Hp       * Lev/25 * Arg1 + Hp      ) * Arg2 )
                ,atk       = util:floor((Atk      * Lev/25 * Arg1 + Atk     ) * Arg2 )
                ,def       = util:floor((Def      * Lev/25 * Arg1 + Def     ) * Arg2 )
                ,pun       = util:floor((Pun      * Lev/25 * Arg1 + Pun     ) * Arg2 )
                ,hit       = util:floor((Hit      * Lev/25 * Arg1 + Hit     ) * Arg2 )
                ,dod       = util:floor((Dod      * Lev/25 * Arg1 + Dod     ) * Arg2 )
                ,crit      = util:floor((Crit     * Lev/25 * Arg1 + Crit    ) * Arg2 )
                ,crit_num  = util:floor((CritNum  * Lev/25 * Arg1 + CritNum ) * Arg2 )
                ,crit_anti = util:floor((CritAnit * Lev/25 * Arg1 + CritAnit) * Arg2 )
                ,tou       = util:floor((Tou      * Lev/25 * Arg1 + Tou     ) * Arg2 )
            },
            %% ?DEBUG("Hero Lev Add:", []),
            %% lib_debug:print_hero([H, H1]),
            get_equs(tuple_to_list(EquIds), H1, Items)
    end,
    [F(Hero) || Hero <- Heroes].

clear_pos(Hero) ->
    case Hero#hero.pos > 0 of
        true -> Hero#hero{pos = 0, changed = 1};
        false -> Hero
    end.

set_pos(Rs, L) ->
    %% ?DEBUG("set_pos:~w", [L]),
    Hs = [clear_pos(Hero) || Hero <- Rs#role.heroes],
    case set_pos1(Hs, L) of
        {ok, Heroes} -> {ok, Rs#role{heroes = Heroes}};
        {error, Error} -> {error, Error}
    end.

set_pos1(Heroes, [[Id, Pos] | L]) ->
    case get_hero(Id, Heroes) of
        false ->
            ?WARN("set_pos error:~w, ~w", [Id, Pos]),
            {error, error};
        Hero ->
            %% ?INFO("set_pos:~w, ~w", [Id, Pos]),
            Hero1 = Hero#hero{pos = Pos, changed = 1},
            Heroes1 = set_hero(Hero1, Heroes),
            set_pos1(Heroes1, L)
    end;
set_pos1(Heroes, []) -> {ok, Heroes}.

get_hero(Id, Heroes) ->
    lists:keyfind(Id, 2, Heroes).

set_hero(Hero, Heroes) ->
    lists:keystore(Hero#hero.id, 2, Heroes, Hero).

%% add_hero(Rs) ->
%%     {ok, Id, Rs1} = lib_role:get_new_id(hero, Rs),
%%     Hero = init_hero(Id),
%%     db_insert(Rs#role.id, Hero),
%%     Rs1#role{heroes = [Hero | Rs#role.heroes]}.

%% get_hero_ids() ->
%%     Ids = data_hero:get(ids),
%%     get_hero_ids1(Ids, []).
%%
%% get_hero_ids1([Tid | Ids], Rt) ->
%%     Item = data_hero:get(Tid),
%%     case util:get_val(sort, Item) of
%%         1 -> get_hero_ids1(Ids, [Tid | Rt]);
%%         _ -> get_hero_ids1(Ids, Rt)
%%     end;
%% get_hero_ids1([], Rt) ->
%%     Rt.

add_hero_exp(Id, AddExp, Heroes) ->
    case get_hero(Id, Heroes) of
        false ->
            ?WARN("Error hero id: ~w", [Id]),
            Heroes;
        Hero ->
            Hero1 = add_hero_exp(Hero, AddExp),
            set_hero(Hero1, Heroes)
    end.

add_hero_exp(Hero, AddExp) ->
    Exp = Hero#hero.exp + AddExp,
    add_hero_exp1(Hero#hero{exp = Exp}).

add_hero_exp1(Hero) ->
    #hero{exp = Exp, exp_max = Max, lev = Lev} = Hero,
    LevMax = 200,
    case Exp >= Max andalso Lev < LevMax of
        true ->
            %% upgrade
            Lev1 = Lev + 1,
            case data_exp:get(Lev1) of
                undefined -> Hero;
                LevData ->
                    self() ! {pt, 2010, [Lev1]},
                    case util:get_val(exp_max, LevData) of
                        undefined ->
                            ?WARN("[No Lev:~w]", [Lev1]),
                            Hero;
                        Max1 ->
                            Exp1 = Exp - Max,
                            Hero1 = Hero#hero{exp = Exp1, lev = Lev1, exp_max = Max1, changed = 1},
                            add_hero_exp1(Hero1)
                    end
            end;
        false -> Hero
    end.

get_tids_by_rare(Rare) ->
    Ids = data_hero:get(ids),
    lists:foldl(fun(Tid, Tids)->
                Data = data_hero:get(Tid),
                case util:get_val(rare, Data) of
                    Rare -> [Tid | Tids];
                    _ -> Tids
                end
        end, [], Ids).

attr_val(Attr, Data, Arg) ->
    V = util:get_val(Attr, Data, 0),
    %% Rand1 = util:rand(1, 100),
    %% Rand2 = util:rand(1, 100),
    %% util:ceil((Rand1*Rand2/10000*0.4*V+0.6*V)*Arg).
    util:ceil(V * data_fun:hero_offset()*Arg).

init_hero(Id) ->
    {Rare} = util:get_range_data(data_hero_rare),
    Tids = get_tids_by_rare(Rare),
    Tid = util:rand_element(Tids),
    {Quality, Arg} = util:get_range_data(data_hero_quality),
    case data_hero:get(Tid) of
        undefined ->
            ?WARN("[INIT HERO] Error hero id: ~w, Rare:~w", [Tid, Rare]),
            false;
        Data ->
            Job    = util:get_val(job    , Data),
            Lev = 1,
            DataExp  = data_exp:get(Lev),
            ExpMax   = util:get_val(exp_max, DataExp),
            Sort     = util:get_val(sort, Data),
            Hp       = attr_val(hp        , Data, Arg),
            Atk      = attr_val(atk        , Data, Arg),
            Def      = attr_val(def       , Data, Arg),
            Pun      = attr_val(pun       , Data, Arg),
            Hit      = attr_val(hit       , Data, Arg),
            Dod      = attr_val(dod       , Data, Arg),
            Crit     = attr_val(crit      , Data, Arg),
            CritNum  = attr_val(crit_num  , Data, Arg),
            CritAnit = attr_val(crit_anti , Data, Arg),
            Tou      = attr_val(tou       , Data, Arg),
            #hero{
                id = Id
                ,tid = Tid
                ,job = Job
                ,sort = Sort
                ,rare = Rare
                ,hp = Hp
                ,atk = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,changed = 1
                ,exp_max = ExpMax
                ,exp = 0
                ,lev = Lev
                ,quality = Quality %% 品极
                ,skills = lib_role:init_skills(Data)
            }
    end.


init_hero(Id, Tid) ->
    Rare = 1,
    {Quality, Arg} = util:get_range_data(data_hero_quality),
    case data_hero:get(Tid) of
        undefined -> false;
        Data ->
            Job    = util:get_val(job    , Data),
            Lev = 1,
            DataExp  = data_exp:get(Lev),
            ExpMax   = util:get_val(exp_max, DataExp),
            Sort     = util:get_val(sort, Data),
            Hp       = attr_val(hp        , Data, Arg),
            Atk      = attr_val(atk        , Data, Arg),
            Def      = attr_val(def       , Data, Arg),
            Pun      = attr_val(pun       , Data, Arg),
            Hit      = attr_val(hit       , Data, Arg),
            Dod      = attr_val(dod       , Data, Arg),
            Crit     = attr_val(crit      , Data, Arg),
            CritNum  = attr_val(crit_num  , Data, Arg),
            CritAnit = attr_val(crit_anti , Data, Arg),
            Tou      = attr_val(tou       , Data, Arg),
            #hero{
                id = Id
                ,tid = Tid
                ,job = Job
                ,sort = Sort
                ,rare = Rare
                ,hp = Hp
                ,atk = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,changed = 1
                ,exp_max = ExpMax
                ,exp = 0
                ,lev = Lev
                ,quality = Quality %% 品极
                ,skills = lib_role:init_skills(Data)
            }
    end.

%% 完成成就赠送英雄 / 签到领奖 / 活动赠送
init_hero(Id, Tid, Quality) ->
    HeroData = data_hero:get(Tid),
    Rare = util:get_val(rare, HeroData),
    Arg = get_quality_arg(Quality),
    case data_hero:get(Tid) of
        undefined ->
            ?WARN("[INIT HERO] Error hero id: ~w, Rare:~w", [Tid, Rare]),
            false;
        Data ->
            Job      = util:get_val(job   , Data),
            Lev      = 1,
            DataExp  = data_exp:get(Lev),
            ExpMax   = util:get_val(exp_max, DataExp),
            Sort     = util:get_val(sort, Data),
            Hp       = attr_val(hp        , Data, Arg),
            Atk      = attr_val(atk       , Data, Arg),
            Def      = attr_val(def       , Data, Arg),
            Pun      = attr_val(pun       , Data, Arg),
            Hit      = attr_val(hit       , Data, Arg),
            Dod      = attr_val(dod       , Data, Arg),
            Crit     = attr_val(crit      , Data, Arg),
            CritNum  = attr_val(crit_num  , Data, Arg),
            CritAnit = attr_val(crit_anti , Data, Arg),
            Tou      = attr_val(tou       , Data, Arg),
            #hero{
                id = Id
                ,tid = Tid
                ,job = Job
                ,sort = Sort
                ,rare = Rare
                ,hp = Hp
                ,atk = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,changed = 1
                ,exp_max = ExpMax
                ,exp = 0
                ,lev = Lev
                ,quality = Quality %% 品极
                ,skills = lib_role:init_skills(Data)
            }
    end.

get_quality_arg(Q) ->
    Ids = data_hero_quality:get(ids),
    get_quality_arg(Ids, Q).

get_quality_arg([Id | Ids], Q) ->
    case data_hero_quality:get(Id) of
        {Q, Arg} -> Arg;
        _ -> get_quality_arg(Ids, Q)
    end;
get_quality_arg([], Q) ->
    ?WARN("Undefined quality:~w", [Q]),
    undefined.

upgrade_quality(Hero) ->
    #hero{
        hp        = Hp
        ,atk       = Atk
        ,def       = Def
        ,pun       = Pun
        ,hit       = Hit
        ,dod       = Dod
        ,crit      = Crit
        ,crit_num  = CritNum
        ,crit_anti = CritAnit
        ,tou       = Tou
        ,quality = Quality
    } = Hero,
    Arg1 = get_quality_arg(Quality),
    Arg2 = get_quality_arg(Quality + 1),
    NewHp       = util:ceil(Hp       / Arg1 * Arg2),
    NewAtk      = util:ceil(Atk      / Arg1 * Arg2),
    NewDef      = util:ceil(Def      / Arg1 * Arg2),
    NewPun      = util:ceil(Pun      / Arg1 * Arg2),
    NewHit      = util:ceil(Hit      / Arg1 * Arg2),
    NewDod      = util:ceil(Dod      / Arg1 * Arg2),
    NewCrit     = util:ceil(Crit     / Arg1 * Arg2),
    NewCritNum  = util:ceil(CritNum  / Arg1 * Arg2),
    NewCritAnit = util:ceil(CritAnit / Arg1 * Arg2),
    NewTou      = util:ceil(Tou      / Arg1 * Arg2),
    Hero#hero{
        hp         = NewHp
        ,atk       = NewAtk
        ,def       = NewDef
        ,pun       = NewPun
        ,hit       = NewHit
        ,dod       = NewDod
        ,crit      = NewCrit
        ,crit_num  = NewCritNum
        ,crit_anti = NewCritAnit
        ,tou       = NewTou
        ,quality   = Quality + 1
		,changed   = 1
    }.

%%' 酒馆刷新英雄
tavern_refresh(Tavern) ->
    tavern_refresh([1, 2, 3], Tavern).

tavern_refresh([Id | Ids], Tavern) ->
    case lists:keyfind(Id, 1, Tavern) of
        false ->
            Hero = init_hero(0),
            tavern_refresh(Ids, [{Id, 0, Hero} | Tavern]);
        {_, 0, _} ->
            Hero = init_hero(0),
            Tavern1 = lists:keyreplace(Id, 1, Tavern, {Id, 0, Hero}),
            tavern_refresh(Ids, Tavern1);
        {_, 1, _} ->
            tavern_refresh(Ids, Tavern)
    end;
tavern_refresh([], Tavern) ->
    Tavern.
%%.

%%' 酒馆引导
tavern_guide(TidList) ->
    tavern_guide1(TidList, []).

tavern_guide1([{Id, Tid1} | Tid], Tavern) ->
    Hero = init_hero_guide(Id, Tid1),
    tavern_guide1(Tid, [{Id, 0, Hero} | Tavern]);

tavern_guide1([], Tavern) ->
    Tavern.

init_hero_guide(Id, Tid) ->
    Rare = 1,
    %% {Quality, Arg} = util:get_range_data(data_hero_quality),
    Quality = 2,
    Arg = get_quality_arg(Quality),
    case data_hero:get(Tid) of
        undefined -> false;
        Data ->
            Job    = util:get_val(job    , Data),
            Lev = 1,
            DataExp  = data_exp:get(Lev),
            ExpMax   = util:get_val(exp_max, DataExp),
            Sort     = util:get_val(sort, Data),
            Hp       = attr_val(hp        , Data, Arg),
            Atk      = attr_val(atk        , Data, Arg),
            Def      = attr_val(def       , Data, Arg),
            Pun      = attr_val(pun       , Data, Arg),
            Hit      = attr_val(hit       , Data, Arg),
            Dod      = attr_val(dod       , Data, Arg),
            Crit     = attr_val(crit      , Data, Arg),
            CritNum  = attr_val(crit_num  , Data, Arg),
            CritAnit = attr_val(crit_anti , Data, Arg),
            Tou      = attr_val(tou       , Data, Arg),
            #hero{
                id = Id
                ,tid = Tid
                ,job = Job
                ,sort = Sort
                ,rare = Rare
                ,hp = Hp
                ,atk = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,changed = 1
                ,exp_max = ExpMax
                ,exp = 0
                ,lev = Lev
                ,quality = Quality %% 品极
                ,skills = lib_role:init_skills(Data)
            }
    end.
%%.

%%' 数据库相关操作

db_init_tavern(Rs) ->
    Sql = list_to_binary([<<"select tavern_time, tavern from tavern where role_id = ">>, integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Time, Tavern]} ->
            {ok, Rs#role{
                tavern_time = Time
                ,tavern = unzip_tavern(Tavern)
            }};
        {error, null} ->
            Time = util:unixtime(),
            Tavern = tavern_refresh([]),
            Rs1 = Rs#role{
                tavern_time = Time
                ,tavern = Tavern
            },
            case db_insert_tavern(Rs1) of
                {ok, _} -> {ok, Rs1};
                {error, Reason} -> {error, Reason}
            end;
        {error, Reason} ->
            %% 初始化失败
            {error, Reason}
    end.

db_insert_tavern(Rs) ->
    #role{id = Rid, tavern_time = Time, tavern = Tavern} = Rs,
    db:execute("insert into tavern (role_id, tavern_time, tavern) values (~s, ~s, ~s)",
        [Rid, Time, zip_tavern(Tavern)]).

db_update_tavern(Rs) ->
    #role{id = Rid, tavern_time = Time, tavern = Tavern} = Rs,
    db:execute("update tavern set tavern_time = ~s, tavern = ~s where role_id = ~s", [Time, zip_tavern(Tavern), Rid]).


-spec db_init(Rs) -> {ok, NewRs} | {error, Reason} when
    Rs :: #role{},
    NewRs :: #role{},
    Reason :: term().

db_init(Rs) ->
    Rid = Rs#role.id,
    Sql = list_to_binary([
            <<"select hero_id, val from hero where role_id = ">>
            ,integer_to_list(Rid)
        ]),
    case db:get_all(Sql) of
        {ok, Rows} ->
            {MaxId, Heroes} = db_init1(Rows, []),
            {ok, Rs#role{heroes = Heroes, max_hero_id = MaxId}};
        {error, null} ->
            {ok, Rs#role{heroes = []}};
        {error, Reason} ->
            {error, Reason}
    end.

db_init1([H | T], Result) ->
    db_init1(T, [unzip(H) | Result]);
db_init1([], Result) ->
    MaxId = lists:max([H#hero.id || H <- Result]),
    {MaxId, Result}.

db_delete(Rid, Hid) when is_integer(Hid) ->
    Sql = list_to_binary([
            <<"delete from hero where role_id = ">>
            ,integer_to_list(Rid),<<" and hero_id = ">>
            ,integer_to_list(Hid)
        ]),
    db:execute(Sql);
db_delete(Rid, H) ->
    db_delete(Rid, H#hero.id).

-spec db_insert(Rid, Hero) -> {ok, Num} | {error, Reason} when
    Rid :: integer(),
    Hero :: #hero{},
    Num :: integer(), %% 影响行数
    Reason :: term().

db_insert(Rid, H) ->
    %% ?DEBUG("H:~w", [H]),
    RidL = integer_to_list(Rid),
    HidL = integer_to_list(H#hero.id),
    Sql = list_to_binary([
            <<"SELECT count(*) FROM `hero` WHERE role_id = ">>,
            RidL,<<" and hero_id = ">>,HidL
        ]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Val = ?ESC_SINGLE_QUOTES(zip(H)),
            Sql2 = list_to_binary([
                    <<"insert hero (role_id, hero_id, val) value (">>
                    ,RidL,<<",">>,HidL,<<",'">>,Val,<<"')">>
                ]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok, _Num} ->
            %% 记录已存在
            {ok, 0}
    end.

-spec db_update(Rid, Heroes) -> {true, NewHeroes} | {false, NewHeroes} when
    Rid :: integer(),
    Heroes :: NewHeroes,
    NewHeroes :: [#hero{}].

db_update(Rid, HL) ->
    db_update(Rid, HL, []).

db_update(Rid, [H | T], Result) ->
    Result1 = [H#hero{changed = 0} | Result],
    case H#hero.changed of
        1 ->
            Val = ?ESC_SINGLE_QUOTES(zip(H)),
            Sql = list_to_binary([
                    <<"update hero set val = '">>,Val,<<"' where ">>
                    ,<<" role_id = ">>,integer_to_list(Rid)
                    ,<<" and hero_id = ">>,integer_to_list(H#hero.id)
                ]),
            case db:execute(Sql) of
                {ok, 0} ->
                    %% 影响行数为0，可能是记录不存在，进行插入操作
                    case db_insert(Rid, H) of
                        {ok, _} ->
                            db_update(Rid, T, Result1);
                        {error, _} ->
                            {false, Result ++ [H | T]}
                    end;
                {ok, 1} ->
                    db_update(Rid, T, Result1);
                {ok, Num} ->
                    ?WARN("Update Hero Return Rows: ~w", [Num]),
                    db_update(Rid, T, Result1);
                {error, Reason} ->
                    ?WARN("Update Hero Error: ~w", [Reason]),
                    {false, Result ++ [H | T]}
            end;
        0 ->
            db_update(Rid, T, Result1);
        _ ->
            ?ERR("Undefined #hero.changed: ~w", [H#hero.changed]),
            db_update(Rid, T, Result1)
    end;
db_update(_Rid, [], Result) -> {true, Result}.
%%.

zip_tavern(Tavern) ->
    zip_tavern(Tavern, <<>>).

zip_tavern([{Nth, Lock, H} | Tavern], Rt) ->
    Bin = zip(H),
    Size = byte_size(Bin),
    Rt1 = <<Rt/binary, Nth:8, Lock:8, Size:16, Bin/binary>>,
    zip_tavern(Tavern, Rt1);
zip_tavern([], Rt) ->
    Rt.

unzip_tavern(Bin) ->
    unzip_tavern(Bin, []).

unzip_tavern(<<Nth:8, Lock:8, Size:16, HeroBin:Size/binary, RestBin/binary>>, Rt) ->
    Hero = unzip([0, HeroBin]),
    Rt1 = [{Nth, Lock, Hero} | Rt],
    unzip_tavern(RestBin, Rt1);
unzip_tavern(<<>>, Rt) ->
    lists:reverse(Rt).

%%' zip / unzip
unzip([Id, Val]) ->
    <<Version:8, Bin1/binary>> = Val,
    case Version of
        2 ->
            <<Tid:32, Job:8, Sort:8, Rare:8,
            Hp      :32,
            Atk     :32,
            Def     :32,
            Pun     :32,
            Hit     :32,
            Dod     :32,
            Crit    :32,
            CritNum :32,
            CritAnit:32,
            Tou     :32,
            Quality :8,
            Pos     :8,
            ExpMax  :32,
            Exp     :32,
            Lev     :8,
            Step    :8,
            Pos1    :32,
            Pos2    :32,
            Pos3    :32,
            Pos4    :32,
            Pos5    :32,
            Pos6    :32
            >> = Bin1,
            %% ?INFO("unzip step:~w, skills:~w", [Step, Skills]),
            Data = data_hero:get(Tid),
            #hero{
                id         = Id
                ,tid       = Tid
                ,job       = Job
                ,sort      = Sort
                ,rare      = Rare
                ,hp        = Hp
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,pos       = Pos
                ,exp_max   = ExpMax
                ,exp       = Exp
                ,lev       = Lev
                ,step      = Step
                ,quality   = Quality
                ,equ_grids = {Pos1, Pos2, Pos3, Pos4, Pos5, Pos6}
                ,skills    = lib_role:init_skills(Data)
            };
        3 ->
            <<Tid:32, Job:8, Sort:8, Rare:8,
            Hp      :32,
            Atk     :32,
            Def     :32,
            Pun     :32,
            Hit     :32,
            Dod     :32,
            Crit    :32,
            CritNum :32,
            CritAnit:32,
            Tou     :32,
            Quality :8,
            Pos     :8,
            ExpMax  :32,
            Exp     :32,
            Lev     :8,
            Step    :8,
            Foster  :8,
            Pos1    :32,
            Pos2    :32,
            Pos3    :32,
            Pos4    :32,
            Pos5    :32,
            Pos6    :32
            >> = Bin1,
            %% ?INFO("unzip step:~w, skills:~w", [Step, Skills]),
            Data = data_hero:get(Tid),
            #hero{
                id         = Id
                ,tid       = Tid
                ,job       = Job
                ,sort      = Sort
                ,rare      = Rare
                ,hp        = Hp
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,pos       = Pos
                ,exp_max   = ExpMax
                ,exp       = Exp
                ,lev       = Lev
                ,step      = Step
                ,foster    = Foster
                ,quality   = Quality
                ,equ_grids = {Pos1, Pos2, Pos3, Pos4, Pos5, Pos6}
                ,skills    = lib_role:init_skills(Data)
            };
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

-define(HERO_ZIP_VERSION, 3).

zip(H) ->
    #hero{
        tid        = Tid
        ,job       = Job
        ,sort      = Sort
        ,rare      = Rare
        ,hp        = Hp
        ,atk       = Atk
        ,def       = Def
        ,pun       = Pun
        ,hit       = Hit
        ,dod       = Dod
        ,crit      = Crit
        ,crit_num  = CritNum
        ,crit_anti = CritAnit
        ,tou       = Tou
        ,pos       = Pos
        ,exp_max   = ExpMax
        ,exp       = Exp
        ,lev       = Lev
        ,step      = Step
        ,foster    = Foster
        ,quality   = Quality
        ,equ_grids = {Pos1, Pos2, Pos3, Pos4, Pos5, Pos6}
    } = H,
    <<?HERO_ZIP_VERSION:8, Tid:32, Job:8, Sort:8, Rare:8,
    Hp      :32,
    Atk     :32,
    Def     :32,
    Pun     :32,
    Hit     :32,
    Dod     :32,
    Crit    :32,
    CritNum :32,
    CritAnit:32,
    Tou     :32,
    Quality :8,
    Pos     :8,
    ExpMax  :32,
    Exp     :32,
    Lev     :8,
    Step    :8,
    Foster  :8,
    Pos1    :32,
    Pos2    :32,
    Pos3    :32,
    Pos4    :32,
    Pos5    :32,
    Pos6    :32
    >>.
%%.

%%' 图鉴功能(pictorialial)
init_pictorial(Rs) ->
    Sql = list_to_binary([<<"SELECT `pictorial` FROM `pictorial` WHERE `role_id` = ">>
            , integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Data]} ->
            Data2 = unzip_pictorial(Data),
            {ok, Rs#role{pictorialial = Data2}};
        {error, null} ->
            {ok, Rs};
        {error, Reason} ->
            {error, Reason}
    end.

update_pictorial(Rs) ->
    #role{id = Id, pictorialial = Pictorial} = Rs,
    Pic = ?ESC_SINGLE_QUOTES(zip_pictorial(Pictorial)),
    Sql1 = list_to_binary([<<"UPDATE `pictorial` SET `pictorial` = '">>
            , Pic, <<"' WHERE `role_id` = ">>
            , integer_to_list(Id)]),
    case db:execute(Sql1) of
        {ok, 0} ->
            insert_pictorial(Rs);
        {ok, Num} -> {ok, Num};
        {error, Reason} -> {error, Reason}
    end.
insert_pictorial(Rs) ->
    #role{id = Id, pictorialial = Pictorial} = Rs,
    Pic = ?ESC_SINGLE_QUOTES(zip_pictorial(Pictorial)),
    Sql1 = list_to_binary([<<"SELECT count(*) FROM `pictorial` WHERE `role_id` = ">>
            ,integer_to_list(Id)]),
    case db:get_one(Sql1) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `pictorial` (`role_id`, `pictorial`) VALUES (">>
                    , integer_to_list(Id), <<", '">>, Pic, <<"')">>]),
            case db:execute(Sql2) of
                {ok, Num} -> {ok, Num};
                {error, Reason} -> {error, Reason}
            end;
        {error, Reason} -> {error, Reason};
        {ok, Num2} -> {ok, Num2}
    end.

%%
-define(PICTORIAL_ZIP_VERSION, 1).

zip_pictorial([]) -> <<>>;
zip_pictorial(Pictorial) ->
    zip_pictorial(Pictorial, []).
zip_pictorial([H | T], Rt) ->
    Rt1 = <<H:32>>,
    zip_pictorial(T, [Rt1 | Rt]);
zip_pictorial([], Rt) ->
    Rt1 = list_to_binary(Rt),
    <<?PICTORIAL_ZIP_VERSION:8, Rt1/binary>>.

unzip_pictorial(<<>>) -> [];
unzip_pictorial(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip_pictorial(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
unzip_pictorial(<<H:32, RestBin/binary>>, Rt) ->
    unzip_pictorial(RestBin, [H | Rt]);
unzip_pictorial(<<>>, Rt) -> Rt.
%%.

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
