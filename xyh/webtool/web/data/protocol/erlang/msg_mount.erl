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

-module(msg_mount).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_mount.hrl").

write_mountInfo(#pk_mountInfo{
        mountDataID = VmountDataID,
        level = Vlevel,
        equiped = Vequiped,
        progress = Vprogress,
        benison_Value = Vbenison_Value
    }) ->
    <<
        VmountDataID:8/little,
        Vlevel:8/little,
        Vequiped:8/little,
        Vprogress:8/little,
        Vbenison_Value:32/little
    >>.

binary_read_mountInfo(Bin0) ->
    <<
        VmountDataID:8/little,
        Vlevel:8/little,
        Vequiped:8/little,
        Vprogress:8/little,
        Vbenison_Value:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_mountInfo{
        mountDataID = VmountDataID,
        level = Vlevel,
        equiped = Vequiped,
        progress = Vprogress,
        benison_Value = Vbenison_Value
    }, RestBin0, 0}.


binary_read_U2GS_QueryMyMountInfo(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryMyMountInfo{reserve = Vreserve}, RestBin0, 0}.


write_GS2U_QueryMyMountInfoResult(#pk_GS2U_QueryMyMountInfoResult{mounts = Vmounts}) ->
    Amounts = write_array(Vmounts, fun(X) -> write_mountInfo(X) end),
    <<Amounts/binary>>.



write_GS2U_MountInfoUpdate(#pk_GS2U_MountInfoUpdate{mounts = Vmounts}) ->
    Amounts = write_mountInfo(Vmounts),
    <<Amounts/binary>>.



write_GS2U_MountOPResult(#pk_GS2U_MountOPResult{mountDataID = VmountDataID, result = Vresult}) ->
    <<VmountDataID:8/little, Vresult:32/little>>.



binary_read_U2GS_MountEquipRequest(Bin0) ->
    <<VmountDataID:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_MountEquipRequest{mountDataID = VmountDataID}, RestBin0, 0}.


binary_read_U2GS_Cancel_MountEquipRequest(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_Cancel_MountEquipRequest{reserve = Vreserve}, RestBin0, 0}.


binary_read_U2GS_MountUpRequest(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_MountUpRequest{reserve = Vreserve}, RestBin0, 0}.


write_GS2U_MountUp(#pk_GS2U_MountUp{actorID = VactorID, mount_data_id = Vmount_data_id}) ->
    <<VactorID:64/little, Vmount_data_id:8/little>>.



binary_read_U2GS_MountDownRequest(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_MountDownRequest{reserve = Vreserve}, RestBin0, 0}.


write_GS2U_MountDown(#pk_GS2U_MountDown{actorID = VactorID}) ->
    <<VactorID:64/little>>.



binary_read_U2GS_LevelUpRequest(Bin0) ->
    <<VmountDataID:8/little, VisAuto:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_LevelUpRequest{mountDataID = VmountDataID, isAuto = VisAuto}, RestBin0, 0}.


%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_GS2U_QueryMyMountInfoResult{} = P) ->
	Bin = write_GS2U_QueryMyMountInfoResult(P),
	pack:send(Socket, ?CMD_GS2U_QueryMyMountInfoResult, Bin);
send(Socket, #pk_GS2U_MountInfoUpdate{} = P) ->
	Bin = write_GS2U_MountInfoUpdate(P),
	pack:send(Socket, ?CMD_GS2U_MountInfoUpdate, Bin);
send(Socket, #pk_GS2U_MountOPResult{} = P) ->
	Bin = write_GS2U_MountOPResult(P),
	pack:send(Socket, ?CMD_GS2U_MountOPResult, Bin);
send(Socket, #pk_GS2U_MountUp{} = P) ->
	Bin = write_GS2U_MountUp(P),
	pack:send(Socket, ?CMD_GS2U_MountUp, Bin);
send(Socket, #pk_GS2U_MountDown{} = P) ->
	Bin = write_GS2U_MountDown(P),
	pack:send(Socket, ?CMD_GS2U_MountDown, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_U2GS_QueryMyMountInfo->
            {Data, _, _} = binary_read_U2GS_QueryMyMountInfo(Bin),
            messageOn:on_U2GS_QueryMyMountInfo(Socket, Data);
        ?CMD_U2GS_MountEquipRequest->
            {Data, _, _} = binary_read_U2GS_MountEquipRequest(Bin),
            messageOn:on_U2GS_MountEquipRequest(Socket, Data);
        ?CMD_U2GS_Cancel_MountEquipRequest->
            {Data, _, _} = binary_read_U2GS_Cancel_MountEquipRequest(Bin),
            messageOn:on_U2GS_Cancel_MountEquipRequest(Socket, Data);
        ?CMD_U2GS_MountUpRequest->
            {Data, _, _} = binary_read_U2GS_MountUpRequest(Bin),
            messageOn:on_U2GS_MountUpRequest(Socket, Data);
        ?CMD_U2GS_MountDownRequest->
            {Data, _, _} = binary_read_U2GS_MountDownRequest(Bin),
            messageOn:on_U2GS_MountDownRequest(Socket, Data);
        ?CMD_U2GS_LevelUpRequest->
            {Data, _, _} = binary_read_U2GS_LevelUpRequest(Bin),
            messageOn:on_U2GS_LevelUpRequest(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
