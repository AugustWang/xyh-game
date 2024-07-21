%%-----------------------------------------------------------
%% @doc Automatic Generation Of Package(read/write/send) File
%% 
%% NOTE: 
%%     Please be careful,
%%     if you have manually edited any of protocol file,
%%     do NOT commit to SVN !!!
%%
%% Shenzhen Turbo Technology Co., Ltd. All Rights Reserved.
%% http://www.szturbotech.com
%% Tool Release Time: 2014.3.21
%%
%% @author Rolong<rolong@vip.qq.com>
%%-----------------------------------------------------------

-module(msg_battle).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_battle.hrl").

write_Skillcooldown(#pk_Skillcooldown{skillID = VskillID, time = Vtime}) ->
    <<VskillID:32/little, Vtime:32/little>>.



%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_Skillcooldown{} = P) ->
	Bin = write_Skillcooldown(P),
	pack:send(Socket, ?CMD_Skillcooldown, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
