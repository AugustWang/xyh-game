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

-module(msg_toplist).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_toplist.hrl").

write_TopPlayerLevelInfo(#pk_TopPlayerLevelInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        camp = Vcamp,
        level = Vlevel,
        fightingcapacity = Vfightingcapacity,
        sex = Vsex,
        weapon = Vweapon,
        coat = Vcoat
    }) ->
    Lname = byte_size(Vname),
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname/binary,
        Vcamp:32/little,
        Vlevel:32/little,
        Vfightingcapacity:32/little,
        Vsex:32/little,
        Vweapon:32/little,
        Vcoat:32/little
    >>.

binary_read_TopPlayerLevelInfo(Bin0) ->
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname:Lname/binary,
        Vcamp:32/little,
        Vlevel:32/little,
        Vfightingcapacity:32/little,
        Vsex:32/little,
        Vweapon:32/little,
        Vcoat:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_TopPlayerLevelInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        camp = Vcamp,
        level = Vlevel,
        fightingcapacity = Vfightingcapacity,
        sex = Vsex,
        weapon = Vweapon,
        coat = Vcoat
    }, RestBin0, 0}.


write_TopPlayerFightingCapacityInfo(#pk_TopPlayerFightingCapacityInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        camp = Vcamp,
        level = Vlevel,
        fightingcapacity = Vfightingcapacity,
        sex = Vsex,
        weapon = Vweapon,
        coat = Vcoat
    }) ->
    Lname = byte_size(Vname),
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname/binary,
        Vcamp:32/little,
        Vlevel:32/little,
        Vfightingcapacity:32/little,
        Vsex:32/little,
        Vweapon:32/little,
        Vcoat:32/little
    >>.

binary_read_TopPlayerFightingCapacityInfo(Bin0) ->
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname:Lname/binary,
        Vcamp:32/little,
        Vlevel:32/little,
        Vfightingcapacity:32/little,
        Vsex:32/little,
        Vweapon:32/little,
        Vcoat:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_TopPlayerFightingCapacityInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        camp = Vcamp,
        level = Vlevel,
        fightingcapacity = Vfightingcapacity,
        sex = Vsex,
        weapon = Vweapon,
        coat = Vcoat
    }, RestBin0, 0}.


write_TopPlayerMoneyInfo(#pk_TopPlayerMoneyInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        camp = Vcamp,
        level = Vlevel,
        money = Vmoney,
        sex = Vsex,
        weapon = Vweapon,
        coat = Vcoat
    }) ->
    Lname = byte_size(Vname),
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname/binary,
        Vcamp:32/little,
        Vlevel:32/little,
        Vmoney:32/little,
        Vsex:32/little,
        Vweapon:32/little,
        Vcoat:32/little
    >>.

binary_read_TopPlayerMoneyInfo(Bin0) ->
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname:Lname/binary,
        Vcamp:32/little,
        Vlevel:32/little,
        Vmoney:32/little,
        Vsex:32/little,
        Vweapon:32/little,
        Vcoat:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_TopPlayerMoneyInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        camp = Vcamp,
        level = Vlevel,
        money = Vmoney,
        sex = Vsex,
        weapon = Vweapon,
        coat = Vcoat
    }, RestBin0, 0}.


write_GS2U_LoadTopPlayerLevelList(#pk_GS2U_LoadTopPlayerLevelList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_TopPlayerLevelInfo(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_LoadTopPlayerFightingCapacityList(#pk_GS2U_LoadTopPlayerFightingCapacityList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_TopPlayerFightingCapacityInfo(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_LoadTopPlayerMoneyList(#pk_GS2U_LoadTopPlayerMoneyList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_TopPlayerMoneyInfo(X) end),
    <<Ainfo_list/binary>>.



binary_read_U2GS_LoadTopPlayerLevelList(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_LoadTopPlayerLevelList{}, RestBin0, 0}.


binary_read_U2GS_LoadTopPlayerFightingCapacityList(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_LoadTopPlayerFightingCapacityList{}, RestBin0, 0}.


binary_read_U2GS_LoadTopPlayerMoneyList(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_LoadTopPlayerMoneyList{}, RestBin0, 0}.


write_AnswerTopInfo(#pk_AnswerTopInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        core = Vcore
    }) ->
    Lname = byte_size(Vname),
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname/binary,
        Vcore:32/little
    >>.

binary_read_AnswerTopInfo(Bin0) ->
    <<
        Vtop:32/little,
        Vplayerid:64/little,
        Lname:16/little, Vname:Lname/binary,
        Vcore:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_AnswerTopInfo{
        top = Vtop,
        playerid = Vplayerid,
        name = Vname,
        core = Vcore
    }, RestBin0, 0}.


write_GS2U_AnswerQuestion(#pk_GS2U_AnswerQuestion{
        id = Vid,
        num = Vnum,
        maxnum = Vmaxnum,
        core = Vcore,
        special_double = Vspecial_double,
        special_right = Vspecial_right,
        special_exclude = Vspecial_exclude,
        a = Va,
        b = Vb,
        c = Vc,
        d = Vd,
        e1 = Ve1,
        e2 = Ve2
    }) ->
    <<
        Vid:32/little,
        Vnum:8/little,
        Vmaxnum:8/little,
        Vcore:32/little,
        Vspecial_double:8/little,
        Vspecial_right:8/little,
        Vspecial_exclude:8/little,
        Va:8/little,
        Vb:8/little,
        Vc:8/little,
        Vd:8/little,
        Ve1:8/little,
        Ve2:8/little
    >>.



write_GS2U_AnswerReady(#pk_GS2U_AnswerReady{time = Vtime}) ->
    <<Vtime:32/little>>.



write_GS2U_AnswerClose(#pk_GS2U_AnswerClose{}) ->
    <<>>.



write_GS2U_AnswerTopList(#pk_GS2U_AnswerTopList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_AnswerTopInfo(X) end),
    <<Ainfo_list/binary>>.



binary_read_U2GS_AnswerCommit(Bin0) ->
    <<
        Vnum:32/little,
        Vanswer:32/little,
        Vtime:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_AnswerCommit{
        num = Vnum,
        answer = Vanswer,
        time = Vtime
    }, RestBin0, 0}.


write_U2GS_AnswerCommitRet(#pk_U2GS_AnswerCommitRet{ret = Vret, score = Vscore}) ->
    <<Vret:8/little, Vscore:32/little>>.



binary_read_U2GS_AnswerSpecial(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_AnswerSpecial{type = Vtype}, RestBin0, 0}.


write_U2GS_AnswerSpecialRet(#pk_U2GS_AnswerSpecialRet{ret = Vret}) ->
    <<Vret:8/little>>.



%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_GS2U_LoadTopPlayerLevelList{} = P) ->
	Bin = write_GS2U_LoadTopPlayerLevelList(P),
	pack:send(Socket, ?CMD_GS2U_LoadTopPlayerLevelList, Bin);
send(Socket, #pk_GS2U_LoadTopPlayerFightingCapacityList{} = P) ->
	Bin = write_GS2U_LoadTopPlayerFightingCapacityList(P),
	pack:send(Socket, ?CMD_GS2U_LoadTopPlayerFightingCapacityList, Bin);
send(Socket, #pk_GS2U_LoadTopPlayerMoneyList{} = P) ->
	Bin = write_GS2U_LoadTopPlayerMoneyList(P),
	pack:send(Socket, ?CMD_GS2U_LoadTopPlayerMoneyList, Bin);
send(Socket, #pk_GS2U_AnswerQuestion{} = P) ->
	Bin = write_GS2U_AnswerQuestion(P),
	pack:send(Socket, ?CMD_GS2U_AnswerQuestion, Bin);
send(Socket, #pk_GS2U_AnswerReady{} = P) ->
	Bin = write_GS2U_AnswerReady(P),
	pack:send(Socket, ?CMD_GS2U_AnswerReady, Bin);
send(Socket, #pk_GS2U_AnswerClose{} = P) ->
	Bin = write_GS2U_AnswerClose(P),
	pack:send(Socket, ?CMD_GS2U_AnswerClose, Bin);
send(Socket, #pk_GS2U_AnswerTopList{} = P) ->
	Bin = write_GS2U_AnswerTopList(P),
	pack:send(Socket, ?CMD_GS2U_AnswerTopList, Bin);
send(Socket, #pk_U2GS_AnswerCommitRet{} = P) ->
	Bin = write_U2GS_AnswerCommitRet(P),
	pack:send(Socket, ?CMD_U2GS_AnswerCommitRet, Bin);
send(Socket, #pk_U2GS_AnswerSpecialRet{} = P) ->
	Bin = write_U2GS_AnswerSpecialRet(P),
	pack:send(Socket, ?CMD_U2GS_AnswerSpecialRet, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_U2GS_LoadTopPlayerLevelList->
            {Data, _, _} = binary_read_U2GS_LoadTopPlayerLevelList(Bin),
            messageOn:on_U2GS_LoadTopPlayerLevelList(Socket, Data);
        ?CMD_U2GS_LoadTopPlayerFightingCapacityList->
            {Data, _, _} = binary_read_U2GS_LoadTopPlayerFightingCapacityList(Bin),
            messageOn:on_U2GS_LoadTopPlayerFightingCapacityList(Socket, Data);
        ?CMD_U2GS_LoadTopPlayerMoneyList->
            {Data, _, _} = binary_read_U2GS_LoadTopPlayerMoneyList(Bin),
            messageOn:on_U2GS_LoadTopPlayerMoneyList(Socket, Data);
        ?CMD_U2GS_AnswerCommit->
            {Data, _, _} = binary_read_U2GS_AnswerCommit(Bin),
            messageOn:on_U2GS_AnswerCommit(Socket, Data);
        ?CMD_U2GS_AnswerSpecial->
            {Data, _, _} = binary_read_U2GS_AnswerSpecial(Bin),
            messageOn:on_U2GS_AnswerSpecial(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
