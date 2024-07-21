%%%-------------------------------------------------------------------
%%% File    : mysql_conn.erl
%%% Author  : Fredrik Thulin <ft@it.su.se>
%%% Descrip.: MySQL connection handler, handles de-framing of messages
%%%           received by the MySQL receiver process.
%%% Created :  5 Aug 2005 by Fredrik Thulin <ft@it.su.se>
%%% Modified: 11 Jan 2006 by Mickael Remond <mickael.remond@process-one.net>
%%%
%%% Note    : All MySQL code was written by Magnus Ahltorp, originally
%%%           in the file mysql.erl - I just moved it here.
%%%
%%% Modified: 12 Sep 2006 by Yariv Sadan <yarivvv@gmail.com>
%%% Added automatic type conversion between MySQL types and Erlang types
%%% and different logging style.
%%%
%%% Modified: 23 Sep 2006 by Yariv Sadan <yarivvv@gmail.com>
%%% Added transaction handling and prepared statement execution.
%%%
%%% Copyright (c) 2001-2004 Kungliga Tekniska H?gskolan
%%% See the file COPYING
%%%
%%%
%%% This module handles a single connection to a single MySQL server.
%%% You can use it stand-alone, or through the 'mysql' module if you
%%% want to have more than one connection to the server, or
%%% connections to different servers.
%%%
%%% To use it stand-alone, set up the connection with
%%%
%%%   {ok, Pid} = mysql_conn:start(Host, Port, User, Password,
%%%                                Database, LogFun)
%%%
%%%         Host     = string()
%%%         Port     = integer()
%%%         User     = string()
%%%         Password = string()
%%%         Database = string()
%%%         LogFun   = undefined | (gives logging to console)
%%%                    function() of arity 3 (Level, Fmt, Args)
%%%
%%% Note: In stand-alone mode you have to start Erlang crypto application by
%%% yourself with crypto:start()
%%%
%%% and then make MySQL querys with
%%%
%%%   Result = mysql_conn:fetch(Pid, Query, self())
%%%
%%%         Result = {data, MySQLRes}    |
%%%                  {updated, MySQLRes} |
%%%                  {error, MySQLRes}
%%%          Where: MySQLRes = #mysql_result
%%%
%%% Actual data can be extracted from MySQLRes by calling the following API
%%% functions:
%%%     - on data received:
%%%          FieldInfo = mysql:get_result_field_info(MysqlRes)
%%%          AllRows   = mysql:get_result_rows(MysqlRes)
%%%         with FieldInfo = list() of {Table, Field, Length, Name}
%%%          and AllRows = list() of list() representing records
%%%     - on update:
%%%          Affected= mysql:get_result_affected_rows(MysqlRes)
%%%         with Affected = integer()
%%%     - on error:
%%%          Reason    = mysql:get_result_reason(MysqlRes)
%%%         with Reason = string()
%%%-------------------------------------------------------------------

-module(mysql_conn).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([start/8,
        start_link/8,
        fetch/3,
        fetch/4,
        execute/5,
        execute/6,
        transaction/3,
        transaction/4
    ]).

%% private exports to be called only from the 'mysql' module
-export([fetch_local/2,
        execute_local/3,
        get_pool_id/1
    ]).

%%--------------------------------------------------------------------
%% External exports (should only be used by the 'mysql_auth' module)
%%--------------------------------------------------------------------
-export([do_recv/3
    ]).

-include("mysql.hrl").
-record(state, {
        mysql_version,
        log_fun,
        recv_pid,
        socket,
        data,

        %% maps statement names to their versions
        prepares = gb_trees:empty(),

        %% the id of the connection pool to which this connection belongs
        pool_id
    }).

-define(SECURE_CONNECTION, 32768).
-define(MYSQL_QUERY_OP, 3).
-define(DEFAULT_STANDALONE_TIMEOUT, 10000).
-define(MYSQL_4_0, 40). %% Support for MySQL 4.0.x
-define(MYSQL_4_1, 41). %% Support for MySQL 4.1.x et 5.0.x

%% Used by transactions to get the state variable for this connection
%% when bypassing the dispatcher.
-define(STATE_VAR, mysql_connection_state).

-define(Log(LogFun,Level,Msg),
    LogFun(?MODULE, ?LINE,Level,fun()-> {Msg,[]} end)).
-define(Log2(LogFun,Level,Msg,Params),
    LogFun(?MODULE, ?LINE,Level,fun()-> {Msg,Params} end)).
-define(L(Msg), io:format("~p:~b ~p ~n", [?MODULE, ?LINE, Msg])).


%%====================================================================
%% External functions
%%====================================================================

%%--------------------------------------------------------------------
%% Function: start(Host, Port, User, Password, Database, LogFun)
%% Function: start_link(Host, Port, User, Password, Database, LogFun)
%%           Host     = string()
%%           Port     = integer()
%%           User     = string()
%%           Password = string()
%%           Database = string()
%%           LogFun   = undefined | function() of arity 3
%% Descrip.: Starts a mysql_conn process that connects to a MySQL
%%           server, logs in and chooses a database.
%% Returns : {ok, Pid} | {error, Reason}
%%           Pid    = pid()
%%           Reason = string()
%%--------------------------------------------------------------------
start(Host, Port, User, Password, Database, LogFun, Encoding, PoolId) ->
    ConnPid = self(),
    Pid = spawn(fun () ->
                init(Host, Port, User, Password, Database,
                    LogFun, Encoding, PoolId, ConnPid)
        end),
    post_start(Pid, LogFun).

start_link(Host, Port, User, Password, Database, LogFun, Encoding, PoolId) ->
    ConnPid = self(),
    Pid = spawn_link(fun () ->
                init(Host, Port, User, Password, Database,
                    LogFun, Encoding, PoolId, ConnPid)
        end),
    post_start(Pid, LogFun).

%% part of start/6 or start_link/6:
post_start(Pid, LogFun) ->
    receive
        {mysql_conn, Pid, ok} ->
            {ok, Pid};
        {mysql_conn, Pid, {error, Reason}} ->
            {error, Reason};
        Unknown ->
            ?Log2(LogFun, error,
                "received unknown signal, exiting: ~p", [Unknown]),
            {error, "unknown signal received"}
    after 5000 ->
            {error, "timed out"}
    end.

%%--------------------------------------------------------------------
%% Function: fetch(Pid, Query, From)
%%           fetch(Pid, Query, From, Timeout)
%%           Pid     = pid(), mysql_conn to send fetch-request to
%%           Queries   = A single binary() query or a list of binary() queries.
%%                     If a list is provided, the return value is the return
%%                     of the last query, or the first query that has
%%                     returned an error. If an error occurs, execution of
%%                     the following queries is aborted.
%%           From    = pid() or term(), use a From of self() when
%%                     using this module for a single connection,
%%                     or pass the gen_server:call/3 From argument if
%%                     using a gen_server to do the querys (e.g. the
%%                     mysql_dispatcher)
%%           Timeout = integer() | infinity, gen_server timeout value
%% Descrip.: Send a query or a list of queries and wait for the result
%%           if running stand-alone (From = self()), but don't block
%%           the caller if we are not running stand-alone
%%           (From = gen_server From).
%% Returns : ok                        | (non-stand-alone mode)
%%           {data, #mysql_result}     | (stand-alone mode)
%%           {updated, #mysql_result}  | (stand-alone mode)
%%           {error, #mysql_result}      (stand-alone mode)
%%           FieldInfo = term()
%%           Rows      = list() of [string()]
%%           Reason    = term()
%%--------------------------------------------------------------------
fetch(Pid, Queries, From) ->
    fetch(Pid, Queries, From, ?DEFAULT_STANDALONE_TIMEOUT).

fetch(Pid, Queries, From, Timeout)  ->
    do_fetch(Pid, Queries, From, Timeout).

execute(Pid, Name, Version, Params, From) ->
    execute(Pid, Name, Version, Params, From, ?DEFAULT_STANDALONE_TIMEOUT).

execute(Pid, Name, Version, Params, From, Timeout) ->
    send_msg(Pid, {execute, Name, Version, Params, From}, From, Timeout).

transaction(Pid, Fun, From) ->
    transaction(Pid, Fun, From, ?DEFAULT_STANDALONE_TIMEOUT).

transaction(Pid, Fun, From, Timeout) ->
    send_msg(Pid, {transaction, Fun, From}, From, Timeout).

get_pool_id(State) ->
    State#state.pool_id.

%%====================================================================
%% Internal functions
%%====================================================================

fetch_local(State, Query) ->
    do_query(State, Query).

execute_local(State, Name, Params) ->
    case do_execute(State, Name, Params, undefined) of
        {ok, Res, State1} ->
            put(?STATE_VAR, State1),
            Res;
        Err ->
            Err
    end.

%%--------------------------------------------------------------------
%% Function: do_recv(LogFun, RecvPid, SeqNum)
%%           LogFun  = undefined | function() with arity 3
%%           RecvPid = pid(), mysql_recv process
%%           SeqNum  = undefined | integer()
%% Descrip.: Wait for a frame decoded and sent to us by RecvPid.
%%           Either wait for a specific frame if SeqNum is an integer,
%%           or just any frame if SeqNum is undefined.
%% Returns : {ok, Packet, Num} |
%%           {error, Reason}
%%           Reason = term()
%%
%% Note    : Only to be used externally by the 'mysql_auth' module.
%%--------------------------------------------------------------------
do_recv(LogFun, RecvPid, SeqNum)  when is_function(LogFun);
LogFun == undefined,
SeqNum == undefined ->
    receive
        {mysql_recv, RecvPid, data, Packet, Num} ->
            {ok, Packet, Num};
        {mysql_recv, RecvPid, closed, _E} ->
            %% TODO：收到socket关闭的消息，可以解决一些后续处理
            {error, "mysql_recv: socket was closed"}
    end;
do_recv(LogFun, RecvPid, SeqNum) when is_function(LogFun);
LogFun == undefined,
is_integer(SeqNum) ->
    ResponseNum = SeqNum + 1,
    receive
        {mysql_recv, RecvPid, data, Packet, ResponseNum} ->
            {ok, Packet, ResponseNum};
        {mysql_recv, RecvPid, closed, _E} ->
            %% TODO：收到socket关闭的消息，可以解决一些后续处理
            {error, "mysql_recv: socket was closed"}
    end.

do_fetch(Pid, Queries, From, Timeout) ->
    send_msg(Pid, {fetch, Queries, From}, From, Timeout).

send_msg(Pid, Msg, From, Timeout) ->
    Self = self(),
    Pid ! Msg,
    case From of
        Self ->
            %% We are not using a mysql_dispatcher, await the response
            receive
                {fetch_result, Pid, Result} ->
                    Result
            after Timeout ->
                    {error, "message timed out"}
            end;
        _ ->
            %% From is gen_server From,
            %% Pid will do gen_server:reply() when it has an answer
            ok
    end.


%%--------------------------------------------------------------------
%% Function: init(Host, Port, User, Password, Database, LogFun,
%%                Parent)
%%           Host     = string()
%%           Port     = integer()
%%           User     = string()
%%           Password = string()
%%           Database = string()
%%           LogFun   = function() of arity 4
%%           Parent   = pid() of process starting this mysql_conn
%% Descrip.: Connect to a MySQL server, log in and chooses a database.
%%           Report result of this to Parent, and then enter loop() if
%%           we were successfull.
%% Returns : void() | does not return
%%--------------------------------------------------------------------
init(Host, Port, User, Password, Database, LogFun, Encoding, PoolId, Parent) ->
    case mysql_recv:start_link(Host, Port, LogFun, self()) of
        {ok, RecvPid, Sock} ->
            case mysql_init(Sock, RecvPid, User, Password, LogFun) of
                {ok, Version} ->
                    Db = iolist_to_binary(Database),
                    case do_query(Sock, RecvPid, LogFun,
                            <<"use ", Db/binary>>,
                            Version) of
                        {error, MySQLRes} ->
                            ?Log2(LogFun, error,
                                "mysql_conn: Failed changing to database "
                                "~p : ~p",
                                [Database,
                                    mysql:get_result_reason(MySQLRes)]),
                            Parent ! {mysql_conn, self(),
                                {error, failed_changing_database}};

                        %% ResultType: data | updated
                        {_ResultType, _MySQLRes} ->
                            Parent ! {mysql_conn, self(), ok},
                            case Encoding of
                                undefined -> undefined;
                                _ ->
                                    EncodingBinary = list_to_binary(atom_to_list(Encoding)),
                                    do_query(Sock, RecvPid, LogFun,
                                        <<"set names '", EncodingBinary/binary, "'">>,
                                        Version)
                            end,
                            State = #state{mysql_version=Version,
                                recv_pid = RecvPid,
                                socket   = Sock,
                                log_fun  = LogFun,
                                pool_id  = PoolId,
                                data     = <<>>
                            },
                            loop(State)
                    end;
                {error, _Reason} ->
                    Parent ! {mysql_conn, self(), {error, login_failed}}
            end;
        E ->
            ?Log2(LogFun, error,
                "failed connecting to ~p:~p : ~p",
                [Host, Port, E]),
            Parent ! {mysql_conn, self(), {error, connect_failed}}
    end.

%%--------------------------------------------------------------------
%% Function: loop(State)
%%           State = state record()
%% Descrip.: Wait for signals asking us to perform a MySQL query, or
%%           signals that the socket was closed.
%% Returns : error | does not return
%%--------------------------------------------------------------------
loop(State) ->
    RecvPid = State#state.recv_pid,
    LogFun = State#state.log_fun,
    receive
        {fetch, Queries, From} ->
            send_reply(From, do_queries(State, Queries)),
            loop(State);
        {transaction, Fun, From} ->
            put(?STATE_VAR, State),

            Res = do_transaction(State, Fun),

            %% The transaction may have changed the state of this process
            %% if it has executed prepared statements. This would happen in
            %% mysql:execute.
            State1 = get(?STATE_VAR),

            send_reply(From, Res),
            loop(State1);
        {execute, Name, Version, Params, From} ->
            State1 =
            case do_execute(State, Name, Params, Version) of
                {error, _} = Err ->
                    send_reply(From, Err),
                    State;
                {ok, Result, NewState} ->
                    send_reply(From, Result),
                    NewState
            end,
            loop(State1);
        {mysql_recv, RecvPid, data, Packet, Num} ->
            ?Log2(LogFun, error,
                "received data when not expecting any -- "
                "ignoring it: {~p, ~p}", [Num, Packet]),
            loop(State);
        close_conn ->
            gen_tcp:close(State#state.socket);
        Unknown ->
            ?Log2(LogFun, error,
                "received unknown signal, exiting: ~p", [Unknown]),
            error
    end.

%% GenSrvFrom is either a gen_server:call/3 From term(),
%% or a pid if no gen_server was used to make the query
send_reply(GenSrvFrom, Res) when is_pid(GenSrvFrom) ->
    %% The query was not sent using gen_server mechanisms       
    GenSrvFrom ! {fetch_result, self(), Res};
send_reply(GenSrvFrom, Res) ->
    gen_server:reply(GenSrvFrom, Res).

do_query(State, Query) ->
    do_query(State#state.socket,
        State#state.recv_pid,
        State#state.log_fun,
        Query,
        State#state.mysql_version
    ).

do_query(Sock, RecvPid, LogFun, Query, Version) ->
    Query1 = iolist_to_binary(Query),
    ?Log2(LogFun, debug, "fetch ~p (id ~p)", [Query1,RecvPid]),
    Packet =  <<?MYSQL_QUERY_OP, Query1/binary>>,
    case do_send(Sock, Packet, 0, LogFun) of
        ok ->
            get_query_response(LogFun,RecvPid,
                Version);
        {error, Reason} ->
            %% TODO：发送失败
            Msg = io_lib:format("Failed sending data "
                "on socket : ~p",
                [Reason]),
            {error, Msg}
    end.

do_queries(State, Queries) when not is_list(Queries) ->
    do_query(State, Queries);
do_queries(State, Queries) ->
    do_queries(State#state.socket,
        State#state.recv_pid,
        State#state.log_fun,
        Queries,
        State#state.mysql_version
    ).

%% Execute a list of queries, returning the response for the last query.
%% If a query returns an error before the last query is executed, the
%% loop is aborted and the error is returned. 
do_queries(Sock, RecvPid, LogFun, Queries, Version) ->
catch
    lists:foldl(
        fun(Query, _LastResponse) ->
                case do_query(Sock, RecvPid, LogFun, Query, Version) of
                    {error, _} = Err -> throw(Err);
                    Res -> Res
                end
        end, ok, Queries).

do_transaction(State, Fun) ->
    case do_query(State, <<"BEGIN">>) of
        {error, _} = Err ->	
            {aborted, Err};
        _ ->
            case catch Fun() of
                error = Err -> rollback(State, Err);
                {error, _} = Err -> rollback(State, Err);
                {'EXIT', _} = Err -> rollback(State, Err);
                Res ->
                    case do_query(State, <<"COMMIT">>) of
                        {error, _} = Err ->
                            rollback(State, {commit_error, Err});
                        _ ->
                            case Res of
                                {atomic, _} -> Res;
                                _ -> {atomic, Res}
                            end
                    end
            end
    end.

rollback(State, Err) ->
    Res = do_query(State, <<"ROLLBACK">>),
    {aborted, {Err, {rollback_result, Res}}}.

do_execute(State, Name, Params, ExpectedVersion) ->
    Res = case gb_trees:lookup(Name, State#state.prepares) of
        {value, Version} when Version == ExpectedVersion ->
            {ok, latest};
        {value, Version} ->
            mysql:get_prepared(Name, Version);
        none ->
            mysql:get_prepared(Name)
    end,
    case Res of
        {ok, latest} ->
            {ok, do_execute1(State, Name, Params), State};
        {ok, {Stmt, NewVersion}} ->
            prepare_and_exec(State, Name, NewVersion, Stmt, Params);
        {error, _} = Err ->
            Err
    end.

prepare_and_exec(State, Name, Version, Stmt, Params) ->
    NameBin = atom_to_binary(Name),
    StmtBin = <<"PREPARE ", NameBin/binary, " FROM '",
    Stmt/binary, "'">>,
    case do_query(State, StmtBin) of
        {updated, _} ->
            State1 =
            State#state{
                prepares = gb_trees:enter(Name, Version,
                    State#state.prepares)},
            {ok, do_execute1(State1, Name, Params), State1};
        {error, _} = Err ->
            Err;
        Other ->
            {error, {unexpected_result, Other}}
    end.

do_execute1(State, Name, Params) ->
    Stmts = make_statements_for_execute(Name, Params),
    do_queries(State, Stmts).

make_statements_for_execute(Name, []) ->
    NameBin = atom_to_binary(Name),
    [<<"EXECUTE ", NameBin/binary>>];
make_statements_for_execute(Name, Params) ->
    NumParams = length(Params),
    ParamNums = lists:seq(1, NumParams),

    NameBin = atom_to_binary(Name),

    ParamNames =
    lists:foldl(
        fun(Num, Acc) ->
                ParamName = [$@ | integer_to_list(Num)],
                if Num == 1 ->
                        ParamName ++ Acc;
                    true ->
                        [$, | ParamName] ++ Acc
                end
        end, [], lists:reverse(ParamNums)),
    ParamNamesBin = list_to_binary(ParamNames),

    ExecStmt = <<"EXECUTE ", NameBin/binary, " USING ",
    ParamNamesBin/binary>>,

    ParamVals = lists:zip(ParamNums, Params),
    Stmts = lists:foldl(
        fun({Num, Val}, Acc) ->
                NumBin = mysql:encode(Num, true),
                ValBin = mysql:encode(Val, true),
                [<<"SET @", NumBin/binary, "=", ValBin/binary>> | Acc]
        end, [ExecStmt], lists:reverse(ParamVals)),
    Stmts.

atom_to_binary(Val) ->
    %% 去掉前面1字节版本号和3字节atom标识和长度
    %% 这用法是个巧合~~
    <<_:4/binary, Bin/binary>> = term_to_binary(Val),
    Bin.

%%--------------------------------------------------------------------
%% Function: mysql_init(Sock, RecvPid, User, Password, LogFun)
%%           Sock     = term(), gen_tcp socket
%%           RecvPid  = pid(), mysql_recv process
%%           User     = string()
%%           Password = string()
%%           LogFun   = undefined | function() with arity 3
%% Descrip.: Try to authenticate on our new socket.
%% Returns : ok | {error, Reason}
%%           Reason = string()
%%--------------------------------------------------------------------
mysql_init(Sock, RecvPid, User, Password, LogFun) ->
    case do_recv(LogFun, RecvPid, undefined) of
        {ok, Packet, InitSeqNum} ->
            {Version, Salt1, Salt2, Caps} = greeting(Packet, LogFun),
            AuthRes =
            case Caps band ?SECURE_CONNECTION of
                ?SECURE_CONNECTION ->
                    mysql_auth:do_new_auth(
                        Sock, RecvPid, InitSeqNum + 1,
                        User, Password, Salt1, Salt2, LogFun);
                _ ->
                    mysql_auth:do_old_auth(
                        Sock, RecvPid, InitSeqNum + 1, User, Password,
                        Salt1, LogFun)
            end,
            %% 服务器回复OK包或者错误信息包
            case AuthRes of
                {ok, <<0:8, _Rest/binary>>, _RecvNum} ->
                    {ok,Version};
                {ok, <<255:8, Code:16/little, Message/binary>>, _RecvNum} ->
                    ?Log2(LogFun, error, "init error ~p: ~p",
                        [Code, binary_to_list(Message)]),
                    {error, binary_to_list(Message)};
                {ok, RecvPacket, _RecvNum} ->
                    ?Log2(LogFun, error,
                        "init unknown error ~p",
                        [binary_to_list(RecvPacket)]),
                    {error, binary_to_list(RecvPacket)};
                {error, Reason} ->
                    ?Log2(LogFun, error,
                        "init failed receiving data : ~p", [Reason]),
                    {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason}
    end.

%% 支持能力协议掩码
%% 
%% 1、握手阶段协商而定
%% 2、包含4byte跟2byte两种类型。4.1+的版本支持两种类型，旧版本仅仅支持2byte
%% 3、无论什么版本，服务器端仅用2byte长度表示本身支持能力。支持任何版本客户端
%% 4、客户端检测服务器的版本，根据服务器的支持版本决定发送4byte或者2byte的mask bit
%% 
%% 掩码定义在include/mysql_com.h, 如:
%%      0x0020 表示是否具备压缩能力
%%      0x0800 SSL能力
%%      
%% 
%% 关于客户请求包
%% 验证通过后，客户端开始发送请求包，body格式:
%% 1字节请求类型 + 请求参数(非压缩类型包长度:包头长度-1;压缩类型包长度:压缩body长度-1)
%% 
%% 请求类型:server_command(include/mysql_com.h)
%% 请求处理逻辑:dispatch_command()(sql/sql_parse.cc)
%% 
%% 如果需要加入一个新的command类型，确保向后兼容旧客户端。将新请求类型加入在COM_END类型之前。确保枚举值不与旧客户端冲突，从这个先后顺序上面可以看到请求的发展历程。
%% 
%% 关于服务器回包
%% 服务器收到请求包后，通过一个或者多个回复包答复客户端。
%% 会存在几种回复类型包，提几种回复类型包之前，讲讲数据域表示法
%% 
%% 数据域表示法
%% 该表示方式是服务器回复包中比较关键的组成部分，由长度加上实际的数据组成。
%% 数据域的长度表示有点特殊。net_store_length()(sql/pack.cc)
%% >如果实际数据小于251,用1byte字段表示长度
%% >如果大于等于251,并且两个字节可以容纳长度值,前面会有另外多一个字节数据,填入252，然后两个字节填入实际长度
%% >如果2byte不够存，但4byte可以,前面多余的1byte填入253,后续跟着4字节的实际长度
%% >如果实际长度超过4byte,多余的1字节填入254,并在后续的8byte填入实际长度值 
%% >251表示该数据域为空,该字段为空
%% 
%% 大部分时间字段都是小的，不浪费空间。如果长度大到需要多一个字节来表示长度的话，也不在乎一个字节了。
%% 
%% 长度位之后，紧跟着便是实际的数据值，数据值转化成为string类型表示
%% 
%% 4.1版本之前，调用net_store_data()函数,该函数因参数不同存在几种不同的重载形式。
%% 实现于sql/net_pkg.cc
%% 4.1+版本，使用Protocol::store(),对于函数net_store_data()的封装,实现在sql/protocol.cc
%% 
%% 4.1版本有个特殊情况，当准备语句返回的数据不是字符串时，数据会通过原始二进制格式返回。同样实际数据之前存在一个长度指示符。
%% 
%% 几种回复类型包:
%% 
%% OK回复包
%% 用于表示服务器已正确处理请求，下面几种请求会导致一个OK回包:
%% 1、ping包
%% 2、不返回结果集查询请求包，如insert/update/alter table
%% 3、refresh包
%% 4、slave注册包
%% OK包类型适合于不返回结果集的请求包。尽管如此，包中还是包含了一些特定的状态信息，如受影响记录数、产生对应的自增主键值或者状态字符串。
%% 具体格式:
%%      1字节标志(值0表示没有字段域) + 影响记录数 + 自增ID(0表示没有使用) + 2字节服务器状态(定义在include/mysql_com.h,4.0之前的协议,该值非0值才有用;4.1之后,该值都有用) + 2字节的warnings数(4.1之后版本才有使用) + 状态字符串(数据域表示法:长度+数据)
%% 通过调用send_ok()函数发送OK包，定义于sql/protocol.h(cc)
%% 
%% 错误回复包
%% 请求包处理发现错误时，服务器发送错误包，具体格式:
%% 1字节标志(255,客户端发现第一个字节是255的包都认为是错误包) + 2字节错误码 + 2字节("#"+连接状态) + 变长的错误信息字符串
%% 通过调用send_error(),定义于sql/protocol.cc
%% 
%% EOF回复包
%% EOF包用于几种交互信息情况:
%% 1、结果集中表明字段域信息结束
%% 2、结果集中表明行数据结束
%% 3、COM_SHUTDOWN请求的确认
%% 4、COM_SET_OPTION和COM_DEBUG的正确处理答复
%% 5、旧验证方式的请求结束
%% 
%% 格式:
%%      1字节(十进制254) + 2字节警告数 + 2字节服务器状态掩码位
%% 由于以254开始，跟之前提到的数据域中认为254开头的后续有8个字节的字段长度值这种表示方式存在冲突，所有这里对于EOF包中254值后7字节限制。区分这两种情况。
%% send_eof()函数定义于sql/protocol.cc
%% 
%% 
%% 结果集回复包
%% 诸如select、show、check、repair、explain此等请求，绝大部分的请求都会导致一个结果集数据返回。简单的状态报告请求不需要结果集返回的情况还是少数。
%% 
%% 结果集由一系列包构成，首先，服务器通过Protocol::send_fields()(sql/protocol.cc)发送字段域信息。
%% 这个阶段会产生以下序列包:
%% 1、各字段长度指示符构成的包。
%% 2、各字段描述信息,一个包包含一个字段域的描述信息。
%% 3、EOF包。
%% 以上三步骤完成了字段域的描述，2步中关系到各字段的描述方式,
%% 基本都是采用数据域的表示法(长度+数据),依次保存了数据名+表名+列名+原列名+字符集编码+字段长度+字段枚举值(include/mysql_com.h)+字段掩码+精确度+可选默认值
%% 
%% 字段掩码表示:主键、可空、唯一键、BLOBorTEXT、是否0填充、是否枚举值、自增属性、时间戳、SET、游标等
%% 
%% 发送完字段描述系列包之后，服务器接着推送具体数据，采用每包一行形式，包内采用标准的数据域表示法。
%% 
%% 常规查询请求(COM_QUERY),字段数据转化为string类型；如果使用准备语句(COM_PREPARE),字段数据采用原生标准格式发送。
%% 
%% 最后，发送完全部行数据后，发送EOF包表示结束。


%% part of mysql_init/4
%%   1字节协议包含号 
%% + 变长(空字节结束的服务器版本串) 
%% + 4字节MySQL内部分配处理线程ID
%% + 9字节随机串(新版本长度有所改动) 
%% + 2字节服务器配置位 
%% + 1字节字符集编码 
%% + 2字节服务器状态标志位 
%% + 13字节保留 
%% + 13字节随机串(新版本改动,保存剩下随机串)
greeting(Packet, LogFun) ->
    <<Protocol:8, Rest/binary>> = Packet,
    {Version, Rest2} = asciz(Rest),
    <<_TreadID:32/little, Rest3/binary>> = Rest2,
    {Salt, Rest4} = asciz(Rest3),
    <<Caps:16/little, Rest5/binary>> = Rest4,
    <<ServerChar:16/binary-unit:8, Rest6/binary>> = Rest5,
    {Salt2, _Rest7} = asciz(Rest6),
    ?Log2(LogFun, debug,
        "greeting version ~p (protocol ~p) salt ~p caps ~p serverchar ~p"
        "salt2 ~p",
        [Version, Protocol, Salt, Caps, ServerChar, Salt2]),
    {normalize_version(Version, LogFun), Salt, Salt2, Caps}.

%% part of greeting/2
asciz(Data) when is_binary(Data) ->
    mysql:asciz_binary(Data, []);
asciz(Data) when is_list(Data) ->
    {String, [0 | Rest]} = lists:splitwith(fun (C) ->
                C /= 0
        end, Data),
    {String, Rest}.

%%--------------------------------------------------------------------
%% Function: get_query_response(LogFun, RecvPid)
%%           LogFun  = undefined | function() with arity 3
%%           RecvPid = pid(), mysql_recv process
%%           Version = integer(), Representing MySQL version used
%% Descrip.: Wait for frames until we have a complete query response.
%% Returns :   {data, #mysql_result}
%%             {updated, #mysql_result}
%%             {error, #mysql_result}
%%           FieldInfo    = list() of term()
%%           Rows         = list() of [string()]
%%           AffectedRows = int()
%%           Reason       = term()
%%--------------------------------------------------------------------
get_query_response(LogFun, RecvPid, Version) ->
    case do_recv(LogFun, RecvPid, undefined) of
        {ok, <<Fieldcount:8, Rest/binary>>, _} ->
            case Fieldcount of
                0 ->
                    %% No Tabular data
                    case Rest of
                        <<252:8, AffectedRows:16/little, _Rest2/binary>> ->
                            {updated, #mysql_result{affectedrows=AffectedRows}};
                        <<253:8, AffectedRows:24/little, _Rest2/binary>> ->
                            {updated, #mysql_result{affectedrows=AffectedRows}};
                        <<254:8, AffectedRows:32/little, _Rest2/binary>> ->
                            {updated, #mysql_result{affectedrows=AffectedRows}};
                        <<AffectedRows:8, _Rest2/binary>> ->
                            {updated, #mysql_result{affectedrows=AffectedRows}}
                    end;
                %%<<AffectedRows:8, _Rest2/binary>> = Rest,
                %%{updated, #mysql_result{affectedrows=AffectedRows}};
                255 ->
                    <<_Code:16/little, Message/binary>>  = Rest,
                    {error, #mysql_result{error=Message}};
                _ ->
                    %% 如果第一字节不为0或255，则有数据返回
                    %% 先读取字段信息，再读数据
                    %% Tabular data received
                    case get_fields(LogFun, RecvPid, [], Version) of
                        {ok, Fields} ->
                            case get_rows(Fields, LogFun, RecvPid, []) of
                                {ok, Rows} ->
                                    {data, #mysql_result{fieldinfo=Fields,
                                            rows=Rows}};
                                {error, Reason} ->
                                    {error, #mysql_result{error=Reason}}
                            end;
                        {error, Reason} ->
                            {error, #mysql_result{error=Reason}}
                    end
            end;
        {error, Reason} ->
            {error, #mysql_result{error=Reason}}
    end.

%%--------------------------------------------------------------------
%% Function: get_fields(LogFun, RecvPid, [], Version)
%%           LogFun  = undefined | function() with arity 3
%%           RecvPid = pid(), mysql_recv process
%%           Version = integer(), Representing MySQL version used
%% Descrip.: Received and decode field information.
%% Returns : {ok, FieldInfo} |
%%           {error, Reason}
%%           FieldInfo = list() of term()
%%           Reason    = term()
%%--------------------------------------------------------------------
%% Support for MySQL 4.0.x:
get_fields(LogFun, RecvPid, Res, ?MYSQL_4_0) ->
    case do_recv(LogFun, RecvPid, undefined) of
        {ok, Packet, _Num} ->
            case Packet of
                <<254:8>> ->
                    {ok, lists:reverse(Res)};
                <<254:8, Rest/binary>> when size(Rest) < 8 ->
                    {ok, lists:reverse(Res)};
                _ ->
                    {Table, Rest} = get_with_length(Packet),
                    {Field, Rest2} = get_with_length(Rest),
                    {LengthB, Rest3} = get_with_length(Rest2),
                    LengthL = size(LengthB) * 8,
                    <<Length:LengthL/little>> = LengthB,
                    {Type, Rest4} = get_with_length(Rest3),
                    {_Flags, _Rest5} = get_with_length(Rest4),
                    This = {Table,
                        Field,
                        Length,
                        %% TODO: Check on MySQL 4.0 if types are specified
                        %%       using the same 4.1 formalism and could 
                        %%       be expanded to atoms:
                        Type},
                    get_fields(LogFun, RecvPid, [This | Res], ?MYSQL_4_0)
            end;
        {error, Reason} ->
            {error, Reason}
    end;
%% Support for MySQL 4.1.x and 5.x:
get_fields(LogFun, RecvPid, Res, ?MYSQL_4_1) ->
    case do_recv(LogFun, RecvPid, undefined) of
        {ok, Packet, _Num} ->
            case Packet of
                <<254:8>> ->
                    {ok, lists:reverse(Res)};
                <<254:8, Rest/binary>> when size(Rest) < 8 ->
                    {ok, lists:reverse(Res)};
                _ ->
                    {_Catalog, Rest} = get_with_length(Packet),
                    {_Database, Rest2} = get_with_length(Rest),
                    {Table, Rest3} = get_with_length(Rest2),
                    %% OrgTable is the real table name if Table is an alias
                    {_OrgTable, Rest4} = get_with_length(Rest3),
                    {Field, Rest5} = get_with_length(Rest4),
                    %% OrgField is the real field name if Field is an alias
                    {_OrgField, Rest6} = get_with_length(Rest5),

                    <<_Metadata:8/little, _Charset:16/little,
                    Length:32/little, Type:8/little,
                    _Flags:16/little, _Decimals:8/little,
                    _Rest7/binary>> = Rest6,

                    This = {Table,
                        Field,
                        Length,
                        get_field_datatype(Type)},
                    get_fields(LogFun, RecvPid, [This | Res], ?MYSQL_4_1)
            end;
        {error, Reason} ->
            {error, Reason}
    end.

%%--------------------------------------------------------------------
%% Function: get_rows(N, LogFun, RecvPid, [])
%%           N       = integer(), number of rows to get
%%           LogFun  = undefined | function() with arity 3
%%           RecvPid = pid(), mysql_recv process
%% Descrip.: Receive and decode a number of rows.
%% Returns : {ok, Rows} |
%%           {error, Reason}
%%           Rows = list() of [string()]
%%--------------------------------------------------------------------
get_rows(Fields, LogFun, RecvPid, Res) ->
    case do_recv(LogFun, RecvPid, undefined) of
        {ok, Packet, _Num} ->
            case Packet of
                <<254:8, Rest/binary>> when size(Rest) < 8 ->
                    %% 如果整个包就是一个字符串，则直接返回
                    {ok, lists:reverse(Res)};
                _ ->
                    %% 取得一行数据
                    {ok, This} = get_row(Fields, Packet, []),
                    get_rows(Fields, LogFun, RecvPid, [This | Res])
            end;
        {error, Reason} ->
            {error, Reason}
    end.

%% part of get_rows/4
get_row([], _Data, Res) ->
    {ok, lists:reverse(Res)};
get_row([Field | OtherFields], Data, Res) ->
    {Col, Rest} = get_with_length(Data),
    This = case Col of
        null ->
            undefined;
        _ ->
            convert_type(Col, element(4, Field))
    end,
    get_row(OtherFields, Rest, [This | Res]).

get_with_length(<<251:8, Rest/binary>>) ->
    %% LONG_BLOG类型，不支持
    {null, Rest};
%% BLOB类型，2字节包长
get_with_length(<<252:8, Length:16/little, Rest/binary>>) ->
    split_binary(Rest, Length);
%% VAR_STRING类型，3字节包长
get_with_length(<<253:8, Length:24/little, Rest/binary>>) ->
    split_binary(Rest, Length);
get_with_length(<<254:8, Length:64/little, Rest/binary>>) ->
    split_binary(Rest, Length);
%% 其它类型为1字节包长
get_with_length(<<Length:8, Rest/binary>>) when Length < 251 ->
    split_binary(Rest, Length).


%%--------------------------------------------------------------------
%% Function: do_send(Sock, Packet, SeqNum, LogFun)
%%           Sock   = term(), gen_tcp socket
%%           Packet = binary()
%%           SeqNum = integer(), packet sequence number
%%           LogFun = undefined | function() with arity 3
%% Descrip.: Send a packet to the MySQL server.
%%           给MySQL发包
%% Returns : result of gen_tcp:send/2
%%--------------------------------------------------------------------
do_send(Sock, Packet, SeqNum, _LogFun) when is_binary(Packet), is_integer(SeqNum) ->
    %% 3字节包长 + 1字节包序 + 包内容
    Data = <<(size(Packet)):24/little, SeqNum:8, Packet/binary>>,
    gen_tcp:send(Sock, Data).

%%--------------------------------------------------------------------
%% Function: normalize_version(Version, LogFun)
%%           Version  = string()
%%           LogFun   = undefined | function() with arity 3
%% Descrip.: Return a flag corresponding to the MySQL version used.
%%           The protocol used depends on this flag.
%%           较正MySQL版本
%% Returns : Version = string()
%%--------------------------------------------------------------------
normalize_version([$4,$.,$0|_T], LogFun) ->
    ?Log(LogFun, debug, "switching to MySQL 4.0.x protocol."),
    ?MYSQL_4_0;
normalize_version([$4,$.,$1|_T], _LogFun) ->
    ?MYSQL_4_1;
normalize_version([$5|_T], _LogFun) ->
    %% MySQL version 5.x protocol is compliant with MySQL 4.1.x:
    %% MySQL5.x与4.1协议是兼容的
    ?MYSQL_4_1; 
normalize_version(_Other, LogFun) ->
    ?Log(LogFun, error, "MySQL version not supported: MySQL Erlang module "
        "might not work correctly."),
    %% Error, but trying the oldest protocol anyway:
    ?MYSQL_4_0.

%%--------------------------------------------------------------------
%% Function: get_field_datatype(DataType)
%%           DataType = integer(), MySQL datatype
%% Descrip.: Return MySQL field datatype as description string
%%           翻译字段名称
%% Returns : String, MySQL datatype
%%--------------------------------------------------------------------
get_field_datatype(0) ->   'DECIMAL';
get_field_datatype(1) ->   'TINY';
get_field_datatype(2) ->   'SHORT';
get_field_datatype(3) ->   'LONG';
get_field_datatype(4) ->   'FLOAT';
get_field_datatype(5) ->   'DOUBLE';
get_field_datatype(6) ->   'NULL';
get_field_datatype(7) ->   'TIMESTAMP';
get_field_datatype(8) ->   'LONGLONG';
get_field_datatype(9) ->   'INT24';
get_field_datatype(10) ->  'DATE';
get_field_datatype(11) ->  'TIME';
get_field_datatype(12) ->  'DATETIME';
get_field_datatype(13) ->  'YEAR';
get_field_datatype(14) ->  'NEWDATE';
get_field_datatype(246) -> 'NEWDECIMAL';
get_field_datatype(247) -> 'ENUM';
get_field_datatype(248) -> 'SET';
get_field_datatype(249) -> 'TINYBLOB';
get_field_datatype(250) -> 'MEDIUM_BLOG';
get_field_datatype(251) -> 'LONG_BLOG';
get_field_datatype(252) -> 'BLOB';
get_field_datatype(253) -> 'VAR_STRING';
get_field_datatype(254) -> 'STRING';
get_field_datatype(255) -> 'GEOMETRY'.

%% 把二进制数据转换成特定的类型
convert_type(Val, ColType) ->
    case ColType of
        T when T == 'TINY';
    T == 'SHORT';
T == 'LONG';
T == 'LONGLONG';
T == 'INT24';
T == 'YEAR' ->
    list_to_integer(binary_to_list(Val));
T when T == 'TIMESTAMP';
T == 'DATETIME' ->
    {ok, [Year, Month, Day, Hour, Minute, Second], _Leftovers} =
    io_lib:fread("~d-~d-~d ~d:~d:~d", binary_to_list(Val)),
    {datetime, {{Year, Month, Day}, {Hour, Minute, Second}}};
'TIME' ->
    {ok, [Hour, Minute, Second], _Leftovers} =
    io_lib:fread("~d:~d:~d", binary_to_list(Val)),
    {time, {Hour, Minute, Second}};
'DATE' ->
    {ok, [Year, Month, Day], _Leftovers} =
    io_lib:fread("~d-~d-~d", binary_to_list(Val)),
    {date, {Year, Month, Day}};
T when T == 'DECIMAL';
T == 'NEWDECIMAL';
T == 'FLOAT';
T == 'DOUBLE' ->
    {ok, [Num], _Leftovers} =
    case io_lib:fread("~f", binary_to_list(Val)) of
        {error, _} ->
            io_lib:fread("~d", binary_to_list(Val));
        Res ->
            Res
    end,
    Num;
_Other ->
    %% 字符串不需要转换，原样返回
    Val
end.

