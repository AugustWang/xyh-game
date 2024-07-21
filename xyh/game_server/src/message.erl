%%----------------------------------------------------
%% $Id$
%% @doc 消息路由处理
%%----------------------------------------------------

-module(message).
-export([send/2, dealMsg/3]).

-include("package.hrl").

%% don't catch exception in this function
%% TODO:不应该是遍历的方式来路由 (Mark By Rolong)
send( S, P ) ->
	case msg_player:send(S,P) of
		noMatch->
			case msg_team:send(S,P) of
				noMatch->
					case msg_task:send(S,P) of
						noMatch->
							case msg_battle:send(S,P) of
								noMatch->
									case msg_guild:send(S, P) of
										noMatch->
											case msg_friend:send(S, P) of
												noMatch->
													case msg_mount:send(S, P) of 
														noMatch->
															case msg_toplist:send(S, P) of
																noMatch->sendFail;
																_->ok
															end;
														_->ok
													end;
												_->ok
											end;
										_->ok
									end;
								_->ok
							end;
						_->ok
					end;
				_->ok
			end;
		_->ok
	end.

%% Socket消息路由 
dealMsg(Socket, Cmd, Bin) -> 
    Module = case Cmd div 100 of
        1 -> msg_battle;
        2 -> msg_friend;
        3 -> msg_guild;
        %% 4 -> msg_LS2GS;
        %% 5 -> msg_LS2User;
        6 -> msg_mount;
        7 -> msg_player;
        8 -> msg_player;
        9 -> msg_player;
        10 -> msg_player;
        11 -> msg_task;
        12 -> msg_team;
        13 -> msg_toplist;
        _ -> undefined
    end,
    if 
        Module == undefined -> dealFail;
        true -> 
            case Module:dealMsg(Socket, Cmd, Bin) of
                noMatch -> dealFail;
                _ -> ok
            end
    end.
