%%----------------------------------------------------
%% $Id: lib_log.erl 9150 2014-02-17 10:45:14Z piaohua $
%% @doc 日志和统计相关的API
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(lib_log).
-export([
        online_num/0
        ,retention/0
        ,user_stat/0
        ,buy_shop_num/0
        ,buy_shop/1
        ,activity_stat/0
    ]
).

-include("common.hrl").

%% @doc 记录当前在线人数
online_num() ->
    try
        Size = ets:info(online, size),
        %% io:format("[online:~w]", [Size]),
        Time = (util:unixtime() div 300) * 300,
        db:execute("INSERT INTO `log_online_num`(`time_stamp`, `day_stamp`, `num`) VALUES (~s, ~s, ~s)", [Time, util:unixtime(today), Size]),
        ok
    catch
        T:X -> ?ERR("online_num[~w:~w]", [T, X])
    end.

%% @doc 统计留存率
retention() ->
    retention1( 2),
    retention1( 3),
    retention1( 4),
    retention1( 5),
    retention1( 6),
    retention1( 7),
    retention1( 8),
    retention1( 9),
    retention1(10),
    retention1(15),
    retention1(30),
    ok.

retention1(Nth) ->
    Sql1 = "SELECT day_stamp FROM `log_login` order by day_stamp asc limit 1",
    PassDay = case db:get_one(Sql1, []) of
        {ok, FirstTime} -> (util:unixtime() - FirstTime) div 86400 + 1;
        {error, null} -> 0;
        {error, Reason} ->
            ?WARN("retention1: ~w", [Reason]),
            0
    end,
    case PassDay >= Nth of
        true ->
            LoginDay = util:unixtime(yesterday),
            RegDay = LoginDay - (Nth - 1) * 86400,
            {LoginNum, RegNum, Rate} = calc_retention(LoginDay, RegDay),
            {{Y, M, D}, _} = util:mktime({to_date, RegDay}),
            Sql2 = "INSERT INTO `log_retention` (`reg_stamp` , `reg_date`, `reg_num`, `login_num`, `nth_day`, `rate`) VALUES (~s, ~s, ~s, ~s, ~s, ~s);",
            Date = Y * 10000 + M * 100 + D,
            db:execute(Sql2, [RegDay, Date, RegNum, LoginNum, Nth, Rate]);
        false ->
            ok
    end.

calc_retention(LoginDay, RegDay) ->
    try
        util:test1(),
        db:execute("TRUNCATE tmp_reg"),
        db:execute("insert into tmp_reg (id) SELECT id FROM `log_reg` WHERE day_stamp = ~s", [RegDay]),
        db:execute("TRUNCATE tmp_login"),
        db:execute("insert into tmp_login (id) SELECT distinct role_id FROM `log_login` WHERE `day_stamp` = ~s", [LoginDay]),
        Day = (LoginDay - RegDay) div 86400 + 1,
        Query = "select count(*) from tmp_reg join tmp_login on tmp_reg.id = tmp_login.id",
        LoginCount = case db:get_one(Query) of
            {ok, C} -> C;
            {error, _} -> 0
        end,
        {RegCount, _, _} = get_user_stat(RegDay),
        util:test2(<<"CALC RETENTION">>),
        Rate = case RegCount of
            0 -> 0;
            _ -> util:floor(LoginCount / RegCount * 100)
        end,
        ?INFO("reg   day: ~w", [util:mktime({to_date, RegDay})]),
        ?INFO("login day: ~w", [util:mktime({to_date, LoginDay})]),
        ?INFO("[RETENTION ~w] ~w / ~w = ~w", [Day, LoginCount, RegCount, Rate]),
        {LoginCount, RegCount, Rate}
    catch
        T:X ->
            util:test2(<<"RETENTION">>),
            ?ERR("[RETENTION] ~w:~w", [T, X])
    end.

%% @doc 读取昨天的用户统计数据，
%%      如果在数据库中找不到相应的统计数据，
%%      则立即进行统计并保存
%% @end
%%'user_stat
user_stat() ->
    get_user_stat(util:unixtime(yesterday)).

get_user_stat({Y, M, D}) ->
    DayStamp = util:mktime({{Y, M, D}, {0, 0, 0}}),
    get_user_stat(DayStamp);
get_user_stat(DayStamp0) ->
    {{Y, M, D}, _} = util:mktime({to_date, DayStamp0}),
    DayStamp = case DayStamp0 rem 100 > 0 of
        true -> util:mktime({{Y, M, D}, {0, 0, 0}});
        false -> DayStamp0
    end,
    case db:get_row("SELECT `reg_num`, `active_num`, `online_num` FROM `log_user_stat` WHERE day_stamp = ~s", [DayStamp]) of
        {ok, [RegNum, ActiveNum, OnlineNum]} -> {RegNum, ActiveNum, OnlineNum};
        {error, null} ->
            {ok, RegNum} = calc_reg_num(DayStamp),
            {ok, LoginNum} = calc_login_num(DayStamp),
            OnlineNum = calc_online_top_num(DayStamp),
            ActiveNum = LoginNum - RegNum,
            case DayStamp =< util:unixtime(today) of
                true ->
                    DayDate = Y * 10000 + M * 100 + D,
                    MonDate = Y * 100 + M,
                    StatSql = "INSERT INTO `log_user_stat`(`day_stamp`, `day_date`, `mon_date`, `reg_num`, `active_num`, `online_num`) VALUES (~s, ~s, ~s, ~s, ~s, ~s);",
                    db:execute(StatSql, [DayStamp, DayDate, MonDate, RegNum, ActiveNum, OnlineNum]);
                false -> ok
            end,
            {RegNum, ActiveNum, OnlineNum};
        {error, _} -> [0, 0, 0]
    end.

%% @doc 计算指定一天的注册量
calc_reg_num(DayStamp) ->
    Sql1 = "SELECT count(*) FROM `log_reg` WHERE `day_stamp` = ~s",
    db:get_one(Sql1, [DayStamp]).

%% @doc 计算指定一天的登陆人数
calc_login_num(DayStamp) ->
    Sql1 = "SELECT count(distinct role_id) FROM `log_login` WHERE day_stamp = ~s",
    db:get_one(Sql1, [DayStamp]).

%% @doc 计算指定一天的在线峰值
calc_online_top_num(DayStamp) ->
    Sql1 = "SELECT max(num) FROM `log_online_num` WHERE day_stamp = ~s",
    case db:get_one(Sql1, [DayStamp]) of
        {ok, undefined} -> 0;
        {ok, C} -> C;
        {error, null} -> 0;
        {error, Reason} ->
            ?WARN("~w", [Reason]),
            0
    end.

%% @doc 统计昨日商城购买日志
buy_shop_num() ->
    List = data_shop:get(ids),
    buy_shop(List).

buy_shop([ShopId | T]) ->
    Yesterday = util:unixtime(yesterday),
    Today = util:unixtime(today),
    {DayDate, MonDate} = util:day_stamp(Yesterday),
    case db:get_row("SELECT count(*) FROM `log_shop` WHERE `ctime` > ~s AND `ctime` < ~s AND `shop_id` = ~s", [Yesterday,Today,ShopId]) of
        {ok, [0]} -> ok;
        {ok, [Num]} ->
            Sql2 = "INSERT log_shop_num(`shop_id`, `day_stamp`, `mon_date`, `num`) VALUES (~s, ~s, ~s, ~s)",
            db:execute(Sql2, [ShopId, DayDate, MonDate, Num]);
        {error, _} -> ok
    end,
    buy_shop(T);

buy_shop([]) -> ok.

%% 统计活动完成日志(绑定激活码用户数,在备份数据库中查询)
activity_stat() ->
    Sql = list_to_binary([<<"SELECT `activityinfo` FROM `activity`">>]),
    case db:get_all(Sql) of
        {ok, List} ->
            activity_stat2(List, 0);
        {error, _} -> 0
    end.

activity_stat2([[H] | T], N) ->
    %% ?DEBUG("H:~w", [H]),
    Info = mod_fest:unzip(H),
    {66,_X2,_X3,X4} = lists:keyfind(66, 1, Info),
    case X4 =/= 0 of
        true ->
            activity_stat2(T, N+1);
        false ->
            activity_stat2(T, N)
    end;
activity_stat2([], N) -> N.

%%% vim: set foldmethod=marker foldmarker=%%',%%.:
