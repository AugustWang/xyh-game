-module(role_h).

-include("db.hrl").
-include("userDefine.hrl").
-include("platformDefine.hrl").
-include("package.hrl").
-include("common.hrl").
-include("gameServerDefine.hrl").

-compile(export_all).

onUserOffline()->
    ok.

on_Login_553(#pk_U2LS_Login_553{}=Msg)->
    Account = Msg#pk_U2LS_Login_553.account,
    PlatformID = Msg#pk_U2LS_Login_553.platformID,
    Time = Msg#pk_U2LS_Login_553.time,
    Sign = Msg#pk_U2LS_Login_553.sign,
    VersionRes = Msg#pk_U2LS_Login_553.versionRes,
    VersionExe = Msg#pk_U2LS_Login_553.versionExe,
    VersionGame = Msg#pk_U2LS_Login_553.versionGame,
    VersionPro = Msg#pk_U2LS_Login_553.versionPro,
    try
        case role:getCurUserState() =:= ?UserState_UnCheckPass of
            false->throw(-1);
            true->ok
        end,
        role:setCurUserState( ?UserState_WaitCheckPass ),
        ?DEBUG("PlatformID:[~p],isTestSupport:[~p],is553Support:[~p]",[PlatformID,platform553:is_test_support(),platform553:is_support()]),
        case ((PlatformID =:= ?PLATFORM_TEST) and (platform553:is_test_support() =:= yes)) or 
            ((PlatformID =:= ?PLATFORM_553) and (platform553:is_support() =:= yes)) or 
            ((PlatformID =:= ?PLATFORM_553_android) and (platform553:is_android_support() =:= yes))of
            true->ok;
            false->throw(-2)
        end,
        case ((PlatformID =:= ?PLATFORM_553) and (success =:= verify:verify553(Account,Time,Sign))) or
            ((PlatformID =:= ?PLATFORM_TEST) and (success =:= verify:verifyTest(Account,role:getCurUserIP())))  or
            ((PlatformID =:= ?PLATFORM_553_android) and (success =:= verify:verify553_android(Account,Time,Sign))) of
            true->
                Params=#userDBLogin{account=Account,platformID=PlatformID,versionRes=VersionRes,versionExe=VersionExe,versionGame=VersionGame,versionPro=VersionPro},
                Result = userDB:onUserLogin(role:getCurUserSocket(),Params),	
                on_dbLoginResult(Result);
            false->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_UserNameOrPassword,account=Account,userID=0,platId=PlatformID})
        end
    catch
        -2->
            on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Unsupport,account=Account,userID=0,platId=PlatformID});

        _->
            on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Exception,account=Account,userID=0,platId=PlatformID})
    end.

%%-------------------------------------------------------------------------------------
on_Login_APPS( #pk_U2LS_Login_APPS{}=Msg )->
    Account = Msg#pk_U2LS_Login_APPS.account,
    PlatformID = Msg#pk_U2LS_Login_APPS.platformID,
    Time = Msg#pk_U2LS_Login_APPS.time,
    Sign = Msg#pk_U2LS_Login_APPS.sign,
    VersionRes = Msg#pk_U2LS_Login_APPS.versionRes,
    VersionExe = Msg#pk_U2LS_Login_APPS.versionExe,
    VersionGame = Msg#pk_U2LS_Login_APPS.versionGame,
    VersionPro = Msg#pk_U2LS_Login_APPS.versionPro,
    try
        case role:getCurUserState() =:= ?UserState_UnCheckPass of
            false->throw(-1);
            true->ok
        end,

        role:setCurUserState( ?UserState_WaitCheckPass ),

        case ((PlatformID =:= ?PLATFORM_APPS) and (platformAPPS:is_support() =:= yes)) of
            true->ok;
            false->throw(-2)
        end,

        case success =:= verify:verifyAPPS(Account,Time,Sign) of
            true->
                Params=#userDBLogin{account=Account,platformID=PlatformID,versionRes=VersionRes,versionExe=VersionExe,versionGame=VersionGame,versionPro=VersionPro},
                Result = userDB:onUserLogin(role:getCurUserSocket(),Params),	
                on_dbLoginResult(Result);
            false->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_UserNameOrPassword,account=Account,userID=0,platId=PlatformID})
        end
    catch
        -2->
            on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Unsupport,account=Account,userID=0,platId=PlatformID});

        _->
            on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Exception,account=Account,userID=0,platId=PlatformID})
    end.

%%-------------------------------------------------------------------------------------
on_Login_360( #pk_U2LS_Login_360{}=Msg )->
    Account = Msg#pk_U2LS_Login_360.account,
    PlatformID = Msg#pk_U2LS_Login_360.platformID,
    AuthoCode = Msg#pk_U2LS_Login_360.authoCode,
    VersionRes = Msg#pk_U2LS_Login_360.versionRes,
    VersionExe = Msg#pk_U2LS_Login_360.versionExe,
    VersionGame = Msg#pk_U2LS_Login_360.versionGame,
    VersionPro = Msg#pk_U2LS_Login_360.versionPro,
    try
        case role:getCurUserState() =:= ?UserState_UnCheckPass of
            false->throw(-1);
            true->ok
        end,

        role:setCurUserState( ?UserState_WaitCheckPass ),

        case ((PlatformID =:= ?PLATFORM_360) and (platform360:is_support() =:= yes)) of
            true->ok;
            false->throw(-2)
        end,

        case verify:verify360(AuthoCode) of 
            {success,UserID,Account0,AccessToken,RefreshToken}->
                ?DEBUG("verify360 ok.Account:~p,AccessToken:~p,RefreshToken:~p",[Account0,AccessToken,RefreshToken]),
                %% 通知客户端，用户名,access_token,refreshToken
                role:send( #pk_LS2U_Login_360{account=Account0,userid=UserID,access_token=AccessToken,refresh_token=RefreshToken} ),

                Params=#userDBLogin{account=Account0,platformID=PlatformID,versionRes=VersionRes,versionExe=VersionExe,versionGame=VersionGame,versionPro=VersionPro},
                Result = userDB:onUserLogin(role:getCurUserSocket(),Params),	
                on_dbLoginResult(Result);
            error->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Disconnect,account=Account,userID=0,platId=PlatformID});
            failed->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_UserNameOrPassword,account=Account,userID=0,platId=PlatformID});
            timeout->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Timeout,account=Account,userID=0,platId=PlatformID});
            closed->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Disconnect,account=Account,userID=0,platId=PlatformID});
            _->
                on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Unknown,account=Account,userID=0,platId=PlatformID})
        end
    catch
        -2->
            on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Unsupport,account=Account,userID=0,platId=PlatformID});
        _->
            on_dbLoginResult(#userDBLoginResult{resultCode=?Login_LS_Result_Fail_Exception,account=Account,userID=0,platId=PlatformID})
    end.

%%-------------------------------------------------------------------------------------

on_dbLoginResult( #userDBLoginResult{account=Account}=UserDBLoginResult )->
    try
        case role:getCurUserState() =:= ?UserState_WaitCheckPass of
            false->throw(-1);
            true->ok
        end,

        case UserDBLoginResult#userDBLoginResult.resultCode of
            ?Login_LS_Result_Succ->
                %%验证成功，检查是否有被封号
                case forbidden:forbiddenCheck(Account) of
                    true->throw({forbiddenAccount});
                    false->ok
                end,
                %%验证成功，检查是否有重复登录
                OtherLoginUser = main:getGlobalLoginUser( UserDBLoginResult#userDBLoginResult.userID ),
                case OtherLoginUser of
                    {}->
                        %%没有重复登录，登录成功
                        %%设置用户表，
                        etsBaseFunc:changeFiled( role:getCurUserSocketTable(), role:getCurUserSocket(), #userSocketRecord.userID, UserDBLoginResult#userDBLoginResult.userID ),
                        etsBaseFunc:changeFiled( role:getCurUserSocketTable(), role:getCurUserSocket(), #userSocketRecord.userName, UserDBLoginResult#userDBLoginResult.account ),
                        etsBaseFunc:changeFiled( role:getCurUserSocketTable(), role:getCurUserSocket(), #userSocketRecord.platId, UserDBLoginResult#userDBLoginResult.platId ),
                        %%修改用户状态
                        role:setCurUserState( ?UserState_WaitUserAskGameServerList ),
                        %%修改Socket检查验证
                        put( "IsSocketCheckPass", true ),
                        put( "UserID", UserDBLoginResult#userDBLoginResult.userID ),
                        %%通知main，用户登录验证成功
                        UserSocketRecord = role:getCurUserSocketRecord(),
                        main_PID ! { loginUser, UserDBLoginResult#userDBLoginResult.userID, role:getCurUserSocket(), self(), UserSocketRecord#userSocketRecord.randIdentity },
                        %%发送验证成功消息
                        role:send( #pk_LS2U_LoginResult{result=?Login_LS_Result_Succ,userID=UserDBLoginResult#userDBLoginResult.userID} ),
                        ?INFO( "username[~p] userid[~p] socket[~p] ip[~p] check pass to wait next ask",
                            [UserDBLoginResult#userDBLoginResult.account,
                                UserDBLoginResult#userDBLoginResult.userID,
                                role:getCurUserSocket(),
                                get("UserIP") ] ),
                        ok;
                    _->
                        %%存在已登录用户，通知main，踢掉
                        main_PID ! { kickOutUser, self(), UserDBLoginResult#userDBLoginResult.userID },
                        %%修改用户状态
                        role:setCurUserState( ?UserState_WaitKickOutOther ),
                        %%设置用户表，
                        etsBaseFunc:changeFiled( role:getCurUserSocketTable(), role:getCurUserSocket(), #userSocketRecord.userID, UserDBLoginResult#userDBLoginResult.userID ),
                        etsBaseFunc:changeFiled( role:getCurUserSocketTable(), role:getCurUserSocket(), #userSocketRecord.userName, UserDBLoginResult#userDBLoginResult.account ),
                        %%重复了，main_PID会踢掉后再通知
                        %%role:send(#pk_LS2U_LoginResult{result=?Login_LS_Result_Fail_OtherLogin,userID=0}),
                        ?INFO( "username[~p] userid[~p] socket[~p] ip[~p] check pass to kick out old",
                            [UserDBLoginResult#userDBLoginResult.account,
                                UserDBLoginResult#userDBLoginResult.userID,
                                role:getCurUserSocket(),
                                get("UserIP")] ),
                        ok
                end,
                ok;
            ?Login_LS_Result_Fail_UserNameOrPassword->
                role:send( #pk_LS2U_LoginResult{result=?Login_LS_Result_Fail_UserNameOrPassword,userID=0} ),
                %%设置状态
                role:setCurUserState( ?UserState_WaitCloseUserSocket ),
                %%关socket
                gen_tcp:close( role:getCurUserSocket() ),
                ?INFO( "user sokcet[~p] check fail [~p]", [role:getCurUserSocket(), UserDBLoginResult#userDBLoginResult.resultCode] ),
                ok;
            _->
                role:send( #pk_LS2U_LoginResult{result=UserDBLoginResult#userDBLoginResult.resultCode,userID=0} ),
                %%设置状态
                role:setCurUserState( ?UserState_WaitCloseUserSocket ),
                %%关socket
                gen_tcp:close( role:getCurUserSocket() ),
                ?INFO( "user socket[~p] check fail [~p]", [role:getCurUserSocket(), UserDBLoginResult#userDBLoginResult.resultCode] ),
                ok
        end,
        ok
    catch
        {forbiddenAccount}->
            role:send( #pk_LS2U_LoginResult{result=?Login_LS_Result_Fail_Forbidden,userID=0} ),
            %%设置状态
            role:setCurUserState( ?UserState_WaitCloseUserSocket ),
            %%关socket
            gen_tcp:close( role:getCurUserSocket() ),
            ?INFO( "user socket[~p],account[~p] is forbidden", [role:getCurUserSocket(),Account] ),
            ok;
        _->
            role:send( #pk_LS2U_LoginResult{result=?Login_LS_Result_Fail_Exception,userID=0} ),
            %%设置状态
            role:setCurUserState( ?UserState_WaitCloseUserSocket ),
            %%关socket
            gen_tcp:close( role:getCurUserSocket() ),
            ?INFO( "user socket[~p] check fail [~p]", [role:getCurUserSocket(), UserDBLoginResult#userDBLoginResult.resultCode] ),
            ok
    end.

onMsgKickOutUserComplete()->
    try
        %%修改用户状态
        role:setCurUserState( ?UserState_WaitCloseUserSocket ),
        %%通知用户，已踢掉上一个在线
        role:send( #pk_LS2U_LoginResult{result=?Login_LS_Result_Fail_OtherLogin,userID=0} ),
        %%关socket
        gen_tcp:close( role:getCurUserSocket() ),
        ?INFO( "onMsgKickOutUserComplete user socket[~p]", [role:getCurUserSocket()] ),
        ok
    catch
        _->ok
    end.

onMsgRequestGameServerList()->
    try
        case role:getCurUserState() =:= ?UserState_WaitUserAskGameServerList of
            false->throw(-1);
            true->ok
        end,

        AllRunningServerList = game_server:getAllRunningGameServerIDList(),
        case AllRunningServerList of
            []->
                UnrunningList = game_server:getAllUnRunningGameServerList(),
                case UnrunningList of
                    []->throw(-1);					
                    _->ok
                end,
                ToMsgFunc = fun( GameServer )->			
                        #pk_GameServerInfo{
                            serverID=GameServer#gameServerRecord.serverID,
                            name=GameServer#gameServerRecord.name,
                            state=game_server:getGameServerUserState( GameServer ),
                            showIndex=GameServer#gameServerRecord.showInUserGameList,
                            remmond=GameServer#gameServerRecord.remmond,
                            maxPlayerLevel=0,
                            isnew=GameServer#gameServerRecord.isnew,
                            begintime=GameServer#gameServerRecord.begintime,
                            hot=GameServer#gameServerRecord.hot
                        }					
                end,
                UnrunningMsgList = lists:map( ToMsgFunc, UnrunningList ),		

                SetClosedList = game_server:getAllSetClosdGameServerList(),
                ToFun= fun( GS )->			
                        #pk_GameServerInfo{
                            serverID=GS#gameServerRecord.serverID,
                            name=GS#gameServerRecord.name,
                            state=game_server:getGameServerUserState( GS ),
                            showIndex=GS#gameServerRecord.showInUserGameList,
                            remmond=GS#gameServerRecord.remmond,
                            maxPlayerLevel=0,
                            isnew=GS#gameServerRecord.isnew,
                            begintime=GS#gameServerRecord.begintime,
                            hot=GS#gameServerRecord.hot
                        }					
                end,
                SetClosedMsgList = lists:map( ToFun, SetClosedList ),	

                ToUser = #pk_LS2U_GameServerList{ gameServers=UnrunningMsgList--SetClosedMsgList},
                %%role:send( ToUser ),
                sendGameServerListToUser( ToUser ),

                role:setCurUserState( ?UserState_WaitUserSelGameServer ),

                throw(-1);

            %% 老版本 直接丢掉了  不在线的也不给发下去
            %%role:send( #pk_LS2U_GameServerList{ gameServers=[] } ),
            %%throw(-1);
            _->ok
        end,

        put( "WaitGameServerAck_MaxPlayerLevel_List", AllRunningServerList ),
        role:setCurUserState( ?UserState_WaitGameServerAckMaxPlayerLevel ),

        Msg = #pk_LS2GS_QueryUserMaxLevel{ userID = role:getCurUserID() },

        MyFunc = fun( Record )->
                game_server:sendToGameServerByServerID( Record, Msg )
        end,
        lists:map( MyFunc, AllRunningServerList ),

        put( "GameServerList", [] ),

        timer:send_after(2000,  {timeOut_WaitUserAskGameServerList}),

        ?DEBUG( "onMsgRequestGameServerList usrid[~p] AllRunningServerList[~p]", [role:getCurUserID(), AllRunningServerList] ),

        ok
    catch
        _->ok
    end.



on_gameServerClosed( ServerID )->
    %%用户所在GameServer断开，踢掉
    ?INFO( "on_gameServerClosed ServerID[~p] socket[~p] UserID[~p]", [ServerID, role:getCurUserSocket(), role:getCurUserID()] ),
    gen_tcp:close( role:getCurUserSocket() ),
    ok.

on_gameServer_QueryUserMaxLevelResult( ServerID, MaxPlayerLevel )->
    try
        ?DEBUG( "on_gameServer_QueryUserMaxLevelResult userid[~p] ServerID[~p] MaxPlayerLevel[~p] begin", [role:getCurUserID(), ServerID, MaxPlayerLevel] ),

        case role:getCurUserState() =:= ?UserState_WaitGameServerAckMaxPlayerLevel of
            false->throw(-1);
            true->ok
        end,

        AllRunningServerList = get( "WaitGameServerAck_MaxPlayerLevel_List" ),
        case AllRunningServerList of
            []->throw(-1);
            undefined->throw(-1);
            _->ok
        end,

        GameServer = game_server:getGameServerRecord( ServerID ),
        case GameServer of
            {}->throw(-1);
            _->ok
        end,

        GameServerInfo = #pk_GameServerInfo{
            serverID=ServerID,
            name=GameServer#gameServerRecord.name,
            state=game_server:getGameServerUserState( GameServer ),
            showIndex=GameServer#gameServerRecord.showInUserGameList,
            remmond=GameServer#gameServerRecord.remmond,
            maxPlayerLevel=MaxPlayerLevel,
            isnew=GameServer#gameServerRecord.isnew,
            begintime=GameServer#gameServerRecord.begintime,
            hot=GameServer#gameServerRecord.hot 
        },
        GameServerList = get( "GameServerList" ),
        case GameServerList of
            []->
                case GameServer#gameServerRecord.hot =/= ?GameServer_User_State_Set_Closed of
                    true->put( "GameServerList", [GameServerInfo] );
                    false->ok
                end;


            undefined->
                case GameServer#gameServerRecord.hot =/= ?GameServer_User_State_Set_Closed of
                    true->put( "GameServerList", [GameServerInfo] );
                    false->ok
                end;

            _->
                case GameServer#gameServerRecord.hot =/= ?GameServer_User_State_Set_Closed of
                    true->put( "GameServerList", GameServerList ++ [GameServerInfo] );
                    false->ok
                end				
        end,

        AllRunningServerList2 = AllRunningServerList -- [ServerID],
        case AllRunningServerList2 of
            []->
                %%GameServer回复完了，发消息给客户端
                UnrunningList = game_server:getAllUnRunningGameServerList(),
                ToMsgFunc = fun( GameServer )->			
                        #pk_GameServerInfo{
                            serverID=GameServer#gameServerRecord.serverID,
                            name=GameServer#gameServerRecord.name,
                            state=game_server:getGameServerUserState( GameServer ),
                            showIndex=GameServer#gameServerRecord.showInUserGameList,
                            remmond=GameServer#gameServerRecord.remmond,
                            maxPlayerLevel=0,
                            isnew=GameServer#gameServerRecord.isnew,
                            begintime=GameServer#gameServerRecord.begintime,
                            hot=GameServer#gameServerRecord.hot
                        }					
                end,
                UnrunningMsgList = lists:map( ToMsgFunc, UnrunningList ),

                SetClosedList = game_server:getAllSetClosdGameServerList(),
                ToFun= fun( GS )->			
                        #pk_GameServerInfo{
                            serverID=GS#gameServerRecord.serverID,
                            name=GS#gameServerRecord.name,
                            state=game_server:getGameServerUserState( GS ),
                            showIndex=GS#gameServerRecord.showInUserGameList,
                            remmond=GS#gameServerRecord.remmond,
                            maxPlayerLevel=0,
                            isnew=GS#gameServerRecord.isnew,
                            begintime=GS#gameServerRecord.begintime,
                            hot=GS#gameServerRecord.hot
                        }					
                end,
                SetClosedMsgList = lists:map( ToFun, SetClosedList ),

                AllMsgList = get( "GameServerList" ) ++ UnrunningMsgList -- SetClosedMsgList,
                ToUser = #pk_LS2U_GameServerList{ gameServers=AllMsgList},
                %%role:send( ToUser ),
                sendGameServerListToUser( ToUser ),

                role:setCurUserState( ?UserState_WaitUserSelGameServer ),
                ?DEBUG( "on_gameServer_QueryUserMaxLevelResult userid[~p] send GameServerInfo[~p]", [role:getCurUserID(), ToUser#pk_LS2U_GameServerList.gameServers] ),
                ok;
            _->
                put( "WaitGameServerAck_MaxPlayerLevel_List", AllRunningServerList2 ),
                ?DEBUG( "on_gameServer_QueryUserMaxLevelResult userid[~p] continue AllRunningServerList2[~p]", [role:getCurUserID(), AllRunningServerList2] ),
                ok
        end,

        ok
    catch
        _->?INFO( "on_gameServer_QueryUserMaxLevelResult userid[~p] ServerID[~p] MaxPlayerLevel[~p] throw", [role:getCurUserID(), ServerID, MaxPlayerLevel] )
    end,
    ok.

on_U2LS_RequestSelGameServer( #pk_U2LS_RequestSelGameServer{}=Msg )->
    try
        ?DEBUG( "on_U2LS_RequestSelGameServer userid[~p] Msg[~p] begin", [role:getCurUserID(), Msg] ),

        case role:getCurUserState() =:= ?UserState_WaitUserSelGameServer of
            false->throw(-1);
            true->ok
        end,

        ServerID = Msg#pk_U2LS_RequestSelGameServer.serverID,
        GameServer = game_server:getGameServerRecord( ServerID ),
        case GameServer of
            {}->
                role:send( #pk_LS2U_SelGameServerResult{ userID=0,ip="", port=0, identity="", errorCode=-3 } ),
                throw(-1);
            _->ok
        end,

        case GameServer#gameServerRecord.state of
            ?GameServer_State_Running->ok;
            _->
                role:send( #pk_LS2U_SelGameServerResult{ userID=0,ip="", port=0, identity="", errorCode=-6 } ),
                throw(-1)
        end,
        %% 		case GameServer#gameServerRecord.state =:= ?GameServer_State_Running of
        %% 			true->ok;
        %% 			false->
        %% 				role:send( #pk_LS2U_SelGameServerResult{ userID=0,ip="", port=0, identity="", errorCode=-3 } ),
        %% 				throw(-1)
        %% 		end,

        case GameServer#gameServerRecord.hot =:= ?GameServer_User_State_Maintain  of
            true->
                Userid = role:getCurUserID(),
                case loginMysqlProc:isUser4TestById(Userid) of 
                    false ->
                        role:send( #pk_LS2U_SelGameServerResult{ userID=0,ip="", port=0, identity="", errorCode=-6 } ),
                        throw(-1);
                    true->ok
                end;
            false->ok
        end,

        User = role:getCurUserSocketRecord(),

        game_server:sendToGameServer( GameServer, #pk_LS2GS_UserReadyToLogin{userID=role:getCurUserID(),
                username= User#userSocketRecord.userName,
                identity=User#userSocketRecord.randIdentity,
                platId=User#userSocketRecord.platId} ),
        role:setCurUserState( ?UserState_WaitSelGameServerResult ),
        ?DEBUG( "on_U2LS_RequestSelGameServer userid[~p] wait sel GameServer[~p]", [role:getCurUserID(), GameServer] ),
        ok
    catch
        _->?INFO( "on_U2LS_RequestSelGameServer userid[~p] Msg[~p] throw", [role:getCurUserID(), Msg] )
    end.

on_GS2LS_UserReadyLoginResult( ServerID, #pk_GS2LS_UserReadyLoginResult{}=Msg )->
    try
        ?DEBUG( "on_GS2LS_UserReadyLoginResult Msg[~p] begin", [Msg] ),

        case role:getCurUserState() =:= ?UserState_WaitSelGameServerResult of
            false->throw(-1);
            true->ok
        end,

        GameServer = game_server:getGameServerRecord( ServerID ),
        case GameServer of
            {}->throw(-1);
            _->ok
        end,

        UserData = role:getCurUserSocketRecord(),

        SendMsg = #pk_LS2U_SelGameServerResult{ userID=role:getCurUserID(),
            ip=GameServer#gameServerRecord.ip, 
            port=GameServer#gameServerRecord.port, 
            identity=UserData#userSocketRecord.randIdentity, 
            errorCode=Msg#pk_GS2LS_UserReadyLoginResult.result },
        role:send( SendMsg ),

        case Msg#pk_GS2LS_UserReadyLoginResult.result >= 0 of
            true->
                main_PID ! { userReadyLoginWS, role:getCurUserID(), ServerID },
                role:setCurUserState( ?UserState_WaitGameServerAckLogin );
            false->
                role:setCurUserState( ?UserState_WaitUserSelGameServer )
        end,

        ?DEBUG( "on_GS2LS_UserReadyLoginResult userid[~p] SendMsg[~p] ", [role:getCurUserID(), SendMsg] ),
        ok
    catch
        _->
            ?INFO( "on_GS2LS_UserReadyLoginResult Msg[~p] throw", [Msg] ),
            SendMsg2 = #pk_LS2U_SelGameServerResult{ userID=0,ip="", port=0, identity="", errorCode=-1 },
            role:send( SendMsg2 )
    end.

on_timeOut_WaitUserAskGameServerList()->
    try
        case role:getCurUserState() =:= ?UserState_WaitGameServerAckMaxPlayerLevel of
            false->throw(-1);
            true->ok
        end,

        %% 		AllRunningServerList = get( "WaitGameServerAck_MaxPlayerLevel_List" ),
        %% 		case AllRunningServerList of
        %% 			[]->throw(-1);
        %% 			undefined->throw(-1);
        %% 			_->ok
        %% 		end,
        %% 		
        %% 		MyFunc = fun( ServerID )->
        %% 					GameServer = game_server:getGameServerRecord( ServerID ),
        %% 					case GameServer of
        %% 						{}->throw(-1);
        %% 						_->ok
        %% 					end,
        %% 					
        %% 					GameServerInfo = #pk_GameServerInfo{
        %% 														serverID=ServerID,
        %% 														name=GameServer#gameServerRecord.name,
        %% 														state=game_server:getGameServerUserState( GameServer ),
        %% 														showIndex=GameServer#gameServerRecord.showInUserGameList,
        %% 														remmond=GameServer#gameServerRecord.remmond,
        %% 														maxPlayerLevel=0,
        %% 														isnew=GameServer#gameServerRecord.isnew,
        %% 														begintime=GameServer#gameServerRecord.begintime
        %% 														},
        %% 					GameServerList = get( "GameServerList" ),
        %% 					case GameServerList of
        %% 						[]->
        %% 							put( "GameServerList", [GameServerInfo] );
        %% 						undefined->
        %% 							put( "GameServerList", [GameServerInfo] );
        %% 						_->
        %% 							put( "GameServerList", GameServerList ++ [GameServerInfo] )
        %% 					end
        %% 				 end,
        %% 		lists:map( MyFunc, AllRunningServerList ),
        %% 		ToUser = #pk_LS2U_GameServerList{ gameServers=get( "GameServerList" ) },

        GameServerList = game_server:getAllGameServerList(),	
        ToMsgFunc = fun( GameServer )->			
                #pk_GameServerInfo{
                    serverID=GameServer#gameServerRecord.serverID,
                    name=GameServer#gameServerRecord.name,
                    state=game_server:getGameServerUserState( GameServer ),
                    showIndex=GameServer#gameServerRecord.showInUserGameList,
                    remmond=GameServer#gameServerRecord.remmond,
                    maxPlayerLevel=0,
                    isnew=GameServer#gameServerRecord.isnew,
                    begintime=GameServer#gameServerRecord.begintime,
                    hot=GameServer#gameServerRecord.hot
                }		
        end,
        GameServerMsgList = lists:map( ToMsgFunc, GameServerList ),
        ToUser = #pk_LS2U_GameServerList{ gameServers=GameServerMsgList },
        %%role:send( ToUser ),
        sendGameServerListToUser( ToUser ),

        role:setCurUserState( ?UserState_WaitUserSelGameServer ),
        ?DEBUG( "on_timeOut_WaitUserAskGameServerList userid[~p] send GameServerInfo[~p]", [role:getCurUserID(), ToUser#pk_LS2U_GameServerList.gameServers] ),
        ok
    catch
        _->ok
    end,
    ok.

sendGameServerListToUser( #pk_LS2U_GameServerList{} = MsgToUser )->
    Userid = role:getCurUserID(),
    IsSpecUser = loginMysqlProc:isUser4TestById(Userid),

    MyFunc = fun( Record )->
            case Record#pk_GameServerInfo.hot of
                ?GameServer_User_State_SpecCanVisable->
                    case IsSpecUser of
                        true->Record;
                        false->{}
                    end;
                _->Record
            end
    end,
    GameServerList = lists:map( MyFunc, MsgToUser#pk_LS2U_GameServerList.gameServers ),

    MyFunc2 = fun( Record )->
            Record =/= {}
    end,
    GameServerList2 = lists:filter( MyFunc2, GameServerList ),

    MsgToUser2 = setelement( #pk_LS2U_GameServerList.gameServers, MsgToUser, GameServerList2 ),
    role:send( MsgToUser2 ),
    ok.

