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

-module(msg_team).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_team.hrl").

binary_read_inviteCreateTeam(Bin0) ->
    <<VtargetPlayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_inviteCreateTeam{targetPlayerID = VtargetPlayerID}, RestBin0, 0}.


write_teamOPResult(#pk_teamOPResult{
        targetPlayerID = VtargetPlayerID,
        targetPlayerName = VtargetPlayerName,
        result = Vresult
    }) ->
    LtargetPlayerName = byte_size(VtargetPlayerName),
    <<
        VtargetPlayerID:64/little,
        LtargetPlayerName:16/little, VtargetPlayerName/binary,
        Vresult:32/little
    >>.



write_beenInviteCreateTeam(#pk_beenInviteCreateTeam{inviterPlayerID = VinviterPlayerID, inviterPlayerName = VinviterPlayerName}) ->
    LinviterPlayerName = byte_size(VinviterPlayerName),
    <<VinviterPlayerID:64/little, LinviterPlayerName:16/little, VinviterPlayerName/binary>>.



binary_read_ackInviteCreateTeam(Bin0) ->
    <<VinviterPlayerID:64/little, Vagree:8/little, RestBin0/binary>> = Bin0,
    {#pk_ackInviteCreateTeam{inviterPlayerID = VinviterPlayerID, agree = Vagree}, RestBin0, 0}.


write_teamMemberInfo(#pk_teamMemberInfo{
        playerID = VplayerID,
        playerName = VplayerName,
        level = Vlevel,
        posx = Vposx,
        posy = Vposy,
        map_data_id = Vmap_data_id,
        isOnline = VisOnline,
        camp = Vcamp,
        sex = Vsex,
        life_percent = Vlife_percent
    }) ->
    LplayerName = byte_size(VplayerName),
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName/binary,
        Vlevel:16/little,
        Vposx:16/little,
        Vposy:16/little,
        Vmap_data_id:8/little,
        VisOnline:8/little,
        Vcamp:8/little,
        Vsex:8/little,
        Vlife_percent:8/little
    >>.

binary_read_teamMemberInfo(Bin0) ->
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName:LplayerName/binary,
        Vlevel:16/little,
        Vposx:16/little,
        Vposy:16/little,
        Vmap_data_id:8/little,
        VisOnline:8/little,
        Vcamp:8/little,
        Vsex:8/little,
        Vlife_percent:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_teamMemberInfo{
        playerID = VplayerID,
        playerName = VplayerName,
        level = Vlevel,
        posx = Vposx,
        posy = Vposy,
        map_data_id = Vmap_data_id,
        isOnline = VisOnline,
        camp = Vcamp,
        sex = Vsex,
        life_percent = Vlife_percent
    }, RestBin0, 0}.


write_teamInfo(#pk_teamInfo{
        teamID = VteamID,
        leaderPlayerID = VleaderPlayerID,
        info_list = Vinfo_list
    }) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_teamMemberInfo(X) end),
    <<
        VteamID:64/little,
        VleaderPlayerID:64/little,
        Ainfo_list/binary
    >>.



write_teamPlayerOffline(#pk_teamPlayerOffline{playerID = VplayerID}) ->
    <<VplayerID:64/little>>.



binary_read_teamQuitRequest(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_teamQuitRequest{reserve = Vreserve}, RestBin0, 0}.


write_teamPlayerQuit(#pk_teamPlayerQuit{playerID = VplayerID}) ->
    <<VplayerID:64/little>>.



binary_read_teamKickOutPlayer(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_teamKickOutPlayer{playerID = VplayerID}, RestBin0, 0}.


write_teamPlayerKickOut(#pk_teamPlayerKickOut{playerID = VplayerID}) ->
    <<VplayerID:64/little>>.



binary_read_inviteJoinTeam(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_inviteJoinTeam{playerID = VplayerID}, RestBin0, 0}.


write_beenInviteJoinTeam(#pk_beenInviteJoinTeam{playerID = VplayerID, playerName = VplayerName}) ->
    LplayerName = byte_size(VplayerName),
    <<VplayerID:64/little, LplayerName:16/little, VplayerName/binary>>.



binary_read_ackInviteJointTeam(Bin0) ->
    <<VplayerID:64/little, Vagree:8/little, RestBin0/binary>> = Bin0,
    {#pk_ackInviteJointTeam{playerID = VplayerID, agree = Vagree}, RestBin0, 0}.


binary_read_applyJoinTeam(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_applyJoinTeam{playerID = VplayerID}, RestBin0, 0}.


write_queryApplyJoinTeam(#pk_queryApplyJoinTeam{playerID = VplayerID, playerName = VplayerName}) ->
    LplayerName = byte_size(VplayerName),
    <<VplayerID:64/little, LplayerName:16/little, VplayerName/binary>>.



binary_read_ackQueryApplyJoinTeam(Bin0) ->
    <<VplayerID:64/little, Vagree:8/little, RestBin0/binary>> = Bin0,
    {#pk_ackQueryApplyJoinTeam{playerID = VplayerID, agree = Vagree}, RestBin0, 0}.


write_addTeamMember(#pk_addTeamMember{info = Vinfo}) ->
    Ainfo = write_teamMemberInfo(Vinfo),
    <<Ainfo/binary>>.



write_shortTeamMemberInfo(#pk_shortTeamMemberInfo{
        playerID = VplayerID,
        level = Vlevel,
        posx = Vposx,
        posy = Vposy,
        map_data_id = Vmap_data_id,
        isOnline = VisOnline,
        life_percent = Vlife_percent
    }) ->
    <<
        VplayerID:64/little,
        Vlevel:16/little,
        Vposx:16/little,
        Vposy:16/little,
        Vmap_data_id:8/little,
        VisOnline:8/little,
        Vlife_percent:8/little
    >>.

binary_read_shortTeamMemberInfo(Bin0) ->
    <<
        VplayerID:64/little,
        Vlevel:16/little,
        Vposx:16/little,
        Vposy:16/little,
        Vmap_data_id:8/little,
        VisOnline:8/little,
        Vlife_percent:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_shortTeamMemberInfo{
        playerID = VplayerID,
        level = Vlevel,
        posx = Vposx,
        posy = Vposy,
        map_data_id = Vmap_data_id,
        isOnline = VisOnline,
        life_percent = Vlife_percent
    }, RestBin0, 0}.


write_updateTeamMemberInfo(#pk_updateTeamMemberInfo{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_shortTeamMemberInfo(X) end),
    <<Ainfo_list/binary>>.



write_teamDisbanded(#pk_teamDisbanded{reserve = Vreserve}) ->
    <<Vreserve:8/little>>.



write_teamQueryLeaderInfo(#pk_teamQueryLeaderInfo{
        playerID = VplayerID,
        playerName = VplayerName,
        level = Vlevel
    }) ->
    LplayerName = byte_size(VplayerName),
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName/binary,
        Vlevel:16/little
    >>.

binary_read_teamQueryLeaderInfo(Bin0) ->
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName:LplayerName/binary,
        Vlevel:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_teamQueryLeaderInfo{
        playerID = VplayerID,
        playerName = VplayerName,
        level = Vlevel
    }, RestBin0, 0}.


write_teamQueryLeaderInfoOnMyMap(#pk_teamQueryLeaderInfoOnMyMap{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_teamQueryLeaderInfo(X) end),
    <<Ainfo_list/binary>>.



binary_read_teamQueryLeaderInfoRequest(Bin0) ->
    <<VmapID:64/little, RestBin0/binary>> = Bin0,
    {#pk_teamQueryLeaderInfoRequest{mapID = VmapID}, RestBin0, 0}.


write_teamChangeLeader(#pk_teamChangeLeader{playerID = VplayerID}) ->
    <<VplayerID:64/little>>.



binary_read_teamChangeLeaderRequest(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_teamChangeLeaderRequest{playerID = VplayerID}, RestBin0, 0}.


binary_read_beenInviteState(Bin0) ->
    <<Vstate:8/little, RestBin0/binary>> = Bin0,
    {#pk_beenInviteState{state = Vstate}, RestBin0, 0}.


%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_teamOPResult{} = P) ->
	Bin = write_teamOPResult(P),
	pack:send(Socket, ?CMD_teamOPResult, Bin);
send(Socket, #pk_beenInviteCreateTeam{} = P) ->
	Bin = write_beenInviteCreateTeam(P),
	pack:send(Socket, ?CMD_beenInviteCreateTeam, Bin);
send(Socket, #pk_teamInfo{} = P) ->
	Bin = write_teamInfo(P),
	pack:send(Socket, ?CMD_teamInfo, Bin);
send(Socket, #pk_teamPlayerOffline{} = P) ->
	Bin = write_teamPlayerOffline(P),
	pack:send(Socket, ?CMD_teamPlayerOffline, Bin);
send(Socket, #pk_teamPlayerQuit{} = P) ->
	Bin = write_teamPlayerQuit(P),
	pack:send(Socket, ?CMD_teamPlayerQuit, Bin);
send(Socket, #pk_teamPlayerKickOut{} = P) ->
	Bin = write_teamPlayerKickOut(P),
	pack:send(Socket, ?CMD_teamPlayerKickOut, Bin);
send(Socket, #pk_beenInviteJoinTeam{} = P) ->
	Bin = write_beenInviteJoinTeam(P),
	pack:send(Socket, ?CMD_beenInviteJoinTeam, Bin);
send(Socket, #pk_queryApplyJoinTeam{} = P) ->
	Bin = write_queryApplyJoinTeam(P),
	pack:send(Socket, ?CMD_queryApplyJoinTeam, Bin);
send(Socket, #pk_addTeamMember{} = P) ->
	Bin = write_addTeamMember(P),
	pack:send(Socket, ?CMD_addTeamMember, Bin);
send(Socket, #pk_updateTeamMemberInfo{} = P) ->
	Bin = write_updateTeamMemberInfo(P),
	pack:send(Socket, ?CMD_updateTeamMemberInfo, Bin);
send(Socket, #pk_teamDisbanded{} = P) ->
	Bin = write_teamDisbanded(P),
	pack:send(Socket, ?CMD_teamDisbanded, Bin);
send(Socket, #pk_teamQueryLeaderInfoOnMyMap{} = P) ->
	Bin = write_teamQueryLeaderInfoOnMyMap(P),
	pack:send(Socket, ?CMD_teamQueryLeaderInfoOnMyMap, Bin);
send(Socket, #pk_teamChangeLeader{} = P) ->
	Bin = write_teamChangeLeader(P),
	pack:send(Socket, ?CMD_teamChangeLeader, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_inviteCreateTeam->
            {Data, _, _} = binary_read_inviteCreateTeam(Bin),
            messageOn:on_inviteCreateTeam(Socket, Data);
        ?CMD_ackInviteCreateTeam->
            {Data, _, _} = binary_read_ackInviteCreateTeam(Bin),
            messageOn:on_ackInviteCreateTeam(Socket, Data);
        ?CMD_teamQuitRequest->
            {Data, _, _} = binary_read_teamQuitRequest(Bin),
            messageOn:on_teamQuitRequest(Socket, Data);
        ?CMD_teamKickOutPlayer->
            {Data, _, _} = binary_read_teamKickOutPlayer(Bin),
            messageOn:on_teamKickOutPlayer(Socket, Data);
        ?CMD_inviteJoinTeam->
            {Data, _, _} = binary_read_inviteJoinTeam(Bin),
            messageOn:on_inviteJoinTeam(Socket, Data);
        ?CMD_ackInviteJointTeam->
            {Data, _, _} = binary_read_ackInviteJointTeam(Bin),
            messageOn:on_ackInviteJointTeam(Socket, Data);
        ?CMD_applyJoinTeam->
            {Data, _, _} = binary_read_applyJoinTeam(Bin),
            messageOn:on_applyJoinTeam(Socket, Data);
        ?CMD_ackQueryApplyJoinTeam->
            {Data, _, _} = binary_read_ackQueryApplyJoinTeam(Bin),
            messageOn:on_ackQueryApplyJoinTeam(Socket, Data);
        ?CMD_teamQueryLeaderInfoRequest->
            {Data, _, _} = binary_read_teamQueryLeaderInfoRequest(Bin),
            messageOn:on_teamQueryLeaderInfoRequest(Socket, Data);
        ?CMD_teamChangeLeaderRequest->
            {Data, _, _} = binary_read_teamChangeLeaderRequest(Bin),
            messageOn:on_teamChangeLeaderRequest(Socket, Data);
        ?CMD_beenInviteState->
            {Data, _, _} = binary_read_beenInviteState(Bin),
            messageOn:on_beenInviteState(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
