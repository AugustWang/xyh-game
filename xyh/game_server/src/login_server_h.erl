%%----------------------------------------------------
%% $Id$
%% 与登陆服务器的Socket消息处理 回调模块
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(login_server_h).

%% Include files
-include("db.hrl").
-include("playerDefine.hrl").
-include("package.hrl").
-include("common.hrl").
-include("platformDefine.hrl").
-include("mailDefine.hrl").

-compile(export_all). 

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

on_pk_LS2GS_LoginResult(#pk_LS2GS_LoginResult{}=_Msg)->
	?INFO( "loginserver check pass " ),

	mainPID ! { login_serverCheckPass },
	
	ok.

on_LS2GS_QueryUserMaxLevel( #pk_LS2GS_QueryUserMaxLevel{}=Msg )->
	dbProcess_PID ! { ls_LS2GS_QueryUserMaxLevel, self(), Msg },
	?DEBUG( "on_LS2GS_QueryUserMaxLevel Msg[~p]  ", [Msg] ),
	ok.

ok_LS2GS_UserReadyToLogin( #pk_LS2GS_UserReadyToLogin{}=Msg )->
	?DEBUG( "ok_LS2GS_UserReadyToLogin Msg[~p] to main proc", [Msg] ),
	mainPID ! { onLS2GS_UserReadyToLogin, Msg }.

on_LS2GS_KickOutUser( #pk_LS2GS_KickOutUser{}=Msg )->
	mainPID ! { onLS2GS_KickOutUser, Msg }.

%%LS通知激活码发邮件给玩家
on_LS2GS_ActiveCode( #pk_LS2GS_ActiveCode{pidStr=PidStr,activeCode=ActiveCode, playerName=PlayerName, type=_} = _Msg )->
	try
		?INFO( "LS2GS_ActiveCode ActiveCode[~p] PlayerName[~p] begin", [ActiveCode, PlayerName] ),
		PlayerID = mySqlProcess:isPlayerExistByName( PlayerName ),
		case PlayerID =:= 0 of
			true->throw({return,?PLATFORM_RCODE_ACTIVE_CODE_NOPLAYER});
			false->ok
		end,
		
		ItemDataID = 2001,
		
		Ret = mail:sendSystemMailToPlayer( PlayerID, "system", "title", "", ItemDataID, 1, true, 0, 0, true, 0 ),
		case Ret =:= ?SendMailResult_Succ of
			true->throw( {return, 0} );
			false->throw( {return, ?PLATFORM_RCODE_ACTIVE_CODE_MAIL_FAILED})
		end,
		
		ok
	catch
		{ return, ReturnCode }->
			?INFO( "LS2GS_ActiveCode ActiveCode[~p] PlayerName[~p] ReturnCode[~p]", [ActiveCode, PlayerName, ReturnCode] ),
			MsgToLS = #pk_GS2LS_ActiveCode{pidStr=PidStr, activeCode=ActiveCode, retcode=ReturnCode },
			login_server:sendToLoginServer( MsgToLS ),
			ok
	end.

%%系统公告
on_LS2GS_Announce( #pk_LS2GS_Announce{pidStr=_PidStr,announceInfo = AnnounceInfo} = _Msg )->
	systemMessage:sendSysMsgToAllPlayer( AnnounceInfo ),
	ok.

%%平台充值
on_LS2GS_Recharge( #pk_LS2GS_Recharge{pidStr=PidStr,orderid=OrderID,platform=Platform,account=Account,userid=UserID,playerid=PlayerID,ammount=Ammount} = Msg )->
	?INFO( "on_LS2GS_Recharge  pkt[~p] ", [Msg] ),

	%% 获取玩家原有的金币数量
	{Ret,Gold_Old}=mySqlProcess:getGoldByPlayerID(PlayerID),
	case Ret of
		ok->
			Gold_Mod=Ammount*?RMB_GOLD_RATIO,
			%% 更改金币数量
			case mySqlProcess:addGoldForChargeByPlayerID(PlayerID,Gold_Mod) of
				{error,_}->
					%% 留日志
					logdbProcess:write_log_recharge_fail(OrderID,Platform,Account,UserID,PlayerID,Ammount),
					%% 给平台返回失败消息
                    MsgToLS = #pk_GS2LS_Recharge{ pidStr=PidStr, orderid=OrderID, platform=Platform,retcode=?PLATFORM_RCODE_RECHARGE_FAILED},
                    login_server:sendToLoginServer( MsgToLS );
				{ok,_}->
					%% 留日志
					logdbProcess:write_log_recharge_succ(OrderID,Platform,Account,UserID,PlayerID,Ammount),
					%{_,Gold_New}=mySqlProcess:getGoldByPlayerID(PlayerID),
					Gold_New=Gold_Old+Gold_Mod,
					%% 更改金币日志
					?INFO( "write_log_gold_add:[~p,~p,~p,~p,~p,~p] ", [PlayerID,Gold_Old,Gold_Mod,Gold_New,?Money_Change_Recharge,"Recharge"] ),
					logdbProcess:write_log_gold_add(PlayerID,Gold_Old,Gold_Mod,Gold_New,?Money_Change_Recharge,"Recharge"),
					%% 给平台返回充值成功消息
					MsgToLS = #pk_GS2LS_Recharge{ pidStr=PidStr, orderid=OrderID, platform=Platform,retcode=?PLATFORM_RCODE_RECHARGE_OK},
					login_server:sendToLoginServer( MsgToLS ),
			
					%% 玩家在线，给玩家进程发送消息，通知玩家进程刷新金币数量
					case player:getPlayerIsOnlineByID(PlayerID) of
						true->
							%% 在线玩家将消息转发到玩家进程
							case player:getPlayerPID(PlayerID) of 
								0->ok;
								PID->
									PID ! {refreshGold}
							end;

						false->ok
					end
			
			end;

		error->
			%% 留日志
			logdbProcess:write_log_recharge_fail(OrderID,Platform,Account,UserID,PlayerID,Ammount),
			%% 给平台返回失败消息
			MsgToLS = #pk_GS2LS_Recharge{ pidStr=PidStr, orderid=OrderID, platform=Platform,retcode=?PLATFORM_RCODE_RECHARGE_FAILED},
			login_server:sendToLoginServer( MsgToLS )
	end.

%%响应平台GM指令
on_LS2GS_Command( #pk_LS2GS_Command{pidStr=PidStr,num=Num,cmd=CMD,params=Params} = _Msg )->

	?INFO( "login server GM cmd[~p,~p,~p] ", [Num,CMD,Params] ),
	case CMD of
		?PLATFORM_COMMAND_SENDITEM->
		try
			%% playerName;itemList;Title;Content
			%% itemList:itemid,cnt,bind|itemid,cnt,bind
			StringTokens = string:tokens(Params, ";" ),
			ParamCount=length(StringTokens),
			%% 参数格式检查
			case ParamCount =:= 4 of
				true->ok;
				false->throw({return,?PLATFORM_RCODE_COMMAND_ERROR_PARAMS})
			end,
			[PlayerName,ItemList,Title,Content]=StringTokens, 
			?DEBUG( "login server GM cmd--------StringTokens:~p", [StringTokens] ),

			Ret = platformSendItem:sendItemToPlayerByPlayerName(PlayerName,ItemList,Title,Content),
			case Ret of
				noPlayer->throw({return,?PLATFORM_RCODE_COMMAND_NOPLAYER});
				exception->throw( {return, ?PLATFORM_RCODE_COMMAND_FAILED});
				fail->throw( {return, ?PLATFORM_RCODE_COMMAND_FAILED});
				ok->throw( {return, ?PLATFORM_RCODE_COMMAND_OK} )
			end,
			ok
		catch
			{ return, ReturnCode }->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] Params[~p] RetCode[~p]", [Num,CMD,Params,ReturnCode] ),
				MsgToLS = #pk_GS2LS_Command{pidStr=PidStr, num=Num,cmd=CMD,retcode=ReturnCode },
				login_server:sendToLoginServer( MsgToLS ),
				ok;
			_:_Why->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] exception", [Num,CMD] ),
				MsgToLS_ = #pk_GS2LS_Command{pidStr=PidStr,num=Num,cmd=CMD,retcode=?PLATFORM_RCODE_COMMAND_FAILED },
				login_server:sendToLoginServer( MsgToLS_ ),
				ok
		end;
		%% 给玩家发送物品扩展
		?PLATFORM_COMMAND_SENDITEM_EX->
		try
			%% levelMin;levelMax;itemList;money;money_b;gold;gold_b;exp;timeBegin;timeEnd;title;content
			%% itemList:itemid,cnt,bind|itemid,cnt,bind
			StringTokens = string:tokens(Params, ";" ),
			ParamCount=length(StringTokens),
			%% 参数格式检查
			case ParamCount =:= 12 of
				true->ok;
				false->throw({return,?PLATFORM_RCODE_COMMAND_ERROR_PARAMS})
			end,
			[LevelMin,LevelMax,ItemList,Money,MoneyB,Gold,GoldB,Exp,TimeBegin,TimeEnd,Title,Content]=StringTokens, 
			?DEBUG( "login server GM cmd--------StringTokens:~p", [StringTokens] ),
			{LevelMin_I,_}=string:to_integer(LevelMin),
			{LevelMax_I,_}=string:to_integer(LevelMax),
			{Money_I,_}=string:to_integer(Money),
			{MoneyB_I,_}=string:to_integer(MoneyB),
			{Gold_I,_}=string:to_integer(Gold),
			{GoldB_I,_}=string:to_integer(GoldB),
			{Exp_I,_}=string:to_integer(Exp),
			{TimeBegin_I,_}=string:to_integer(TimeBegin),
			{TimeEnd_I,_}=string:to_integer(TimeEnd),
	
			%% 将数据写入数据库表 platform_sendItem
			PlatformSendItemRecord=#platform_sendItem{id=0,levelMin=LevelMin_I,levelMax=LevelMax_I,itemList=ItemList,
								money=Money_I,money_b=MoneyB_I,gold=Gold_I,gold_b=GoldB_I,
								exp=Exp_I,flag=?PLATFORM_SENDITEM_FLAG_VALID,
								timeBegin=TimeBegin_I,timeEnd=TimeEnd_I,title=Title,content=Content},

			?DEBUG( "login server GM cmd---3-----info:~p", [PlatformSendItemRecord] ),
			
			_Ret=mySqlProcess:insert_platformSendItem(PlatformSendItemRecord),

			%% 广播在线玩家发放物品
			player:sendToAllPlayerProc({platformLoadAndSendItem}),

			throw( {return, ?PLATFORM_RCODE_COMMAND_OK} ),

			ok
		catch
			{ return, ReturnCode }->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] Params[~p] RetCode[~p]", [Num,CMD,Params,ReturnCode] ),
				MsgToLS = #pk_GS2LS_Command{pidStr=PidStr, num=Num,cmd=CMD,retcode=ReturnCode },
				login_server:sendToLoginServer( MsgToLS ),
				ok;
			_:_Why->
				?ERR( "LS2GS_Command Num[~p] Cmd[~p] exception", [Num,CMD] ),
				MsgToLS_ = #pk_GS2LS_Command{pidStr=PidStr,num=Num,cmd=CMD,retcode=?PLATFORM_RCODE_COMMAND_FAILED },
				login_server:sendToLoginServer( MsgToLS_ ),
				ok
		end;
		%% 通知商城重新加载数据
		?PLATFORM_COMMAND_BAZZAR->
			?INFO( "login server GM cmd--------reloadDBItem ", [] ),
			bazzar:getPid() ! {reloadDBItem};

		%% 设置某角色为gm
		?PLATFORM_COMMAND_ADD_GM_USER->
		try
			%% playerName
			StringTokens = string:tokens(Params, ";"),
			ParamCount=length(StringTokens),
			%% 参数格式检查
			case ParamCount =:= 2 of
				true-> ok;
				false-> throw({return,?PLATFORM_RCODE_COMMAND_ERROR_PARAMS})
			end,
			[Value,PlayerName] = StringTokens, 
			?DEBUG( "login server GM cmd add gm user--------StringTokens:~p", [StringTokens]),
			GmLevel = case list_to_integer(Value) =:= 1 of
				true -> 2; %%设置用户为gm用户
				false -> 0 %%取消gm权限
			end,
			mySqlProcess:update_GmByPlayerName(GmLevel,PlayerName),
			?DEBUG("add gm user succ GmLevel: ~p, PlayerName:~p",[GmLevel, PlayerName]),
			throw({return, ?PLATFORM_RCODE_COMMAND_OK})
		catch
			{ return, ReturnCode }->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] Params[~p] RetCode[~p]", [Num,CMD,Params,ReturnCode] ),
				MsgToLS = #pk_GS2LS_Command{pidStr=PidStr, num=Num,cmd=CMD,retcode=ReturnCode },
				login_server:sendToLoginServer( MsgToLS ),
				ok;
			_:_Why->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] exception", [Num,CMD] ),
				MsgToLS_ = #pk_GS2LS_Command{pidStr=PidStr,num=Num,cmd=CMD,retcode=?PLATFORM_RCODE_COMMAND_FAILED },
				login_server:sendToLoginServer( MsgToLS_ ),
				ok
		end;

		?PLATFORM_COMMAND_KILLOUT_USER ->%% 踢角色下线
		try
			%% playerName
			StringTokens = string:tokens(Params, ";"),
			ParamCount=length(StringTokens),
			%% 参数格式检查
			case ParamCount =:= 1 of
				true-> ok;
				false-> throw({return,?PLATFORM_RCODE_COMMAND_ERROR_PARAMS})
			end,
			[PlayerName] = StringTokens, 
			?DEBUG( "login server GM cmd killout user--------StringTokens:~p", [StringTokens]),
			case player:getOnlinePlayerIDByName(PlayerName) of
				0 -> throw({return,?PLATFORM_RCODE_COMMAND_NOPLAYER});
				PlayerID -> mainPID ! { kickoutByPlayerId, PlayerID}
			end,
			?DEBUG("killout user succ PlayerName:~p",[PlayerName]),
			throw({return, ?PLATFORM_RCODE_COMMAND_OK})
		catch
			{ return, ReturnCode }->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] Params[~p] RetCode[~p]", [Num,CMD,Params,ReturnCode] ),
				MsgToLS = #pk_GS2LS_Command{pidStr=PidStr, num=Num,cmd=CMD,retcode=ReturnCode },
				login_server:sendToLoginServer( MsgToLS ),
				ok;
			_:_Why->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] exception", [Num,CMD] ),
				MsgToLS_ = #pk_GS2LS_Command{pidStr=PidStr,num=Num,cmd=CMD,retcode=?PLATFORM_RCODE_COMMAND_FAILED },
				login_server:sendToLoginServer( MsgToLS_ ),
				ok
		end;

		?PLATFORM_COMMAND_FORBIDDEN_USER_CHAT ->%% 禁止角色聊天
		try
			%% playerName
			StringTokens = string:tokens(Params, ";"),
			ParamCount=length(StringTokens),
			%% 参数格式检查
			case ParamCount =:= 2 of
				true-> ok;
				false-> throw({return,?PLATFORM_RCODE_COMMAND_ERROR_PARAMS})
			end,
			[Value, PlayerName] = StringTokens, 
			?DEBUG( "login server GM cmd forbidden user chat--------StringTokens:~p", [StringTokens]),
			ChatValue = list_to_integer(Value),
			case player:getOnlinePlayerIDByName(PlayerName) of
				0 -> ok;
				PlayerID -> %% notify online player to modify forbidChatFlag
					player:sendMsgToPlayerProcess(PlayerID, {changeForbidChatFlag, ChatValue})
			end,
			%% modify ForbidChatFlag in db
			mySqlProcess:update_forbidChatFlagByPlayerName(PlayerName, ChatValue),
			?DEBUG("forbidden user chat succ ChatValue: ~p, PlayerName:~p",[ChatValue, PlayerName]),
			throw({return, ?PLATFORM_RCODE_COMMAND_OK})
		catch
			{ return, ReturnCode }->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] Params[~p] RetCode[~p]", [Num,CMD,Params,ReturnCode] ),
				MsgToLS = #pk_GS2LS_Command{pidStr=PidStr, num=Num,cmd=CMD,retcode=ReturnCode },
				login_server:sendToLoginServer( MsgToLS ),
				ok;
			_:_Why->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] exception", [Num,CMD] ),
				MsgToLS_ = #pk_GS2LS_Command{pidStr=PidStr,num=Num,cmd=CMD,retcode=?PLATFORM_RCODE_COMMAND_FAILED },
				login_server:sendToLoginServer( MsgToLS_ ),
				ok
		end;

		?PLATFORM_COMMAND_SWITCH_USERID -> %% 将某帐号下某角色的userid转换到某帐号下
		try
			%% SrcUserID; DesUserID
			StringTokens = string:tokens(Params, ";"),
			ParamCount=length(StringTokens),
			%% 参数格式检查
			case ParamCount =:= 2 of
				true-> ok;
				false-> throw({return,?PLATFORM_RCODE_COMMAND_ERROR_PARAMS})
			end,
			[SrcUserID, DesUserID] = StringTokens, 
			?DEBUG( "login server GM cmd switch userid--------StringTokens:~p", [StringTokens]),
			mySqlProcess:update_userIDByPlatUserId(SrcUserID, DesUserID),
			?INFO("switch userid succ SrcUserID:~p, DesUserID:~p",[SrcUserID,DesUserID]),
			throw({return, ?PLATFORM_RCODE_COMMAND_OK})
		catch
			{ return, ReturnCode }->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] Params[~p] RetCode[~p]", [Num,CMD,Params,ReturnCode] ),
				MsgToLS = #pk_GS2LS_Command{pidStr=PidStr, num=Num,cmd=CMD,retcode=ReturnCode },
				login_server:sendToLoginServer( MsgToLS ),
				ok;
			_:_Why->
				?INFO( "LS2GS_Command Num[~p] Cmd[~p] exception", [Num,CMD] ),
				MsgToLS_ = #pk_GS2LS_Command{pidStr=PidStr,num=Num,cmd=CMD,retcode=?PLATFORM_RCODE_COMMAND_FAILED },
				login_server:sendToLoginServer( MsgToLS_ ),
				ok
		end;

		_->
			?INFO( "login server received invalid GM cmd[~p,~p,~p] ", [Num,CMD,Params] )
	end.

