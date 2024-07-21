%%----------------------------------------------------
%%
%% $Id: mod_video.erl 12590 2014-05-10 06:29:03Z piaohua $
%%
%% @doc 录像服务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(mod_video).

%% -behaviour(gen_server).
-include("common.hrl").
-include("hero.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/qlc.hrl").
%% -define(SERVER, video).
%% -define(REPORT, report_list).

%% API
-export([%% init/0
        start/0
        ,do/1
        ,set_report_list/6
        ,get_report_list/1
        ,get_video/2
        ,reset_main/1
        ,get_list_long/1
    ]).
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

%%%===================================================================
%%% API
%%%===================================================================
%% init() ->
%%     ?INFO("start ~w...", [?MODULE]),
%%     mnesia:create_schema([node()]),
%%     mnesia:start(),
%%     mnesia:create_table(report_list, [{type, bag}, {attributes, record_info(fields, report_list)}]),
%%     mnesia:stop().

start() ->
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
    mnesia:wait_for_tables([report_list], 20000).

%% start() ->
%%     ?INFO("start ~w...", [?MODULE]),
%%     mnesia:start(),
%%     mnesia:wait_for_tables([report_list], 20000).

%% [#report_list{name = xx, id = xx, power = xx, heroes = xx, data = xx}]
do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.

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
reset_main(clean) ->
    mnesia:clear_table(report_list).

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
