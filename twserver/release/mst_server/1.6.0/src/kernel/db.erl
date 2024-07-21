%%----------------------------------------------------
%% $Id: db.erl 6604 2013-12-18 11:13:31Z rolong $
%% @doc 数据库API
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(db).
-export(
    [
        execute/1
        ,execute/2
        ,get_one/1
        ,get_one/2
        ,get_row/1
        ,get_row/2
        ,get_all/1
        ,get_all/2
        ,format_sql/2
    ]
).
-include("common.hrl").

%% @equiv execute(Sql, [])
%% @see execute/2
-spec execute(Sql) -> {ok, Num} | {error, Reason} when
    Sql :: iolist(),
    Num :: integer(),
    Reason :: term().

execute(Sql) ->
    case mysql:fetch(?DB, Sql) of
        {updated, {_, _, _, R, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Sql, Reason]);
        {error, Reason} -> mysql_halt([Sql, Reason])
    end.

%% @doc 执行一个SQL语句，返回影响的行数
-spec execute(Sql, Args) -> {ok, Num} | {error, Reason} when
    Sql :: iolist(),
    Args :: list(),
    Num :: integer(),
    Reason :: term().

execute(Sql, Args) ->
    Query = format_sql(Sql, Args),
    case mysql:fetch(?DB, Query) of
        {updated, {_, _, _, R, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Query, Reason]);
        {error, Reason} -> mysql_halt([Query, Reason])
    end.

%% @equiv get_one(Sql, [])
%% @see get_one/2
get_one(Sql) ->
    case mysql:fetch(?DB, Sql) of
        {data, {_, _, [], _, _}} -> {error, null};
        {data, {_, _, [[R]], _, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Sql, Reason]);
        {error, Reason} -> mysql_halt([Sql, Reason])
    end.

%% @doc 取出查询结果中的第一行第一列，未找到时返回{error, null}
-spec get_one(Sql, Args) -> {ok, Value} | {error, Reason} when
    Sql :: iolist(),
    Args :: list(),
    Value :: term(),
    Reason :: null | term().

get_one(Sql, Args) ->
    Query = format_sql(Sql, Args),
    case mysql:fetch(?DB, Query) of
        {data, {_, _, [], _, _}} -> {error, null};
        {data, {_, _, [[R]], _, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Query, Reason]);
        {error, Reason} -> mysql_halt([Query, Reason])
    end.

%% @equiv get_row(Sql, [])
%% @see get_row/2
get_row(Sql) ->
    case mysql:fetch(?DB, Sql) of
        {data, {_, _, [], _, _}} -> {error, null};
        {data, {_, _, [R], _, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Sql, Reason]);
        {error, Reason} -> mysql_halt([Sql, Reason])
    end.

%% @doc 取出查询结果中的第一行第一列，未找到时返回{error, null}
-spec get_row(Sql, Args) -> {ok, Row} | {error, Reason} when
    Sql :: term(),
    Args :: list(),
    Row :: list(),
    Reason :: null | term().

get_row(Sql, Args) ->
    Query = format_sql(Sql, Args),
    case mysql:fetch(?DB, Query) of
        {data, {_, _, [], _, _}} -> {error, null};
        {data, {_, _, [R], _, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Query, Reason]);
        {error, Reason} -> mysql_halt([Query, Reason])
    end.

%% @equiv get_all(Sql, [])
%% @see get_all/2
get_all(Sql) ->
    case mysql:fetch(?DB, Sql) of
        {data, {_, _, [], _, _}} -> {error, null};
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Sql, Reason]);
        {error, Reason} -> mysql_halt([Sql, Reason])
    end.

%% @doc 取出查询结果中的所有行，未找到时返回{error, null}
-spec get_all(Sql, Args) -> {ok, Rows} | {error, Reason} when
    Sql :: term(),
    Args :: list(),
    Rows :: list(),
    Reason :: null | term().

get_all(Sql, Args) ->
    Query = format_sql(Sql, Args),
    case mysql:fetch(?DB, Query) of
        {data, {_, _, [], _, _}} -> {error, null};
        {data, {_, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, Reason}} -> mysql_halt([Query, Reason]);
        {error, Reason} -> mysql_halt([Query, Reason])
    end.

%% @doc 格式化sql语句，SQL语句中变量用~s表示，
%% @deprecated 此函数效率低，尽量使用list_to_binary格式的SQL
-spec format_sql(Sql, Args) -> bitstring() when
    Sql :: list() | bitstring(),
    Args :: list().

format_sql(Sql, Args) when is_list(Sql) ->
    S = re:replace(Sql, "\\?", "~s", [global, {return, list}]),
    L = [ mysql:encode(A) || A <- Args],
    list_to_bitstring(io_lib:format(S, L));
format_sql(Sql, Args) when is_bitstring(Sql) ->
    format_sql(bitstring_to_list(Sql), Args).

mysql_halt([Sql, Reason]) ->
    case is_binary(Reason) of
        true ->
            ?DEBUG("~n[Database Error]~nQuery:~s~nError:~s", [Sql, Reason]);
        false ->
            ?DEBUG("~n[Database Error]~nQuery:~s~nError:~w", [Sql, Reason])
    end,
    {error, Reason}.

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
