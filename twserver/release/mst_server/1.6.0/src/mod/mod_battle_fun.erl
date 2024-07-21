%%----------------------------------------------------
%% $Id: mod_battle_fun.erl 11521 2014-04-08 09:34:23Z piaohua $
%% @doc 战斗模块回调函数
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(mod_battle_fun).
-export([
        set_cmd/5
        ,set_dod/5
        ,set_pun/5
        ,set_atk/5
        ,set_buff/5
        ,set_hit/5
        ,set_def/5
        ,set_crited_must/5
        ,set_hp_max/5
        ,set_crit_anti/5
        ,set_states/2
        ,add_hp/5
        ,add_atk/5
        ,sub_atk/5
        ,atked2atk/5
        ,set_crit/5
        ,add_ice_rate/5
        ,set_damaged/5
        ,add_hp_max_def/5
        ,add_hp_max_atk/5
        ,super/5
    ]
).

-include("common.hrl").
-include("hero.hrl").
-include("s.hrl").

super(Targets, _A, _Arg, _ExtArg, _) ->
    Targets.

set_cmd([S | Targets], A, {Trigger, T, Cmd}, ExtArg, Rt) ->
    Skills = [[{trigger, Trigger}, {target, T}, {cmd, [Cmd]}] | S#s.skills],
    S1 = S#s{skills = Skills},
    Rt1 = [S1 | Rt],
    set_cmd(Targets, A, {Trigger, T, Cmd}, ExtArg, Rt1);
set_cmd([], _, _, _, Rt) -> Rt.

set_hp_max([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
        '*' -> S#s.hp_max * V;
        '-' -> max(S#s.hp_max - V, 0);
        '+' -> S#s.hp_max + V
    end,
    S1 = S#s{hp_max = New},
    Rt1 = [S1 | Rt],
    set_hp_max(Targets, A, {Op, V}, ExtArg, Rt1);
set_hp_max([], _, _, _, Rt) -> Rt.

%% skills 65
add_hp_max_def([S | Targets], A, {{Op1, V1},{Op2,V2},{Op3,V3}}, ExtArg, Rt) ->
    NewHp = case Op1 of
        '*' -> util:ceil(S#s.hp + S#s.hp_max * V1);
        '-' -> max(S#s.hp - V1, 0);
        '+' -> S#s.hp + V1
    end,
    NewHpMax = case Op2 of
        '*' -> util:ceil(S#s.hp_max + S#s.hp_max * V2);
        '-' -> max(S#s.hp_max - V2, 0);
        '+' -> S#s.hp_max + V2
    end,
    NewDef = case Op3 of
        '*' -> util:ceil(S#s.def + S#s.def * V3);
        '-' -> max(S#s.def - V3, 0);
        '+' -> S#s.def + V3
    end,
    S1 = S#s{hp = NewHp, hp_max = NewHpMax, def = NewDef},
    Rt1 = [S1 | Rt],
    ?INFO("===NewHp:~w, NewHpMax:~w, NewDef:~w", [NewHp, NewHpMax, NewDef]),
    add_hp_max_def(Targets, A, {{Op1, V1},{Op2,V2},{Op3,V3}}, ExtArg, Rt1);
add_hp_max_def([], _, _, _, Rt) -> Rt.

%% skills 67
add_hp_max_atk([S | Targets], A, {{Op1,V1},{Op2,V2},{Op3,V3}}, ExtArg, Rt) ->
    NewHp = case Op1 of
        '*' -> util:ceil(S#s.hp + S#s.hp_max * V1);
        '-' -> max(S#s.hp - V1, 0);
        '+' -> S#s.hp + V1
    end,
    NewHpMax = case Op2 of
        '*' -> util:ceil(S#s.hp_max + S#s.hp_max * V2);
        '-' -> max(S#s.hp_max - V2, 0);
        '+' -> S#s.hp_max + V2
    end,
    NewAtk = case Op3 of
        '*' -> util:ceil(S#s.atk + S#s.atk * V3);
        '-' -> max(S#s.atk - V3, 0);
        '+' -> S#s.atk + V3
    end,
    S1 = S#s{hp = NewHp, hp_max = NewHpMax, atk = NewAtk},
    Rt1 = [S1 | Rt],
    %% ?INFO("===NewHp:~w, NewHpMax:~w, NewAtk:~w", [NewHp, NewHpMax, NewAtk]),
    add_hp_max_atk(Targets, A, {{Op1,V1},{Op2,V2},{Op3,V3}}, ExtArg, Rt1);
add_hp_max_atk([], _, _, _, Rt) -> Rt.

add_hp(Targets, A, Arg, _ExtArg, Rt) ->
    add_hp1(Targets, A, Arg, length(Targets), Rt).

add_hp1([S | Targets], A, {Op, V}, TargetNum, Rt) ->
    Hp = case Op of
        '*' -> S#s.hp + S#s.hp_max * V;
        '+' -> S#s.hp + V;
        '-' -> max(S#s.hp - V, 0);
        cure ->
            X = mod_battle:calc_crit(A, S),
            S#s.hp + A#s.atk * mod_battle:calc_dmg_offset() * X * V;
        cure_sum ->
            X = mod_battle:calc_crit(A, S),
            XX = S#s.hp + A#s.atk * mod_battle:calc_dmg_offset() * X * (V / TargetNum),
            %% ?INFO("CURE_SUM: ~w + ~w = ~w [crit:~w,atk:~w, V:~w, Num:~w]", [S#s.hp, XX - S#s.hp, XX, X, S#s.atk, V, TargetNum]),
            XX
    end,
    %% S1 = if
    %%     Op =:= cure -> set_state(S, ?STA_CURE);
    %%     true -> S
    %% end,
    S1 =  set_state(S, ?STA_CURE),
    S2 = if
        S#s.hp =< 0, Hp > 0 ->
                 set_state(S1, ?STA_REALIVE);
        true -> S1
    end,
    Hp1 = min(util:ceil(Hp), S2#s.hp_max),
    S3 = S2#s{hp = Hp1},
    Rt1 = [S3 | Rt],
    add_hp1(Targets, A, {Op, V}, TargetNum, Rt1);
add_hp1([], _, _, _, Rt) -> Rt.

set_damaged([S | Targets], A, {lost, Op, V}, ExtArg, Rt) ->
    #s{hp = Hp, hp_max = HpMax} = S,
    LostRatio = 1 - (Hp / HpMax),
    New = case Op of
        '*' -> S#s.damaged + LostRatio * V;
        '+' -> S#s.damaged + LostRatio + V;
        '-' -> S#s.damaged + LostRatio - V
    end,
    S1 = S#s{damaged = New},
    Rt1 = [S1 | Rt],
    set_damaged(Targets, A, {Op, V}, ExtArg, Rt1);
set_damaged([S | Targets], A, {Name, Op, V}, ExtArg, Rt) ->
    case lists:keymember(Name, #buff.name, S#s.buffs) of
        false -> set_damaged(Targets, A, {Name, Op, V}, ExtArg, [S | Rt]);
        true ->
            New = case Op of
                '*' -> S#s.damaged * V;
                '-' -> max(S#s.damaged - V, 0);
                '+' -> S#s.damaged + V
            end,
            S1 = S#s{damaged = New},
            Rt1 = [S1 | Rt],
            set_damaged(Targets, A, {Op, V}, ExtArg, Rt1)
    end;
set_damaged([], _, _, _, Rt) -> Rt.

set_dod([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '-' -> max(S#s.dod - V, 0);
             '+' -> S#s.dod + V;
             '*' -> S#s.dod * V
         end,
    S1 = S#s{dod = New},
    Rt1 = [S1 | Rt],
    set_dod(Targets, A, {Op, V}, ExtArg, Rt1);
set_dod([], _, _, _, Rt) -> Rt.

set_hit([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '-' -> max(S#s.hit - V, 0);
             '+' -> S#s.hit + V;
             '*' -> S#s.hit * V
         end,
    S1 = S#s{hit = New},
    Rt1 = [S1 | Rt],
    set_hit(Targets, A, {Op, V}, ExtArg, Rt1);
set_hit([], _, _, _, Rt) -> Rt.

set_crited_must([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '=' -> V
         end,
    S1 = S#s{crited_must = New},
    Rt1 = [S1 | Rt],
    set_crited_must(Targets, A, {Op, V}, ExtArg, Rt1);
set_crited_must([], _, _, _, Rt) -> Rt.

set_def([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '-' -> max(S#s.def - V, 0);
             '+' -> S#s.def + V;
             '=' -> V;
             '*' -> S#s.def * V
         end,
    S1 = S#s{def = New},
    %% ?DEBUG("Pos:~w, set_def: ~w ~s ~w = ~w", [S#s.pos, S#s.def, Op, V, New]),
    Rt1 = [S1 | Rt],
    set_def(Targets, A, {Op, V}, ExtArg, Rt1);
set_def([], _, _, _, Rt) -> Rt.

set_pun([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '+' -> S#s.pun + V;
             '-' -> max(S#s.pun - V, 0);
             '*' -> S#s.pun * V
         end,
    S1 = S#s{pun = New},
    Rt1 = [S1 | Rt],
    set_pun(Targets, A, {Op, V}, ExtArg, Rt1);
set_pun([], _, _, _, Rt) -> Rt.

set_atk([S | Targets], A, {original, V, Limit}, ExtArg, Rt) ->
    New = case V > 0 of
        true ->
            case (S#s.atk / S#s.atk_init) > Limit of
                true -> S#s.atk;
                false -> S#s.atk + S#s.atk_init * V
            end;
        false ->
            case (S#s.atk / S#s.atk_init) < Limit of
                true -> S#s.atk;
                false -> S#s.atk + S#s.atk_init * V
            end
    end,
    S1 = S#s{atk = New},
    Rt1 = [S1 | Rt],
    set_atk(Targets, A, {original, V, Limit}, ExtArg, Rt1);
set_atk([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '+' -> S#s.atk + V;
             '-' -> max(S#s.atk - V, 0);
             '*' -> S#s.atk * V
         end,
    S1 = S#s{atk = New},
    Rt1 = [S1 | Rt],
    set_atk(Targets, A, {Op, V}, ExtArg, Rt1);
set_atk([], _, _, _, Rt) -> Rt.

add_atk([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    Add = case Op of
             '+' -> V;
             '*' -> S#s.atk * V
         end,
    S1 = S#s{atk = Add + S#s.atk},
    Rt1 = [S1 | Rt],
    add_atk(Targets, A, {Op, V}, ExtArg, Rt1);
add_atk([], _, _, _, Rt) -> Rt.

sub_atk([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    Add = case Op of
             '-' -> V;
             '*' -> S#s.atk * V
         end,
    S1 = S#s{atk = max(S#s.atk - Add, 0)},
    Rt1 = [S1 | Rt],
    sub_atk(Targets, A, {Op, V}, ExtArg, Rt1);
sub_atk([], _, _, _, Rt) -> Rt.

set_crit_anti([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '+' -> S#s.crit_anti + V;
             '*' -> S#s.crit_anti * V
         end,
    S1 = S#s{crit_anti = New},
    Rt1 = [S1 | Rt],
    set_crit_anti(Targets, A, {Op, V}, ExtArg, Rt1);
set_crit_anti([], _, _, _, Rt) -> Rt.

set_crit([S | Targets], A, {Op, V}, ExtArg, Rt) ->
    New = case Op of
             '*' -> S#s.crit * V;
             '+' -> S#s.crit + V;
             '-' -> S#s.crit - V
         end,
    S1 = S#s{crit = New},
    Rt1 = [S1 | Rt],
    set_crit(Targets, A, {Op, V}, ExtArg, Rt1);
set_crit([], _, _, _, Rt) -> Rt.

add_ice_rate([S | Targets], A, {Add, Max}, ExtArg, Rt) ->
    IcedRate = case S#s.iced_rate of
        undefined -> dict:new();
        Dict -> Dict
    end,
    F = fun(Old) ->
            Val = Old + Add,
            case Val > Max of
                true -> Max;
                false -> Val
            end
    end,
    IcedRate1 = dict:update(A#s.pos, F, Add, IcedRate),
    S1 = S#s{iced_rate = IcedRate1},
    Rt1 = [S1 | Rt],
    ?DEBUG("add_ice_rate:~w", [dict:to_list(IcedRate)]),
    add_ice_rate(Targets, A, {Add, Max}, ExtArg, Rt1);
add_ice_rate([], _, _, _, Rt) -> Rt.

set_buff([S | Targets], A, {Name, Args, Bout, Id, Trigger}, ExtArg, Rt) ->
    Skip1 = case Args of
        {rate, SetRate} ->
            SetRate1 = case Name of
                ice ->
                    ?DEBUG("ice_rate1:~w", [SetRate]),
                    SetRateXX = case S#s.iced_rate of
                        undefined -> SetRate;
                        IceDict ->
                            case dict:is_key(A#s.pos, IceDict) of
                                true ->
                                    SetRate + dict:fetch(A#s.pos, IceDict);
                                false ->
                                    SetRate
                            end
                    end,
                    ?DEBUG("ice_rate2:~w", [SetRateXX]),
                    SetRateXX;
                _ ->
                    SetRate
            end,
            not util:rate(SetRate1);
        _ -> false
    end,
    Anti = mod_battle:get_skill_cmd_value_by_key(S, set_buff, anti_buff),
    Skip2 = is_list(Anti) andalso lists:member(Id, Anti),
    Skip3 = (not is_friend(S, A)) andalso is_super(S#s.buffs),
    case Skip1 orelse Skip2 orelse Skip3 of
        true ->
            set_buff(Targets, A, {Name, Args, Bout, Id, Trigger}, ExtArg, [S|Rt]);
        false ->
            #s{buffs = Buffs, buff_ids = BuffIds} = S,
            Buff = #buff{
                name = Name
                ,args = Args
                ,bout = Bout
                ,id = Id
                ,trigger = Trigger
            },
            Buffs1 = lists:keystore(
                Name, #buff.name, Buffs, Buff),
            BuffIds1 = case Id == 0 orelse lists:member(Id, BuffIds) of
                true -> BuffIds;
                false -> [Id | BuffIds]
            end,
            S1 = S#s{buffs = Buffs1, buff_ids = BuffIds1},
            Rt1 = [S1 | Rt],
            set_buff(Targets, A, {Name, Args, Bout, Id, Trigger}, ExtArg, Rt1)
    end;
set_buff([], _, _, _, Rt) -> Rt.

%% 将所受的伤害比转化为攻击
%% atked2atk([S | Targets], A, V, Atked, Rt) ->
%%     Rt1 = case Atked > 0 of
%%         true ->
%%             #s{hp_max = HpMax, atk = Atk} = S,
%%             Rate = Atked / HpMax / V + 1,
%%             AtkAdd = util:ceil(Atk * Rate),
%%             [S#s{atk = AtkAdd} | Rt];
%%         false ->
%%             [S | Rt]
%%     end,
%%     atked2atk(Targets, A, V, Atked, Rt1);
%% atked2atk([], _, _, _, Rt) ->
%%     Rt.
%%增加光环后的攻击=基础攻击+基础攻击*（1-当前血量比例）/表内的值
atked2atk([S | Targets], A, V, _Atked, Rt) ->
    #s{hp_max = HpMax, hp = Hp, atk = Atk} = S,
    Rt1 = case HpMax > Hp of
        true ->
            Add = util:ceil(Atk * (1 - Hp / HpMax) * V),
            Atk1 = Atk + Add,
            %% ?INFO("atked2atk: ~w + ~w = ~w, Hp: ~w/~w", [Atk, Add, Atk1, Hp, HpMax]),
            [S#s{atk = Atk1} | Rt];
        false ->
            [S | Rt]
    end,
    atked2atk(Targets, A, V, _Atked, Rt1);
atked2atk([], _, _, _, Rt) ->
    Rt.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 设置每回合的状态
set_states(Ss, V) ->
    set_states(Ss, V, []).

set_states([S | Ss], V, Rt) ->
    S1 = set_state(S, V),
    set_states(Ss, V, [S1 | Rt]);
set_states([], _V, Rt) ->
    lists:reverse(Rt).

set_state(S, 0) ->
    S#s{state = 0};
set_state(S, V) ->
    S#s{state = S#s.state bor V}.

is_friend(A, B) ->
    (A#s.pos div 10) =:= (B#s.pos div 10).

is_super([#buff{name = super} | _Buffs]) ->
    true;
is_super([_ | Buffs]) ->
    is_super(Buffs);
is_super([]) ->
    false.
