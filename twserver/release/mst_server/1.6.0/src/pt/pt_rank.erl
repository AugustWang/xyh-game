%%----------------------------------------------------
%% $Id: pt_rank.erl 12474 2014-05-09 02:26:15Z piaohua $
%% @doc 协议29 - 排行榜
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_rank).
-export([handle/3]).

-include("common.hrl").
-include("equ.hrl").

%% 排行榜信息
handle(29010, [Type], Rs) ->
    case lists:member(Type, [1,2,3,4]) of
        true ->
            #role{luck = Luck, coliseum = Coliseum} = Rs,
            {_,_,_,Num} = Luck,
            Lev = case Coliseum == [] of
                true -> 6;
                false ->
                    [_, Lev1, _,_,_,_,_,_] = Coliseum,
                    Lev1
            end,
            rank ! {rank_list, Rs#role.pid_sender, Type, Num, Lev},
            {ok};
        false ->
            {ok, [Type, []]}
    end;

%% 查看英雄(机器人不可查看英雄之家,前端做限制)
handle(29020, [Id], Rs) ->
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
                            %% ?INFO("==Heroes3:~w", [Heroes3]),
                            {ok, [Heroes3]};
                        {'EXIT', Reason} ->
                            ?WARN("call pid_sender error: ~w", [Reason]),
                            {ok, []}
                    end
            end
    end;

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
