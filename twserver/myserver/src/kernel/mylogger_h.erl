%% -------------------------------------------------
%% 写日志
%%
%% @author rolong@vip.qq.com
%% -------------------------------------------------
-module(mylogger_h).

-behaviour(gen_event).
-export([init/1,
        handle_event/2, handle_call/2, handle_info/2,
        terminate/2, code_change/3]).

%% This one is used when we are started directly.
init(File) ->
    process_flag(trap_exit, true),
    %% case file:open(File, [append, raw, {encoding, utf8}]) of
    case file:open(File, [append, {encoding, utf8}]) of
        {ok,Fd} ->
            {ok, {Fd, File, []}};
        Error ->
            io:format("\nmylogger file:open/2 error:~p", [Error]),
            Error
    end.

handle_event({error, _GL, Pid, Format, Arg, Module, Line}, {Fd, File, PrevHandler}) ->
    Event = io_format("~n~s ####~n ** Node == ~p~n" ++ Format
        ,[add_header(error, Pid, Module, Line), node(Pid)] ++ Arg
    ),
    io:format(Fd, Event, []),
    {ok, {Fd, File, PrevHandler}};

handle_event({warning, _GL, Pid, Format, Arg, Module, Line}, {Fd, File, PrevHandler}) ->
    Event = io_format("~s " ++ Format
        ,[add_header(warning, Pid, Module, Line) | Arg]
    ),
    io:format(Fd, Event, []),
    {ok, {Fd, File, PrevHandler}};

handle_event({log, {login, Rid, Ip}}, State) ->
    Now = util:unixtime(),
    catch db:execute("UPDATE `role` SET `login_time`=~s WHERE `id`=~s", [Now, Rid]),
    catch db:execute("INSERT INTO `log_login`(`role_id`, `event`, `ip`, `day_stamp`, `login_time`) VALUES (~s, 0, ~s, ~s, ~s)", [Rid, Ip, util:unixtime(today), Now]),
    {ok, State};

handle_event({log, {logout, Rid, Event}}, State) when Event > 0 ->
    catch db:execute("UPDATE `log_login` SET `event`= ~s, `logout_time`= ~s WHERE role_id = ~s and event = 0", [Event, util:unixtime(), Rid]),
    {ok, State};

handle_event({log, {upgrade, Rid, Lev}}, State) ->
    catch db:execute("INSERT INTO `log_upgrade`(`role_id`, `lev`, `ctime`) VALUES (~s, ~s, ~s)", [Rid, Lev, util:unixtime()]),
    {ok, State};

handle_event({log, {reg, Rid, AccountId, Ip}}, State) ->
    Time = util:unixtime(),
    {{Y, M, D}, _} = util:mktime({to_date, Time}),
    DayStamp = util:unixtime(today),
    DayDate = Y * 10000 + M * 100 + D,
    catch db:execute("INSERT INTO `log_reg`(`id`, `aid`, `ctime`, `day_stamp`, `day_date`, `ip`) "
        "VALUES (~s, ~s, ~s, ~s, ~s, ~s)", [Rid, AccountId, util:unixtime(), DayStamp, DayDate, Ip]),
    {ok, State};

handle_event({log, {shop, Rid, ShopId}}, State) ->
    catch db:execute("INSERT INTO `log_shop`(`role_id`, `shop_id`, `ctime`) VALUES (~s, ~s, ~s)",
        [Rid, ShopId, util:unixtime()]),
    {ok, State};

handle_event({log, {hero, Rid, HeroId, Quality}}, State) ->
    catch db:execute("INSERT INTO `log_hero`(`role_id`, `hero_id`, `quality`, `ctime`) VALUES (~s, ~s, ~s, ~s)",
        [Rid, HeroId, Quality, util:unixtime()]),
    {ok, State};

handle_event({log, {jewel, Rid, Tid}}, State) ->
    catch db:execute("INSERT INTO `log_jewel`(`role_id`, `tid`, `ctime`) VALUES (~s, ~s, ~s)",
        [Rid, Tid, util:unixtime()]),
    {ok, State};

handle_event({log, {embed, Rid, EquTid, JewelTid}}, State) ->
    catch db:execute("INSERT INTO `log_embed`(`role_id`, `equ_id`, `jewel_id`, `ctime`) VALUES (~s, ~s, ~s, ~s)",
        [Rid, EquTid, JewelTid, util:unixtime()]),
    {ok, State};

handle_event({log, {combine, Rid, Tid}}, State) ->
    catch db:execute("INSERT INTO `log_combine`(`role_id`, `tid`, `ctime`) VALUES (~s, ~s, ~s)", [Rid, Tid, util:unixtime()]),
    {ok, State};

handle_event({log, {enhance, Rid, Tid, Lev, Status0}}, State) ->
    Status = case Status0 of
        0 -> 1;
        _ -> 0
    end,
    catch db:execute("INSERT INTO `log_enhance`(`role_id`, `tid`, `lev`, `status`, `ctime`) VALUES (~s, ~s, ~s, ~s, ~s)", [Rid, Tid, Lev, Status, util:unixtime()]),
    {ok, State};

handle_event({log, {add_item, Rid, Type, Tid, Num}}, State) ->
    catch db:execute("INSERT INTO `log_add_item`(`role_id`, `type`, `tid`, `num`, `ctime`) VALUES (~s, ~s, ~s, ~s, ~s)", [Rid, Type, Tid, Num, util:unixtime()]),
    {ok, State};

handle_event({log, {del_item, Rid, Type, Tid, Num}}, State) ->
    catch db:execute("INSERT INTO `log_del_item`(`role_id`, `type`, `tid`, `num`, `ctime`) VALUES (~s, ~s, ~s, ~s, ~s)", [Rid, Type, Tid, Num, util:unixtime()]),
    {ok, State};

handle_event({log, {gold, Rid, Type, Num, Rest}}, State) ->
    case Num of
        0 -> ok;
        _ ->
            catch db:execute("INSERT INTO `log_gold` (`role_id`, `type`, `num`, `rest`, `ctime`) VALUES (~s, ~s, ~s, ~s, ~s);", [Rid, Type, Num, Rest, util:unixtime()])
    end,
    {ok, State};

handle_event({log, {diamond, Rid, Type, Num, Rest}}, State) ->
    case Num of
        0 -> ok;
        _ ->
            catch db:execute("INSERT INTO `log_diamond` (`role_id`, `type`, `num`, `rest`, `ctime`) VALUES (~s, ~s, ~s, ~s, ~s);", [Rid, Type, Num, Rest, util:unixtime()])
    end,
    {ok, State};

handle_event({log, {forge, Rid, Tid}}, State) ->
    catch db:execute("INSERT INTO `log_forge` (`role_id`, `tid`, `ctime`) VALUES (~s, ~s, ~s)", [Rid, Tid, util:unixtime()]),
    {ok, State};

handle_event({log, {honor, Rid, Tid, Num, Rest}}, State) ->
    catch db:execute("INSERT INTO `log_honor` (`role_id`, `tid`, `num`, `rest`, `ctime`) VALUES (~s, ~s, ~s, ~s, ~s)", [Rid, Tid, Num, Rest, util:unixtime()]),
    {ok, State};

handle_event({log, {combat, Rid, Gid}}, State) ->
    case catch db:execute("UPDATE `log_combat` SET `num` = `num` + 1, `ctime` = ~s WHERE `role_id` = ~s AND `tollgate_id` = ~s",[util:unixtime(),Rid,Gid]) of
        {ok, 0} ->
            catch db:execute("INSERT INTO `log_combat` (`role_id`, `tollgate_id`, `num`, `ctime`) VALUES (~s, ~s, ~s, ~s)", [Rid, Gid, 1, util:unixtime()]);
        _ -> ok
    end,
    {ok, State};

handle_event({log, _Msg}, State) ->
    io:format("********** Unmatch log event: ~w~n", [_Msg]),
    {ok, State};

handle_event(_Msg, State) ->
    %% io:format("********** Unmatch event: ~w~n", [_Msg]),
    {ok, State}.

handle_info({'EXIT', Fd, _Reason}, {Fd, _File, PrevHandler}) ->
    case PrevHandler of
        [] ->
            remove_handler;
        _ ->
            {swap_handler, install_prev, [], PrevHandler, go_back}
    end;

handle_info(_Msg, State) ->
    %% io:format("********** Unmatch info: ~w~n", [_Msg]),
    {ok, State}.

handle_call(filename, {Fd, File, Prev}) ->
    {ok, File, {Fd, File, Prev}};

handle_call(_Query, State) ->
    {ok, {error, bad_query}, State}.

terminate(_Reason, State) ->
    case State of
        {Fd, _File, _Prev} ->
            ok = file:close(Fd);
        _ ->
            ok
    end,
    [].

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%% ------------------------------------------------------
%%% Misc. functions.
%%% ------------------------------------------------------

io_format(F, A) ->
    try io_lib:format(F, A) catch
        T:W ->
            error_logger:format(
                " ** ~p:~p~n ** ~p~n"
                ,[T, W, erlang:get_stacktrace()]
            )
    end.

add_header(Type, Pid, Module, Line) ->
    {{Y,Mo,D},{H,Mi,S}} = erlang:localtime(),
    io_lib:format(
        "## ~p ~p-~p-~p ~s:~s:~s[~p:~p] ~p"
		,[Type, Y, Mo, D, t(H), t(Mi), t(S), Module, Line, Pid]
    ).

t(X) when is_integer(X) ->
    t1(integer_to_list(X));
t(_) ->
    "".
t1([X]) -> [$0,X];
t1(X)   -> X.
