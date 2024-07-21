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

-module(msg_guild).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_guild.hrl").

binary_read_U2GS_RequestCreateGuild(Bin0) ->
    <<VuseToken:8/little, LstrGuildName:16/little, VstrGuildName:LstrGuildName/binary, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestCreateGuild{useToken = VuseToken, strGuildName = VstrGuildName}, RestBin0, 0}.


binary_read_U2GS_QueryGuildList(Bin0) ->
    <<VbFirst:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryGuildList{bFirst = VbFirst}, RestBin0, 0}.


binary_read_U2GS_QueryGuildShortInfoEx(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {VvGuilds, Bin1} = read_array(RestBin0, fun(X) -> <<X1:64/little, B1/binary>> = X, {X1, B1, 0} end),
    <<RestBin1/binary>> = Bin1,
    {#pk_U2GS_QueryGuildShortInfoEx{vGuilds = VvGuilds}, RestBin1, 0}.


binary_read_U2GS_GetMyGuildInfo(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_GetMyGuildInfo{reserve = Vreserve}, RestBin0, 0}.


binary_read_U2GS_GetMyGuildApplicantShortInfo(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_GetMyGuildApplicantShortInfo{reserve = Vreserve}, RestBin0, 0}.


binary_read_U2GS_RequestChangeGuildAffiche(Bin0) ->
    <<LstrAffiche:16/little, VstrAffiche:LstrAffiche/binary, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestChangeGuildAffiche{strAffiche = VstrAffiche}, RestBin0, 0}.


binary_read_U2GS_RequestGuildContribute(Bin0) ->
    <<
        VnMoney:32/little,
        VnGold:32/little,
        VnItemCount:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_RequestGuildContribute{
        nMoney = VnMoney,
        nGold = VnGold,
        nItemCount = VnItemCount
    }, RestBin0, 0}.


binary_read_U2GS_RequestGuildMemberRankChange(Bin0) ->
    <<VnPlayerID:64/little, VnRank:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildMemberRankChange{nPlayerID = VnPlayerID, nRank = VnRank}, RestBin0, 0}.


binary_read_U2GS_RequestGuildKickOutMember(Bin0) ->
    <<VnPlayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildKickOutMember{nPlayerID = VnPlayerID}, RestBin0, 0}.


binary_read_U2GS_RequestGuildQuit(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildQuit{reserve = Vreserve}, RestBin0, 0}.


binary_read_U2GS_RequestGuildStudySkill(Bin0) ->
    <<VnSkillGroupID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildStudySkill{nSkillGroupID = VnSkillGroupID}, RestBin0, 0}.


binary_read_U2GS_RequestJoinGuld(Bin0) ->
    <<VnGuildID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestJoinGuld{nGuildID = VnGuildID}, RestBin0, 0}.


binary_read_U2GS_RequestGuildApplicantAllow(Bin0) ->
    <<VnPlayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildApplicantAllow{nPlayerID = VnPlayerID}, RestBin0, 0}.


binary_read_U2GS_RequestGuildApplicantRefuse(Bin0) ->
    <<VnPlayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildApplicantRefuse{nPlayerID = VnPlayerID}, RestBin0, 0}.


binary_read_U2GS_RequestGuildApplicantOPAll(Bin0) ->
    <<VnAllowOrRefuse:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestGuildApplicantOPAll{nAllowOrRefuse = VnAllowOrRefuse}, RestBin0, 0}.


write_GS2U_CreateGuildResult(#pk_GS2U_CreateGuildResult{result = Vresult, guildID = VguildID}) ->
    <<Vresult:32/little, VguildID:64/little>>.



write_GS2U_GuildInfoSmall(#pk_GS2U_GuildInfoSmall{
        nGuildID = VnGuildID,
        nChairmanPlayerID = VnChairmanPlayerID,
        nLevel = VnLevel,
        nMemberCount = VnMemberCount
    }) ->
    <<
        VnGuildID:64/little,
        VnChairmanPlayerID:64/little,
        VnLevel:8/little,
        VnMemberCount:16/little
    >>.

binary_read_GS2U_GuildInfoSmall(Bin0) ->
    <<
        VnGuildID:64/little,
        VnChairmanPlayerID:64/little,
        VnLevel:8/little,
        VnMemberCount:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildInfoSmall{
        nGuildID = VnGuildID,
        nChairmanPlayerID = VnChairmanPlayerID,
        nLevel = VnLevel,
        nMemberCount = VnMemberCount
    }, RestBin0, 0}.


write_GS2U_GuildInfoSmallList(#pk_GS2U_GuildInfoSmallList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_GS2U_GuildInfoSmall(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_GuildShortInfoEx(#pk_GS2U_GuildShortInfoEx{
        nGuildID = VnGuildID,
        nFaction = VnFaction,
        strGuildName = VstrGuildName,
        strChairmanPlayerName = VstrChairmanPlayerName
    }) ->
    LstrGuildName = byte_size(VstrGuildName),
    LstrChairmanPlayerName = byte_size(VstrChairmanPlayerName),
    <<
        VnGuildID:64/little,
        VnFaction:8/little,
        LstrGuildName:16/little, VstrGuildName/binary,
        LstrChairmanPlayerName:16/little, VstrChairmanPlayerName/binary
    >>.

binary_read_GS2U_GuildShortInfoEx(Bin0) ->
    <<
        VnGuildID:64/little,
        VnFaction:8/little,
        LstrGuildName:16/little, VstrGuildName:LstrGuildName/binary,
        LstrChairmanPlayerName:16/little, VstrChairmanPlayerName:LstrChairmanPlayerName/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildShortInfoEx{
        nGuildID = VnGuildID,
        nFaction = VnFaction,
        strGuildName = VstrGuildName,
        strChairmanPlayerName = VstrChairmanPlayerName
    }, RestBin0, 0}.


write_GS2U_GuildShortInfoExList(#pk_GS2U_GuildShortInfoExList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_GS2U_GuildShortInfoEx(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_GuildAllShortInfo(#pk_GS2U_GuildAllShortInfo{
        nGuildID = VnGuildID,
        nChairmanPlayerID = VnChairmanPlayerID,
        strChairmanPlayerName = VstrChairmanPlayerName,
        nLevel = VnLevel,
        nMemberCount = VnMemberCount,
        nFaction = VnFaction,
        strGuildName = VstrGuildName
    }) ->
    LstrChairmanPlayerName = byte_size(VstrChairmanPlayerName),
    LstrGuildName = byte_size(VstrGuildName),
    <<
        VnGuildID:64/little,
        VnChairmanPlayerID:64/little,
        LstrChairmanPlayerName:16/little, VstrChairmanPlayerName/binary,
        VnLevel:8/little,
        VnMemberCount:16/little,
        VnFaction:8/little,
        LstrGuildName:16/little, VstrGuildName/binary
    >>.

binary_read_GS2U_GuildAllShortInfo(Bin0) ->
    <<
        VnGuildID:64/little,
        VnChairmanPlayerID:64/little,
        LstrChairmanPlayerName:16/little, VstrChairmanPlayerName:LstrChairmanPlayerName/binary,
        VnLevel:8/little,
        VnMemberCount:16/little,
        VnFaction:8/little,
        LstrGuildName:16/little, VstrGuildName:LstrGuildName/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildAllShortInfo{
        nGuildID = VnGuildID,
        nChairmanPlayerID = VnChairmanPlayerID,
        strChairmanPlayerName = VstrChairmanPlayerName,
        nLevel = VnLevel,
        nMemberCount = VnMemberCount,
        nFaction = VnFaction,
        strGuildName = VstrGuildName
    }, RestBin0, 0}.


write_GS2U_GuildAllShortInfoList(#pk_GS2U_GuildAllShortInfoList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_GS2U_GuildAllShortInfo(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_GuildBaseData(#pk_GS2U_GuildBaseData{
        nGuildID = VnGuildID,
        nChairmanPlayerID = VnChairmanPlayerID,
        nFaction = VnFaction,
        nLevel = VnLevel,
        nExp = VnExp,
        memberCount = VmemberCount,
        strChairmanPlayerName = VstrChairmanPlayerName,
        strGuildName = VstrGuildName,
        strAffiche = VstrAffiche
    }) ->
    LstrChairmanPlayerName = byte_size(VstrChairmanPlayerName),
    LstrGuildName = byte_size(VstrGuildName),
    LstrAffiche = byte_size(VstrAffiche),
    <<
        VnGuildID:64/little,
        VnChairmanPlayerID:64/little,
        VnFaction:8/little,
        VnLevel:8/little,
        VnExp:16/little,
        VmemberCount:32/little,
        LstrChairmanPlayerName:16/little, VstrChairmanPlayerName/binary,
        LstrGuildName:16/little, VstrGuildName/binary,
        LstrAffiche:16/little, VstrAffiche/binary
    >>.

binary_read_GS2U_GuildBaseData(Bin0) ->
    <<
        VnGuildID:64/little,
        VnChairmanPlayerID:64/little,
        VnFaction:8/little,
        VnLevel:8/little,
        VnExp:16/little,
        VmemberCount:32/little,
        LstrChairmanPlayerName:16/little, VstrChairmanPlayerName:LstrChairmanPlayerName/binary,
        LstrGuildName:16/little, VstrGuildName:LstrGuildName/binary,
        LstrAffiche:16/little, VstrAffiche:LstrAffiche/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildBaseData{
        nGuildID = VnGuildID,
        nChairmanPlayerID = VnChairmanPlayerID,
        nFaction = VnFaction,
        nLevel = VnLevel,
        nExp = VnExp,
        memberCount = VmemberCount,
        strChairmanPlayerName = VstrChairmanPlayerName,
        strGuildName = VstrGuildName,
        strAffiche = VstrAffiche
    }, RestBin0, 0}.


write_GS2U_GuildMemberData(#pk_GS2U_GuildMemberData{
        nPlayerID = VnPlayerID,
        strPlayerName = VstrPlayerName,
        nPlayerLevel = VnPlayerLevel,
        nRank = VnRank,
        nClass = VnClass,
        nContribute = VnContribute,
        bOnline = VbOnline
    }) ->
    LstrPlayerName = byte_size(VstrPlayerName),
    <<
        VnPlayerID:64/little,
        LstrPlayerName:16/little, VstrPlayerName/binary,
        VnPlayerLevel:16/little,
        VnRank:8/little,
        VnClass:8/little,
        VnContribute:32/little,
        VbOnline:8/little
    >>.

binary_read_GS2U_GuildMemberData(Bin0) ->
    <<
        VnPlayerID:64/little,
        LstrPlayerName:16/little, VstrPlayerName:LstrPlayerName/binary,
        VnPlayerLevel:16/little,
        VnRank:8/little,
        VnClass:8/little,
        VnContribute:32/little,
        VbOnline:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildMemberData{
        nPlayerID = VnPlayerID,
        strPlayerName = VstrPlayerName,
        nPlayerLevel = VnPlayerLevel,
        nRank = VnRank,
        nClass = VnClass,
        nContribute = VnContribute,
        bOnline = VbOnline
    }, RestBin0, 0}.


write_GS2U_GuildApplicantData(#pk_GS2U_GuildApplicantData{
        nPlayerID = VnPlayerID,
        strPlayerName = VstrPlayerName,
        nPlayerLevel = VnPlayerLevel,
        nClass = VnClass,
        nZhanLi = VnZhanLi
    }) ->
    LstrPlayerName = byte_size(VstrPlayerName),
    <<
        VnPlayerID:64/little,
        LstrPlayerName:16/little, VstrPlayerName/binary,
        VnPlayerLevel:16/little,
        VnClass:8/little,
        VnZhanLi:32/little
    >>.

binary_read_GS2U_GuildApplicantData(Bin0) ->
    <<
        VnPlayerID:64/little,
        LstrPlayerName:16/little, VstrPlayerName:LstrPlayerName/binary,
        VnPlayerLevel:16/little,
        VnClass:8/little,
        VnZhanLi:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildApplicantData{
        nPlayerID = VnPlayerID,
        strPlayerName = VstrPlayerName,
        nPlayerLevel = VnPlayerLevel,
        nClass = VnClass,
        nZhanLi = VnZhanLi
    }, RestBin0, 0}.


write_GS2U_GuildFullInfo(#pk_GS2U_GuildFullInfo{
        stBase = VstBase,
        member_list = Vmember_list,
        applicant_list = Vapplicant_list
    }) ->
    AstBase = write_GS2U_GuildBaseData(VstBase),
    Amember_list = write_array(Vmember_list, fun(X) -> write_GS2U_GuildMemberData(X) end),
    Aapplicant_list = write_array(Vapplicant_list, fun(X) -> write_GS2U_GuildApplicantData(X) end),
    <<
        AstBase/binary,
        Amember_list/binary,
        Aapplicant_list/binary
    >>.



write_GS2U_GuildApplicantShortData(#pk_GS2U_GuildApplicantShortData{
        nPlayerID = VnPlayerID,
        nPlayerLevel = VnPlayerLevel,
        nZhanLi = VnZhanLi
    }) ->
    <<
        VnPlayerID:64/little,
        VnPlayerLevel:16/little,
        VnZhanLi:32/little
    >>.

binary_read_GS2U_GuildApplicantShortData(Bin0) ->
    <<
        VnPlayerID:64/little,
        VnPlayerLevel:16/little,
        VnZhanLi:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2U_GuildApplicantShortData{
        nPlayerID = VnPlayerID,
        nPlayerLevel = VnPlayerLevel,
        nZhanLi = VnZhanLi
    }, RestBin0, 0}.


write_GS2U_GuildApplicantShortList(#pk_GS2U_GuildApplicantShortList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_GS2U_GuildApplicantShortData(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_GuildLevelEXPChanged(#pk_GS2U_GuildLevelEXPChanged{nLevel = VnLevel, nEXP = VnEXP}) ->
    <<VnLevel:16/little, VnEXP:32/little>>.



write_GS2U_GuildAfficheChanged(#pk_GS2U_GuildAfficheChanged{strAffiche = VstrAffiche}) ->
    LstrAffiche = byte_size(VstrAffiche),
    <<LstrAffiche:16/little, VstrAffiche/binary>>.



write_GS2U_GuildMemberContributeChanged(#pk_GS2U_GuildMemberContributeChanged{nPlayerID = VnPlayerID, nContribute = VnContribute}) ->
    <<VnPlayerID:64/little, VnContribute:32/little>>.



write_GS2U_GuildMemberLevelChanged(#pk_GS2U_GuildMemberLevelChanged{nPlayerID = VnPlayerID, nLevel = VnLevel}) ->
    <<VnPlayerID:64/little, VnLevel:16/little>>.



write_GS2U_GuildMemberOnlineChanged(#pk_GS2U_GuildMemberOnlineChanged{nPlayerID = VnPlayerID, nOnline = VnOnline}) ->
    <<VnPlayerID:64/little, VnOnline:8/little>>.



write_GS2U_GuildMemberRankChanged(#pk_GS2U_GuildMemberRankChanged{nPlayerID = VnPlayerID, nRank = VnRank}) ->
    <<VnPlayerID:64/little, VnRank:8/little>>.



write_GS2U_GuildMemberAdd(#pk_GS2U_GuildMemberAdd{stData = VstData}) ->
    AstData = write_GS2U_GuildMemberData(VstData),
    <<AstData/binary>>.



write_GS2U_GuildMemberQuit(#pk_GS2U_GuildMemberQuit{nPlayerID = VnPlayerID, bKickOut = VbKickOut}) ->
    <<VnPlayerID:64/little, VbKickOut:8/little>>.



write_GS2U_JoinGuildSuccess(#pk_GS2U_JoinGuildSuccess{guildID = VguildID, guildName = VguildName}) ->
    LguildName = byte_size(VguildName),
    <<VguildID:64/little, LguildName:16/little, VguildName/binary>>.



write_GS2U_AllowOpComplete(#pk_GS2U_AllowOpComplete{playerID = VplayerID}) ->
    <<VplayerID:64/little>>.



%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_GS2U_CreateGuildResult{} = P) ->
	Bin = write_GS2U_CreateGuildResult(P),
	pack:send(Socket, ?CMD_GS2U_CreateGuildResult, Bin);
send(Socket, #pk_GS2U_GuildInfoSmallList{} = P) ->
	Bin = write_GS2U_GuildInfoSmallList(P),
	pack:send(Socket, ?CMD_GS2U_GuildInfoSmallList, Bin);
send(Socket, #pk_GS2U_GuildShortInfoExList{} = P) ->
	Bin = write_GS2U_GuildShortInfoExList(P),
	pack:send(Socket, ?CMD_GS2U_GuildShortInfoExList, Bin);
send(Socket, #pk_GS2U_GuildAllShortInfoList{} = P) ->
	Bin = write_GS2U_GuildAllShortInfoList(P),
	pack:send(Socket, ?CMD_GS2U_GuildAllShortInfoList, Bin);
send(Socket, #pk_GS2U_GuildFullInfo{} = P) ->
	Bin = write_GS2U_GuildFullInfo(P),
	pack:send(Socket, ?CMD_GS2U_GuildFullInfo, Bin);
send(Socket, #pk_GS2U_GuildApplicantShortList{} = P) ->
	Bin = write_GS2U_GuildApplicantShortList(P),
	pack:send(Socket, ?CMD_GS2U_GuildApplicantShortList, Bin);
send(Socket, #pk_GS2U_GuildLevelEXPChanged{} = P) ->
	Bin = write_GS2U_GuildLevelEXPChanged(P),
	pack:send(Socket, ?CMD_GS2U_GuildLevelEXPChanged, Bin);
send(Socket, #pk_GS2U_GuildAfficheChanged{} = P) ->
	Bin = write_GS2U_GuildAfficheChanged(P),
	pack:send(Socket, ?CMD_GS2U_GuildAfficheChanged, Bin);
send(Socket, #pk_GS2U_GuildMemberContributeChanged{} = P) ->
	Bin = write_GS2U_GuildMemberContributeChanged(P),
	pack:send(Socket, ?CMD_GS2U_GuildMemberContributeChanged, Bin);
send(Socket, #pk_GS2U_GuildMemberLevelChanged{} = P) ->
	Bin = write_GS2U_GuildMemberLevelChanged(P),
	pack:send(Socket, ?CMD_GS2U_GuildMemberLevelChanged, Bin);
send(Socket, #pk_GS2U_GuildMemberOnlineChanged{} = P) ->
	Bin = write_GS2U_GuildMemberOnlineChanged(P),
	pack:send(Socket, ?CMD_GS2U_GuildMemberOnlineChanged, Bin);
send(Socket, #pk_GS2U_GuildMemberRankChanged{} = P) ->
	Bin = write_GS2U_GuildMemberRankChanged(P),
	pack:send(Socket, ?CMD_GS2U_GuildMemberRankChanged, Bin);
send(Socket, #pk_GS2U_GuildMemberAdd{} = P) ->
	Bin = write_GS2U_GuildMemberAdd(P),
	pack:send(Socket, ?CMD_GS2U_GuildMemberAdd, Bin);
send(Socket, #pk_GS2U_GuildMemberQuit{} = P) ->
	Bin = write_GS2U_GuildMemberQuit(P),
	pack:send(Socket, ?CMD_GS2U_GuildMemberQuit, Bin);
send(Socket, #pk_GS2U_JoinGuildSuccess{} = P) ->
	Bin = write_GS2U_JoinGuildSuccess(P),
	pack:send(Socket, ?CMD_GS2U_JoinGuildSuccess, Bin);
send(Socket, #pk_GS2U_AllowOpComplete{} = P) ->
	Bin = write_GS2U_AllowOpComplete(P),
	pack:send(Socket, ?CMD_GS2U_AllowOpComplete, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_U2GS_RequestCreateGuild->
            {Data, _, _} = binary_read_U2GS_RequestCreateGuild(Bin),
            messageOn:on_U2GS_RequestCreateGuild(Socket, Data);
        ?CMD_U2GS_QueryGuildList->
            {Data, _, _} = binary_read_U2GS_QueryGuildList(Bin),
            messageOn:on_U2GS_QueryGuildList(Socket, Data);
        ?CMD_U2GS_QueryGuildShortInfoEx->
            {Data, _, _} = binary_read_U2GS_QueryGuildShortInfoEx(Bin),
            messageOn:on_U2GS_QueryGuildShortInfoEx(Socket, Data);
        ?CMD_U2GS_GetMyGuildInfo->
            {Data, _, _} = binary_read_U2GS_GetMyGuildInfo(Bin),
            messageOn:on_U2GS_GetMyGuildInfo(Socket, Data);
        ?CMD_U2GS_GetMyGuildApplicantShortInfo->
            {Data, _, _} = binary_read_U2GS_GetMyGuildApplicantShortInfo(Bin),
            messageOn:on_U2GS_GetMyGuildApplicantShortInfo(Socket, Data);
        ?CMD_U2GS_RequestChangeGuildAffiche->
            {Data, _, _} = binary_read_U2GS_RequestChangeGuildAffiche(Bin),
            messageOn:on_U2GS_RequestChangeGuildAffiche(Socket, Data);
        ?CMD_U2GS_RequestGuildContribute->
            {Data, _, _} = binary_read_U2GS_RequestGuildContribute(Bin),
            messageOn:on_U2GS_RequestGuildContribute(Socket, Data);
        ?CMD_U2GS_RequestGuildMemberRankChange->
            {Data, _, _} = binary_read_U2GS_RequestGuildMemberRankChange(Bin),
            messageOn:on_U2GS_RequestGuildMemberRankChange(Socket, Data);
        ?CMD_U2GS_RequestGuildKickOutMember->
            {Data, _, _} = binary_read_U2GS_RequestGuildKickOutMember(Bin),
            messageOn:on_U2GS_RequestGuildKickOutMember(Socket, Data);
        ?CMD_U2GS_RequestGuildQuit->
            {Data, _, _} = binary_read_U2GS_RequestGuildQuit(Bin),
            messageOn:on_U2GS_RequestGuildQuit(Socket, Data);
        ?CMD_U2GS_RequestGuildStudySkill->
            {Data, _, _} = binary_read_U2GS_RequestGuildStudySkill(Bin),
            messageOn:on_U2GS_RequestGuildStudySkill(Socket, Data);
        ?CMD_U2GS_RequestJoinGuld->
            {Data, _, _} = binary_read_U2GS_RequestJoinGuld(Bin),
            messageOn:on_U2GS_RequestJoinGuld(Socket, Data);
        ?CMD_U2GS_RequestGuildApplicantAllow->
            {Data, _, _} = binary_read_U2GS_RequestGuildApplicantAllow(Bin),
            messageOn:on_U2GS_RequestGuildApplicantAllow(Socket, Data);
        ?CMD_U2GS_RequestGuildApplicantRefuse->
            {Data, _, _} = binary_read_U2GS_RequestGuildApplicantRefuse(Bin),
            messageOn:on_U2GS_RequestGuildApplicantRefuse(Socket, Data);
        ?CMD_U2GS_RequestGuildApplicantOPAll->
            {Data, _, _} = binary_read_U2GS_RequestGuildApplicantOPAll(Bin),
            messageOn:on_U2GS_RequestGuildApplicantOPAll(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
