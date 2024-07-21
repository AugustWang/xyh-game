%%----------------------------------------------------
%% $Id: pt_video.erl 12385 2014-05-05 07:42:46Z piaohua $
%% @doc 协议34 - 录像
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_video).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").

%% 获取战报录像排行榜
handle(34010, [Id], Rs) ->
    video ! {get_rank, Rs#role.pid_sender, Id},
    {ok};
    %% Rank = case Id > 0 andalso Id < 451 of
    %%     true ->
    %%         List = mod_video:get_report_list(Id),
    %%         report_list(List);
    %%     false ->
    %%         []
    %% end,
    %% {ok, [Rank]};

%% 获取战报数据录像
handle(34020, [Id1, Id2], Rs) ->
    video ! {get_video, Rs#role.pid_sender, Id1, Id2},
    {ok};
    %% L1 = lists:seq(1, 450),
    %% L2 = lists:seq(1, 3),
    %% [H, D] = case lists:member(Id1, L1) andalso lists:member(Id2, L2) of
    %%     true ->
    %%         mod_video:get_video(Id1, Id2);
    %%     false ->
    %%         [[], []]
    %% end,
    %% %% ?INFO("==H:~w,====D:~w", [H,D]),
    %% H2 = case H == [] of
    %%     true -> [];
    %%     false ->
    %%         %% ?INFO("===H:~w", [H]),
    %%         %% [mod_hero:pack_hero(X) || X <- H]
    %%         [pack_hero(pack_hero2(X)) || X <- H]
    %% end,
    %% D2 = case D == [] of
    %%     true -> [];
    %%     false -> [D]
    %% end,
    %% {ok, [H2, D2]};

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===
%% report_list(List) ->
%%     report_list(List, []).
%% report_list([], Rt) -> lists:reverse(Rt);
%% report_list([{{_Id, Name}, Power, Picture} | Rest], Rt) ->
%%     report_list(Rest, [{Name, Power, Picture}|Rt]).

%%' video英雄数据存储的是record,record改变老数据需要转换
%% pack_hero2(Hero) ->
%%     case length(tuple_to_list(Hero)) == 26 of
%%         true ->
%%             {hero
%%                 ,Id
%%                 ,Tid
%%                 ,Job
%%                 ,Sort
%%                 ,Changed
%%                 ,Rare      %% 稀有度
%%                 % --- Base
%%                 ,Hp        %% 血
%%                 ,Atk       %% 攻
%%                 ,Def       %% 防
%%                 ,Pun       %% 穿刺
%%                 ,Hit       %% 命中
%%                 ,Dod       %% 闪避
%%                 ,Crit      %% 暴击率
%%                 ,Crit_num  %% 暴击提成
%%                 ,Crit_anti %% 免暴
%%                 ,Tou       %% 韧性
%%                 % --- ----
%%                 ,Tou_anit  %% 免韧
%%                 ,Pos
%%                 ,Exp_max
%%                 ,Exp
%%                 ,Lev
%%                 ,Step
%%                 %% ,foster
%%                 ,Quality
%%                 ,Equ_grids
%%                 ,Skills
%%             } = Hero,
%%             #hero{
%%                 id         = Id
%%                 ,tid       = Tid
%%                 ,job       = Job
%%                 ,sort      = Sort
%%                 ,changed   = Changed
%%                 ,rare      = Rare
%%                 ,hp        = Hp
%%                 ,atk       = Atk
%%                 ,def       = Def
%%                 ,pun       = Pun
%%                 ,hit       = Hit
%%                 ,dod       = Dod
%%                 ,crit      = Crit
%%                 ,crit_num  = Crit_num
%%                 ,crit_anti = Crit_anti
%%                 ,tou       = Tou
%%                 ,tou_anit  = Tou_anit
%%                 ,pos       = Pos
%%                 ,exp_max   = Exp_max
%%                 ,exp       = Exp
%%                 %% ,foster    = Foster
%%                 ,lev       = Lev
%%                 ,step      = Step
%%                 ,quality   = Quality
%%                 ,equ_grids = Equ_grids
%%                 ,skills    = Skills
%%             };
%%         false -> Hero
%%     end.
%%
%% pack_hero(Hero) ->
%%     %% ?INFO("==Hero:~w", [Hero]),
%%     %% io:format("Id:~w,Tid:~w,hp:~w,atk:~w,def:~w,pun:~w,hit:~w,dod:~w,crit:~w,crit_num:~w,crit_anti:~w,tou:~w,pos:~w,exp:~w,lev:~w",
%%     %%     [Hero#hero.id,Hero#hero.tid,Hero#hero.hp,Hero#hero.atk,Hero#hero.def,Hero#hero.pun,
%%     %%         Hero#hero.hit,Hero#hero.dod,Hero#hero.crit,Hero#hero.crit_num,Hero#hero.crit_anti,Hero#hero.tou,Hero#hero.pos,Hero#hero.exp,Hero#hero.lev]),
%%     #hero{
%%         id         = Id
%%         ,tid       = Tid
%%         ,hp        = Hp
%%         ,atk       = Atk
%%         ,def       = Def
%%         ,pun       = Pun
%%         ,hit       = Hit
%%         ,dod       = Dod
%%         ,crit      = Crit
%%         ,crit_num  = CritNum
%%         ,crit_anti = CritAnit
%%         ,tou       = Tou
%%         ,pos       = Pos
%%         ,exp       = Exp
%%         %% ,foster    = Foster
%%         ,lev       = Lev
%%         ,quality   = Quality
%%         ,equ_grids = {Pos1, Pos2, Pos3, Pos4, _Pos5, _Pos6}
%%     } = Hero,
%%     [
%%         Id
%%         ,Tid
%%         ,Pos
%%         ,Quality
%%         ,Lev
%%         ,Exp
%%         %% ,Foster
%%         % --- Base ---
%%         ,Hp
%%         ,Atk
%%         ,Def
%%         ,Pun
%%         ,Hit
%%         ,Dod
%%         ,Crit
%%         ,CritNum
%%         ,CritAnit
%%         ,Tou
%%         ,Pos1
%%         ,Pos2
%%         ,Pos3
%%         ,Pos4
%%     ].
%%.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
