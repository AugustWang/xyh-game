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

-module(msg_friend).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_friend.hrl").

write_FriendInfo(#pk_FriendInfo{
        friendType = VfriendType,
        friendID = VfriendID,
        friendName = VfriendName,
        friendSex = VfriendSex,
        friendFace = VfriendFace,
        friendClassType = VfriendClassType,
        friendLevel = VfriendLevel,
        friendVip = VfriendVip,
        friendValue = VfriendValue,
        friendOnline = VfriendOnline
    }) ->
    LfriendName = byte_size(VfriendName),
    <<
        VfriendType:8/little,
        VfriendID:64/little,
        LfriendName:16/little, VfriendName/binary,
        VfriendSex:8/little,
        VfriendFace:8/little,
        VfriendClassType:8/little,
        VfriendLevel:16/little,
        VfriendVip:8/little,
        VfriendValue:32/little,
        VfriendOnline:8/little
    >>.

binary_read_FriendInfo(Bin0) ->
    <<
        VfriendType:8/little,
        VfriendID:64/little,
        LfriendName:16/little, VfriendName:LfriendName/binary,
        VfriendSex:8/little,
        VfriendFace:8/little,
        VfriendClassType:8/little,
        VfriendLevel:16/little,
        VfriendVip:8/little,
        VfriendValue:32/little,
        VfriendOnline:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_FriendInfo{
        friendType = VfriendType,
        friendID = VfriendID,
        friendName = VfriendName,
        friendSex = VfriendSex,
        friendFace = VfriendFace,
        friendClassType = VfriendClassType,
        friendLevel = VfriendLevel,
        friendVip = VfriendVip,
        friendValue = VfriendValue,
        friendOnline = VfriendOnline
    }, RestBin0, 0}.


write_GS2U_LoadFriend(#pk_GS2U_LoadFriend{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_FriendInfo(X) end),
    <<Ainfo_list/binary>>.



binary_read_U2GS_QueryFriend(Bin0) ->
    <<Vplayerid:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryFriend{playerid = Vplayerid}, RestBin0, 0}.


write_GS2U_FriendTips(#pk_GS2U_FriendTips{type = Vtype, tips = Vtips}) ->
    <<Vtype:8/little, Vtips:8/little>>.



write_GS2U_LoadBlack(#pk_GS2U_LoadBlack{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_FriendInfo(X) end),
    <<Ainfo_list/binary>>.



binary_read_U2GS_QueryBlack(Bin0) ->
    <<Vplayerid:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryBlack{playerid = Vplayerid}, RestBin0, 0}.


write_GS2U_LoadTemp(#pk_GS2U_LoadTemp{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_FriendInfo(X) end),
    <<Ainfo_list/binary>>.



binary_read_U2GS_QueryTemp(Bin0) ->
    <<Vplayerid:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryTemp{playerid = Vplayerid}, RestBin0, 0}.


write_GS2U_FriendInfo(#pk_GS2U_FriendInfo{friendInfo = VfriendInfo}) ->
    AfriendInfo = write_FriendInfo(VfriendInfo),
    <<AfriendInfo/binary>>.



binary_read_U2GS_AddFriend(Bin0) ->
    <<
        VfriendID:64/little,
        LfriendName:16/little, VfriendName:LfriendName/binary,
        Vtype:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_AddFriend{
        friendID = VfriendID,
        friendName = VfriendName,
        type = Vtype
    }, RestBin0, 0}.


write_GS2U_AddAcceptResult(#pk_GS2U_AddAcceptResult{
        isSuccess = VisSuccess,
        type = Vtype,
        fname = Vfname
    }) ->
    Lfname = byte_size(Vfname),
    <<
        VisSuccess:8/little,
        Vtype:64/little,
        Lfname:16/little, Vfname/binary
    >>.



binary_read_U2GS_DeleteFriend(Bin0) ->
    <<VfriendID:64/little, Vtype:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_DeleteFriend{friendID = VfriendID, type = Vtype}, RestBin0, 0}.


binary_read_U2GS_AcceptFriend(Bin0) ->
    <<Vresult:8/little, VfriendID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_AcceptFriend{result = Vresult, friendID = VfriendID}, RestBin0, 0}.


write_GS2U_DeteFriendBack(#pk_GS2U_DeteFriendBack{type = Vtype, friendID = VfriendID}) ->
    <<Vtype:8/little, VfriendID:64/little>>.



write_GS2U_Net_Message(#pk_GS2U_Net_Message{
        mswerHead = VmswerHead,
        skno = Vskno,
        rel = Vrel
    }) ->
    <<
        VmswerHead:32/little,
        Vskno:32/little,
        Vrel:32/little
    >>.

binary_read_GS2U_Net_Message(Bin0) ->
    <<
        VmswerHead:32/little,
        Vskno:32/little,
        Vrel:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_Net_Message{
        mswerHead = VmswerHead,
        skno = Vskno,
        rel = Vrel
    }, RestBin0, 0}.


write_GS2U_OnHookSet_Mess(#pk_GS2U_OnHookSet_Mess{
        playerHP = VplayerHP,
        petHP = VpetHP,
        skillID1 = VskillID1,
        skillID2 = VskillID2,
        skillID3 = VskillID3,
        skillID4 = VskillID4,
        skillID5 = VskillID5,
        skillID6 = VskillID6,
        getThing = VgetThing,
        hpThing = VhpThing,
        other = Vother,
        isAutoDrug = VisAutoDrug
    }) ->
    <<
        VplayerHP:32/little,
        VpetHP:32/little,
        VskillID1:32/little,
        VskillID2:32/little,
        VskillID3:32/little,
        VskillID4:32/little,
        VskillID5:32/little,
        VskillID6:32/little,
        VgetThing:32/little,
        VhpThing:32/little,
        Vother:32/little,
        VisAutoDrug:32/little
    >>.

binary_read_GS2U_OnHookSet_Mess(Bin0) ->
    <<
        VplayerHP:32/little,
        VpetHP:32/little,
        VskillID1:32/little,
        VskillID2:32/little,
        VskillID3:32/little,
        VskillID4:32/little,
        VskillID5:32/little,
        VskillID6:32/little,
        VgetThing:32/little,
        VhpThing:32/little,
        Vother:32/little,
        VisAutoDrug:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_OnHookSet_Mess{
        playerHP = VplayerHP,
        petHP = VpetHP,
        skillID1 = VskillID1,
        skillID2 = VskillID2,
        skillID3 = VskillID3,
        skillID4 = VskillID4,
        skillID5 = VskillID5,
        skillID6 = VskillID6,
        getThing = VgetThing,
        hpThing = VhpThing,
        other = Vother,
        isAutoDrug = VisAutoDrug
    }, RestBin0, 0}.


%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_GS2U_LoadFriend{} = P) ->
	Bin = write_GS2U_LoadFriend(P),
	pack:send(Socket, ?CMD_GS2U_LoadFriend, Bin);
send(Socket, #pk_GS2U_FriendTips{} = P) ->
	Bin = write_GS2U_FriendTips(P),
	pack:send(Socket, ?CMD_GS2U_FriendTips, Bin);
send(Socket, #pk_GS2U_LoadBlack{} = P) ->
	Bin = write_GS2U_LoadBlack(P),
	pack:send(Socket, ?CMD_GS2U_LoadBlack, Bin);
send(Socket, #pk_GS2U_LoadTemp{} = P) ->
	Bin = write_GS2U_LoadTemp(P),
	pack:send(Socket, ?CMD_GS2U_LoadTemp, Bin);
send(Socket, #pk_GS2U_FriendInfo{} = P) ->
	Bin = write_GS2U_FriendInfo(P),
	pack:send(Socket, ?CMD_GS2U_FriendInfo, Bin);
send(Socket, #pk_GS2U_AddAcceptResult{} = P) ->
	Bin = write_GS2U_AddAcceptResult(P),
	pack:send(Socket, ?CMD_GS2U_AddAcceptResult, Bin);
send(Socket, #pk_GS2U_DeteFriendBack{} = P) ->
	Bin = write_GS2U_DeteFriendBack(P),
	pack:send(Socket, ?CMD_GS2U_DeteFriendBack, Bin);
send(Socket, #pk_GS2U_Net_Message{} = P) ->
	Bin = write_GS2U_Net_Message(P),
	pack:send(Socket, ?CMD_GS2U_Net_Message, Bin);
send(Socket, #pk_GS2U_OnHookSet_Mess{} = P) ->
	Bin = write_GS2U_OnHookSet_Mess(P),
	pack:send(Socket, ?CMD_GS2U_OnHookSet_Mess, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_U2GS_QueryFriend->
            {Data, _, _} = binary_read_U2GS_QueryFriend(Bin),
            messageOn:on_U2GS_QueryFriend(Socket, Data);
        ?CMD_U2GS_QueryBlack->
            {Data, _, _} = binary_read_U2GS_QueryBlack(Bin),
            messageOn:on_U2GS_QueryBlack(Socket, Data);
        ?CMD_U2GS_QueryTemp->
            {Data, _, _} = binary_read_U2GS_QueryTemp(Bin),
            messageOn:on_U2GS_QueryTemp(Socket, Data);
        ?CMD_U2GS_AddFriend->
            {Data, _, _} = binary_read_U2GS_AddFriend(Bin),
            messageOn:on_U2GS_AddFriend(Socket, Data);
        ?CMD_U2GS_DeleteFriend->
            {Data, _, _} = binary_read_U2GS_DeleteFriend(Bin),
            messageOn:on_U2GS_DeleteFriend(Socket, Data);
        ?CMD_U2GS_AcceptFriend->
            {Data, _, _} = binary_read_U2GS_AcceptFriend(Bin),
            messageOn:on_U2GS_AcceptFriend(Socket, Data);
        ?CMD_GS2U_Net_Message->
            {Data, _, _} = binary_read_GS2U_Net_Message(Bin),
            messageOn:on_GS2U_Net_Message(Socket, Data);
        ?CMD_GS2U_OnHookSet_Mess->
            {Data, _, _} = binary_read_GS2U_OnHookSet_Mess(Bin),
            messageOn:on_GS2U_OnHookSet_Mess(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
