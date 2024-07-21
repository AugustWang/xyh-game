-module(messageOn).

%%
%% Include files
%%
-include("db.hrl").
-include("userDefine.hrl").
-include("package.hrl").
-include("gameServerDefine.hrl").

%%
%% Exported Functions
%%
-compile(export_all).

%%------------------------------------------------------LS2GS------------------------------------------------------
on_GS2LS_Request_Login(_Socket,Pk)->
    game_server_h:onMsgGS2LS_Request_Login(Pk).
on_GS2LS_ReadyToAcceptUser(_Socket,Pk)->
    game_server_h:onMsgGS2LS_ReadyToAcceptUser(Pk).
on_GS2LS_OnlinePlayers(_Socket,Pk)->
    game_server_h:onMsgGS2LS_OnlinePlayers(Pk).
on_GS2LS_QueryUserMaxLevelResult(_Socket,Pk)->
    game_server_h:on_GS2LS_QueryUserMaxLevelResult(Pk).
on_GS2LS_UserReadyLoginResult(_Socket,Pk)->
    game_server_h:on_GS2LS_UserReadyLoginResult(Pk).
on_GS2LS_UserLoginGameServer(_Socket,Pk)->
    game_server_h:on_GS2LS_UserLoginGameServer(Pk).
on_GS2LS_UserLogoutGameServer(_Socket,Pk)->
    game_server_h:on_GS2LS_UserLogoutGameServer(Pk).
on_GS2LS_ActiveCode(_Socket,Pk) ->
    game_server_h:on_GS2LS_ActiveCode(Pk).
on_GS2LS_Command(_Socket,Pk) ->
    game_server_h:on_GS2LS_Command(Pk).
on_GS2LS_Recharge(_Socket,Pk) ->
    game_server_h:on_GS2LS_Recharge(Pk).



%%------------------------------------------------------LS2User------------------------------------------------------
on_U2LS_Login(_Socket,Pk)->
    role_h:on_Login(Pk).
on_U2LS_Login_553(_Socket,Pk)->
    role_h:on_Login_553(Pk).
on_U2LS_Login_APPS(_Socket,Pk)->
    role_h:on_Login_APPS(Pk).
on_U2LS_Login_PP(_Socket,Pk)->
    role_h:on_Login_PP(Pk).
on_U2LS_Login_360(_Socket,Pk)->
    role_h:on_Login_360(Pk).
on_U2LS_Login_91(_Socket,Pk)->
    role_h:on_Login_91(Pk).
on_U2LS_RequestGameServerList(_Socket,_Pk)->
    role_h:onMsgRequestGameServerList().
on_U2LS_RequestSelGameServer(_Socket,Pk)->
    role_h:on_U2LS_RequestSelGameServer(Pk).
on_U2LS_Login_UC(_Socket,Pk)->
    role_h:on_U2LS_Login_UC(Pk).

