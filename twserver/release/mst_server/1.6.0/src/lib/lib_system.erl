%%----------------------------------------------------
%% $Id: lib_system.erl 12590 2014-05-10 06:29:03Z piaohua $
%% @doc 系统相关的API
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(lib_system).
-export([
        shutdown/0
        ,fest_id/0
        ,extra_product/1
        ,cast_sys_msg/4
    ]).

-include("common.hrl").

%% @doc 系统关闭前会被自动调用
-spec shutdown() -> ok.
shutdown() ->
    ?INFO("shutdown...", []),
    listener:stop(), %% 首先停止接收新的连接
    lib_role:stop(), %% 强制让在线玩家退出
    cache:save(),
    mod_luck:save_data_to_db(),
    %% 保存事件管理器中的数据
    myevent:save_events(),
    %% 保存管理/统计进程中的数据
    gen_server:call(admin, save_data),
    %% 保存定时活动中的数据
    timeing:save_timeing_ets(),
    %% 保存自定义活动中的数据
    custom:save_custom_ets(),
    extra:save_extra_ets(),
    %% mnesia backup
    %% mnesia:backup("log/backup.log"),
    %% 暂停一秒
    util:sleep(1000),
    ok.

%% 获取当前节日活动的ID，
%% 如果没有开启活动，则返回0
-spec fest_id() ->
    integer().

fest_id() ->
    case env:get(fest_id) of
        undefined -> 0;
        V -> V
    end.

%% 附加的主线产出
%% 如：[{2,2,1}]
%% Type:
%% 1=主线
%% 2=副本
%% 3=竞技场
%% 4=节日活动
-spec extra_product(Type) -> list() when
    Type :: integer().

extra_product(1) ->
    case env:get(main_extra_product) of
        undefined -> [];
        V -> V
    end;
extra_product(2) ->
    case env:get(fb_extra_product) of
        undefined -> [];
        V -> V
    end;
extra_product(_) ->
    [].

cast_sys_msg(Id, Name, Content, Attr) when is_list(Content) ->
    case Name == <<>> of
        true -> ok;
        false ->
            sender:pack_cast(world, 27020, [3, Id, Name, list_to_binary(Content), Attr]),
            ok
    end;
cast_sys_msg(Id, Name, Content, Attr) ->
    case Name == <<>> of
        true -> ok;
        false ->
            sender:pack_cast(world, 27020, [3, Id, Name, Content, Attr]),
            ok
    end.
