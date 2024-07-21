%%----------------------------------------------------
%%
%% $Id: mod_video.erl 12590 2014-05-10 06:29:03Z piaohua $
%%
%% @doc 录像服务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(mod_video).
-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

%% API
-export([
        %% start/0
        %% do/1
        %% ,set_report_list/6
        %% ,get_report_list/1
        %% ,get_video/2
        reset_main/0
        %% ,reset_main/1
        %% ,get_list_long/1
    ]).

-include("common.hrl").
-include("hero.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/qlc.hrl").
-define(SERVER, video).
%% -define(REPORT, report_list).

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-record(report_list, {
        id
        %% name
        ,tollgate_id
        ,picture
        ,power
        ,heroes
        ,data
    }).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    mnesia:create_schema([node()]),
    mnesia:start(),
    case mnesia:create_table(report_list, [
                {type, set}
                ,{disc_only_copies,[node()]}
                ,{attributes
                    ,record_info(fields, report_list)}
            ]) of
        {atomic, ok} -> ok;
        _ -> ok
    end,
    mnesia:wait_for_tables([report_list], 20000),
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({set_video,Id,Name,Picture,Power,Heroes,VideoData}, State) ->
    set_report_list(Id,Name,Picture,Power,Heroes,VideoData),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info({get_rank,Sender,Id}, State) ->
    Rank = case Id > 0 andalso Id < 300 of
        true ->
            List = get_report_list(Id),
            report_list(List);
        false ->
            []
    end,
    sender:pack_send(Sender, 34010, [Rank]),
    {noreply, State};

handle_info({get_video,Sender,Id1,Id2}, State) ->
    L1 = lists:seq(1, 300),
    L2 = lists:seq(1, 3),
    [H, D] = case lists:member(Id1, L1) andalso lists:member(Id2, L2) of
        true ->
            get_video(Id1, Id2);
        false ->
            [[], []]
    end,
    %% ?INFO("==H:~w,====D:~w", [H,D]),
    H2 = case H == [] of
        true -> [];
        false ->
            %% ?INFO("===H:~w", [H]),
            %% [mod_hero:pack_hero(X) || X <- H]
            [pack_hero(pack_hero2(X)) || X <- H]
    end,
    D2 = case D == [] of
        true -> [];
        false -> [D]
    end,
    sender:pack_send(Sender, 34020, [H2,D2]),
    {noreply, State};

handle_info(clean, State) ->
    mnesia:clear_table(report_list),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% start() ->
%%     ?INFO("start ~w...", [?MODULE]),
%%     mnesia:create_schema([node()]),
%%     mnesia:start(),
%%     case mnesia:create_table(report_list, [
%%                 {type, set}
%%                 ,{disc_only_copies,[node()]}
%%                 ,{attributes
%%                     ,record_info(fields, report_list)}
%%             ]) of
%%         {atomic, ok} -> ok;
%%         _ -> ok
%%     end,
%%     mnesia:wait_for_tables([report_list], 20000).

%% [#report_list{name = xx, id = xx, power = xx, heroes = xx, data = xx}]
do(Q) ->
    F = fun() -> qlc:e(Q) end,
    case mnesia:transaction(F) of
        {atomic, Val} -> Val;
        {aborted, Reason} ->
            ?WARN("video do :~w", [Reason]),
            []
    end.
    %% {atomic, Val} = mnesia:transaction(F),
    %% Val.

%% @doc 设置主线战报数据
-spec set_report_list(TollgateId, Name, Picture, Power, Heroes, VideoData) -> any when
    TollgateId :: integer(),
    Name       :: bitstring(),
    Picture    :: integer(),
    Power      :: integer(),
    Heroes     :: list(),
    VideoData  :: list().
set_report_list(Id, Name, Picture, Power, Heroes, VideoData) ->
    Data = #report_list{
        id = {Id, Name}
        %% name = Name
        ,tollgate_id = Id
        ,picture = Picture
        ,power = Power
        ,heroes = Heroes
        ,data = VideoData
    },
    List = get_list_long(Id),
    List2 = lists:reverse(lists:sort(List)),
    case erlang:length(List) >= 3 of
        true ->
            case check_power(List2, {Id, Name}, Power) of
                true ->
                    F1 = fun() -> mnesia:write(Data) end,
                    mnesia:transaction(F1),
                    ok;
                false -> ok
            end;
        false ->
            case check_name(List, {Id, Name}, Power) of
                true ->
                    F2 = fun() -> mnesia:write(Data) end,
                    mnesia:transaction(F2),
                    ok;
                false -> ok
            end
    end.

get_list_long(Id) ->
    do(qlc:q([{X#report_list.power, X#report_list.id} || X <- mnesia:table(report_list), X#report_list.tollgate_id == Id])).

check_power(List, Key, NewPower) ->
    case lists:keyfind(Key, 2, List) of
        false -> check_power(List, NewPower);
        {Power, Key} ->
            NewPower < Power
    end.
check_power([{Power, Id} | T], NewPower) ->
    case NewPower < Power of
        true ->
            F = fun() -> mnesia:delete({report_list, Id}) end,
            mnesia:transaction(F),
            true;
        false ->
            check_power(T, Power)
    end;
check_power([], _Power) -> false.

check_name(List, Key, NewPower) ->
    case lists:keyfind(Key, 2, List) of
        false -> true;
        {Power, Key} ->
            NewPower < Power
    end.

%% @doc 获取战报列表
-spec get_report_list(TollgateId) -> List when
    TollgateId :: integer(),
    List       :: list().
get_report_list(TollgateId) ->
    do(qlc:q([{X#report_list.id, X#report_list.power, X#report_list.picture} || X <- mnesia:table(report_list), X#report_list.tollgate_id == TollgateId])).

%% @doc 获取战报录像数据
-spec get_video(TollgateId, Id) -> List when
    TollgateId :: integer(),
    Id         :: integer(),
    List       :: list().
get_video(TollgateId, Id) ->
    Data = do(qlc:q([{X#report_list.heroes, X#report_list.data} || X <- mnesia:table(report_list), X#report_list.tollgate_id == TollgateId])),
    case erlang:length(Data) >= Id andalso Id > 0 of
        true ->
            {Heroes, Data2} = lists:nth(Id, Data),
            [Heroes, Data2];
        false -> [[], []]
    end.

%% 清除report_list表
%% reset_main(clean) ->
%%     mnesia:clear_table(report_list).

reset_main() ->
    ?SERVER ! clean.

%% === 私有函数 ===
report_list(List) ->
    report_list(List, []).
report_list([], Rt) -> lists:reverse(Rt);
report_list([{{_Id, Name}, Power, Picture} | Rest], Rt) ->
    report_list(Rest, [{Name, Power, Picture}|Rt]).

%% video英雄数据存储的是record,record改变老数据需要转换
pack_hero2(Hero) ->
    case length(tuple_to_list(Hero)) == 26 of
        true ->
            {hero
                ,Id
                ,Tid
                ,Job
                ,Sort
                ,Changed
                ,Rare      %% 稀有度
                % --- Base
                ,Hp        %% 血
                ,Atk       %% 攻
                ,Def       %% 防
                ,Pun       %% 穿刺
                ,Hit       %% 命中
                ,Dod       %% 闪避
                ,Crit      %% 暴击率
                ,Crit_num  %% 暴击提成
                ,Crit_anti %% 免暴
                ,Tou       %% 韧性
                % --- ----
                ,Tou_anit  %% 免韧
                ,Pos
                ,Exp_max
                ,Exp
                ,Lev
                ,Step
                %% ,foster
                ,Quality
                ,Equ_grids
                ,Skills
            } = Hero,
            #hero{
                id         = Id
                ,tid       = Tid
                ,job       = Job
                ,sort      = Sort
                ,changed   = Changed
                ,rare      = Rare
                ,hp        = Hp
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = Crit_num
                ,crit_anti = Crit_anti
                ,tou       = Tou
                ,tou_anit  = Tou_anit
                ,pos       = Pos
                ,exp_max   = Exp_max
                ,exp       = Exp
                %% ,foster    = Foster
                ,lev       = Lev
                ,step      = Step
                ,quality   = Quality
                ,equ_grids = Equ_grids
                ,skills    = Skills
            };
        false -> Hero
    end.

pack_hero(Hero) ->
    %% ?INFO("==Hero:~w", [Hero]),
    %% io:format("Id:~w,Tid:~w,hp:~w,atk:~w,def:~w,pun:~w,hit:~w,dod:~w,crit:~w,crit_num:~w,crit_anti:~w,tou:~w,pos:~w,exp:~w,lev:~w",
    %%     [Hero#hero.id,Hero#hero.tid,Hero#hero.hp,Hero#hero.atk,Hero#hero.def,Hero#hero.pun,
    %%         Hero#hero.hit,Hero#hero.dod,Hero#hero.crit,Hero#hero.crit_num,Hero#hero.crit_anti,Hero#hero.tou,Hero#hero.pos,Hero#hero.exp,Hero#hero.lev]),
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
        %% ,foster    = Foster
        ,lev       = Lev
        ,quality   = Quality
        ,equ_grids = {Pos1, Pos2, Pos3, Pos4, _Pos5, _Pos6}
    } = Hero,
    [
        Id
        ,Tid
        ,Pos
        ,Quality
        ,Lev
        ,Exp
        %% ,Foster
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
    ].

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
