%%----------------------------------------------------
%% $Id$
%% 与登陆服务器的Socket连接
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(login_server).
-behaviour(gen_server).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------
-export([
        init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
    ]).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([
        start_link/0
        ,sendToLoginServer/1
%%         ,ini_ReadString/3
%%         ,ini_ReadInt/3
%%         ,ini_ReadKey/3
    ]).

-record(state, {
        socket
        ,half_package = <<>>
    }).

%% Include files
-include("db.hrl").
-include("playerDefine.hrl").
-include("package.hrl").
-include("common.hrl").
-include("platformDefine.hrl").
-include("mailDefine.hrl").
-include("condition_compile.hrl").
-include("globalDefine.hrl").

-define(Reconnect_LoginServer_Interval_ms,5*1000).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
	gen_server:start_link({local,?MODULE},?MODULE, [], []).



%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
	IP = env:get(login_server_ip),
	Port = env:get(login_server_port),
	%%开始面向loginserver的网络连接
	?INFO( "beginNetLoginServer start connect ip[~p] port:~p", [IP, Port] ),
	put("ConnectIP",IP),
	put("ConnectPort",Port),
	reconnectLoginUser().	

handle_call(_Request, _From, State) ->
    {noreply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Socket消息处理
handle_info({tcp, Socket, Bin}, State)->
    Bin2 = case State#state.half_package of
        <<>> -> Bin;
        HalfPackge -> list_to_binary([HalfPackge, Bin])
    end,
    case unpack(Socket, Bin2) of
        {ok, RestBin} ->
            State1 = State#state{half_package = RestBin},
            case inet:setopts(Socket,[{active, once}]) of
                ok -> {noreply, State1};
                {error, Reason} -> 
                    ?ERR("inet:setopts, reason:~p ~n",[Reason]),
                    {stop, normal, State1}
            end;
        {error, Reason} ->
            ?ERR("unpack: ~p", [Reason]),
            {stop, normal, State}
    end;

%% STOP
handle_info(stop, State)->
    {stop, normal, State};

handle_info(Info, #state{socket=Socket} = StateData)->	
	put( "receiveLoginServer", true ),
	put("handle_info_state",StateData),
	try
	case Info of
	%%   {tcp,Socket,Data}->
	%% 	  case Socket of
	%% 		  undefined -> ok;
	%% 		  _ ->
	%% 			  inet:setopts(Socket,[{active,once}]),
	%% 			  doMsg(Socket,Data)
	%% 	  end;
	  { db_GS2LS_QueryUserMaxLevelResult, ToLS }->
		sendToLoginServer( ToLS );
	 {tcp_error, _Socket, Reason}->
		 ?ERR( "receiveLoginServer closed reson[~p]", [Reason] ),
		 doLoginServerSocketClose(Socket, 0 );
		 %put( "receiveLoginServer", false );
     {tcp_closed,_Socket}->
		 ?INFO( "receiveLoginServer closed normal " ),
		 doLoginServerSocketClose(Socket, 0 );
		 %put( "receiveLoginServer", false );
	{ lsTimer_reconnectLoginserver }->
		case reconnectLoginUser() of
			{ok, State1}->put("handle_info_state",State1);
			_ -> erlang:send_after(?Reconnect_LoginServer_Interval_ms, self(),{lsTimer_reconnectLoginserver} )
		end;
	Unkown->
		?INFO("recv unkown msg:~p",Unkown)
	end,

	case get( "receiveLoginServer" ) of
		true->{noreply, get("handle_info_state")};
		false->{stop, normal, get("handle_info_state")}
	end

	catch
		_:_Why->
			common:messageBox( "ExceptionFunc_Module:[~p] ExceptionFunc[hande_info] Why[~p] stack[~p]", 
						[?MODULE,_Why, erlang:get_stacktrace()] ),
			{noreply, get("handle_info_state")}
	end.


%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

unpack(Socket, BinIn = <<Len:16/little, Code:16/little, RestBin1/binary>>) ->
    DataLen = Len - 4,
    case RestBin1 of
        <<DataBin:DataLen/binary, RestBin/binary>> ->
            Cmd = ( Code band 16#7FF ),
            ?DEBUG("Cmd:~w, Data:~w", [Cmd, DataBin]),
            %% 数据处理
            case msg_LS2GS:dealMsg(Socket, Cmd, DataBin) of
                noMatch ->
                    ?WARN("undefined cmd:~p data:~w", [Cmd, DataBin]);
                _ -> ok
            end,
            RestLen = byte_size(RestBin),
            case RestLen > 1048576 of
                true ->
                    %% 不能解包的数据累积太多了（大于1M），结束进程
                    ?ERR("RestBin too larger: ~w", [RestLen]),
                    {error, rest_binary_too_larger};
                false ->
                    %% 继续回调处理粘包的情况
                    unpack(Socket, RestBin)
            end;
        _ ->
            ?DEBUG("HalfPackge1:~w", [BinIn]),
            {ok, BinIn}
    end;
unpack(_, HalfPackge) -> 
    ?DEBUG("HalfPackge2:~w", [HalfPackge]),
    {ok, HalfPackge}.

doLoginServerSocketClose(Socket, Reson )->
	?DEBUG( " the socket(to gs) is closed,reson:~p",[Reson] ),
	case Socket of
		undefined->ok;
		_ -> gen_tcp:close(Socket)
	end,
	etsBaseFunc:changeFiled( ?GlobalMainAtom, ?GlobalMainID, #globalMain.loginServerSocket, 0 ),
	put( "LoginServerSocket", undefined ),
	erlang:send_after(?Reconnect_LoginServer_Interval_ms,self(), {lsTimer_reconnectLoginserver} ),
	put("handle_info_state",#state{socket=undefined}).
	
reconnectLoginUser() ->
	IP = get( "ConnectIP" ),
	Port = get( "ConnectPort" ),
	case gen_tcp:connect(IP, Port, ?CONNECT_TCP_OPTIONS ) of
        {ok, Socket} ->
			PID = self(),
			gen_tcp:controlling_process(Socket, PID),	
			put( "LoginServerSocket", Socket ),	
			etsBaseFunc:changeFiled( ?GlobalMainAtom, ?GlobalMainID, #globalMain.loginServerSocket, Socket ),
			?INFO( "loginserver connected ." ),
			%%链接成功，发验证消息给loginserver
			timer:sleep( 1000 ),
			sendLoginMsg(),	
			inet:setopts(Socket,?TCP_OPTIONS),
			{ok, #state{socket=Socket}};
        {error, Reason} ->
            ?ERR( "connect to loginserver error ~p", [Reason] ),
			{error, Reason};
		_->
           ?ERR( "connect to loginserver error uknown" ),
		   {error,{init,unknow}}
    end.


getLoginServerSocket()->
	Socket = get( "LoginServerSocket" ),
	case Socket of
		undefined->
			etsBaseFunc:getRecordField(?GlobalMainAtom,?GlobalMainID, #globalMain.loginServerSocket );
		_->Socket
	end.

sendToLoginServer( Msg )->
	Socket = getLoginServerSocket(),
	case Socket of
		0->
			?INFO( "sendToLoginServer Socket=0 Msg[~p]", [Msg] );
		_->
			msg_LS2GS:send(Socket, Msg)
	end.

sendLoginMsg()->
    MyIP = util:default_var(env:get(listen_to_user_ip), util:get_ip()),
    Name = env:get(server_name),
	ListenToUserPort = env:get(listen_to_user_port),
	Recommend = util:default_var(env:get(remmond), 0),
	Hot = util:default_var(env:get(hot), 0),
	Msg = #pk_GS2LS_Request_Login{serverID=common:formatString(main:getServerID()), name=Name, ip=MyIP, port=ListenToUserPort, remmond=Recommend, showInUserGameList=1,hot = Hot },
	sendToLoginServer( Msg ),
	ok.

%% ini_ReadKey( IniFile, File, Key )->
%% 	case io:get_line(File, '') of
%% 		eof->
%% 			throw(-1);
%% 		{error, Reason }->
%% 			?INFO( "ini_ReadKey IniFile[~p] Key[~p] getline false[~p]", [IniFile, Key, Reason] ),
%% 			throw(-1);
%% 		LineString->
%% 			Tokens = string:tokens(LineString, "=\n"),
%% 			case length( Tokens ) >= 2 of
%% 				true->
%% 					[ReadKey|Tokens2] = Tokens,
%% 					case length( Tokens2 ) > 1 of
%% 						true->[ReadValue|_] = Tokens2;
%% 						false->ReadValue=Tokens2
%% 					end,
%% 					case ReadKey =:= Key of
%% 						true->ReadValue;
%% 						false->ini_ReadKey(IniFile, File, Key)
%% 					end;
%% 				false->ini_ReadKey(IniFile, File, Key)
%% 			end
%% 	end.
%% 
%% ini_ReadString( IniFile, Key, Default )->
%% 	try
%% 		put( "ini_ReadString_File", 0 ),
%% 		case file:open("data/" ++ IniFile, read ) of
%% 			{ok, File }->
%% 				put( "ini_ReadString_File", File ),
%% 				ReadValue = ini_ReadKey( IniFile, File, Key ),
%% 				file:close(File),
%% 				[Return|_] = ReadValue,
%% 				Return;
%% 			{error, Reason}->
%% 				?INFO( "ini_ReadString IniFile[~p] Key[~p] file open false[~p]", [IniFile, Key, Reason] ),
%% 				throw(-1);
%% 			_->
%% 				throw(-1)
%% 		end
%% 	catch
%% 		_->
%% 			File2 = get( "ini_ReadString_File" ),
%% 			case File2 of
%% 				0->ok;
%% 				_->file:close(File2)
%% 			end,
%% 			Default
%% 	end.
%% 
%% ini_ReadInt( IniFile, Key, Default )->
%% 	ReadString = ini_ReadString( IniFile, Key, Default ),
%% 	case ReadString =:= Default of
%% 		true->Default;
%% 		false->
%% 			{Return,_}=string:to_integer( ReadString ),
%% 			Return
%% 	end.

