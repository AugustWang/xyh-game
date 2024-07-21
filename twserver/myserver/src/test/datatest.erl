%%----------------------------------------------------
%% data table test util
%%----------------------------------------------------
-module(datatest).
-export([
        test/0
        ,data_produce_rand_test/3
    ]).

-include("common.hrl").
-include("hero.hrl").

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
-endif.

-include_lib("eunit/include/eunit.hrl").

%% result necessary include data fields id
test() ->
    io:format("data_attain test result : ~w~n", [data_attain_test()]),
    io:format("data_robot_new test result : ~w~n", [data_robot_new_test()]),
    io:format("data_tollgate test result : ~w~n", [data_tollgate_test()]),
    io:format("data_produce test result : ~w~n", [data_produce_test()]),
    io:format("data_mail_prize test result : ~w~n", [data_mail_prize_test()]),
    io:format("data_reg_prize test result : ~w~n", [data_reg_prize_test()]),
    io:format("data_power_multiple test result : ~w~n", [data_power_multiple_test()]),
    io:format("data_first_pay test result : ~w~n", [data_first_pay_test()]),
    io:format("data_diamond_shop test result : ~w~n", [data_diamond_shop_test()]),
    io:format("data_hero test result : ~w~n", [data_hero_test()]),
    io:format("data_hero_rare test result : ~w~n", [data_hero_rare_test()]),
    io:format("data_equ test result : ~w~n", [data_equ_test()]),
    io:format("data_prop test result : ~w~n", [data_prop_test()]),
    io:format("data_luck test result : ~w~n", [data_luck_test()]),
    io:format("data_sign test result : ~w~n", [data_sign_test()]),
    io:format("data_vip test result : ~w~n", [data_vip_test()]),
    io:format("data_forge test result : ~w~n", [data_forge_test()]),
    io:format("data_monster test result : ~w~n", [data_monster_test()]),
    io:format("data_exp test result : ~w~n", [data_exp_test()]),
    io:format("data_gate_buy test result : ~w~n", [data_gate_buy_test()]),
    io:format("data_hero_total test result : ~w~n", [data_hero_total_test()]),
    io:format("data_config_herosoul test result : ~w~n", [data_config_herosoul_test()]),
    io:format("data_herosoul test result : ~w~n", [data_herosoul_test()]),
    io:format("data_herosoul_id test result : ~w~n", [data_herosoul_id_test()]),
    io:format("data_task test result : ~w~n", [data_task_test()]),
    ok.

%%' data_attain_test
data_attain_test() ->
    Ids = data_attain:get(ids),
    data_attain_test(Ids, []).
data_attain_test([], Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_attain_test([H|T], Rt) ->
    Data = data_attain:get(H),
    Tid = util:get_val(tid,Data,0),
    Num = util:get_val(num,Data),
    Rt1 = case util:get_val(tid,Data,0) > 0 andalso
        util:get_val(type,Data,0) > 0 andalso
        util:get_val(title,Data,0) > 0 andalso
        util:get_val(tid,Data,0) > 0 andalso
        util:get_val(condition,Data,0) > 0 of
        true ->
            case Tid < ?MIN_EQU_ID of
                true ->
                    case Tid == 5 of
                        true ->
                            case util:get_val(num,Data) of
                                {_,_} -> [];
                                R -> [{H,{Tid,R}}]
                            end;
                        false ->
                            case Num > 0 of
                                true -> [];
                                false -> [{H,{Tid,Num}}]
                            end
                    end;
                false ->
                    case data_equ:get(Tid) of
                        undefined -> [{H,Tid}];
                        _ -> []
                    end
            end;
        false -> [H]
    end,
    Rt2 = case util:get_val(title,Data) of
        9 ->
            case util:get_val(tollgate,Data) of
                {Toll1,Toll2} when Toll1 > 0 andalso Toll2 > Toll1 -> [];
                R2 -> R2
            end;
        _ -> []
    end,
    data_attain_test(T,Rt1 ++ Rt2 ++ Rt).
%%.

%%' data_robot_new_test
data_robot_new_test() ->
    Ids1 = data_robot_new:get(ids),
    Ids2 = data_robot_new2:get(ids),
    data_robot_new_test(Ids1, Ids2, []).
data_robot_new_test([], _L, Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_robot_new_test([H|T], L, Rt) ->
    Data = data_robot_new:get(H),
    Rt1 = case length(Data) =< 4 andalso length(Data) > 0 of
        true -> [];
        false -> [H]
    end,
    Rt2 = case lists:member(H, L) of
        true -> [];
        false -> [H]
    end,
    data_robot_new_test(T, L, Rt1++Rt2++Rt).
%%.

%%' data_tollgate_test
data_tollgate_test() ->
    Ids = data_tollgate:get(ids),
    data_tollgate_test(Ids, []).
data_tollgate_test([], Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_tollgate_test([H|T], Rt) ->
    Data = data_tollgate:get(H),
    Monsters = util:get_val(monsters,Data),
    Produce = util:get_val(produce, Data),
    Rt1 = case util:find_repeat_element(Monsters) of
        [] ->
            Monsters1 = data_tollgate_fields_monsters(Monsters,[]),
            case Monsters1 of
                [] -> [];
                _ -> [{monster,H,Monsters1}]
            end;
        _ ->  [{monster,H,Monsters}]
    end,
    Rt2 = case util:find_repeat_element(Produce) of
        [] ->
            Produce1 = data_tollgate_fields_produce(Produce,[]),
            case Produce1 of
                [] -> [];
                _ -> [{produce,H,Produce1}]
            end;
        _ -> [{produce,H,Produce}]
    end,
    Rt3 = case H of
        {1, _} ->
            case util:get_val(nightmare,Data) of
                undefined -> [];
                Nightmare ->
                    Nightmare1 = data_tollgate_fields_consume(Nightmare),
                    case Nightmare1 of
                        [] -> [];
                        _ -> [{nightmare,H,Nightmare1}]
                    end
            end;
        _ -> []
    end,
    Rt4 = case util:get_val(exp,Data,0) >= 0 andalso
        util:get_val(gold,Data,0) > 0 andalso
        util:get_val(power,Data,0) > 0 andalso
        util:get_val(combat,Data,0) > 0 of
        true -> [];
        false -> [{H}]
    end,
    Rt5 = case util:get_val(mate,Data) of
        undefined -> [];
        Mate -> data_tollgate_fields_mate(Mate,[])
    end,
    data_tollgate_test(T,Rt1++Rt2++Rt3++Rt4++Rt5++Rt).


data_tollgate_fields_monsters([],Rt) -> Rt;
data_tollgate_fields_monsters([{Id,_Pos}|T]=L,Rt) ->
    L1 = [X||{_,X}<-L],
    Rt1 = case util:find_repeat_element(L1) of
        [] ->
            case data_monster:get(Id) of
                undefined -> [{Id}];
                _ -> []
            end;
        _ -> L
    end,
    data_tollgate_fields_monsters(T,Rt1 ++ Rt).

data_tollgate_fields_produce([],Rt) -> Rt;
data_tollgate_fields_produce([{Type,Num,Id}|T]=L,Rt) ->
    Rt1 = case Type > 0 andalso Num > 0 of
        true ->
            case data_produce:get(Id) of
                undefined -> [{Id}];
                _ -> []
            end;
        false -> L
    end,
    data_tollgate_fields_produce(T,Rt1++Rt);
data_tollgate_fields_produce(L,[]) -> L.

data_tollgate_fields_consume(Id) ->
    case data_tollgate:get({5,Id}) of
        undefined -> {Id};
        _Data ->
            []
            %% case util:get_val(consume,Data) of
            %%     undefined -> {Data};
            %%     Consume ->
            %%         F = fun(X,Y) ->
            %%                 case Y > 0 of
            %%                     true ->
            %%                         case data_prop:get(X) of
            %%                             undefined -> X;
            %%                             _ -> 0
            %%                         end;
            %%                     false -> X
            %%                 end
            %%         end,
            %%         [F(X1,X2)||{X1,X2}<-Consume,F(X1,X2)>0]
            %% end
    end.

data_tollgate_fields_mate([],Rt) -> Rt;
data_tollgate_fields_mate([{Id,Pos}|T],Rt) ->
    Rt1 = case data_monster:get(Id) of
        undefined -> [{mate,Id,Pos}];
        _ -> []
    end,
    L = lists:seq(1,9),
    Rt2 = case lists:member(Pos,L) of
        true -> [];
        false -> [{mate,Id,Pos}]
    end,
    data_tollgate_fields_mate(T,Rt1++Rt2++Rt).

%%.

%%' data_produce_test
data_produce_test() ->
    Ids = data_produce:get(ids),
    data_produce_test(Ids, []).
data_produce_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_produce_test([H|T],Rt) ->
    Data = data_produce:get(H),
    Rt1 = case data_produce_field(Data,0,[]) of
        [] -> [];
        R -> [{H,R}]
    end,
    data_produce_test(T,Rt1++Rt).
data_produce_field([],_,Rt) -> Rt;
data_produce_field([{Id,{Num1,Num2}}|T]=L,Num3,Rt) ->
    case Num1 > Num3 andalso Num2 >= Num1 of
        true ->
            Rt1 = case Id == 0 of
                true -> [];
                false ->
                    case Id < ?MIN_EQU_ID of
                        true ->
                            case data_prop:get(Id) of
                                undefined -> L;
                                _ -> []
                            end;
                        false ->
                            case data_equ:get(Id) of
                                undefined -> L;
                                _ -> []
                            end
                    end
            end,
            data_produce_field(T,Num2,Rt1++Rt);
        false ->
            L
    end.
%%.

%%' data_mail_prize_test
data_mail_prize_test() ->
    Ids = data_mail_prize:get(ids),
    data_mail_prize_test(Ids, []).
data_mail_prize_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_mail_prize_test([H|T],Rt) ->
    Data = data_mail_prize:get(H),
    Rt1 = case util:get_val(prize,Data) of
        undefined -> [{H}];
        Prize ->
            case data_mail_prize_field(Prize,[]) of
                [] -> [];
                R -> [{H,R}]
            end
    end,
    data_mail_prize_test(T,Rt1++Rt).
data_mail_prize_field([],Rt) -> Rt;
data_mail_prize_field([{Id,Num}|T]=L,Rt) ->
    case Num > 0 of
        true ->
            Rt1 = case Id < ?MIN_EQU_ID of
                true ->
                    case data_prop:get(Id) of
                        undefined -> L;
                        _ -> []
                    end;
                false ->
                    case data_equ:get(Id) of
                        undefined -> L;
                        _ -> []
                    end
            end,
            data_mail_prize_field(T,Rt1++Rt);
        false -> L
    end.
%%.

%%' data_reg_prize_test
data_reg_prize_test() ->
    Ids = data_reg_prize:get(ids),
    data_reg_prize_test(Ids, []).
data_reg_prize_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_reg_prize_test([H|T],Rt) ->
    Data = data_reg_prize:get(H),
    Rt1 = case util:get_val(prize,Data) of
        undefined -> [{H}];
        Prize ->
            case data_reg_prize_field(Prize,[]) of
                [] -> [];
                R -> [{H,R}]
            end
    end,
    data_reg_prize_test(T,Rt1++Rt).
data_reg_prize_field([],Rt) -> Rt;
data_reg_prize_field([{Id,Num}|T]=L,Rt) ->
    case Num > 0 of
        true ->
            Rt1 = case Id < ?MIN_EQU_ID of
                true ->
                    case data_prop:get(Id) of
                        undefined -> L;
                        _ -> []
                    end;
                false ->
                    case data_equ:get(Id) of
                        undefined -> L;
                        _ -> []
                    end
            end,
            data_reg_prize_field(T,Rt1++Rt);
        false -> L
    end.
%%.

%%' data_power_multiple_test
data_power_multiple_test() ->
    Ids = data_power_multiple:get(ids),
    F = fun(Id) ->
            Data = data_power_multiple:get(Id),
            case util:get_val(multiple,Data) of
                N when N > 0 -> 0;
                _ -> Id
            end
    end,
    L = [F(X)||X<-Ids,F(X)>0],
    case L == [] of
        true -> pass;
        false -> L
    end.
%%.

%%' data_first_pay_test
data_first_pay_test() ->
    Ids = data_first_pay:get(ids),
    data_first_pay_field(Ids,[]).
data_first_pay_field([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_first_pay_field([H|T],Rt) ->
    Data = data_first_pay:get(H),
    Id = util:get_val(tid,Data),
    Num = util:get_val(num,Data),
    Rt1 = case Id < ?MIN_EQU_ID of
        true ->
            case Id == 5 of
                true ->
                    {Hid,_Q} = Num,
                    case data_hero:get(Hid) of
                        undefined -> {H};
                        _ -> []
                    end;
                false ->
                    case data_prop:get(Id) of
                        undefined -> {H};
                        _ -> []
                    end
            end;
        false ->
            case data_equ:get(Id) of
                undefined -> {H};
                _ -> []
            end
    end,
    data_first_pay_field(T,Rt1++Rt).
%%.

%%' data_diamond_shop_test
data_diamond_shop_test() ->
    Ids = data_diamond_shop:get(ids),
    F = fun(X) ->
            Data = data_diamond_shop:get(X),
            util:get_val(shopid,Data,0)
    end,
    ShopIds = [F(X1) || X1 <- Ids],
    case util:find_repeat_element(ShopIds) of
        [] -> data_diamond_shop_test(Ids, []);
        _ -> ShopIds
    end.
data_diamond_shop_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_diamond_shop_test([H|T],Rt) ->
    Data = data_diamond_shop:get(H),
    Rt1 = case util:get_val(tier,Data,0) > 0 andalso
        util:get_val(rmb,Data,0) > 0 andalso
        util:get_val(diamond,Data,0) > 0 andalso
        util:get_val(shopid,Data,0) > 0 andalso
        util:get_val(double,Data,0) >=0 of
        true -> [];
        false -> [{H}]
    end,
    data_diamond_shop_test(T,Rt1++Rt).
%%.

%%' data_hero_test
data_hero_test() ->
    Ids = data_hero:get(ids),
    data_hero_test(Ids,[]).
data_hero_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_hero_test([H|T],Rt) ->
    Data = data_hero:get(H),
    S1 = util:get_val(skill1,Data,0),
    S2 = util:get_val(skill2,Data,0),
    S3 = util:get_val(skill3,Data,0),
    L1 = [X||X<-[S1,S2,S3],X=/=0],
    Rt1 = case util:get_val(job,Data,0) > 0 andalso
        util:get_val(sort,Data,0) > 0 andalso
        util:get_val(atk_type,Data,0) > 0 andalso
        util:get_val(rare,Data,0) > 0 andalso
        util:get_val(atk,Data,0) > 0 andalso
        util:get_val(hp,Data,0) > 0 andalso
        util:get_val(def,Data,0) > 0 andalso
        util:get_val(pun,Data,0) > 0 andalso
        util:get_val(hit,Data,0) > 0 andalso
        util:get_val(dod,Data,0) > 0 andalso
        util:get_val(crit,Data,0) > 0 andalso
        util:get_val(crit_num,Data,0) > 0 andalso
        util:get_val(crit_anti,Data,0) > 0 andalso
        util:get_val(tou,Data,0) >= 0 andalso
        util:get_val(tou,Data) /= undefined andalso
        util:get_val(foster,Data,0) > 0 of
        true -> [];
        false -> [{H}]
    end,
    F1 = fun(I) ->
            case data_skill:get(I) of
                undefined -> I;
                _ -> 0
            end
    end,
    L2 = [F1(X1)||X1<-L1,F1(X1)=/=0],
    Rt2 = case L2 of
        [] -> [];
        R -> [{H,R}]
    end,
    Rt3 = case util:get_val(items,Data) of
        undefined -> [{H}];
        Items ->
            F2 = fun(I1,I2) ->
                    case data_prop:get(I1) of
                        undefined -> {I1,I2};
                        _ ->
                            case I2 > 0 of
                                true -> 0;
                                false -> {I1,I2}
                            end
                    end
            end,
            L3 = [F2(X3,X4)||{X3,X4}<-Items,F2(X3,X4)=/=0],
            case L3 of
                [] -> [];
                _ -> L3
            end
    end,
    data_hero_test(T,Rt1++Rt2++Rt3++Rt).

data_hero_rare_test() ->
    Ids = data_hero_rare:get(ids),
    {_R1, R2} = data_hero_rare:get(range),
    %% L1 = lists:flatten([tuple_to_list(X)||X<-Ids]),
    %% R3 = lists:max(L1),
    {_,R3} = lists:last(Ids),
    case R2 == R3 of
        true ->
            L2 = [data_hero_rare:get(X1)||X1<-Ids],
            F = fun({E}) -> E > 0 end,
            case lists:all(F,L2) of
                true -> pass;
                false -> [{L2}]
            end;
        false -> [{range,R2,R3}]
    end.
%%.

%%' data_equ_test
data_equ_test() ->
    Ids = data_equ:get(ids),
    data_equ_test(Ids,[]).
data_equ_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_equ_test([H|T],Rt) ->
    Data = data_equ:get(H),
    Rt1 = case util:get_val(sort,Data) /= 21 of
        true ->
            case util:get_val(sell,Data,0) > 0 andalso
                util:get_val(sort,Data,0) > 0 andalso
                util:get_val(pos,Data,0) > 0 andalso
                util:get_val(quality,Data,0) > 0 andalso
                util:get_val(enhance_gold_arg,Data,0) > 0 andalso
                util:get_val(enhance_rate_arg,Data,0) > 0 andalso
                util:get_val(lev,Data,0) > 0 andalso
                util:get_val(price,Data,0) > 0 andalso
                util:get_val(atk,Data,0) > 0 andalso
                util:get_val(hp,Data,0) > 0 andalso
                util:get_val(def,Data,0) > 0 andalso
                util:get_val(pun,Data,0) > 0 andalso
                util:get_val(hit,Data,0) > 0 andalso
                util:get_val(dod,Data,0) > 0 andalso
                util:get_val(crit,Data,0) > 0 andalso
                util:get_val(crit_num,Data,0) > 0 andalso
                util:get_val(crit_anti,Data,0) > 0 andalso
                util:get_val(tou,Data,0) >= 0 andalso
                util:get_val(tou,Data) /= undefined andalso
                util:get_val(sockets,Data,0) > 0 of
                true -> [];
                false -> [{H}]
            end;
        false -> []
    end,
    Rt2 = case H > ?MIN_EQU_ID of
        true -> [];
        false -> [{H}]
    end,
    data_equ_test(T,Rt1++Rt2++Rt).
%%.

%%' data_prop_test
data_prop_test() ->
    Ids = data_prop:get(ids),
    data_prop_test(Ids,[]).
data_prop_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_prop_test([H|T],Rt) ->
    Data = data_prop:get(H),
    Rt1 = case H < ?MIN_EQU_ID andalso
        util:get_val(tab,Data,0) > 0 andalso
        util:get_val(quality,Data,0) > 0 andalso
        util:get_val(sort,Data,0) > 0 andalso
        util:get_val(num_max,Data,0) > 0 andalso
        util:get_val(sell,Data,0) > 0 andalso
        util:get_val(price,Data,0) > 0 of
        true -> [];
        false -> [{prop,H}]
    end,
    Rt2 = case util:get_val(sort,Data) == 4 of
        true ->
            case util:get_val(num_max,Data) == 1 andalso
                util:get_val(control1,Data,0) > 0 andalso
                util:get_val(control2,Data,0) > 0 of
                true -> [];
                false -> [{jewel,H}]
            end;
        false -> []
    end,
    data_prop_test(T,Rt1++Rt2++Rt).
%%.

%%' data_luck_test
data_luck_test() ->
    Ids = data_luck:get(ids),
    data_luck_test(Ids,[]).
data_luck_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_luck_test([H|T]=Ids,Rt) ->
    Data = data_luck:get(H),
    Rt1 = case lists:all(fun(X) ->
                    length(data_luck:get(X)) =:= 14
            end, Ids) of
        true -> [];
        false -> [{Ids}]
    end,
    Rt2 = data_luck_test1(Data,[]),
    data_luck_test(T,Rt1++Rt2++Rt).
data_luck_test1([],Rt) -> Rt;
data_luck_test1([{A,B,C,D,E,F,G}=H|T],Rt) ->
    Rt1 = case A < ?MIN_EQU_ID of
        true ->
            case A == 5 of
                true ->
                    {Hid,_Q} = C,
                    case data_hero:get(Hid) of
                        undefined -> {H};
                        _ -> []
                    end;
                false ->
                    case data_prop:get(A) of
                        undefined -> [{prop,H}];
                        _ -> []
                    end
            end;
        false ->
            case data_equ:get(A) of
                undefined -> [{equ,H}];
                _ -> []
            end
    end,
    Rt2 = case  A > 0 andalso B > 0 andalso
        E > 0 andalso D > 0 andalso
        F > 0 andalso G > 0 of
        true -> [];
        false -> [H]
    end,
    data_luck_test1(T,Rt1++Rt2++Rt).
%%.

%%' data_sign_test
data_sign_test() ->
    Ids = data_sign:get(ids),
    data_sign_test(Ids,[]).
data_sign_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_sign_test([H|T],Rt) ->
    Data = data_sign:get(H),
    Rt1 = case util:get_val(coin,Data,0) > 0 andalso
        util:get_val(diamond,Data,0) > 0 of
        true -> [];
        false -> [{H}]
    end,
    Rt2 = case util:get_val(hero,Data) of
            undefined -> [];
            {Hid,Q} ->
                case data_hero:get(Hid) =/= undefined andalso
                    Q > 0 of
                    true -> [];
                    false -> [{H,{Hid,Q}}]
                end;
            _ -> [{H}]
        end,
        Rt3 = case util:get_val(tid_num,Data) of
            undefined -> [];
            TidNum ->
                data_sign_test1(TidNum,[])
        end,
        data_sign_test(T,Rt1++Rt2++Rt3++Rt).

data_sign_test1([],Rt) -> Rt;
data_sign_test1([{Id,Num}|T]=L,Rt) ->
    case Num > 0 of
        true ->
            Rt1 = case Id < ?MIN_EQU_ID of
                true ->
                    case data_prop:get(Id) of
                        undefined -> L;
                        _ -> []
                    end;
                false ->
                    case data_equ:get(Id) of
                        undefined -> L;
                        _ -> []
                    end
            end,
            data_sign_test1(T,Rt1++Rt);
        false -> L
    end.
%%.

%%' data_vip_test
data_vip_test() ->
    Ids = data_vip:get(ids),
    data_vip_test(Ids,[]).
data_vip_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_vip_test([H|T],Rt) ->
    Data = data_vip:get(H),
    F = fun({X1,X2}) ->
            case X1 of
                fast ->
                    is_atom(X1) andalso is_integer(X2) andalso X2 >= 10;
                _ ->
                    is_atom(X1) andalso is_integer(X2)
            end
    end,
    Rt1 = case lists:all(F,Data) of
        true -> [];
        false -> Data
    end,
    data_vip_test(T,Rt1++Rt).
%%.

%%' data_forge_test
data_forge_test() ->
    Ids = data_forge:get(ids),
    data_forge_test(Ids,[]).
data_forge_test([],Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_forge_test([H|T],Rt) ->
    {Send,Rate,Del,Type,Price,Dels} = data_forge:get(H),
    Rt1 = case H < ?MIN_EQU_ID of
        true ->
            case data_prop:get(H) of
                undefined -> [{H}];
                _ -> []
            end;
        false ->
            case data_equ:get(H) of
                undefined -> [{H}];
                _ -> []
            end
    end,
    Rt2 = case Send > 0 andalso
        Rate > 0 andalso
        Del > 0 andalso
        Type > 0 andalso
        Price > 0 of
        true -> [];
        false -> [{H}]
    end,
    Rt3 = data_forge_test1(Dels, []),
    data_forge_test(T,Rt1++Rt2++Rt3++Rt).

data_forge_test1([],Rt) -> Rt;
data_forge_test1([{Id,Num}|T]=L,Rt) ->
    case Num > 0 of
        true ->
            Rt1 = case Id < ?MIN_EQU_ID of
                true ->
                    case data_prop:get(Id) of
                        undefined -> L;
                        _ -> []
                    end;
                false ->
                    case data_equ:get(Id) of
                        undefined -> L;
                        _ -> []
                    end
            end,
            data_forge_test1(T,Rt1++Rt);
        false -> L
    end.
%%.

%%' data_produce_rand_test
data_produce_rand_test(Num,Id1,Id2) ->
    case data_tollgate:get({Id1,Id2}) of
        undefined ->
            io:format("fault tollgate id~n");
        Data ->
            Produce = util:get_val(produce,Data),
            Rt = data_produce_rand_test1(Num,Produce,[]),
            io:format("tollgate {~w,~w} test ~w result:~w~n", [Id1,Id2,Num,Rt])
    end.
data_produce_rand_test1(Num,Produce,Rt) ->
    case Num < 0 of
        true -> Rt;
        false ->
            Ids = mod_item:get_produce_ids(Produce,[]),
            Rt1 = data_produce_rand_test2(Ids,Rt),
            data_produce_rand_test1(Num-1,Produce,Rt1)
    end.
data_produce_rand_test2([],Rt) -> Rt;
data_produce_rand_test2([H|T],Rt) ->
    case lists:keyfind(H,1,Rt) of
        false ->
            data_produce_rand_test2(T,[{H,1}|Rt]);
        {H,N} ->
            Rt1 = lists:keyreplace(H,1,Rt,{H,N+1}),
            data_produce_rand_test2(T,Rt1)
    end.
%%.

%%' data_monster_test
data_monster_test() ->
    Ids = data_monster:get(ids),
    data_monster_test(Ids, []).
data_monster_test([], Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_monster_test([H|T], Rt) ->
    Data = data_monster:get(H),
    S1 = util:get_val(skill1,Data,0),
    S2 = util:get_val(skill2,Data,0),
    S3 = util:get_val(skill3,Data,0),
    L1 = [X||X<-[S1,S2,S3],X=/=0],
    Rt1 = case util:get_val(atk,Data,0) > 0 andalso
        util:get_val(hp,Data,0) > 0 andalso
        util:get_val(def,Data,0) >= 0 andalso
        util:get_val(pun,Data,0) >= 0 andalso
        util:get_val(hit,Data,0) >= 0 andalso
        util:get_val(dod,Data,0) >= 0 andalso
        util:get_val(crit,Data,0) >= 0 andalso
        util:get_val(crit_num,Data,0) >= 0 andalso
        util:get_val(crit_anti,Data,0) >= 0 andalso
        util:get_val(tou,Data,0) >= 0 andalso
        util:get_val(tou_anit,Data,0) >= 0 andalso
        util:get_val(def,Data) /= undefined andalso
        util:get_val(pun,Data) /= undefined andalso
        util:get_val(hit,Data) /= undefined andalso
        util:get_val(dod,Data) /= undefined andalso
        util:get_val(tou,Data) /= undefined andalso
        util:get_val(crit,Data) /= undefined andalso
        util:get_val(crit_num,Data) /= undefined andalso
        util:get_val(crit_anti,Data) /= undefined of
        true -> [];
        false -> [{H}]
    end,
    F1 = fun(I) ->
            case data_skill:get(I) of
                undefined -> I;
                _ -> 0
            end
    end,
    L2 = [F1(X1)||X1<-L1,F1(X1)=/=0],
    Rt2 = case L2 of
        [] -> [];
        _ -> [{H,{skill,L2}}]
    end,
    data_monster_test(T,Rt1++Rt2++Rt).
%%.

%%' data_exp_test
data_exp_test() ->
    Ids = data_exp:get(ids),
    Ids2 = lists:seq(1, length(Ids)),
    case Ids == Ids2 of
        true ->
            data_exp_test(Ids, []);
        false ->
            Ids
    end.
data_exp_test([], Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_exp_test([H|T], Rt) ->
    Data = data_exp:get(H),
    Rt1 = case util:get_val(exp_max,Data,0) > 0 andalso
        util:get_val(exp_sum,Data,0) > 0 of
        true -> [];
        false ->
            case H of
                1 -> [];
                _ -> [H]
            end
    end,
    Rt2 = case util:get_val(item,Data) of
        undefined -> [];
        Item ->
            data_exp_test1(Item, [])
    end,
    data_exp_test(T, Rt1++Rt2++Rt).
data_exp_test1([], Rt) -> Rt;
data_exp_test1([{Id,Num}|Item], Rt) ->
    Ids = data_prop:get(ids),
    Rt1 = case lists:member(Id,Ids) andalso Num > 0 of
        true -> [];
        false -> [{Id,Num}]
    end,
    data_exp_test1(Item, Rt1 ++ Rt).
%%.

%%' data_gate_buy_test
data_gate_buy_test() ->
    IdList = data_gate_buy:get(ids),
    data_gate_buy_test(IdList, []).

data_gate_buy_test([], Ret) ->
    if  Ret == [] ->
            pass;
        true ->
            Ret
    end;
data_gate_buy_test([H|T], Ret) ->
    OneTupleList = data_gate_buy:get(H),
    Q = util:get_val(quality,OneTupleList),
    Level = util:get_val(level,OneTupleList),
    PointID = util:get_val(pointID,OneTupleList),
    case length(OneTupleList) == 8 andalso
        OneTupleList /= undefined andalso
        Level > 0 andalso is_integer(Level) andalso
        Q > 0 andalso is_integer(Q) andalso
        PointID > 0 andalso is_integer(PointID) of
        true ->
            case util:get_val(heroID,OneTupleList) of
                undefined ->
                    data_gate_buy_test(T,[H]++Ret);
                Id ->
                    case data_hero:get(Id) of
                        List when is_list(List) ->
                            data_gate_buy_test(T,Ret);
                        _ ->
                            data_gate_buy_test(T,[H]++Ret)
                    end
            end;
        false ->
            data_gate_buy_test(T,[H]++Ret)
    end.
data_hero_total_test() ->
    IdList = data_hero_total:get(ids),
    if  IdList == [] ->
            [];
        true ->
            data_hero_total_test(IdList, [])
    end.

data_hero_total_test([], Ret) ->
    if  Ret == [] ->
            pass;
        true ->
            Ret
    end;
data_hero_total_test([H|T], Ret) ->
    TupleList = data_hero_total:get(H),
    case length(TupleList) == 1 andalso H > 0 of
            true ->
                MaxCount = util:get_val(maxcount,TupleList),
                case is_integer(MaxCount) andalso
                    MaxCount > 0 of
                    true ->
                        data_hero_total_test(T, Ret);
                    false ->
                        data_hero_total_test(T, Ret++[H])
                end;
            false ->
                data_hero_total_test(T, Ret++[H])
    end.
%%.

%%' 配置数据中命运之轮数据
data_config_herosoul_test() ->
    ItemList  = [herosoul_cd,
        herosoul_refresh,
        herosoul_cq,
        herosoul_coin_cd,
        herosoul_coin_count,
        herosoul_cq_times ],
    check_config_hs(ItemList, []).

check_config_hs([],Ret) ->
    if  Ret == [] ->
            pass;
        true ->
            Ret
    end;
check_config_hs([H|T],Ret) ->
    case data_config:get(H) of
        undefined ->
            check_config_hs(T,[H|Ret]);
        Number ->
            if  is_integer(Number) andalso Number >= 0 ->
                    check_config_hs(T,Ret);
                true ->
                    check_config_hs(T,[H|Ret])
            end
    end.
%%.

%%' data_herosoul
data_herosoul_test() ->
    IdList = data_herosoul:get(ids),
    case IdList == lists:seq(1,9) of
        true ->
            data_herosoul_test(IdList, []);
        false ->
            IdList
    end.

data_herosoul_test([], Ret) ->
    if  Ret == [] ->
            pass;
        true ->
            Ret
    end;
data_herosoul_test([H|T], Ret) ->
    case data_herosoul:get(H) of
        undefined ->
            data_herosoul_test(T, [H|Ret]);
        [{proportion, TupleList}, {rate,Value}|_] ->
            case is_prop(TupleList) andalso is_number(Value) of
                true ->
                    data_herosoul_test(T, Ret);
                false ->
                    data_herosoul_test(T, [H|Ret])
            end
    end.

is_prop(Tp) ->
    if  is_list(Tp) ->
            is_prop(Tp, true);
        true ->
            false
    end.
is_prop([], Ret) ->
    Ret;
is_prop([{Rare,Prop}|T], Ret) ->
    if  is_integer(Rare) andalso is_integer(Prop) ->
           is_prop(T, Ret);
       true ->
           false
    end.
%%.

%%' 英雄魂表测试
data_herosoul_id_test() ->
    RareList = lists:seq(1,8),
    data_herosoul_id_test(RareList, []).

data_herosoul_id_test([], Ret) ->
    if  Ret == [] ->
            pass;
        true ->
            Ret
    end;
data_herosoul_id_test([H|T], Ret) ->
    case data_herosoul_id:get(H) of
        undefined ->
            data_herosoul_id_test(T, [H|Ret]);
        [{id_list, IdList}] ->
            NotFoundIdListt = id_can_not_find(IdList),
            if  NotFoundIdListt == [] ->
                    data_herosoul_id_test(T, Ret);
                true ->
                    data_herosoul_id_test(T, [H|Ret])
            end
    end.

%% 道具表中找不到的id
id_can_not_find(IdList) ->
    id_can_not_find(IdList, []).

id_can_not_find([], Ret) ->
    Ret;
id_can_not_find([H|T], Ret) ->
    case data_prop:get(H) of
        undefined->
            [Ret|H];
        _ ->
            id_can_not_find(T,Ret)
    end.
%%.

%%' data_task
data_task_test() ->
    Ids = data_task:get(ids),
    data_task_test(Ids, []).

data_task_test([], Rt) ->
    case Rt == [] of
        true -> pass;
        false -> Rt
    end;
data_task_test([Id|Ids], Rt) ->
    Data = data_task:get(Id),
    Rt1 = case util:get_val(type,Data,0) > 0 andalso
        util:get_val(target,Data,0) > 0 andalso
        util:get_val(lev1,Data,0) >= 0 andalso
        util:get_val(lev2,Data,0) >= 0 andalso
        is_list(util:get_val(award,Data)) andalso
        is_list(util:get_val(condition,Data)) of
        true -> [];
        false -> [{ids,Id}]
    end,
    Target = util:get_val(target,Data),
    Con = util:get_val(condition,Data),
    Be1 = util:get_val(before1,Data),
    Be2 = util:get_val(before2,Data),
    Award = util:get_val(award,Data),
    Rt2 = data_task_test1(Con,[]),
    Rt3 = data_task_test2(Be1,[]),
    Rt4 = data_task_test2(Be2,[]),
    Rt5 = data_task_award_field(Award,[]),
    Rt6 = data_task_condition_field(Con,Target,[]),
    data_task_test(Ids,Rt1++Rt2++Rt3++Rt4++Rt5++Rt6++Rt).

data_task_test1([], Rt) -> Rt;
data_task_test1([{C1,C2}|C3],Rt) when is_integer(C1) andalso is_integer(C2) ->
    data_task_test1(C3,Rt);
data_task_test1([C1|_C2],Rt) -> [{condition,C1}|Rt].

data_task_test2([], Rt) -> Rt;
data_task_test2(undefined, Rt) -> Rt;
data_task_test2([Id|Ids], Rt) ->
    List = data_task:get(ids),
    case lists:member(Id,List) of
        true -> data_task_test2(Ids, Rt);
        false -> data_task_test2(Ids, [{before,Id}|Rt])
    end.

data_task_condition_field([],_Target,Rt) -> Rt;
data_task_condition_field([{Id,Num}|T],Target,Rt) ->
    case Target of
        2 ->
            case data_monster:get(Id) of
                undefined ->
                    data_task_condition_field(T,Target,[{Id,Num}|Rt]);
                _ ->
                    data_task_condition_field(T,Target,Rt)
            end;
        _ ->
            data_task_condition_field(T,Target,Rt)
    end.

data_task_award_field([],Rt) -> Rt;
data_task_award_field([{Id,Num}|T]=L,Rt) ->
    case Num > 0 of
        true ->
            Rt1 = case Id < ?MIN_EQU_ID of
                true ->
                    case Id == 5 of
                        true ->
                            {Hid,_Q} = Num,
                            case data_hero:get(Hid) of
                                undefined -> {Id,Num};
                                _ -> []
                            end;
                        false ->
                            case data_prop:get(Id) of
                                undefined -> [{prop,Id,Num}];
                                _ -> []
                            end
                    end;
                false ->
                    case data_equ:get(Id) of
                        undefined -> [{equ,Id,Num}];
                        _ -> []
                    end
            end,
            data_task_award_field(T,Rt1++Rt);
        false -> L
    end.

%%.

%% private fun


%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
