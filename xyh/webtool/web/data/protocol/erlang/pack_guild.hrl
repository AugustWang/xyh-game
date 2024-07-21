%%---------------------------------------------------------
%% @doc Automatic Generation Of Protocol File
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
%%---------------------------------------------------------

%%---------------------------------------------------------
%% define cmd
%%---------------------------------------------------------

-define(CMD_U2GS_RequestCreateGuild, 301).
-define(CMD_U2GS_QueryGuildList, 302).
-define(CMD_U2GS_QueryGuildShortInfoEx, 303).
-define(CMD_U2GS_GetMyGuildInfo, 304).
-define(CMD_U2GS_GetMyGuildApplicantShortInfo, 305).
-define(CMD_U2GS_RequestChangeGuildAffiche, 306).
-define(CMD_U2GS_RequestGuildContribute, 307).
-define(CMD_U2GS_RequestGuildMemberRankChange, 308).
-define(CMD_U2GS_RequestGuildKickOutMember, 309).
-define(CMD_U2GS_RequestGuildQuit, 310).
-define(CMD_U2GS_RequestGuildStudySkill, 311).
-define(CMD_U2GS_RequestJoinGuld, 312).
-define(CMD_U2GS_RequestGuildApplicantAllow, 313).
-define(CMD_U2GS_RequestGuildApplicantRefuse, 314).
-define(CMD_U2GS_RequestGuildApplicantOPAll, 315).
-define(CMD_GS2U_CreateGuildResult, 316).
-define(CMD_GS2U_GuildInfoSmall, 317).
-define(CMD_GS2U_GuildInfoSmallList, 318).
-define(CMD_GS2U_GuildShortInfoEx, 319).
-define(CMD_GS2U_GuildShortInfoExList, 320).
-define(CMD_GS2U_GuildAllShortInfo, 321).
-define(CMD_GS2U_GuildAllShortInfoList, 322).
-define(CMD_GS2U_GuildBaseData, 323).
-define(CMD_GS2U_GuildMemberData, 324).
-define(CMD_GS2U_GuildApplicantData, 325).
-define(CMD_GS2U_GuildFullInfo, 326).
-define(CMD_GS2U_GuildApplicantShortData, 327).
-define(CMD_GS2U_GuildApplicantShortList, 328).
-define(CMD_GS2U_GuildLevelEXPChanged, 329).
-define(CMD_GS2U_GuildAfficheChanged, 330).
-define(CMD_GS2U_GuildMemberContributeChanged, 331).
-define(CMD_GS2U_GuildMemberLevelChanged, 332).
-define(CMD_GS2U_GuildMemberOnlineChanged, 333).
-define(CMD_GS2U_GuildMemberRankChanged, 334).
-define(CMD_GS2U_GuildMemberAdd, 335).
-define(CMD_GS2U_GuildMemberQuit, 336).
-define(CMD_GS2U_JoinGuildSuccess, 337).
-define(CMD_GS2U_AllowOpComplete, 338).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_U2GS_RequestCreateGuild, {
        useToken,
        strGuildName
	}).
-record(pk_U2GS_QueryGuildList, {
        bFirst
	}).
-record(pk_U2GS_QueryGuildShortInfoEx, {
        vGuilds
	}).
-record(pk_U2GS_GetMyGuildInfo, {
        reserve
	}).
-record(pk_U2GS_GetMyGuildApplicantShortInfo, {
        reserve
	}).
-record(pk_U2GS_RequestChangeGuildAffiche, {
        strAffiche
	}).
-record(pk_U2GS_RequestGuildContribute, {
        nMoney,
        nGold,
        nItemCount
	}).
-record(pk_U2GS_RequestGuildMemberRankChange, {
        nPlayerID,
        nRank
	}).
-record(pk_U2GS_RequestGuildKickOutMember, {
        nPlayerID
	}).
-record(pk_U2GS_RequestGuildQuit, {
        reserve
	}).
-record(pk_U2GS_RequestGuildStudySkill, {
        nSkillGroupID
	}).
-record(pk_U2GS_RequestJoinGuld, {
        nGuildID
	}).
-record(pk_U2GS_RequestGuildApplicantAllow, {
        nPlayerID
	}).
-record(pk_U2GS_RequestGuildApplicantRefuse, {
        nPlayerID
	}).
-record(pk_U2GS_RequestGuildApplicantOPAll, {
        nAllowOrRefuse
	}).
-record(pk_GS2U_CreateGuildResult, {
        result,
        guildID
	}).
-record(pk_GS2U_GuildInfoSmall, {
        nGuildID,
        nChairmanPlayerID,
        nLevel,
        nMemberCount
	}).
-record(pk_GS2U_GuildInfoSmallList, {
        info_list
	}).
-record(pk_GS2U_GuildShortInfoEx, {
        nGuildID,
        nFaction,
        strGuildName,
        strChairmanPlayerName
	}).
-record(pk_GS2U_GuildShortInfoExList, {
        info_list
	}).
-record(pk_GS2U_GuildAllShortInfo, {
        nGuildID,
        nChairmanPlayerID,
        strChairmanPlayerName,
        nLevel,
        nMemberCount,
        nFaction,
        strGuildName
	}).
-record(pk_GS2U_GuildAllShortInfoList, {
        info_list
	}).
-record(pk_GS2U_GuildBaseData, {
        nGuildID,
        nChairmanPlayerID,
        nFaction,
        nLevel,
        nExp,
        memberCount,
        strChairmanPlayerName,
        strGuildName,
        strAffiche
	}).
-record(pk_GS2U_GuildMemberData, {
        nPlayerID,
        strPlayerName,
        nPlayerLevel,
        nRank,
        nClass,
        nContribute,
        bOnline
	}).
-record(pk_GS2U_GuildApplicantData, {
        nPlayerID,
        strPlayerName,
        nPlayerLevel,
        nClass,
        nZhanLi
	}).
-record(pk_GS2U_GuildFullInfo, {
        stBase,
        member_list,
        applicant_list
	}).
-record(pk_GS2U_GuildApplicantShortData, {
        nPlayerID,
        nPlayerLevel,
        nZhanLi
	}).
-record(pk_GS2U_GuildApplicantShortList, {
        info_list
	}).
-record(pk_GS2U_GuildLevelEXPChanged, {
        nLevel,
        nEXP
	}).
-record(pk_GS2U_GuildAfficheChanged, {
        strAffiche
	}).
-record(pk_GS2U_GuildMemberContributeChanged, {
        nPlayerID,
        nContribute
	}).
-record(pk_GS2U_GuildMemberLevelChanged, {
        nPlayerID,
        nLevel
	}).
-record(pk_GS2U_GuildMemberOnlineChanged, {
        nPlayerID,
        nOnline
	}).
-record(pk_GS2U_GuildMemberRankChanged, {
        nPlayerID,
        nRank
	}).
-record(pk_GS2U_GuildMemberAdd, {
        stData
	}).
-record(pk_GS2U_GuildMemberQuit, {
        nPlayerID,
        bKickOut
	}).
-record(pk_GS2U_JoinGuildSuccess, {
        guildID,
        guildName
	}).
-record(pk_GS2U_AllowOpComplete, {
        playerID
	}).
