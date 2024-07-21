%%----------------------------------------------------
%% $Id: pt_attain.erl 13214 2014-06-05 09:15:25Z piaohua $
%% @doc 协议24 - 成就
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_attain).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_attain_test() ->
    Ids = data_attain:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_attain:get(Id),
                ?assert(util:get_val(type, Data, 0) > 0),
                ?assert(util:get_val(title, Data, 0) > 0),
                ?assert(util:get_val(tid, Data, 0) > 0),
                ?assert(util:get_val(condition, Data, 0) > 0),
                ?assert(case util:get_val(num, Data) of
                        {_, _} -> true;
                        Num when is_integer(Num) -> true;
                        _ -> false
                    end),
                ?assert(case util:get_val(title,Data) of
                        9 ->
                            {Toll1,Toll2} = case util:get_val(tollgate,Data) of
                                undefined -> {0, 0};
                                RR -> RR
                            end,
                            Toll1 > 0 andalso Toll2 > 0;
                        _ -> true
                end)
        end, Ids),
    ok.
-endif.

%% 领取成就
handle(24004, [Id], Rs) ->
    Attain = Rs#role.attain,
    case lists:keyfind(Id, 1, Attain) of
        false -> {ok, [127, 0, 0]};
        {Id, _, _, _, 1} ->
            Data = data_attain:get(Id),
            case util:get_val(tid, Data) of
                1 ->
                    PriceNum = util:get_val(num, Data),
                    Rs1 = lib_role:add_attr(gold, PriceNum, Rs),
                    Rs2 = lib_role:add_attr_ok(gold, 27, Rs, Rs1),
                    {NextId, State, Rs0} = attain_next(Id, Rs2),
                    lib_role:notice(Rs0),
                    {ok, [0, NextId, State], Rs0};
                2 ->
                    PriceNum = util:get_val(num, Data),
                    Rs1 = lib_role:add_attr(diamond, PriceNum, Rs),
                    Rs2 = lib_role:add_attr_ok(diamond, 27, Rs, Rs1),
                    {NextId, State, Rs0} = attain_next(Id, Rs2),
                    %% ?DEBUG("NextId:~w, State:~w ", [NextId, State]),
                    lib_role:notice(Rs0),
                    {ok, [0, NextId, State], Rs0};
                3 ->
                    PriceNum = util:get_val(num, Data),
                    Rs1 = lib_role:add_attr(luck, PriceNum, Rs),
                    lib_role:notice(luck, Rs1),
                    {NextId, State, Rs2} = attain_next(Id, Rs1),
                    {ok, [0, NextId, State], Rs2};
                5 ->
                    case length(Rs#role.heroes) < Rs#role.herotab of
                        true ->
                            {Tid, Quality} = util:get_val(num, Data),
                            {ok, Rs1, Hero} = mod_hero:add_hero(Rs, Tid, Quality),
                            {NextId, State, Rs2} = attain_next(Id, Rs1),
                            mod_hero:hero_notice(Rs2#role.pid_sender, Hero),
                            {ok, [0, NextId, State], Rs2#role{save = [heroes]}};
                        false ->
                            {Tid, Quality} = util:get_val(num, Data),
                            Title = data_text:get(2),
                            Body = data_text:get(12),
                            mod_mail:new_mail(Rs#role.id, 0, 27, Title, Body, [{5,{Tid, Quality}}]),
                            {NextId, State, Rs2} = attain_next(Id, Rs),
                            {ok, [3, NextId, State], Rs2}
                    end;
                Tid ->
                    PriceNum = util:get_val(num, Data),
                    case mod_item:add_item(Rs, Tid, PriceNum) of
                        {ok, Rs1, PA, EA} ->
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            {NextId, State, Rs2} = attain_next(Id, Rs1),
                            {ok, [0, NextId, State], Rs2#role{save = [items]}};
                        %% TODO:邮件系统
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id, 0, 27, Title, Body, [{Tid, PriceNum}]),
                            {NextId, State, Rs2} = attain_next(Id, Rs),
                            {ok, [3, NextId, State], Rs2};
                        {error, _} ->
                            {ok, [128, 0, 0]}
                    end
            end;
        _ -> {ok, [129, 0, 0]}
    end;

%% 初始化成就
handle(24006, [], Rs) ->
    case Rs#role.attain of
        [] ->
            ?WARN("MyAttain is null:", []),
            {ok, [[]]};
        Attain ->
            F = fun({Id,_Id2,Type,Num,State}) ->
                    case State < 2 of
                        true ->
                            case lists:member(Type,[2,3,4,5,6,7,8,60,35,37,52,53,54,55,56,57,33]) of
                                true -> [];
                                false ->
                                    {Id,Num,State}
                            end;
                        false -> []
                    end
            end,
            %% L = [{Id, Num, State} || {Id, _, _, Num, State} <- Attain, State < 2],
            L = [F(X) || X <- Attain, F(X) =/= []],
            {ok, [L]}
    end;

handle(_Cmd, _Data, _RoleState) ->
    {error, bad_request}.


%% === 私有函数 ===

%% 下一个成就
attain_next(Id, Rs) ->
    Data = data_attain:get(Id),
    %% Title = util:get_val(title,Data),
    MyAttain = Rs#role.attain,
    {A, B, C, D, _E} = lists:keyfind(Id, 1, MyAttain),
    %% 是否存在下一个成就
    case util:get_val(next, Data, 0) of
        0 ->
            Lists1 = lists:keyreplace(Id, 1, MyAttain, {A,B,C,D,2}),
            Rs1 = Rs#role{attain = Lists1},
            {0, 0, Rs1};
        NextId ->
            %% 是否已经完成可领取
            Data2 = data_attain:get(NextId),
            S = util:get_val(condition, Data2),
            State = case D >= S of
                true -> 1;
                false -> 0
            end,
            NextId2 = util:get_val(next, Data2, 0),
            Lists1 = {NextId, NextId2, C, D, State},
            Lists2 = lists:keyreplace(Id, 1, MyAttain, Lists1),
            Rs1 = Rs#role{attain = Lists2},
            {NextId, State, Rs1}
    end.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
