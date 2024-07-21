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

-module(msg_player).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_player.hrl").

write_CharProperty(#pk_CharProperty{
        attack = Vattack,
        defence = Vdefence,
        ph_def = Vph_def,
        fire_def = Vfire_def,
        ice_def = Vice_def,
        elec_def = Velec_def,
        poison_def = Vpoison_def,
        max_life = Vmax_life,
        life_recover = Vlife_recover,
        been_attack_recover = Vbeen_attack_recover,
        damage_recover = Vdamage_recover,
        coma_def = Vcoma_def,
        hold_def = Vhold_def,
        silent_def = Vsilent_def,
        move_def = Vmove_def,
        hit = Vhit,
        dodge = Vdodge,
        block = Vblock,
        crit = Vcrit,
        pierce = Vpierce,
        attack_speed = Vattack_speed,
        tough = Vtough,
        crit_damage_rate = Vcrit_damage_rate,
        block_dec_damage = Vblock_dec_damage,
        phy_attack_rate = Vphy_attack_rate,
        fire_attack_rate = Vfire_attack_rate,
        ice_attack_rate = Vice_attack_rate,
        elec_attack_rate = Velec_attack_rate,
        poison_attack_rate = Vpoison_attack_rate,
        phy_def_rate = Vphy_def_rate,
        fire_def_rate = Vfire_def_rate,
        ice_def_rate = Vice_def_rate,
        elec_def_rate = Velec_def_rate,
        poison_def_rate = Vpoison_def_rate,
        treat_rate = Vtreat_rate,
        on_treat_rate = Von_treat_rate,
        move_speed = Vmove_speed
    }) ->
    <<
        Vattack:32/little,
        Vdefence:32/little,
        Vph_def:32/little,
        Vfire_def:32/little,
        Vice_def:32/little,
        Velec_def:32/little,
        Vpoison_def:32/little,
        Vmax_life:32/little,
        Vlife_recover:32/little,
        Vbeen_attack_recover:32/little,
        Vdamage_recover:32/little,
        Vcoma_def:32/little,
        Vhold_def:32/little,
        Vsilent_def:32/little,
        Vmove_def:32/little,
        Vhit:32/little,
        Vdodge:32/little,
        Vblock:32/little,
        Vcrit:32/little,
        Vpierce:32/little,
        Vattack_speed:32/little,
        Vtough:32/little,
        Vcrit_damage_rate:32/little,
        Vblock_dec_damage:32/little,
        Vphy_attack_rate:32/little,
        Vfire_attack_rate:32/little,
        Vice_attack_rate:32/little,
        Velec_attack_rate:32/little,
        Vpoison_attack_rate:32/little,
        Vphy_def_rate:32/little,
        Vfire_def_rate:32/little,
        Vice_def_rate:32/little,
        Velec_def_rate:32/little,
        Vpoison_def_rate:32/little,
        Vtreat_rate:32/little,
        Von_treat_rate:32/little,
        Vmove_speed:32/little
    >>.

binary_read_CharProperty(Bin0) ->
    <<
        Vattack:32/little,
        Vdefence:32/little,
        Vph_def:32/little,
        Vfire_def:32/little,
        Vice_def:32/little,
        Velec_def:32/little,
        Vpoison_def:32/little,
        Vmax_life:32/little,
        Vlife_recover:32/little,
        Vbeen_attack_recover:32/little,
        Vdamage_recover:32/little,
        Vcoma_def:32/little,
        Vhold_def:32/little,
        Vsilent_def:32/little,
        Vmove_def:32/little,
        Vhit:32/little,
        Vdodge:32/little,
        Vblock:32/little,
        Vcrit:32/little,
        Vpierce:32/little,
        Vattack_speed:32/little,
        Vtough:32/little,
        Vcrit_damage_rate:32/little,
        Vblock_dec_damage:32/little,
        Vphy_attack_rate:32/little,
        Vfire_attack_rate:32/little,
        Vice_attack_rate:32/little,
        Velec_attack_rate:32/little,
        Vpoison_attack_rate:32/little,
        Vphy_def_rate:32/little,
        Vfire_def_rate:32/little,
        Vice_def_rate:32/little,
        Velec_def_rate:32/little,
        Vpoison_def_rate:32/little,
        Vtreat_rate:32/little,
        Von_treat_rate:32/little,
        Vmove_speed:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_CharProperty{
        attack = Vattack,
        defence = Vdefence,
        ph_def = Vph_def,
        fire_def = Vfire_def,
        ice_def = Vice_def,
        elec_def = Velec_def,
        poison_def = Vpoison_def,
        max_life = Vmax_life,
        life_recover = Vlife_recover,
        been_attack_recover = Vbeen_attack_recover,
        damage_recover = Vdamage_recover,
        coma_def = Vcoma_def,
        hold_def = Vhold_def,
        silent_def = Vsilent_def,
        move_def = Vmove_def,
        hit = Vhit,
        dodge = Vdodge,
        block = Vblock,
        crit = Vcrit,
        pierce = Vpierce,
        attack_speed = Vattack_speed,
        tough = Vtough,
        crit_damage_rate = Vcrit_damage_rate,
        block_dec_damage = Vblock_dec_damage,
        phy_attack_rate = Vphy_attack_rate,
        fire_attack_rate = Vfire_attack_rate,
        ice_attack_rate = Vice_attack_rate,
        elec_attack_rate = Velec_attack_rate,
        poison_attack_rate = Vpoison_attack_rate,
        phy_def_rate = Vphy_def_rate,
        fire_def_rate = Vfire_def_rate,
        ice_def_rate = Vice_def_rate,
        elec_def_rate = Velec_def_rate,
        poison_def_rate = Vpoison_def_rate,
        treat_rate = Vtreat_rate,
        on_treat_rate = Von_treat_rate,
        move_speed = Vmove_speed
    }, RestBin0, 0}.


write_ObjectBuff(#pk_ObjectBuff{
        buff_id = Vbuff_id,
        allValidTime = VallValidTime,
        remainTriggerCount = VremainTriggerCount
    }) ->
    <<
        Vbuff_id:16/little,
        VallValidTime:16/little,
        VremainTriggerCount:8/little
    >>.

binary_read_ObjectBuff(Bin0) ->
    <<
        Vbuff_id:16/little,
        VallValidTime:16/little,
        VremainTriggerCount:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_ObjectBuff{
        buff_id = Vbuff_id,
        allValidTime = VallValidTime,
        remainTriggerCount = VremainTriggerCount
    }, RestBin0, 0}.


write_PlayerBaseInfo(#pk_PlayerBaseInfo{
        id = Vid,
        name = Vname,
        x = Vx,
        y = Vy,
        sex = Vsex,
        face = Vface,
        weapon = Vweapon,
        level = Vlevel,
        camp = Vcamp,
        faction = Vfaction,
        vip = Vvip,
        maxEnabledBagCells = VmaxEnabledBagCells,
        maxEnabledStorageBagCells = VmaxEnabledStorageBagCells,
        storageBagPassWord = VstorageBagPassWord,
        unlockTimes = VunlockTimes,
        money = Vmoney,
        moneyBinded = VmoneyBinded,
        gold = Vgold,
        goldBinded = VgoldBinded,
        rechargeAmmount = VrechargeAmmount,
        ticket = Vticket,
        guildContribute = VguildContribute,
        honor = Vhonor,
        credit = Vcredit,
        exp = Vexp,
        bloodPool = VbloodPool,
        petBloodPool = VpetBloodPool,
        life = Vlife,
        lifeMax = VlifeMax,
        guildID = VguildID,
        mountDataID = VmountDataID,
        pK_Kill_RemainTime = VpK_Kill_RemainTime,
        exp15Add = Vexp15Add,
        exp20Add = Vexp20Add,
        exp30Add = Vexp30Add,
        pk_Kill_Value = Vpk_Kill_Value,
        pkFlags = VpkFlags,
        minEquipLevel = VminEquipLevel,
        guild_name = Vguild_name,
        guild_rank = Vguild_rank,
        goldPassWord = VgoldPassWord
    }) ->
    Lname = byte_size(Vname),
    LstorageBagPassWord = byte_size(VstorageBagPassWord),
    Lguild_name = byte_size(Vguild_name),
    LgoldPassWord = byte_size(VgoldPassWord),
    <<
        Vid:64/little,
        Lname:16/little, Vname/binary,
        Vx:16/little,
        Vy:16/little,
        Vsex:8/little,
        Vface:8/little,
        Vweapon:8/little,
        Vlevel:16/little,
        Vcamp:8/little,
        Vfaction:8/little,
        Vvip:8/little,
        VmaxEnabledBagCells:16/little,
        VmaxEnabledStorageBagCells:16/little,
        LstorageBagPassWord:16/little, VstorageBagPassWord/binary,
        VunlockTimes:32/little,
        Vmoney:32/little,
        VmoneyBinded:32/little,
        Vgold:32/little,
        VgoldBinded:32/little,
        VrechargeAmmount:32/little,
        Vticket:32/little,
        VguildContribute:32/little,
        Vhonor:32/little,
        Vcredit:32/little,
        Vexp:32/little,
        VbloodPool:32/little,
        VpetBloodPool:32/little,
        Vlife:32/little,
        VlifeMax:32/little,
        VguildID:64/little,
        VmountDataID:32/little,
        VpK_Kill_RemainTime:32/little,
        Vexp15Add:32/little,
        Vexp20Add:32/little,
        Vexp30Add:32/little,
        Vpk_Kill_Value:32/little,
        VpkFlags:8/little,
        VminEquipLevel:8/little,
        Lguild_name:16/little, Vguild_name/binary,
        Vguild_rank:8/little,
        LgoldPassWord:16/little, VgoldPassWord/binary
    >>.



write_rideInfo(#pk_rideInfo{mountDataID = VmountDataID, rideFlage = VrideFlage}) ->
    <<VmountDataID:32/little, VrideFlage:32/little>>.

binary_read_rideInfo(Bin0) ->
    <<VmountDataID:32/little, VrideFlage:32/little, RestBin0/binary>> = Bin0,
    {#pk_rideInfo{mountDataID = VmountDataID, rideFlage = VrideFlage}, RestBin0, 0}.


write_LookInfoPlayer(#pk_LookInfoPlayer{
        id = Vid,
        name = Vname,
        lifePercent = VlifePercent,
        x = Vx,
        y = Vy,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y,
        move_dir = Vmove_dir,
        move_speed = Vmove_speed,
        level = Vlevel,
        value_flags = Vvalue_flags,
        charState = VcharState,
        weapon = Vweapon,
        coat = Vcoat,
        buffList = VbuffList,
        convoyFlags = VconvoyFlags,
        guild_id = Vguild_id,
        guild_name = Vguild_name,
        guild_rank = Vguild_rank,
        vip = Vvip
    }) ->
    Lname = byte_size(Vname),
    AbuffList = write_array(VbuffList, fun(X) -> write_ObjectBuff(X) end),
    Lguild_name = byte_size(Vguild_name),
    <<
        Vid:64/little,
        Lname:16/little, Vname/binary,
        VlifePercent:8/little,
        Vx:16/little,
        Vy:16/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        Vmove_dir:8/little,
        Vmove_speed:16/little,
        Vlevel:16/little,
        Vvalue_flags:32/little,
        VcharState:32/little,
        Vweapon:16/little,
        Vcoat:16/little,
        AbuffList/binary,
        VconvoyFlags:8/little,
        Vguild_id:64/little,
        Lguild_name:16/little, Vguild_name/binary,
        Vguild_rank:8/little,
        Vvip:8/little
    >>.

binary_read_LookInfoPlayer(Bin0) ->
    <<
        Vid:64/little,
        Lname:16/little, Vname:Lname/binary,
        VlifePercent:8/little,
        Vx:16/little,
        Vy:16/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        Vmove_dir:8/little,
        Vmove_speed:16/little,
        Vlevel:16/little,
        Vvalue_flags:32/little,
        VcharState:32/little,
        Vweapon:16/little,
        Vcoat:16/little,
        RestBin0/binary>> = Bin0,
    {VbuffList, Bin1} = read_array(RestBin0, fun(X) -> binary_read_ObjectBuff(X) end),
    <<
        VconvoyFlags:8/little,
        Vguild_id:64/little,
        Lguild_name:16/little, Vguild_name:Lguild_name/binary,
        Vguild_rank:8/little,
        Vvip:8/little,
        RestBin1/binary
    >> = Bin1,
    {#pk_LookInfoPlayer{
        id = Vid,
        name = Vname,
        lifePercent = VlifePercent,
        x = Vx,
        y = Vy,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y,
        move_dir = Vmove_dir,
        move_speed = Vmove_speed,
        level = Vlevel,
        value_flags = Vvalue_flags,
        charState = VcharState,
        weapon = Vweapon,
        coat = Vcoat,
        buffList = VbuffList,
        convoyFlags = VconvoyFlags,
        guild_id = Vguild_id,
        guild_name = Vguild_name,
        guild_rank = Vguild_rank,
        vip = Vvip
    }, RestBin1, 0}.


write_LookInfoPlayerList(#pk_LookInfoPlayerList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_LookInfoPlayer(X) end),
    <<Ainfo_list/binary>>.



write_LookInfoPet(#pk_LookInfoPet{
        id = Vid,
        masterId = VmasterId,
        data_id = Vdata_id,
        name = Vname,
        titleid = Vtitleid,
        modelId = VmodelId,
        lifePercent = VlifePercent,
        level = Vlevel,
        x = Vx,
        y = Vy,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y,
        move_speed = Vmove_speed,
        charState = VcharState,
        buffList = VbuffList
    }) ->
    Lname = byte_size(Vname),
    AbuffList = write_array(VbuffList, fun(X) -> write_ObjectBuff(X) end),
    <<
        Vid:64/little,
        VmasterId:64/little,
        Vdata_id:16/little,
        Lname:16/little, Vname/binary,
        Vtitleid:16/little,
        VmodelId:16/little,
        VlifePercent:8/little,
        Vlevel:16/little,
        Vx:16/little,
        Vy:16/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        Vmove_speed:16/little,
        VcharState:32/little,
        AbuffList/binary
    >>.

binary_read_LookInfoPet(Bin0) ->
    <<
        Vid:64/little,
        VmasterId:64/little,
        Vdata_id:16/little,
        Lname:16/little, Vname:Lname/binary,
        Vtitleid:16/little,
        VmodelId:16/little,
        VlifePercent:8/little,
        Vlevel:16/little,
        Vx:16/little,
        Vy:16/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        Vmove_speed:16/little,
        VcharState:32/little,
        RestBin0/binary>> = Bin0,
    {VbuffList, Bin1} = read_array(RestBin0, fun(X) -> binary_read_ObjectBuff(X) end),
    <<
        RestBin1/binary
    >> = Bin1,
    {#pk_LookInfoPet{
        id = Vid,
        masterId = VmasterId,
        data_id = Vdata_id,
        name = Vname,
        titleid = Vtitleid,
        modelId = VmodelId,
        lifePercent = VlifePercent,
        level = Vlevel,
        x = Vx,
        y = Vy,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y,
        move_speed = Vmove_speed,
        charState = VcharState,
        buffList = VbuffList
    }, RestBin1, 0}.


write_LookInfoPetList(#pk_LookInfoPetList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_LookInfoPet(X) end),
    <<Ainfo_list/binary>>.



write_LookInfoMonster(#pk_LookInfoMonster{
        id = Vid,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y,
        move_speed = Vmove_speed,
        x = Vx,
        y = Vy,
        monster_data_id = Vmonster_data_id,
        lifePercent = VlifePercent,
        faction = Vfaction,
        charState = VcharState,
        buffList = VbuffList
    }) ->
    AbuffList = write_array(VbuffList, fun(X) -> write_ObjectBuff(X) end),
    <<
        Vid:64/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        Vmove_speed:16/little,
        Vx:16/little,
        Vy:16/little,
        Vmonster_data_id:16/little,
        VlifePercent:8/little,
        Vfaction:8/little,
        VcharState:32/little,
        AbuffList/binary
    >>.

binary_read_LookInfoMonster(Bin0) ->
    <<
        Vid:64/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        Vmove_speed:16/little,
        Vx:16/little,
        Vy:16/little,
        Vmonster_data_id:16/little,
        VlifePercent:8/little,
        Vfaction:8/little,
        VcharState:32/little,
        RestBin0/binary>> = Bin0,
    {VbuffList, Bin1} = read_array(RestBin0, fun(X) -> binary_read_ObjectBuff(X) end),
    <<
        RestBin1/binary
    >> = Bin1,
    {#pk_LookInfoMonster{
        id = Vid,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y,
        move_speed = Vmove_speed,
        x = Vx,
        y = Vy,
        monster_data_id = Vmonster_data_id,
        lifePercent = VlifePercent,
        faction = Vfaction,
        charState = VcharState,
        buffList = VbuffList
    }, RestBin1, 0}.


write_LookInfoMonsterList(#pk_LookInfoMonsterList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_LookInfoMonster(X) end),
    <<Ainfo_list/binary>>.



write_LookInfoNpc(#pk_LookInfoNpc{
        id = Vid,
        x = Vx,
        y = Vy,
        npc_data_id = Vnpc_data_id,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y
    }) ->
    <<
        Vid:64/little,
        Vx:16/little,
        Vy:16/little,
        Vnpc_data_id:16/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little
    >>.

binary_read_LookInfoNpc(Bin0) ->
    <<
        Vid:64/little,
        Vx:16/little,
        Vy:16/little,
        Vnpc_data_id:16/little,
        Vmove_target_x:16/little,
        Vmove_target_y:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_LookInfoNpc{
        id = Vid,
        x = Vx,
        y = Vy,
        npc_data_id = Vnpc_data_id,
        move_target_x = Vmove_target_x,
        move_target_y = Vmove_target_y
    }, RestBin0, 0}.


write_LookInfoNpcList(#pk_LookInfoNpcList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_LookInfoNpc(X) end),
    <<Ainfo_list/binary>>.



write_LookInfoObject(#pk_LookInfoObject{
        id = Vid,
        x = Vx,
        y = Vy,
        object_data_id = Vobject_data_id,
        object_type = Vobject_type,
        param = Vparam
    }) ->
    <<
        Vid:64/little,
        Vx:16/little,
        Vy:16/little,
        Vobject_data_id:16/little,
        Vobject_type:16/little,
        Vparam:32/little
    >>.

binary_read_LookInfoObject(Bin0) ->
    <<
        Vid:64/little,
        Vx:16/little,
        Vy:16/little,
        Vobject_data_id:16/little,
        Vobject_type:16/little,
        Vparam:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_LookInfoObject{
        id = Vid,
        x = Vx,
        y = Vy,
        object_data_id = Vobject_data_id,
        object_type = Vobject_type,
        param = Vparam
    }, RestBin0, 0}.


write_LookInfoObjectList(#pk_LookInfoObjectList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_LookInfoObject(X) end),
    <<Ainfo_list/binary>>.



write_ActorDisapearList(#pk_ActorDisapearList{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> <<X:64/little>> end),
    <<Ainfo_list/binary>>.



write_PosInfo(#pk_PosInfo{x = Vx, y = Vy}) ->
    <<Vx:16/little, Vy:16/little>>.

binary_read_PosInfo(Bin0) ->
    <<Vx:16/little, Vy:16/little, RestBin0/binary>> = Bin0,
    {#pk_PosInfo{x = Vx, y = Vy}, RestBin0, 0}.


binary_read_PlayerMoveTo(Bin0) ->
    <<
        VposX:16/little,
        VposY:16/little,
        RestBin0/binary>> = Bin0,
    {VposInfos, Bin1} = read_array(RestBin0, fun(X) -> binary_read_PosInfo(X) end),
    <<
        RestBin1/binary
    >> = Bin1,
    {#pk_PlayerMoveTo{
        posX = VposX,
        posY = VposY,
        posInfos = VposInfos
    }, RestBin1, 0}.


binary_read_PlayerStopMove(Bin0) ->
    <<VposX:16/little, VposY:16/little, RestBin0/binary>> = Bin0,
    {#pk_PlayerStopMove{posX = VposX, posY = VposY}, RestBin0, 0}.


write_PlayerStopMove_S2C(#pk_PlayerStopMove_S2C{
        id = Vid,
        posX = VposX,
        posY = VposY
    }) ->
    <<
        Vid:64/little,
        VposX:16/little,
        VposY:16/little
    >>.



write_MoveInfo(#pk_MoveInfo{
        id = Vid,
        posX = VposX,
        posY = VposY,
        posInfos = VposInfos
    }) ->
    AposInfos = write_array(VposInfos, fun(X) -> write_PosInfo(X) end),
    <<
        Vid:64/little,
        VposX:16/little,
        VposY:16/little,
        AposInfos/binary
    >>.

binary_read_MoveInfo(Bin0) ->
    <<
        Vid:64/little,
        VposX:16/little,
        VposY:16/little,
        RestBin0/binary>> = Bin0,
    {VposInfos, Bin1} = read_array(RestBin0, fun(X) -> binary_read_PosInfo(X) end),
    <<
        RestBin1/binary
    >> = Bin1,
    {#pk_MoveInfo{
        id = Vid,
        posX = VposX,
        posY = VposY,
        posInfos = VposInfos
    }, RestBin1, 0}.


write_PlayerMoveInfo(#pk_PlayerMoveInfo{ids = Vids}) ->
    Aids = write_array(Vids, fun(X) -> write_MoveInfo(X) end),
    <<Aids/binary>>.



binary_read_ChangeFlyState(Bin0) ->
    <<VflyState:32/little, RestBin0/binary>> = Bin0,
    {#pk_ChangeFlyState{flyState = VflyState}, RestBin0, 0}.


write_ChangeFlyState_S2C(#pk_ChangeFlyState_S2C{id = Vid, flyState = VflyState}) ->
    <<Vid:64/little, VflyState:32/little>>.



write_MonsterMoveInfo(#pk_MonsterMoveInfo{ids = Vids}) ->
    Aids = write_array(Vids, fun(X) -> write_MoveInfo(X) end),
    <<Aids/binary>>.



write_MonsterStopMove(#pk_MonsterStopMove{
        id = Vid,
        x = Vx,
        y = Vy
    }) ->
    <<
        Vid:64/little,
        Vx:16/little,
        Vy:16/little
    >>.



write_PetMoveInfo(#pk_PetMoveInfo{ids = Vids}) ->
    Aids = write_array(Vids, fun(X) -> write_MoveInfo(X) end),
    <<Aids/binary>>.



write_PetStopMove(#pk_PetStopMove{
        id = Vid,
        x = Vx,
        y = Vy
    }) ->
    <<
        Vid:64/little,
        Vx:16/little,
        Vy:16/little
    >>.



write_ChangeMap(#pk_ChangeMap{
        mapDataID = VmapDataID,
        mapId = VmapId,
        x = Vx,
        y = Vy
    }) ->
    <<
        VmapDataID:32/little,
        VmapId:64/little,
        Vx:16/little,
        Vy:16/little
    >>.

binary_read_ChangeMap(Bin0) ->
    <<
        VmapDataID:32/little,
        VmapId:64/little,
        Vx:16/little,
        Vy:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_ChangeMap{
        mapDataID = VmapDataID,
        mapId = VmapId,
        x = Vx,
        y = Vy
    }, RestBin0, 0}.


write_CollectFail(#pk_CollectFail{}) ->
    <<>>.



binary_read_RequestGM(Bin0) ->
    <<LstrCMD:16/little, VstrCMD:LstrCMD/binary, RestBin0/binary>> = Bin0,
    {#pk_RequestGM{strCMD = VstrCMD}, RestBin0, 0}.


write_PlayerPropertyChangeValue(#pk_PlayerPropertyChangeValue{proType = VproType, value = Vvalue}) ->
    <<VproType:8/little, Vvalue:32/little>>.

binary_read_PlayerPropertyChangeValue(Bin0) ->
    <<VproType:8/little, Vvalue:32/little, RestBin0/binary>> = Bin0,
    {#pk_PlayerPropertyChangeValue{proType = VproType, value = Vvalue}, RestBin0, 0}.


write_PlayerPropertyChanged(#pk_PlayerPropertyChanged{changeValues = VchangeValues}) ->
    AchangeValues = write_array(VchangeValues, fun(X) -> write_PlayerPropertyChangeValue(X) end),
    <<AchangeValues/binary>>.



write_PlayerMoneyChanged(#pk_PlayerMoneyChanged{
        changeReson = VchangeReson,
        moneyType = VmoneyType,
        moneyValue = VmoneyValue
    }) ->
    <<
        VchangeReson:8/little,
        VmoneyType:8/little,
        VmoneyValue:32/little
    >>.



write_PlayerKickOuted(#pk_PlayerKickOuted{reserve = Vreserve}) ->
    <<Vreserve:32/little>>.



write_ActorStateFlagSet(#pk_ActorStateFlagSet{nSetStateFlag = VnSetStateFlag}) ->
    <<VnSetStateFlag:32/little>>.



write_ActorStateFlagSet_Broad(#pk_ActorStateFlagSet_Broad{nActorID = VnActorID, nSetStateFlag = VnSetStateFlag}) ->
    <<VnActorID:64/little, VnSetStateFlag:32/little>>.



write_PlayerSkillInitData(#pk_PlayerSkillInitData{
        nSkillID = VnSkillID,
        nCD = VnCD,
        nActiveBranch1 = VnActiveBranch1,
        nActiveBranch2 = VnActiveBranch2,
        nBindedBranch = VnBindedBranch
    }) ->
    <<
        VnSkillID:16/little,
        VnCD:32/little,
        VnActiveBranch1:16/little,
        VnActiveBranch2:16/little,
        VnBindedBranch:16/little
    >>.

binary_read_PlayerSkillInitData(Bin0) ->
    <<
        VnSkillID:16/little,
        VnCD:32/little,
        VnActiveBranch1:16/little,
        VnActiveBranch2:16/little,
        VnBindedBranch:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_PlayerSkillInitData{
        nSkillID = VnSkillID,
        nCD = VnCD,
        nActiveBranch1 = VnActiveBranch1,
        nActiveBranch2 = VnActiveBranch2,
        nBindedBranch = VnBindedBranch
    }, RestBin0, 0}.


write_PlayerSkillInitInfo(#pk_PlayerSkillInitInfo{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_PlayerSkillInitData(X) end),
    <<Ainfo_list/binary>>.



binary_read_U2GS_StudySkill(Bin0) ->
    <<VnSkillID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_StudySkill{nSkillID = VnSkillID}, RestBin0, 0}.


write_GS2U_StudySkillResult(#pk_GS2U_StudySkillResult{nSkillID = VnSkillID, nResult = VnResult}) ->
    <<VnSkillID:32/little, VnResult:32/little>>.



binary_read_activeBranchID(Bin0) ->
    <<
        VnWhichBranch:8/little,
        VnSkillID:32/little,
        VbranchID:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_activeBranchID{
        nWhichBranch = VnWhichBranch,
        nSkillID = VnSkillID,
        branchID = VbranchID
    }, RestBin0, 0}.


write_activeBranchIDResult(#pk_activeBranchIDResult{
        result = Vresult,
        nSkillID = VnSkillID,
        branckID = VbranckID
    }) ->
    <<
        Vresult:32/little,
        VnSkillID:32/little,
        VbranckID:32/little
    >>.



binary_read_U2GS_AddSkillBranch(Bin0) ->
    <<VnSkillID:32/little, VnBranchID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_AddSkillBranch{nSkillID = VnSkillID, nBranchID = VnBranchID}, RestBin0, 0}.


write_GS2U_AddSkillBranchAck(#pk_GS2U_AddSkillBranchAck{
        result = Vresult,
        nSkillID = VnSkillID,
        nBranchID = VnBranchID
    }) ->
    <<
        Vresult:32/little,
        VnSkillID:32/little,
        VnBranchID:32/little
    >>.



binary_read_U2GS_UseSkillRequest(Bin0) ->
    <<
        VnSkillID:32/little,
        RestBin0/binary>> = Bin0,
    {VnTargetIDList, Bin1} = read_array(RestBin0, fun(X) -> <<X1:64/little, B1/binary>> = X, {X1, B1, 0} end),
    <<
        VnCombatID:32/little,
        RestBin1/binary
    >> = Bin1,
    {#pk_U2GS_UseSkillRequest{
        nSkillID = VnSkillID,
        nTargetIDList = VnTargetIDList,
        nCombatID = VnCombatID
    }, RestBin1, 0}.


write_GS2U_UseSkillToObject(#pk_GS2U_UseSkillToObject{
        nUserActorID = VnUserActorID,
        nSkillID = VnSkillID,
        nTargetActorIDList = VnTargetActorIDList,
        nCombatID = VnCombatID
    }) ->
    AnTargetActorIDList = write_array(VnTargetActorIDList, fun(X) -> <<X:64/little>> end),
    <<
        VnUserActorID:64/little,
        VnSkillID:16/little,
        AnTargetActorIDList/binary,
        VnCombatID:32/little
    >>.



write_GS2U_UseSkillToPos(#pk_GS2U_UseSkillToPos{
        nUserActorID = VnUserActorID,
        nSkillID = VnSkillID,
        x = Vx,
        y = Vy,
        nCombatID = VnCombatID,
        id_list = Vid_list
    }) ->
    Aid_list = write_array(Vid_list, fun(X) -> <<X:64/little>> end),
    <<
        VnUserActorID:64/little,
        VnSkillID:16/little,
        Vx:16/little,
        Vy:16/little,
        VnCombatID:32/little,
        Aid_list/binary
    >>.



write_GS2U_AttackDamage(#pk_GS2U_AttackDamage{
        nDamageTarget = VnDamageTarget,
        nCombatID = VnCombatID,
        nSkillID = VnSkillID,
        nDamageLife = VnDamageLife,
        nTargetLifePer100 = VnTargetLifePer100,
        isBlocked = VisBlocked,
        isCrited = VisCrited
    }) ->
    <<
        VnDamageTarget:64/little,
        VnCombatID:32/little,
        VnSkillID:16/little,
        VnDamageLife:32/little,
        VnTargetLifePer100:8/little,
        VisBlocked:8/little,
        VisCrited:8/little
    >>.



write_GS2U_CharactorDead(#pk_GS2U_CharactorDead{
        nDeadActorID = VnDeadActorID,
        nKiller = VnKiller,
        nCombatNumber = VnCombatNumber
    }) ->
    <<
        VnDeadActorID:64/little,
        VnKiller:64/little,
        VnCombatNumber:32/little
    >>.



write_GS2U_AttackMiss(#pk_GS2U_AttackMiss{
        nActorID = VnActorID,
        nTargetID = VnTargetID,
        nCombatID = VnCombatID
    }) ->
    <<
        VnActorID:64/little,
        VnTargetID:64/little,
        VnCombatID:32/little
    >>.



write_GS2U_AttackDodge(#pk_GS2U_AttackDodge{
        nActorID = VnActorID,
        nTargetID = VnTargetID,
        nCombatID = VnCombatID
    }) ->
    <<
        VnActorID:64/little,
        VnTargetID:64/little,
        VnCombatID:32/little
    >>.



write_GS2U_AttackCrit(#pk_GS2U_AttackCrit{nActorID = VnActorID, nCombatID = VnCombatID}) ->
    <<VnActorID:64/little, VnCombatID:32/little>>.



write_GS2U_AttackBlock(#pk_GS2U_AttackBlock{nActorID = VnActorID, nCombatID = VnCombatID}) ->
    <<VnActorID:64/little, VnCombatID:32/little>>.



write_PlayerAllShortcut(#pk_PlayerAllShortcut{
        index1ID = Vindex1ID,
        index2ID = Vindex2ID,
        index3ID = Vindex3ID,
        index4ID = Vindex4ID,
        index5ID = Vindex5ID,
        index6ID = Vindex6ID,
        index7ID = Vindex7ID,
        index8ID = Vindex8ID,
        index9ID = Vindex9ID,
        index10ID = Vindex10ID,
        index11ID = Vindex11ID,
        index12ID = Vindex12ID
    }) ->
    <<
        Vindex1ID:32/little,
        Vindex2ID:32/little,
        Vindex3ID:32/little,
        Vindex4ID:32/little,
        Vindex5ID:32/little,
        Vindex6ID:32/little,
        Vindex7ID:32/little,
        Vindex8ID:32/little,
        Vindex9ID:32/little,
        Vindex10ID:32/little,
        Vindex11ID:32/little,
        Vindex12ID:32/little
    >>.



binary_read_ShortcutSet(Bin0) ->
    <<Vindex:8/little, Vdata:32/little, RestBin0/binary>> = Bin0,
    {#pk_ShortcutSet{index = Vindex, data = Vdata}, RestBin0, 0}.


write_PlayerEXPChanged(#pk_PlayerEXPChanged{curEXP = VcurEXP, changeReson = VchangeReson}) ->
    <<VcurEXP:32/little, VchangeReson:8/little>>.



write_ActorLifeUpdate(#pk_ActorLifeUpdate{
        nActorID = VnActorID,
        nLife = VnLife,
        nMaxLife = VnMaxLife
    }) ->
    <<
        VnActorID:64/little,
        VnLife:32/little,
        VnMaxLife:32/little
    >>.



write_ActorMoveSpeedUpdate(#pk_ActorMoveSpeedUpdate{nActorID = VnActorID, nSpeed = VnSpeed}) ->
    <<VnActorID:64/little, VnSpeed:32/little>>.



write_PlayerCombatIDInit(#pk_PlayerCombatIDInit{nBeginCombatID = VnBeginCombatID}) ->
    <<VnBeginCombatID:32/little>>.



write_GS2U_CharactorRevived(#pk_GS2U_CharactorRevived{
        nActorID = VnActorID,
        nLife = VnLife,
        nMaxLife = VnMaxLife
    }) ->
    <<
        VnActorID:64/little,
        VnLife:32/little,
        VnMaxLife:32/little
    >>.



binary_read_U2GS_InteractObject(Bin0) ->
    <<VnActorID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_InteractObject{nActorID = VnActorID}, RestBin0, 0}.


binary_read_U2GS_QueryHeroProperty(Bin0) ->
    <<VnReserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryHeroProperty{nReserve = VnReserve}, RestBin0, 0}.


write_CharPropertyData(#pk_CharPropertyData{nPropertyType = VnPropertyType, nValue = VnValue}) ->
    <<VnPropertyType:8/little, VnValue:32/little>>.

binary_read_CharPropertyData(Bin0) ->
    <<VnPropertyType:8/little, VnValue:32/little, RestBin0/binary>> = Bin0,
    {#pk_CharPropertyData{nPropertyType = VnPropertyType, nValue = VnValue}, RestBin0, 0}.


write_GS2U_HeroPropertyResult(#pk_GS2U_HeroPropertyResult{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_CharPropertyData(X) end),
    <<Ainfo_list/binary>>.



write_ItemInfo(#pk_ItemInfo{
        id = Vid,
        owner_type = Vowner_type,
        owner_id = Vowner_id,
        location = Vlocation,
        cell = Vcell,
        amount = Vamount,
        item_data_id = Vitem_data_id,
        param1 = Vparam1,
        param2 = Vparam2,
        binded = Vbinded,
        remain_time = Vremain_time
    }) ->
    <<
        Vid:64/little,
        Vowner_type:8/little,
        Vowner_id:64/little,
        Vlocation:8/little,
        Vcell:16/little,
        Vamount:32/little,
        Vitem_data_id:32/little,
        Vparam1:32/little,
        Vparam2:32/little,
        Vbinded:8/little,
        Vremain_time:32/little
    >>.

binary_read_ItemInfo(Bin0) ->
    <<
        Vid:64/little,
        Vowner_type:8/little,
        Vowner_id:64/little,
        Vlocation:8/little,
        Vcell:16/little,
        Vamount:32/little,
        Vitem_data_id:32/little,
        Vparam1:32/little,
        Vparam2:32/little,
        Vbinded:8/little,
        Vremain_time:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_ItemInfo{
        id = Vid,
        owner_type = Vowner_type,
        owner_id = Vowner_id,
        location = Vlocation,
        cell = Vcell,
        amount = Vamount,
        item_data_id = Vitem_data_id,
        param1 = Vparam1,
        param2 = Vparam2,
        binded = Vbinded,
        remain_time = Vremain_time
    }, RestBin0, 0}.


write_PlayerBagInit(#pk_PlayerBagInit{items = Vitems}) ->
    Aitems = write_array(Vitems, fun(X) -> write_ItemInfo(X) end),
    <<Aitems/binary>>.



write_PlayerGetItem(#pk_PlayerGetItem{item_info = Vitem_info}) ->
    Aitem_info = write_ItemInfo(Vitem_info),
    <<Aitem_info/binary>>.



write_PlayerDestroyItem(#pk_PlayerDestroyItem{itemDBID = VitemDBID, reson = Vreson}) ->
    <<VitemDBID:64/little, Vreson:8/little>>.



write_PlayerItemLocationCellChanged(#pk_PlayerItemLocationCellChanged{
        itemDBID = VitemDBID,
        location = Vlocation,
        cell = Vcell
    }) ->
    <<
        VitemDBID:64/little,
        Vlocation:8/little,
        Vcell:16/little
    >>.



binary_read_RequestDestroyItem(Bin0) ->
    <<VitemDBID:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestDestroyItem{itemDBID = VitemDBID}, RestBin0, 0}.


binary_read_RequestGetItem(Bin0) ->
    <<VitemDataID:32/little, Vamount:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestGetItem{itemDataID = VitemDataID, amount = Vamount}, RestBin0, 0}.


write_PlayerItemAmountChanged(#pk_PlayerItemAmountChanged{
        itemDBID = VitemDBID,
        amount = Vamount,
        reson = Vreson
    }) ->
    <<
        VitemDBID:64/little,
        Vamount:32/little,
        Vreson:32/little
    >>.



write_PlayerItemParamChanged(#pk_PlayerItemParamChanged{
        itemDBID = VitemDBID,
        param1 = Vparam1,
        param2 = Vparam2,
        reson = Vreson
    }) ->
    <<
        VitemDBID:64/little,
        Vparam1:32/little,
        Vparam2:32/little,
        Vreson:32/little
    >>.



write_PlayerBagOrderData(#pk_PlayerBagOrderData{
        itemDBID = VitemDBID,
        amount = Vamount,
        cell = Vcell
    }) ->
    <<
        VitemDBID:64/little,
        Vamount:32/little,
        Vcell:32/little
    >>.

binary_read_PlayerBagOrderData(Bin0) ->
    <<
        VitemDBID:64/little,
        Vamount:32/little,
        Vcell:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_PlayerBagOrderData{
        itemDBID = VitemDBID,
        amount = Vamount,
        cell = Vcell
    }, RestBin0, 0}.


binary_read_RequestPlayerBagOrder(Bin0) ->
    <<Vlocation:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestPlayerBagOrder{location = Vlocation}, RestBin0, 0}.


write_PlayerBagOrderResult(#pk_PlayerBagOrderResult{location = Vlocation, cell = Vcell}) ->
    <<Vlocation:32/little, Vcell:32/little>>.



binary_read_PlayerRequestUseItem(Bin0) ->
    <<
        Vlocation:16/little,
        Vcell:16/little,
        VuseCount:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_PlayerRequestUseItem{
        location = Vlocation,
        cell = Vcell,
        useCount = VuseCount
    }, RestBin0, 0}.


write_PlayerUseItemResult(#pk_PlayerUseItemResult{
        location = Vlocation,
        cell = Vcell,
        result = Vresult
    }) ->
    <<
        Vlocation:16/little,
        Vcell:16/little,
        Vresult:32/little
    >>.



binary_read_RequestPlayerBagCellOpen(Bin0) ->
    <<Vcell:32/little, Vlocation:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestPlayerBagCellOpen{cell = Vcell, location = Vlocation}, RestBin0, 0}.


binary_read_RequestChangeStorageBagPassWord(Bin0) ->
    <<
        LoldStorageBagPassWord:16/little, VoldStorageBagPassWord:LoldStorageBagPassWord/binary,
        LnewStorageBagPassWord:16/little, VnewStorageBagPassWord:LnewStorageBagPassWord/binary,
        Vstatus:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_RequestChangeStorageBagPassWord{
        oldStorageBagPassWord = VoldStorageBagPassWord,
        newStorageBagPassWord = VnewStorageBagPassWord,
        status = Vstatus
    }, RestBin0, 0}.


write_PlayerStorageBagPassWordChanged(#pk_PlayerStorageBagPassWordChanged{result = Vresult}) ->
    <<Vresult:32/little>>.



write_PlayerBagCellEnableChanged(#pk_PlayerBagCellEnableChanged{
        cell = Vcell,
        location = Vlocation,
        gold = Vgold,
        item_count = Vitem_count
    }) ->
    <<
        Vcell:32/little,
        Vlocation:32/little,
        Vgold:32/little,
        Vitem_count:32/little
    >>.



binary_read_RequestPlayerBagSellItem(Bin0) ->
    <<Vcell:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestPlayerBagSellItem{cell = Vcell}, RestBin0, 0}.


binary_read_RequestClearTempBag(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestClearTempBag{reserve = Vreserve}, RestBin0, 0}.


binary_read_RequestMoveTempBagItem(Bin0) ->
    <<Vcell:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestMoveTempBagItem{cell = Vcell}, RestBin0, 0}.


binary_read_RequestMoveAllTempBagItem(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestMoveAllTempBagItem{reserve = Vreserve}, RestBin0, 0}.


binary_read_RequestMoveStorageBagItem(Bin0) ->
    <<Vcell:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestMoveStorageBagItem{cell = Vcell}, RestBin0, 0}.


binary_read_RequestMoveBagItemToStorage(Bin0) ->
    <<Vcell:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestMoveBagItemToStorage{cell = Vcell}, RestBin0, 0}.


binary_read_RequestUnlockingStorageBagPassWord(Bin0) ->
    <<VpassWordType:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestUnlockingStorageBagPassWord{passWordType = VpassWordType}, RestBin0, 0}.


binary_read_RequestCancelUnlockingStorageBagPassWord(Bin0) ->
    <<VpassWordType:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestCancelUnlockingStorageBagPassWord{passWordType = VpassWordType}, RestBin0, 0}.


write_PlayerUnlockTimesChanged(#pk_PlayerUnlockTimesChanged{unlockTimes = VunlockTimes}) ->
    <<VunlockTimes:32/little>>.



write_ItemBagCellSetData(#pk_ItemBagCellSetData{
        location = Vlocation,
        cell = Vcell,
        itemDBID = VitemDBID
    }) ->
    <<
        Vlocation:32/little,
        Vcell:32/little,
        VitemDBID:64/little
    >>.

binary_read_ItemBagCellSetData(Bin0) ->
    <<
        Vlocation:32/little,
        Vcell:32/little,
        VitemDBID:64/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_ItemBagCellSetData{
        location = Vlocation,
        cell = Vcell,
        itemDBID = VitemDBID
    }, RestBin0, 0}.


write_ItemBagCellSet(#pk_ItemBagCellSet{cells = Vcells}) ->
    Acells = write_array(Vcells, fun(X) -> write_ItemBagCellSetData(X) end),
    <<Acells/binary>>.



write_NpcStoreItemData(#pk_NpcStoreItemData{
        id = Vid,
        item_id = Vitem_id,
        price = Vprice,
        isbind = Visbind
    }) ->
    <<
        Vid:64/little,
        Vitem_id:32/little,
        Vprice:32/little,
        Visbind:32/little
    >>.

binary_read_NpcStoreItemData(Bin0) ->
    <<
        Vid:64/little,
        Vitem_id:32/little,
        Vprice:32/little,
        Visbind:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_NpcStoreItemData{
        id = Vid,
        item_id = Vitem_id,
        price = Vprice,
        isbind = Visbind
    }, RestBin0, 0}.


binary_read_RequestGetNpcStoreItemList(Bin0) ->
    <<Vstore_id:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestGetNpcStoreItemList{store_id = Vstore_id}, RestBin0, 0}.


write_GetNpcStoreItemListAck(#pk_GetNpcStoreItemListAck{store_id = Vstore_id, itemList = VitemList}) ->
    AitemList = write_array(VitemList, fun(X) -> write_NpcStoreItemData(X) end),
    <<Vstore_id:32/little, AitemList/binary>>.



binary_read_RequestBuyItem(Bin0) ->
    <<
        Vitem_id:32/little,
        Vamount:32/little,
        Vstore_id:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_RequestBuyItem{
        item_id = Vitem_id,
        amount = Vamount,
        store_id = Vstore_id
    }, RestBin0, 0}.


write_BuyItemAck(#pk_BuyItemAck{count = Vcount}) ->
    <<Vcount:32/little>>.



binary_read_RequestSellItem(Bin0) ->
    <<Vitem_cell:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestSellItem{item_cell = Vitem_cell}, RestBin0, 0}.


binary_read_GetNpcStoreBackBuyItemList(Bin0) ->
    <<Vcount:32/little, RestBin0/binary>> = Bin0,
    {#pk_GetNpcStoreBackBuyItemList{count = Vcount}, RestBin0, 0}.


write_GetNpcStoreBackBuyItemListAck(#pk_GetNpcStoreBackBuyItemListAck{itemList = VitemList}) ->
    AitemList = write_array(VitemList, fun(X) -> write_ItemInfo(X) end),
    <<AitemList/binary>>.



binary_read_RequestBackBuyItem(Bin0) ->
    <<Vitem_id:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestBackBuyItem{item_id = Vitem_id}, RestBin0, 0}.


write_PlayerEquipNetData(#pk_PlayerEquipNetData{
        dbID = VdbID,
        nEquip = VnEquip,
        type = Vtype,
        nQuality = VnQuality,
        isEquiped = VisEquiped,
        enhanceLevel = VenhanceLevel,
        property1Type = Vproperty1Type,
        property1FixOrPercent = Vproperty1FixOrPercent,
        property1Value = Vproperty1Value,
        property2Type = Vproperty2Type,
        property2FixOrPercent = Vproperty2FixOrPercent,
        property2Value = Vproperty2Value,
        property3Type = Vproperty3Type,
        property3FixOrPercent = Vproperty3FixOrPercent,
        property3Value = Vproperty3Value,
        property4Type = Vproperty4Type,
        property4FixOrPercent = Vproperty4FixOrPercent,
        property4Value = Vproperty4Value,
        property5Type = Vproperty5Type,
        property5FixOrPercent = Vproperty5FixOrPercent,
        property5Value = Vproperty5Value
    }) ->
    <<
        VdbID:32/little,
        VnEquip:32/little,
        Vtype:8/little,
        VnQuality:8/little,
        VisEquiped:8/little,
        VenhanceLevel:16/little,
        Vproperty1Type:8/little,
        Vproperty1FixOrPercent:8/little,
        Vproperty1Value:32/little,
        Vproperty2Type:8/little,
        Vproperty2FixOrPercent:8/little,
        Vproperty2Value:32/little,
        Vproperty3Type:8/little,
        Vproperty3FixOrPercent:8/little,
        Vproperty3Value:32/little,
        Vproperty4Type:8/little,
        Vproperty4FixOrPercent:8/little,
        Vproperty4Value:32/little,
        Vproperty5Type:8/little,
        Vproperty5FixOrPercent:8/little,
        Vproperty5Value:32/little
    >>.

binary_read_PlayerEquipNetData(Bin0) ->
    <<
        VdbID:32/little,
        VnEquip:32/little,
        Vtype:8/little,
        VnQuality:8/little,
        VisEquiped:8/little,
        VenhanceLevel:16/little,
        Vproperty1Type:8/little,
        Vproperty1FixOrPercent:8/little,
        Vproperty1Value:32/little,
        Vproperty2Type:8/little,
        Vproperty2FixOrPercent:8/little,
        Vproperty2Value:32/little,
        Vproperty3Type:8/little,
        Vproperty3FixOrPercent:8/little,
        Vproperty3Value:32/little,
        Vproperty4Type:8/little,
        Vproperty4FixOrPercent:8/little,
        Vproperty4Value:32/little,
        Vproperty5Type:8/little,
        Vproperty5FixOrPercent:8/little,
        Vproperty5Value:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_PlayerEquipNetData{
        dbID = VdbID,
        nEquip = VnEquip,
        type = Vtype,
        nQuality = VnQuality,
        isEquiped = VisEquiped,
        enhanceLevel = VenhanceLevel,
        property1Type = Vproperty1Type,
        property1FixOrPercent = Vproperty1FixOrPercent,
        property1Value = Vproperty1Value,
        property2Type = Vproperty2Type,
        property2FixOrPercent = Vproperty2FixOrPercent,
        property2Value = Vproperty2Value,
        property3Type = Vproperty3Type,
        property3FixOrPercent = Vproperty3FixOrPercent,
        property3Value = Vproperty3Value,
        property4Type = Vproperty4Type,
        property4FixOrPercent = Vproperty4FixOrPercent,
        property4Value = Vproperty4Value,
        property5Type = Vproperty5Type,
        property5FixOrPercent = Vproperty5FixOrPercent,
        property5Value = Vproperty5Value
    }, RestBin0, 0}.


write_PlayerEquipInit(#pk_PlayerEquipInit{equips = Vequips}) ->
    Aequips = write_array(Vequips, fun(X) -> write_PlayerEquipNetData(X) end),
    <<Aequips/binary>>.



binary_read_RequestPlayerEquipActive(Bin0) ->
    <<Vequip_data_id:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestPlayerEquipActive{equip_data_id = Vequip_data_id}, RestBin0, 0}.


write_PlayerEquipActiveResult(#pk_PlayerEquipActiveResult{equip = Vequip}) ->
    Aequip = write_PlayerEquipNetData(Vequip),
    <<Aequip/binary>>.



binary_read_RequestPlayerEquipPutOn(Bin0) ->
    <<Vequip_dbID:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestPlayerEquipPutOn{equip_dbID = Vequip_dbID}, RestBin0, 0}.


write_PlayerEquipPutOnResult(#pk_PlayerEquipPutOnResult{equip_dbID = Vequip_dbID, equiped = Vequiped}) ->
    <<Vequip_dbID:32/little, Vequiped:8/little>>.



binary_read_RequestQueryPlayerEquip(Bin0) ->
    <<Vplayerid:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestQueryPlayerEquip{playerid = Vplayerid}, RestBin0, 0}.


write_QueryPlayerEquipResult(#pk_QueryPlayerEquipResult{equips = Vequips}) ->
    Aequips = write_array(Vequips, fun(X) -> write_PlayerEquipNetData(X) end),
    <<Aequips/binary>>.



binary_read_StudySkill(Bin0) ->
    <<Vid:32/little, Vlvl:32/little, RestBin0/binary>> = Bin0,
    {#pk_StudySkill{id = Vid, lvl = Vlvl}, RestBin0, 0}.


write_StudyResult(#pk_StudyResult{
        result = Vresult,
        id = Vid,
        lvl = Vlvl
    }) ->
    <<
        Vresult:8/little,
        Vid:32/little,
        Vlvl:32/little
    >>.



binary_read_Reborn(Bin0) ->
    <<Vtype:8/little, RestBin0/binary>> = Bin0,
    {#pk_Reborn{type = Vtype}, RestBin0, 0}.


write_RebornAck(#pk_RebornAck{x = Vx, y = Vy}) ->
    <<Vx:32/little, Vy:32/little>>.



write_Chat2Player(#pk_Chat2Player{
        channel = Vchannel,
        sendID = VsendID,
        receiveID = VreceiveID,
        sendName = VsendName,
        receiveName = VreceiveName,
        content = Vcontent,
        vipLevel = VvipLevel
    }) ->
    LsendName = byte_size(VsendName),
    LreceiveName = byte_size(VreceiveName),
    Lcontent = byte_size(Vcontent),
    <<
        Vchannel:8/little,
        VsendID:64/little,
        VreceiveID:64/little,
        LsendName:16/little, VsendName/binary,
        LreceiveName:16/little, VreceiveName/binary,
        Lcontent:16/little, Vcontent/binary,
        VvipLevel:8/little
    >>.



binary_read_Chat2Server(Bin0) ->
    <<
        Vchannel:8/little,
        VsendID:64/little,
        VreceiveID:64/little,
        LsendName:16/little, VsendName:LsendName/binary,
        LreceiveName:16/little, VreceiveName:LreceiveName/binary,
        Lcontent:16/little, Vcontent:Lcontent/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_Chat2Server{
        channel = Vchannel,
        sendID = VsendID,
        receiveID = VreceiveID,
        sendName = VsendName,
        receiveName = VreceiveName,
        content = Vcontent
    }, RestBin0, 0}.


write_Chat_Error_Result(#pk_Chat_Error_Result{reason = Vreason}) ->
    <<Vreason:32/little>>.



binary_read_RequestSendMail(Bin0) ->
    <<
        VtargetPlayerID:64/little,
        LtargetPlayerName:16/little, VtargetPlayerName:LtargetPlayerName/binary,
        LstrTitle:16/little, VstrTitle:LstrTitle/binary,
        LstrContent:16/little, VstrContent:LstrContent/binary,
        VattachItemDBID1:64/little,
        VattachItem1Cnt:32/little,
        VattachItemDBID2:64/little,
        VattachItem2Cnt:32/little,
        VmoneySend:32/little,
        VmoneyPay:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_RequestSendMail{
        targetPlayerID = VtargetPlayerID,
        targetPlayerName = VtargetPlayerName,
        strTitle = VstrTitle,
        strContent = VstrContent,
        attachItemDBID1 = VattachItemDBID1,
        attachItem1Cnt = VattachItem1Cnt,
        attachItemDBID2 = VattachItemDBID2,
        attachItem2Cnt = VattachItem2Cnt,
        moneySend = VmoneySend,
        moneyPay = VmoneyPay
    }, RestBin0, 0}.


write_RequestSendMailAck(#pk_RequestSendMailAck{result = Vresult}) ->
    <<Vresult:8/little>>.



binary_read_RequestRecvMail(Bin0) ->
    <<VmailID:64/little, VdeleteMail:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestRecvMail{mailID = VmailID, deleteMail = VdeleteMail}, RestBin0, 0}.


binary_read_RequestUnReadMail(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestUnReadMail{playerID = VplayerID}, RestBin0, 0}.


write_RequestUnReadMailAck(#pk_RequestUnReadMailAck{unReadCount = VunReadCount}) ->
    <<VunReadCount:32/little>>.



binary_read_RequestMailList(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestMailList{playerID = VplayerID}, RestBin0, 0}.


write_MailInfo(#pk_MailInfo{
        id = Vid,
        type = Vtype,
        recvPlayerID = VrecvPlayerID,
        isOpen = VisOpen,
        timeOut = VtimeOut,
        senderType = VsenderType,
        senderName = VsenderName,
        title = Vtitle,
        content = Vcontent,
        haveItem = VhaveItem,
        moneySend = VmoneySend,
        moneyPay = VmoneyPay,
        mailTimerType = VmailTimerType,
        mailRecTime = VmailRecTime
    }) ->
    LsenderName = byte_size(VsenderName),
    Ltitle = byte_size(Vtitle),
    Lcontent = byte_size(Vcontent),
    <<
        Vid:64/little,
        Vtype:32/little,
        VrecvPlayerID:64/little,
        VisOpen:32/little,
        VtimeOut:32/little,
        VsenderType:32/little,
        LsenderName:16/little, VsenderName/binary,
        Ltitle:16/little, Vtitle/binary,
        Lcontent:16/little, Vcontent/binary,
        VhaveItem:8/little,
        VmoneySend:32/little,
        VmoneyPay:32/little,
        VmailTimerType:32/little,
        VmailRecTime:32/little
    >>.

binary_read_MailInfo(Bin0) ->
    <<
        Vid:64/little,
        Vtype:32/little,
        VrecvPlayerID:64/little,
        VisOpen:32/little,
        VtimeOut:32/little,
        VsenderType:32/little,
        LsenderName:16/little, VsenderName:LsenderName/binary,
        Ltitle:16/little, Vtitle:Ltitle/binary,
        Lcontent:16/little, Vcontent:Lcontent/binary,
        VhaveItem:8/little,
        VmoneySend:32/little,
        VmoneyPay:32/little,
        VmailTimerType:32/little,
        VmailRecTime:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_MailInfo{
        id = Vid,
        type = Vtype,
        recvPlayerID = VrecvPlayerID,
        isOpen = VisOpen,
        timeOut = VtimeOut,
        senderType = VsenderType,
        senderName = VsenderName,
        title = Vtitle,
        content = Vcontent,
        haveItem = VhaveItem,
        moneySend = VmoneySend,
        moneyPay = VmoneyPay,
        mailTimerType = VmailTimerType,
        mailRecTime = VmailRecTime
    }, RestBin0, 0}.


write_RequestMailListAck(#pk_RequestMailListAck{mailList = VmailList}) ->
    AmailList = write_array(VmailList, fun(X) -> write_MailInfo(X) end),
    <<AmailList/binary>>.



binary_read_RequestMailItemInfo(Bin0) ->
    <<VmailID:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestMailItemInfo{mailID = VmailID}, RestBin0, 0}.


write_RequestMailItemInfoAck(#pk_RequestMailItemInfoAck{mailID = VmailID, mailItem = VmailItem}) ->
    AmailItem = write_array(VmailItem, fun(X) -> write_ItemInfo(X) end),
    <<VmailID:64/little, AmailItem/binary>>.



binary_read_RequestAcceptMailItem(Bin0) ->
    <<VmailID:64/little, VisDeleteMail:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestAcceptMailItem{mailID = VmailID, isDeleteMail = VisDeleteMail}, RestBin0, 0}.


write_RequestAcceptMailItemAck(#pk_RequestAcceptMailItemAck{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_MailReadNotice(Bin0) ->
    <<VmailID:64/little, RestBin0/binary>> = Bin0,
    {#pk_MailReadNotice{mailID = VmailID}, RestBin0, 0}.


binary_read_RequestDeleteMail(Bin0) ->
    <<VmailID:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestDeleteMail{mailID = VmailID}, RestBin0, 0}.


write_InformNewMail(#pk_InformNewMail{}) ->
    <<>>.



binary_read_RequestDeleteReadMail(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {VreadMailID, Bin1} = read_array(RestBin0, fun(X) -> <<X1:64/little, B1/binary>> = X, {X1, B1, 0} end),
    <<RestBin1/binary>> = Bin1,
    {#pk_RequestDeleteReadMail{readMailID = VreadMailID}, RestBin1, 0}.


binary_read_RequestSystemMail(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_RequestSystemMail{}, RestBin0, 0}.


binary_read_U2GS_RequestLogin(Bin0) ->
    <<
        VuserID:64/little,
        Lidentity:16/little, Videntity:Lidentity/binary,
        VprotocolVer:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_RequestLogin{
        userID = VuserID,
        identity = Videntity,
        protocolVer = VprotocolVer
    }, RestBin0, 0}.


binary_read_U2GS_SelPlayerEnterGame(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_SelPlayerEnterGame{playerID = VplayerID}, RestBin0, 0}.


binary_read_U2GS_RequestCreatePlayer(Bin0) ->
    <<
        Lname:16/little, Vname:Lname/binary,
        Vcamp:8/little,
        VclassValue:8/little,
        Vsex:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_RequestCreatePlayer{
        name = Vname,
        camp = Vcamp,
        classValue = VclassValue,
        sex = Vsex
    }, RestBin0, 0}.


binary_read_U2GS_RequestDeletePlayer(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestDeletePlayer{playerID = VplayerID}, RestBin0, 0}.


write_GS2U_LoginResult(#pk_GS2U_LoginResult{result = Vresult}) ->
    <<Vresult:32/little>>.



write_GS2U_SelPlayerResult(#pk_GS2U_SelPlayerResult{result = Vresult}) ->
    <<Vresult:32/little>>.



write_UserPlayerData(#pk_UserPlayerData{
        playerID = VplayerID,
        name = Vname,
        level = Vlevel,
        classValue = VclassValue,
        sex = Vsex,
        faction = Vfaction
    }) ->
    Lname = byte_size(Vname),
    <<
        VplayerID:64/little,
        Lname:16/little, Vname/binary,
        Vlevel:32/little,
        VclassValue:8/little,
        Vsex:8/little,
        Vfaction:8/little
    >>.

binary_read_UserPlayerData(Bin0) ->
    <<
        VplayerID:64/little,
        Lname:16/little, Vname:Lname/binary,
        Vlevel:32/little,
        VclassValue:8/little,
        Vsex:8/little,
        Vfaction:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_UserPlayerData{
        playerID = VplayerID,
        name = Vname,
        level = Vlevel,
        classValue = VclassValue,
        sex = Vsex,
        faction = Vfaction
    }, RestBin0, 0}.


write_GS2U_UserPlayerList(#pk_GS2U_UserPlayerList{info = Vinfo}) ->
    Ainfo = write_array(Vinfo, fun(X) -> write_UserPlayerData(X) end),
    <<Ainfo/binary>>.



write_GS2U_CreatePlayerResult(#pk_GS2U_CreatePlayerResult{errorCode = VerrorCode}) ->
    <<VerrorCode:32/little>>.



write_GS2U_DeletePlayerResult(#pk_GS2U_DeletePlayerResult{playerID = VplayerID, errorCode = VerrorCode}) ->
    <<VplayerID:64/little, VerrorCode:32/little>>.



binary_read_ConSales_GroundingItem(Bin0) ->
    <<
        VdbId:64/little,
        Vcount:32/little,
        Vmoney:32/little,
        VtimeType,:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_ConSales_GroundingItem{
        dbId = VdbId,
        count = Vcount,
        money = Vmoney,
        timeType, = VtimeType,
    }, RestBin0, 0}.


write_ConSales_GroundingItem_Result(#pk_ConSales_GroundingItem_Result{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_ConSales_TakeDown(Bin0) ->
    <<VconSalesId:64/little, RestBin0/binary>> = Bin0,
    {#pk_ConSales_TakeDown{conSalesId = VconSalesId}, RestBin0, 0}.


write_ConSales_TakeDown_Result(#pk_ConSales_TakeDown_Result{
        allTakeDown = VallTakeDown,
        result = Vresult,
        protectTime = VprotectTime
    }) ->
    <<
        VallTakeDown:32/little,
        Vresult:32/little,
        VprotectTime:32/little
    >>.



binary_read_ConSales_BuyItem(Bin0) ->
    <<VconSalesOderId:64/little, RestBin0/binary>> = Bin0,
    {#pk_ConSales_BuyItem{conSalesOderId = VconSalesOderId}, RestBin0, 0}.


write_ConSales_BuyItem_Result(#pk_ConSales_BuyItem_Result{result = Vresult}) ->
    <<Vresult:8/little>>.



binary_read_ConSales_FindItems(Bin0) ->
    <<
        VoffsetCount:32/little,
        VignoreOption:8/little,
        Vtype:8/little,
        VdetType:8/little,
        VlevelMin:32/little,
        VlevelMax:32/little,
        Vocc:32/little,
        Vquality:32/little,
        VidLimit:32/little,
        RestBin0/binary>> = Bin0,
    {VidList, Bin1} = read_array(RestBin0, fun(X) -> <<X1:32/little, B1/binary>> = X, {X1, B1, 0} end),
    <<
        RestBin1/binary
    >> = Bin1,
    {#pk_ConSales_FindItems{
        offsetCount = VoffsetCount,
        ignoreOption = VignoreOption,
        type = Vtype,
        detType = VdetType,
        levelMin = VlevelMin,
        levelMax = VlevelMax,
        occ = Vocc,
        quality = Vquality,
        idLimit = VidLimit,
        idList = VidList
    }, RestBin1, 0}.


write_ConSalesItem(#pk_ConSalesItem{
        conSalesId = VconSalesId,
        conSalesMoney = VconSalesMoney,
        groundingTime = VgroundingTime,
        timeType = VtimeType,
        playerId = VplayerId,
        playerName = VplayerName,
        itemDBId = VitemDBId,
        itemId = VitemId,
        itemCount = VitemCount,
        itemType = VitemType,
        itemQuality = VitemQuality,
        itemLevel = VitemLevel,
        itemOcc = VitemOcc
    }) ->
    LplayerName = byte_size(VplayerName),
    <<
        VconSalesId:64/little,
        VconSalesMoney:32/little,
        VgroundingTime:32/little,
        VtimeType:32/little,
        VplayerId:32/little,
        LplayerName:16/little, VplayerName/binary,
        VitemDBId:32/little,
        VitemId:32/little,
        VitemCount:32/little,
        VitemType:32/little,
        VitemQuality:32/little,
        VitemLevel:32/little,
        VitemOcc:32/little
    >>.

binary_read_ConSalesItem(Bin0) ->
    <<
        VconSalesId:64/little,
        VconSalesMoney:32/little,
        VgroundingTime:32/little,
        VtimeType:32/little,
        VplayerId:32/little,
        LplayerName:16/little, VplayerName:LplayerName/binary,
        VitemDBId:32/little,
        VitemId:32/little,
        VitemCount:32/little,
        VitemType:32/little,
        VitemQuality:32/little,
        VitemLevel:32/little,
        VitemOcc:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_ConSalesItem{
        conSalesId = VconSalesId,
        conSalesMoney = VconSalesMoney,
        groundingTime = VgroundingTime,
        timeType = VtimeType,
        playerId = VplayerId,
        playerName = VplayerName,
        itemDBId = VitemDBId,
        itemId = VitemId,
        itemCount = VitemCount,
        itemType = VitemType,
        itemQuality = VitemQuality,
        itemLevel = VitemLevel,
        itemOcc = VitemOcc
    }, RestBin0, 0}.


write_ConSales_FindItems_Result(#pk_ConSales_FindItems_Result{
        result = Vresult,
        allCount = VallCount,
        page = Vpage,
        itemList = VitemList
    }) ->
    AitemList = write_array(VitemList, fun(X) -> write_ConSalesItem(X) end),
    <<
        Vresult:32/little,
        VallCount:32/little,
        Vpage:32/little,
        AitemList/binary
    >>.



binary_read_ConSales_TrunPage(Bin0) ->
    <<Vmode:32/little, RestBin0/binary>> = Bin0,
    {#pk_ConSales_TrunPage{mode = Vmode}, RestBin0, 0}.


binary_read_ConSales_Close(Bin0) ->
    <<Vn:32/little, RestBin0/binary>> = Bin0,
    {#pk_ConSales_Close{n = Vn}, RestBin0, 0}.


binary_read_ConSales_GetSelfSell(Bin0) ->
    <<Vn:32/little, RestBin0/binary>> = Bin0,
    {#pk_ConSales_GetSelfSell{n = Vn}, RestBin0, 0}.


write_ConSales_GetSelfSell_Result(#pk_ConSales_GetSelfSell_Result{itemList = VitemList}) ->
    AitemList = write_array(VitemList, fun(X) -> write_ConSalesItem(X) end),
    <<AitemList/binary>>.



write_TradeAsk(#pk_TradeAsk{playerID = VplayerID, playerName = VplayerName}) ->
    LplayerName = byte_size(VplayerName),
    <<VplayerID:64/little, LplayerName:16/little, VplayerName/binary>>.

binary_read_TradeAsk(Bin0) ->
    <<VplayerID:64/little, LplayerName:16/little, VplayerName:LplayerName/binary, RestBin0/binary>> = Bin0,
    {#pk_TradeAsk{playerID = VplayerID, playerName = VplayerName}, RestBin0, 0}.


write_TradeAskResult(#pk_TradeAskResult{
        playerID = VplayerID,
        playerName = VplayerName,
        result = Vresult
    }) ->
    LplayerName = byte_size(VplayerName),
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName/binary,
        Vresult:8/little
    >>.

binary_read_TradeAskResult(Bin0) ->
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName:LplayerName/binary,
        Vresult:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_TradeAskResult{
        playerID = VplayerID,
        playerName = VplayerName,
        result = Vresult
    }, RestBin0, 0}.


write_CreateTrade(#pk_CreateTrade{
        playerID = VplayerID,
        playerName = VplayerName,
        result = Vresult
    }) ->
    LplayerName = byte_size(VplayerName),
    <<
        VplayerID:64/little,
        LplayerName:16/little, VplayerName/binary,
        Vresult:8/little
    >>.



binary_read_TradeInputItem_C2S(Bin0) ->
    <<
        Vcell:32/little,
        VitemDBID:64/little,
        Vcount:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_TradeInputItem_C2S{
        cell = Vcell,
        itemDBID = VitemDBID,
        count = Vcount
    }, RestBin0, 0}.


write_TradeInputItemResult_S2C(#pk_TradeInputItemResult_S2C{
        itemDBID = VitemDBID,
        item_data_id = Vitem_data_id,
        count = Vcount,
        cell = Vcell,
        result = Vresult
    }) ->
    <<
        VitemDBID:64/little,
        Vitem_data_id:32/little,
        Vcount:32/little,
        Vcell:32/little,
        Vresult:8/little
    >>.



write_TradeInputItem_S2C(#pk_TradeInputItem_S2C{
        itemDBID = VitemDBID,
        item_data_id = Vitem_data_id,
        count = Vcount
    }) ->
    <<
        VitemDBID:64/little,
        Vitem_data_id:32/little,
        Vcount:32/little
    >>.



binary_read_TradeTakeOutItem_C2S(Bin0) ->
    <<VitemDBID:64/little, RestBin0/binary>> = Bin0,
    {#pk_TradeTakeOutItem_C2S{itemDBID = VitemDBID}, RestBin0, 0}.


write_TradeTakeOutItemResult_S2C(#pk_TradeTakeOutItemResult_S2C{
        cell = Vcell,
        itemDBID = VitemDBID,
        result = Vresult
    }) ->
    <<
        Vcell:32/little,
        VitemDBID:64/little,
        Vresult:8/little
    >>.



write_TradeTakeOutItem_S2C(#pk_TradeTakeOutItem_S2C{itemDBID = VitemDBID}) ->
    <<VitemDBID:64/little>>.



binary_read_TradeChangeMoney_C2S(Bin0) ->
    <<Vmoney:32/little, RestBin0/binary>> = Bin0,
    {#pk_TradeChangeMoney_C2S{money = Vmoney}, RestBin0, 0}.


write_TradeChangeMoneyResult_S2C(#pk_TradeChangeMoneyResult_S2C{money = Vmoney, result = Vresult}) ->
    <<Vmoney:32/little, Vresult:8/little>>.



write_TradeChangeMoney_S2C(#pk_TradeChangeMoney_S2C{money = Vmoney}) ->
    <<Vmoney:32/little>>.



binary_read_TradeLock_C2S(Bin0) ->
    <<Vlock:8/little, RestBin0/binary>> = Bin0,
    {#pk_TradeLock_C2S{lock = Vlock}, RestBin0, 0}.


write_TradeLock_S2C(#pk_TradeLock_S2C{person = Vperson, lock = Vlock}) ->
    <<Vperson:8/little, Vlock:8/little>>.



write_CancelTrade_S2C(#pk_CancelTrade_S2C{person = Vperson, reason = Vreason}) ->
    <<Vperson:8/little, Vreason:8/little>>.



binary_read_CancelTrade_C2S(Bin0) ->
    <<Vreason:8/little, RestBin0/binary>> = Bin0,
    {#pk_CancelTrade_C2S{reason = Vreason}, RestBin0, 0}.


binary_read_TradeAffirm_C2S(Bin0) ->
    <<VbAffrim:32/little, RestBin0/binary>> = Bin0,
    {#pk_TradeAffirm_C2S{bAffrim = VbAffrim}, RestBin0, 0}.


write_TradeAffirm_S2C(#pk_TradeAffirm_S2C{person = Vperson, bAffirm = VbAffirm}) ->
    <<Vperson:8/little, VbAffirm:8/little>>.



write_PetSkill(#pk_PetSkill{id = Vid, coolDownTime = VcoolDownTime}) ->
    <<Vid:64/little, VcoolDownTime:32/little>>.

binary_read_PetSkill(Bin0) ->
    <<Vid:64/little, VcoolDownTime:32/little, RestBin0/binary>> = Bin0,
    {#pk_PetSkill{id = Vid, coolDownTime = VcoolDownTime}, RestBin0, 0}.


write_PetProperty(#pk_PetProperty{
        db_id = Vdb_id,
        data_id = Vdata_id,
        master_id = Vmaster_id,
        level = Vlevel,
        exp = Vexp,
        name = Vname,
        titleId = VtitleId,
        aiState = VaiState,
        showModel = VshowModel,
        exModelId = VexModelId,
        soulLevel = VsoulLevel,
        soulRate = VsoulRate,
        attackGrowUp = VattackGrowUp,
        defGrowUp = VdefGrowUp,
        lifeGrowUp = VlifeGrowUp,
        isWashGrow = VisWashGrow,
        attackGrowUpWash = VattackGrowUpWash,
        defGrowUpWash = VdefGrowUpWash,
        lifeGrowUpWash = VlifeGrowUpWash,
        convertRatio = VconvertRatio,
        exerciseLevel = VexerciseLevel,
        moneyExrciseNum = VmoneyExrciseNum,
        exerciseExp = VexerciseExp,
        maxSkillNum = VmaxSkillNum,
        skills = Vskills,
        life = Vlife,
        maxLife = VmaxLife,
        attack = Vattack,
        def = Vdef,
        crit = Vcrit,
        block = Vblock,
        hit = Vhit,
        dodge = Vdodge,
        tough = Vtough,
        pierce = Vpierce,
        crit_damage_rate = Vcrit_damage_rate,
        attack_speed = Vattack_speed,
        ph_def = Vph_def,
        fire_def = Vfire_def,
        ice_def = Vice_def,
        elec_def = Velec_def,
        poison_def = Vpoison_def,
        coma_def = Vcoma_def,
        hold_def = Vhold_def,
        silent_def = Vsilent_def,
        move_def = Vmove_def,
        atkPowerGrowUp_Max = VatkPowerGrowUp_Max,
        defClassGrowUp_Max = VdefClassGrowUp_Max,
        hpGrowUp_Max = VhpGrowUp_Max,
        benison_Value = Vbenison_Value
    }) ->
    Lname = byte_size(Vname),
    Askills = write_array(Vskills, fun(X) -> write_PetSkill(X) end),
    <<
        Vdb_id:64/little,
        Vdata_id:32/little,
        Vmaster_id:64/little,
        Vlevel:32/little,
        Vexp:32/little,
        Lname:16/little, Vname/binary,
        VtitleId:32/little,
        VaiState:8/little,
        VshowModel:8/little,
        VexModelId:32/little,
        VsoulLevel:32/little,
        VsoulRate:32/little,
        VattackGrowUp:32/little,
        VdefGrowUp:32/little,
        VlifeGrowUp:32/little,
        VisWashGrow:8/little,
        VattackGrowUpWash:32/little,
        VdefGrowUpWash:32/little,
        VlifeGrowUpWash:32/little,
        VconvertRatio:32/little,
        VexerciseLevel:32/little,
        VmoneyExrciseNum:32/little,
        VexerciseExp:32/little,
        VmaxSkillNum:32/little,
        Askills/binary,
        Vlife:32/little,
        VmaxLife:32/little,
        Vattack:32/little,
        Vdef:32/little,
        Vcrit:32/little,
        Vblock:32/little,
        Vhit:32/little,
        Vdodge:32/little,
        Vtough:32/little,
        Vpierce:32/little,
        Vcrit_damage_rate:32/little,
        Vattack_speed:32/little,
        Vph_def:32/little,
        Vfire_def:32/little,
        Vice_def:32/little,
        Velec_def:32/little,
        Vpoison_def:32/little,
        Vcoma_def:32/little,
        Vhold_def:32/little,
        Vsilent_def:32/little,
        Vmove_def:32/little,
        VatkPowerGrowUp_Max:32/little,
        VdefClassGrowUp_Max:32/little,
        VhpGrowUp_Max:32/little,
        Vbenison_Value:32/little
    >>.

binary_read_PetProperty(Bin0) ->
    <<
        Vdb_id:64/little,
        Vdata_id:32/little,
        Vmaster_id:64/little,
        Vlevel:32/little,
        Vexp:32/little,
        Lname:16/little, Vname:Lname/binary,
        VtitleId:32/little,
        VaiState:8/little,
        VshowModel:8/little,
        VexModelId:32/little,
        VsoulLevel:32/little,
        VsoulRate:32/little,
        VattackGrowUp:32/little,
        VdefGrowUp:32/little,
        VlifeGrowUp:32/little,
        VisWashGrow:8/little,
        VattackGrowUpWash:32/little,
        VdefGrowUpWash:32/little,
        VlifeGrowUpWash:32/little,
        VconvertRatio:32/little,
        VexerciseLevel:32/little,
        VmoneyExrciseNum:32/little,
        VexerciseExp:32/little,
        VmaxSkillNum:32/little,
        RestBin0/binary>> = Bin0,
    {Vskills, Bin1} = read_array(RestBin0, fun(X) -> binary_read_PetSkill(X) end),
    <<
        Vlife:32/little,
        VmaxLife:32/little,
        Vattack:32/little,
        Vdef:32/little,
        Vcrit:32/little,
        Vblock:32/little,
        Vhit:32/little,
        Vdodge:32/little,
        Vtough:32/little,
        Vpierce:32/little,
        Vcrit_damage_rate:32/little,
        Vattack_speed:32/little,
        Vph_def:32/little,
        Vfire_def:32/little,
        Vice_def:32/little,
        Velec_def:32/little,
        Vpoison_def:32/little,
        Vcoma_def:32/little,
        Vhold_def:32/little,
        Vsilent_def:32/little,
        Vmove_def:32/little,
        VatkPowerGrowUp_Max:32/little,
        VdefClassGrowUp_Max:32/little,
        VhpGrowUp_Max:32/little,
        Vbenison_Value:32/little,
        RestBin1/binary
    >> = Bin1,
    {#pk_PetProperty{
        db_id = Vdb_id,
        data_id = Vdata_id,
        master_id = Vmaster_id,
        level = Vlevel,
        exp = Vexp,
        name = Vname,
        titleId = VtitleId,
        aiState = VaiState,
        showModel = VshowModel,
        exModelId = VexModelId,
        soulLevel = VsoulLevel,
        soulRate = VsoulRate,
        attackGrowUp = VattackGrowUp,
        defGrowUp = VdefGrowUp,
        lifeGrowUp = VlifeGrowUp,
        isWashGrow = VisWashGrow,
        attackGrowUpWash = VattackGrowUpWash,
        defGrowUpWash = VdefGrowUpWash,
        lifeGrowUpWash = VlifeGrowUpWash,
        convertRatio = VconvertRatio,
        exerciseLevel = VexerciseLevel,
        moneyExrciseNum = VmoneyExrciseNum,
        exerciseExp = VexerciseExp,
        maxSkillNum = VmaxSkillNum,
        skills = Vskills,
        life = Vlife,
        maxLife = VmaxLife,
        attack = Vattack,
        def = Vdef,
        crit = Vcrit,
        block = Vblock,
        hit = Vhit,
        dodge = Vdodge,
        tough = Vtough,
        pierce = Vpierce,
        crit_damage_rate = Vcrit_damage_rate,
        attack_speed = Vattack_speed,
        ph_def = Vph_def,
        fire_def = Vfire_def,
        ice_def = Vice_def,
        elec_def = Velec_def,
        poison_def = Vpoison_def,
        coma_def = Vcoma_def,
        hold_def = Vhold_def,
        silent_def = Vsilent_def,
        move_def = Vmove_def,
        atkPowerGrowUp_Max = VatkPowerGrowUp_Max,
        defClassGrowUp_Max = VdefClassGrowUp_Max,
        hpGrowUp_Max = VhpGrowUp_Max,
        benison_Value = Vbenison_Value
    }, RestBin1, 0}.


write_PlayerPetInfo(#pk_PlayerPetInfo{petSkillBag = VpetSkillBag, petInfos = VpetInfos}) ->
    ApetSkillBag = write_array(VpetSkillBag, fun(X) -> <<X:32/little>> end),
    ApetInfos = write_array(VpetInfos, fun(X) -> write_PetProperty(X) end),
    <<ApetSkillBag/binary, ApetInfos/binary>>.



write_UpdatePetProerty(#pk_UpdatePetProerty{petInfo = VpetInfo}) ->
    ApetInfo = write_PetProperty(VpetInfo),
    <<ApetInfo/binary>>.



write_DelPet(#pk_DelPet{petId = VpetId}) ->
    <<VpetId:64/little>>.



binary_read_PetOutFight(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetOutFight{petId = VpetId}, RestBin0, 0}.


write_PetOutFight_Result(#pk_PetOutFight_Result{result = Vresult, petId = VpetId}) ->
    <<Vresult:8/little, VpetId:64/little>>.



binary_read_PetTakeRest(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetTakeRest{petId = VpetId}, RestBin0, 0}.


write_PetTakeRest_Result(#pk_PetTakeRest_Result{result = Vresult, petId = VpetId}) ->
    <<Vresult:8/little, VpetId:64/little>>.



binary_read_PetFreeCaptiveAnimals(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetFreeCaptiveAnimals{petId = VpetId}, RestBin0, 0}.


write_PetFreeCaptiveAnimals_Result(#pk_PetFreeCaptiveAnimals_Result{result = Vresult, petId = VpetId}) ->
    <<Vresult:8/little, VpetId:64/little>>.



binary_read_PetCompoundModel(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetCompoundModel{petId = VpetId}, RestBin0, 0}.


write_PetCompoundModel_Result(#pk_PetCompoundModel_Result{result = Vresult, petId = VpetId}) ->
    <<Vresult:8/little, VpetId:64/little>>.



binary_read_PetWashGrowUpValue(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetWashGrowUpValue{petId = VpetId}, RestBin0, 0}.


write_PetWashGrowUpValue_Result(#pk_PetWashGrowUpValue_Result{
        result = Vresult,
        petId = VpetId,
        attackGrowUp = VattackGrowUp,
        defGrowUp = VdefGrowUp,
        lifeGrowUp = VlifeGrowUp
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        VattackGrowUp:32/little,
        VdefGrowUp:32/little,
        VlifeGrowUp:32/little
    >>.



binary_read_PetReplaceGrowUpValue(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetReplaceGrowUpValue{petId = VpetId}, RestBin0, 0}.


write_PetReplaceGrowUpValue_Result(#pk_PetReplaceGrowUpValue_Result{result = Vresult, petId = VpetId}) ->
    <<Vresult:8/little, VpetId:64/little>>.



binary_read_PetIntensifySoul(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetIntensifySoul{petId = VpetId}, RestBin0, 0}.


write_PetIntensifySoul_Result(#pk_PetIntensifySoul_Result{
        result = Vresult,
        petId = VpetId,
        soulLevel = VsoulLevel,
        soulRate = VsoulRate,
        benison_Value = Vbenison_Value
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        VsoulLevel:32/little,
        VsoulRate:32/little,
        Vbenison_Value:32/little
    >>.



binary_read_PetOneKeyIntensifySoul(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetOneKeyIntensifySoul{petId = VpetId}, RestBin0, 0}.


write_PetOneKeyIntensifySoul_Result(#pk_PetOneKeyIntensifySoul_Result{
        petId = VpetId,
        result = Vresult,
        itemCount = VitemCount,
        money = Vmoney
    }) ->
    <<
        VpetId:64/little,
        Vresult:8/little,
        VitemCount:32/little,
        Vmoney:32/little
    >>.



binary_read_PetFuse(Bin0) ->
    <<VpetSrcId:64/little, VpetDestId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetFuse{petSrcId = VpetSrcId, petDestId = VpetDestId}, RestBin0, 0}.


write_PetFuse_Result(#pk_PetFuse_Result{
        result = Vresult,
        petSrcId = VpetSrcId,
        petDestId = VpetDestId
    }) ->
    <<
        Vresult:8/little,
        VpetSrcId:64/little,
        VpetDestId:64/little
    >>.



write_PetJumpTo(#pk_PetJumpTo{
        petId = VpetId,
        x = Vx,
        y = Vy
    }) ->
    <<
        VpetId:64/little,
        Vx:32/little,
        Vy:32/little
    >>.



write_ActorSetPos(#pk_ActorSetPos{
        actorId = VactorId,
        x = Vx,
        y = Vy
    }) ->
    <<
        VactorId:64/little,
        Vx:32/little,
        Vy:32/little
    >>.



write_PetTakeBack(#pk_PetTakeBack{petId = VpetId}) ->
    <<VpetId:64/little>>.



write_ChangePetAIState(#pk_ChangePetAIState{state = Vstate}) ->
    <<Vstate:8/little>>.

binary_read_ChangePetAIState(Bin0) ->
    <<Vstate:8/little, RestBin0/binary>> = Bin0,
    {#pk_ChangePetAIState{state = Vstate}, RestBin0, 0}.


write_PetExpChanged(#pk_PetExpChanged{
        petId = VpetId,
        curExp = VcurExp,
        reason = Vreason
    }) ->
    <<
        VpetId:64/little,
        VcurExp:32/little,
        Vreason:8/little
    >>.



binary_read_PetLearnSkill(Bin0) ->
    <<VpetId:64/little, VskillId:32/little, RestBin0/binary>> = Bin0,
    {#pk_PetLearnSkill{petId = VpetId, skillId = VskillId}, RestBin0, 0}.


write_PetLearnSkill_Result(#pk_PetLearnSkill_Result{
        result = Vresult,
        petId = VpetId,
        oldSkillId = VoldSkillId,
        newSkillId = VnewSkillId
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        VoldSkillId:32/little,
        VnewSkillId:32/little
    >>.



binary_read_PetDelSkill(Bin0) ->
    <<VpetId:64/little, VskillId:32/little, RestBin0/binary>> = Bin0,
    {#pk_PetDelSkill{petId = VpetId, skillId = VskillId}, RestBin0, 0}.


write_PetDelSkill_Result(#pk_PetDelSkill_Result{
        result = Vresult,
        petId = VpetId,
        skillid = Vskillid
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        Vskillid:32/little
    >>.



binary_read_PetUnLockSkillCell(Bin0) ->
    <<VpetId:64/little, RestBin0/binary>> = Bin0,
    {#pk_PetUnLockSkillCell{petId = VpetId}, RestBin0, 0}.


write_PetUnLoctSkillCell_Result(#pk_PetUnLoctSkillCell_Result{
        result = Vresult,
        petId = VpetId,
        newSkillCellNum = VnewSkillCellNum
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        VnewSkillCellNum:32/little
    >>.



binary_read_PetSkillSealAhs(Bin0) ->
    <<VpetId:64/little, Vskillid:32/little, RestBin0/binary>> = Bin0,
    {#pk_PetSkillSealAhs{petId = VpetId, skillid = Vskillid}, RestBin0, 0}.


write_PetSkillSealAhs_Result(#pk_PetSkillSealAhs_Result{
        result = Vresult,
        petId = VpetId,
        skillid = Vskillid
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        Vskillid:32/little
    >>.



write_PetUpdateSealAhsStore(#pk_PetUpdateSealAhsStore{petSkillBag = VpetSkillBag}) ->
    ApetSkillBag = write_array(VpetSkillBag, fun(X) -> <<X:32/little>> end),
    <<ApetSkillBag/binary>>.



binary_read_PetlearnSealAhsSkill(Bin0) ->
    <<VpetId:64/little, VskillId:32/little, RestBin0/binary>> = Bin0,
    {#pk_PetlearnSealAhsSkill{petId = VpetId, skillId = VskillId}, RestBin0, 0}.


write_PetlearnSealAhsSkill_Result(#pk_PetlearnSealAhsSkill_Result{
        result = Vresult,
        petId = VpetId,
        oldSkillId = VoldSkillId,
        newSkillId = VnewSkillId
    }) ->
    <<
        Vresult:8/little,
        VpetId:64/little,
        VoldSkillId:32/little,
        VnewSkillId:32/little
    >>.



binary_read_RequestGetPlayerEquipEnhanceByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestGetPlayerEquipEnhanceByType{type = Vtype}, RestBin0, 0}.


write_GetPlayerEquipEnhanceByTypeBack(#pk_GetPlayerEquipEnhanceByTypeBack{
        type = Vtype,
        level = Vlevel,
        progress = Vprogress,
        blessValue = VblessValue
    }) ->
    <<
        Vtype:32/little,
        Vlevel:32/little,
        Vprogress:32/little,
        VblessValue:32/little
    >>.



binary_read_RequestEquipEnhanceByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestEquipEnhanceByType{type = Vtype}, RestBin0, 0}.


write_EquipEnhanceByTypeBack(#pk_EquipEnhanceByTypeBack{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_RequestEquipOnceEnhanceByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestEquipOnceEnhanceByType{type = Vtype}, RestBin0, 0}.


write_EquipOnceEnhanceByTypeBack(#pk_EquipOnceEnhanceByTypeBack{
        result = Vresult,
        times = Vtimes,
        itemnumber = Vitemnumber,
        money = Vmoney
    }) ->
    <<
        Vresult:32/little,
        Vtimes:32/little,
        Vitemnumber:32/little,
        Vmoney:32/little
    >>.



binary_read_RequestGetPlayerEquipQualityByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestGetPlayerEquipQualityByType{type = Vtype}, RestBin0, 0}.


write_GetPlayerEquipQualityByTypeBack(#pk_GetPlayerEquipQualityByTypeBack{type = Vtype, quality = Vquality}) ->
    <<Vtype:32/little, Vquality:32/little>>.



binary_read_RequestEquipQualityUPByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestEquipQualityUPByType{type = Vtype}, RestBin0, 0}.


write_EquipQualityUPByTypeBack(#pk_EquipQualityUPByTypeBack{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_RequestEquipOldPropertyByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestEquipOldPropertyByType{type = Vtype}, RestBin0, 0}.


write_GetEquipOldPropertyByType(#pk_GetEquipOldPropertyByType{
        type = Vtype,
        property1Type = Vproperty1Type,
        property1FixOrPercent = Vproperty1FixOrPercent,
        property1Value = Vproperty1Value,
        property2Type = Vproperty2Type,
        property2FixOrPercent = Vproperty2FixOrPercent,
        property2Value = Vproperty2Value,
        property3Type = Vproperty3Type,
        property3FixOrPercent = Vproperty3FixOrPercent,
        property3Value = Vproperty3Value,
        property4Type = Vproperty4Type,
        property4FixOrPercent = Vproperty4FixOrPercent,
        property4Value = Vproperty4Value,
        property5Type = Vproperty5Type,
        property5FixOrPercent = Vproperty5FixOrPercent,
        property5Value = Vproperty5Value
    }) ->
    <<
        Vtype:32/little,
        Vproperty1Type:8/little,
        Vproperty1FixOrPercent:8/little,
        Vproperty1Value:32/little,
        Vproperty2Type:8/little,
        Vproperty2FixOrPercent:8/little,
        Vproperty2Value:32/little,
        Vproperty3Type:8/little,
        Vproperty3FixOrPercent:8/little,
        Vproperty3Value:32/little,
        Vproperty4Type:8/little,
        Vproperty4FixOrPercent:8/little,
        Vproperty4Value:32/little,
        Vproperty5Type:8/little,
        Vproperty5FixOrPercent:8/little,
        Vproperty5Value:32/little
    >>.



binary_read_RequestEquipChangePropertyByType(Bin0) ->
    <<
        Vtype:32/little,
        Vproperty1:8/little,
        Vproperty2:8/little,
        Vproperty3:8/little,
        Vproperty4:8/little,
        Vproperty5:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_RequestEquipChangePropertyByType{
        type = Vtype,
        property1 = Vproperty1,
        property2 = Vproperty2,
        property3 = Vproperty3,
        property4 = Vproperty4,
        property5 = Vproperty5
    }, RestBin0, 0}.


write_GetEquipNewPropertyByType(#pk_GetEquipNewPropertyByType{
        type = Vtype,
        property1Type = Vproperty1Type,
        property1FixOrPercent = Vproperty1FixOrPercent,
        property1Value = Vproperty1Value,
        property2Type = Vproperty2Type,
        property2FixOrPercent = Vproperty2FixOrPercent,
        property2Value = Vproperty2Value,
        property3Type = Vproperty3Type,
        property3FixOrPercent = Vproperty3FixOrPercent,
        property3Value = Vproperty3Value,
        property4Type = Vproperty4Type,
        property4FixOrPercent = Vproperty4FixOrPercent,
        property4Value = Vproperty4Value,
        property5Type = Vproperty5Type,
        property5FixOrPercent = Vproperty5FixOrPercent,
        property5Value = Vproperty5Value
    }) ->
    <<
        Vtype:32/little,
        Vproperty1Type:8/little,
        Vproperty1FixOrPercent:8/little,
        Vproperty1Value:32/little,
        Vproperty2Type:8/little,
        Vproperty2FixOrPercent:8/little,
        Vproperty2Value:32/little,
        Vproperty3Type:8/little,
        Vproperty3FixOrPercent:8/little,
        Vproperty3Value:32/little,
        Vproperty4Type:8/little,
        Vproperty4FixOrPercent:8/little,
        Vproperty4Value:32/little,
        Vproperty5Type:8/little,
        Vproperty5FixOrPercent:8/little,
        Vproperty5Value:32/little
    >>.



binary_read_RequestEquipSaveNewPropertyByType(Bin0) ->
    <<Vtype:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestEquipSaveNewPropertyByType{type = Vtype}, RestBin0, 0}.


write_RequestEquipChangeAddSavePropertyByType(#pk_RequestEquipChangeAddSavePropertyByType{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_U2GS_EnterCopyMapRequest(Bin0) ->
    <<VnpcActorID:64/little, VenterMapID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_EnterCopyMapRequest{npcActorID = VnpcActorID, enterMapID = VenterMapID}, RestBin0, 0}.


write_GS2U_EnterMapResult(#pk_GS2U_EnterMapResult{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_U2GS_QueryMyCopyMapCD(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QueryMyCopyMapCD{reserve = Vreserve}, RestBin0, 0}.


write_MyCopyMapCDInfo(#pk_MyCopyMapCDInfo{
        mapDataID = VmapDataID,
        mapEnteredCount = VmapEnteredCount,
        mapActiveCount = VmapActiveCount
    }) ->
    <<
        VmapDataID:16/little,
        VmapEnteredCount:8/little,
        VmapActiveCount:8/little
    >>.

binary_read_MyCopyMapCDInfo(Bin0) ->
    <<
        VmapDataID:16/little,
        VmapEnteredCount:8/little,
        VmapActiveCount:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_MyCopyMapCDInfo{
        mapDataID = VmapDataID,
        mapEnteredCount = VmapEnteredCount,
        mapActiveCount = VmapActiveCount
    }, RestBin0, 0}.


write_GS2U_MyCopyMapCDInfo(#pk_GS2U_MyCopyMapCDInfo{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_MyCopyMapCDInfo(X) end),
    <<Ainfo_list/binary>>.



write_AddBuff(#pk_AddBuff{
        actor_id = Vactor_id,
        buff_data_id = Vbuff_data_id,
        allValidTime = VallValidTime,
        remainTriggerCount = VremainTriggerCount
    }) ->
    <<
        Vactor_id:64/little,
        Vbuff_data_id:16/little,
        VallValidTime:16/little,
        VremainTriggerCount:8/little
    >>.



write_DelBuff(#pk_DelBuff{actor_id = Vactor_id, buff_data_id = Vbuff_data_id}) ->
    <<Vactor_id:64/little, Vbuff_data_id:16/little>>.



write_UpdateBuff(#pk_UpdateBuff{
        actor_id = Vactor_id,
        buff_data_id = Vbuff_data_id,
        remainTriggerCount = VremainTriggerCount
    }) ->
    <<
        Vactor_id:64/little,
        Vbuff_data_id:16/little,
        VremainTriggerCount:8/little
    >>.



write_HeroBuffList(#pk_HeroBuffList{buffList = VbuffList}) ->
    AbuffList = write_array(VbuffList, fun(X) -> write_ObjectBuff(X) end),
    <<AbuffList/binary>>.



binary_read_U2GS_TransByWorldMap(Bin0) ->
    <<
        VmapDataID:32/little,
        VposX:32/little,
        VposY:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_TransByWorldMap{
        mapDataID = VmapDataID,
        posX = VposX,
        posY = VposY
    }, RestBin0, 0}.


binary_read_U2GS_TransForSameScence(Bin0) ->
    <<
        VmapDataID:32/little,
        VposX:32/little,
        VposY:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_TransForSameScence{
        mapDataID = VmapDataID,
        posX = VposX,
        posY = VposY
    }, RestBin0, 0}.


binary_read_U2GS_FastTeamCopyMapRequest(Bin0) ->
    <<
        VnpcActorID:64/little,
        VmapDataID:32/little,
        VenterOrQuit:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_FastTeamCopyMapRequest{
        npcActorID = VnpcActorID,
        mapDataID = VmapDataID,
        enterOrQuit = VenterOrQuit
    }, RestBin0, 0}.


write_GS2U_FastTeamCopyMapResult(#pk_GS2U_FastTeamCopyMapResult{
        mapDataID = VmapDataID,
        result = Vresult,
        enterOrQuit = VenterOrQuit
    }) ->
    <<
        VmapDataID:32/little,
        Vresult:32/little,
        VenterOrQuit:8/little
    >>.



write_GS2U_TeamCopyMapQuery(#pk_GS2U_TeamCopyMapQuery{
        nReadyEnterMapDataID = VnReadyEnterMapDataID,
        nCurMapID = VnCurMapID,
        nPosX = VnPosX,
        nPosY = VnPosY,
        nDistanceSQ = VnDistanceSQ
    }) ->
    <<
        VnReadyEnterMapDataID:32/little,
        VnCurMapID:32/little,
        VnPosX:32/little,
        VnPosY:32/little,
        VnDistanceSQ:32/little
    >>.



binary_read_U2GS_RestCopyMapRequest(Bin0) ->
    <<VnNpcID:64/little, VnMapDataID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RestCopyMapRequest{nNpcID = VnNpcID, nMapDataID = VnMapDataID}, RestBin0, 0}.


write_GS2U_AddOrRemoveHatred(#pk_GS2U_AddOrRemoveHatred{nActorID = VnActorID, nAddOrRemove = VnAddOrRemove}) ->
    <<VnActorID:64/little, VnAddOrRemove:8/little>>.



binary_read_U2GS_QieCuoInvite(Bin0) ->
    <<VnActorID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QieCuoInvite{nActorID = VnActorID}, RestBin0, 0}.


write_GS2U_QieCuoInviteQuery(#pk_GS2U_QieCuoInviteQuery{nActorID = VnActorID, strName = VstrName}) ->
    LstrName = byte_size(VstrName),
    <<VnActorID:64/little, LstrName:16/little, VstrName/binary>>.



binary_read_U2GS_QieCuoInviteAck(Bin0) ->
    <<VnActorID:64/little, Vagree:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_QieCuoInviteAck{nActorID = VnActorID, agree = Vagree}, RestBin0, 0}.


write_GS2U_QieCuoInviteResult(#pk_GS2U_QieCuoInviteResult{nActorID = VnActorID, result = Vresult}) ->
    <<VnActorID:64/little, Vresult:8/little>>.



write_GS2U_QieCuoResult(#pk_GS2U_QieCuoResult{
        nWinner_ActorID = VnWinner_ActorID,
        strWinner_Name = VstrWinner_Name,
        nLoser_ActorID = VnLoser_ActorID,
        strLoser_Name = VstrLoser_Name,
        reson = Vreson
    }) ->
    LstrWinner_Name = byte_size(VstrWinner_Name),
    LstrLoser_Name = byte_size(VstrLoser_Name),
    <<
        VnWinner_ActorID:64/little,
        LstrWinner_Name:16/little, VstrWinner_Name/binary,
        VnLoser_ActorID:64/little,
        LstrLoser_Name:16/little, VstrLoser_Name/binary,
        Vreson:8/little
    >>.



binary_read_U2GS_PK_KillOpenRequest(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_PK_KillOpenRequest{reserve = Vreserve}, RestBin0, 0}.


write_GS2U_PK_KillOpenResult(#pk_GS2U_PK_KillOpenResult{
        result = Vresult,
        pK_Kill_RemainTime = VpK_Kill_RemainTime,
        pk_Kill_Value = Vpk_Kill_Value
    }) ->
    <<
        Vresult:32/little,
        VpK_Kill_RemainTime:32/little,
        Vpk_Kill_Value:32/little
    >>.



write_GS2U_Player_ChangeEquipResult(#pk_GS2U_Player_ChangeEquipResult{playerID = VplayerID, equipID = VequipID}) ->
    <<VplayerID:64/little, VequipID:32/little>>.



write_SysMessage(#pk_SysMessage{type = Vtype, text = Vtext}) ->
    Ltext = byte_size(Vtext),
    <<Vtype:32/little, Ltext:16/little, Vtext/binary>>.



write_GS2U_AddLifeByItem(#pk_GS2U_AddLifeByItem{
        actorID = VactorID,
        addLife = VaddLife,
        percent = Vpercent
    }) ->
    <<
        VactorID:64/little,
        VaddLife:32/little,
        Vpercent:8/little
    >>.



write_GS2U_AddLifeBySkill(#pk_GS2U_AddLifeBySkill{
        actorID = VactorID,
        addLife = VaddLife,
        percent = Vpercent,
        crite = Vcrite
    }) ->
    <<
        VactorID:64/little,
        VaddLife:32/little,
        Vpercent:8/little,
        Vcrite:8/little
    >>.



write_PlayerItemCDInfo(#pk_PlayerItemCDInfo{
        cdTypeID = VcdTypeID,
        remainTime = VremainTime,
        allTime = VallTime
    }) ->
    <<
        VcdTypeID:8/little,
        VremainTime:32/little,
        VallTime:32/little
    >>.

binary_read_PlayerItemCDInfo(Bin0) ->
    <<
        VcdTypeID:8/little,
        VremainTime:32/little,
        VallTime:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_PlayerItemCDInfo{
        cdTypeID = VcdTypeID,
        remainTime = VremainTime,
        allTime = VallTime
    }, RestBin0, 0}.


write_GS2U_PlayerItemCDInit(#pk_GS2U_PlayerItemCDInit{info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_PlayerItemCDInfo(X) end),
    <<Ainfo_list/binary>>.



write_GS2U_PlayerItemCDUpdate(#pk_GS2U_PlayerItemCDUpdate{info = Vinfo}) ->
    Ainfo = write_PlayerItemCDInfo(Vinfo),
    <<Ainfo/binary>>.



binary_read_U2GS_BloodPoolAddLife(Bin0) ->
    <<VactorID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_BloodPoolAddLife{actorID = VactorID}, RestBin0, 0}.


write_GS2U_ItemDailyCount(#pk_GS2U_ItemDailyCount{remainCount = VremainCount, task_data_id = Vtask_data_id}) ->
    <<VremainCount:32/little, Vtask_data_id:32/little>>.



binary_read_U2GS_GetSigninInfo(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_GetSigninInfo{}, RestBin0, 0}.


write_GS2U_PlayerSigninInfo(#pk_GS2U_PlayerSigninInfo{isAlreadySign = VisAlreadySign, days = Vdays}) ->
    <<VisAlreadySign:8/little, Vdays:8/little>>.



binary_read_U2GS_Signin(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_Signin{}, RestBin0, 0}.


write_GS2U_PlayerSignInResult(#pk_GS2U_PlayerSignInResult{nResult = VnResult, awardDays = VawardDays}) ->
    <<VnResult:32/little, VawardDays:8/little>>.



binary_read_U2GS_LeaveCopyMap(Bin0) ->
    <<Vreserve:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_LeaveCopyMap{reserve = Vreserve}, RestBin0, 0}.


write_PetChangeModel(#pk_PetChangeModel{petId = VpetId, modelID = VmodelID}) ->
    <<VpetId:64/little, VmodelID:32/little>>.



write_PetChangeName(#pk_PetChangeName{petId = VpetId, newName = VnewName}) ->
    LnewName = byte_size(VnewName),
    <<VpetId:64/little, LnewName:16/little, VnewName/binary>>.

binary_read_PetChangeName(Bin0) ->
    <<VpetId:64/little, LnewName:16/little, VnewName:LnewName/binary, RestBin0/binary>> = Bin0,
    {#pk_PetChangeName{petId = VpetId, newName = VnewName}, RestBin0, 0}.


write_PetChangeName_Result(#pk_PetChangeName_Result{
        result = Vresult,
        petId = VpetId,
        newName = VnewName
    }) ->
    LnewName = byte_size(VnewName),
    <<
        Vresult:8/little,
        VpetId:64/little,
        LnewName:16/little, VnewName/binary
    >>.



write_BazzarItem(#pk_BazzarItem{
        db_id = Vdb_id,
        item_id = Vitem_id,
        item_column = Vitem_column,
        gold = Vgold,
        binded_gold = Vbinded_gold,
        remain_count = Vremain_count,
        remain_time = Vremain_time
    }) ->
    <<
        Vdb_id:32/little,
        Vitem_id:16/little,
        Vitem_column:8/little,
        Vgold:16/little,
        Vbinded_gold:16/little,
        Vremain_count:16/little,
        Vremain_time:32/little
    >>.

binary_read_BazzarItem(Bin0) ->
    <<
        Vdb_id:32/little,
        Vitem_id:16/little,
        Vitem_column:8/little,
        Vgold:16/little,
        Vbinded_gold:16/little,
        Vremain_count:16/little,
        Vremain_time:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_BazzarItem{
        db_id = Vdb_id,
        item_id = Vitem_id,
        item_column = Vitem_column,
        gold = Vgold,
        binded_gold = Vbinded_gold,
        remain_count = Vremain_count,
        remain_time = Vremain_time
    }, RestBin0, 0}.


binary_read_BazzarListRequest(Bin0) ->
    <<Vseed:32/little, RestBin0/binary>> = Bin0,
    {#pk_BazzarListRequest{seed = Vseed}, RestBin0, 0}.


write_BazzarPriceItemList(#pk_BazzarPriceItemList{itemList = VitemList}) ->
    AitemList = write_array(VitemList, fun(X) -> write_BazzarItem(X) end),
    <<AitemList/binary>>.



write_BazzarItemList(#pk_BazzarItemList{seed = Vseed, itemList = VitemList}) ->
    AitemList = write_array(VitemList, fun(X) -> write_BazzarItem(X) end),
    <<Vseed:32/little, AitemList/binary>>.



write_BazzarItemUpdate(#pk_BazzarItemUpdate{item = Vitem}) ->
    Aitem = write_BazzarItem(Vitem),
    <<Aitem/binary>>.



binary_read_BazzarBuyRequest(Bin0) ->
    <<
        Vdb_id:32/little,
        VisBindGold:16/little,
        Vcount:16/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_BazzarBuyRequest{
        db_id = Vdb_id,
        isBindGold = VisBindGold,
        count = Vcount
    }, RestBin0, 0}.


write_BazzarBuyResult(#pk_BazzarBuyResult{result = Vresult}) ->
    <<Vresult:8/little>>.



write_PlayerBagCellOpenResult(#pk_PlayerBagCellOpenResult{result = Vresult}) ->
    <<Vresult:8/little>>.



binary_read_U2GS_RemoveSkillBranch(Bin0) ->
    <<VnSkillID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RemoveSkillBranch{nSkillID = VnSkillID}, RestBin0, 0}.


write_GS2U_RemoveSkillBranch(#pk_GS2U_RemoveSkillBranch{result = Vresult, nSkillID = VnSkillID}) ->
    <<Vresult:32/little, VnSkillID:32/little>>.



binary_read_U2GS_PetBloodPoolAddLife(Bin0) ->
    <<Vn:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_PetBloodPoolAddLife{n = Vn}, RestBin0, 0}.


binary_read_U2GS_CopyMapAddActiveCount(Bin0) ->
    <<Vmap_data_id:16/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_CopyMapAddActiveCount{map_data_id = Vmap_data_id}, RestBin0, 0}.


write_U2GS_CopyMapAddActiveCountResult(#pk_U2GS_CopyMapAddActiveCountResult{result = Vresult}) ->
    <<Vresult:16/little>>.



write_GS2U_CurConvoyInfo(#pk_GS2U_CurConvoyInfo{
        isDead = VisDead,
        convoyType = VconvoyType,
        carriageQuality = VcarriageQuality,
        remainTime = VremainTime,
        lowCD = VlowCD,
        highCD = VhighCD,
        freeCnt = VfreeCnt
    }) ->
    <<
        VisDead:8/little,
        VconvoyType:32/little,
        VcarriageQuality:32/little,
        VremainTime:32/little,
        VlowCD:32/little,
        VhighCD:32/little,
        VfreeCnt:32/little
    >>.



binary_read_U2GS_CarriageQualityRefresh(Bin0) ->
    <<
        VisRefreshLegend:32/little,
        VisCostGold:32/little,
        VcurConvoyType:32/little,
        VcurCarriageQuality:32/little,
        VcurTaskID:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_CarriageQualityRefresh{
        isRefreshLegend = VisRefreshLegend,
        isCostGold = VisCostGold,
        curConvoyType = VcurConvoyType,
        curCarriageQuality = VcurCarriageQuality,
        curTaskID = VcurTaskID
    }, RestBin0, 0}.


write_GS2U_CarriageQualityRefreshResult(#pk_GS2U_CarriageQualityRefreshResult{
        retCode = VretCode,
        newConvoyType = VnewConvoyType,
        newCarriageQuality = VnewCarriageQuality,
        freeCnt = VfreeCnt
    }) ->
    <<
        VretCode:32/little,
        VnewConvoyType:32/little,
        VnewCarriageQuality:32/little,
        VfreeCnt:32/little
    >>.



binary_read_U2GS_ConvoyCDRequst(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_ConvoyCDRequst{}, RestBin0, 0}.


write_GS2U_ConvoyCDResult(#pk_GS2U_ConvoyCDResult{retCode = VretCode}) ->
    <<VretCode:8/little>>.



binary_read_U2GS_BeginConvoy(Bin0) ->
    <<
        VnTaskID:32/little,
        VcurConvoyType:32/little,
        VcurCarriageQuality:32/little,
        VnNpcActorID:64/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_BeginConvoy{
        nTaskID = VnTaskID,
        curConvoyType = VcurConvoyType,
        curCarriageQuality = VcurCarriageQuality,
        nNpcActorID = VnNpcActorID
    }, RestBin0, 0}.


write_GS2U_BeginConvoyResult(#pk_GS2U_BeginConvoyResult{
        retCode = VretCode,
        curConvoyType = VcurConvoyType,
        curCarriageQuality = VcurCarriageQuality,
        remainTime = VremainTime,
        lowCD = VlowCD,
        highCD = VhighCD
    }) ->
    <<
        VretCode:32/little,
        VcurConvoyType:32/little,
        VcurCarriageQuality:32/little,
        VremainTime:32/little,
        VlowCD:32/little,
        VhighCD:32/little
    >>.



write_GS2U_FinishConvoyResult(#pk_GS2U_FinishConvoyResult{curConvoyType = VcurConvoyType, curCarriageQuality = VcurCarriageQuality}) ->
    <<VcurConvoyType:32/little, VcurCarriageQuality:32/little>>.



write_GS2U_GiveUpConvoyResult(#pk_GS2U_GiveUpConvoyResult{curConvoyType = VcurConvoyType, curCarriageQuality = VcurCarriageQuality}) ->
    <<VcurConvoyType:32/little, VcurCarriageQuality:32/little>>.



write_GS2U_ConvoyNoticeTimerResult(#pk_GS2U_ConvoyNoticeTimerResult{isDead = VisDead, remainTime = VremainTime}) ->
    <<VisDead:8/little, VremainTime:32/little>>.



write_GS2U_ConvoyState(#pk_GS2U_ConvoyState{
        convoyFlags = VconvoyFlags,
        quality = Vquality,
        actorID = VactorID
    }) ->
    <<
        VconvoyFlags:8/little,
        Vquality:32/little,
        VactorID:64/little
    >>.



write_GSWithU_GameSetMenu(#pk_GSWithU_GameSetMenu{
        joinTeamOnoff = VjoinTeamOnoff,
        inviteGuildOnoff = VinviteGuildOnoff,
        tradeOnoff = VtradeOnoff,
        applicateFriendOnoff = VapplicateFriendOnoff,
        singleKeyOperateOnoff = VsingleKeyOperateOnoff,
        musicPercent = VmusicPercent,
        soundEffectPercent = VsoundEffectPercent,
        shieldEnermyCampPlayer = VshieldEnermyCampPlayer,
        shieldSelfCampPlayer = VshieldSelfCampPlayer,
        shieldOthersPet = VshieldOthersPet,
        shieldOthersName = VshieldOthersName,
        shieldSkillEffect = VshieldSkillEffect,
        dispPlayerLimit = VdispPlayerLimit
    }) ->
    <<
        VjoinTeamOnoff:8/little,
        VinviteGuildOnoff:8/little,
        VtradeOnoff:8/little,
        VapplicateFriendOnoff:8/little,
        VsingleKeyOperateOnoff:8/little,
        VmusicPercent:8/little,
        VsoundEffectPercent:8/little,
        VshieldEnermyCampPlayer:8/little,
        VshieldSelfCampPlayer:8/little,
        VshieldOthersPet:8/little,
        VshieldOthersName:8/little,
        VshieldSkillEffect:8/little,
        VdispPlayerLimit:8/little
    >>.

binary_read_GSWithU_GameSetMenu(Bin0) ->
    <<
        VjoinTeamOnoff:8/little,
        VinviteGuildOnoff:8/little,
        VtradeOnoff:8/little,
        VapplicateFriendOnoff:8/little,
        VsingleKeyOperateOnoff:8/little,
        VmusicPercent:8/little,
        VsoundEffectPercent:8/little,
        VshieldEnermyCampPlayer:8/little,
        VshieldSelfCampPlayer:8/little,
        VshieldOthersPet:8/little,
        VshieldOthersName:8/little,
        VshieldSkillEffect:8/little,
        VdispPlayerLimit:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GSWithU_GameSetMenu{
        joinTeamOnoff = VjoinTeamOnoff,
        inviteGuildOnoff = VinviteGuildOnoff,
        tradeOnoff = VtradeOnoff,
        applicateFriendOnoff = VapplicateFriendOnoff,
        singleKeyOperateOnoff = VsingleKeyOperateOnoff,
        musicPercent = VmusicPercent,
        soundEffectPercent = VsoundEffectPercent,
        shieldEnermyCampPlayer = VshieldEnermyCampPlayer,
        shieldSelfCampPlayer = VshieldSelfCampPlayer,
        shieldOthersPet = VshieldOthersPet,
        shieldOthersName = VshieldOthersName,
        shieldSkillEffect = VshieldSkillEffect,
        dispPlayerLimit = VdispPlayerLimit
    }, RestBin0, 0}.


binary_read_U2GS_RequestRechargeGift(Bin0) ->
    <<Vtype:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestRechargeGift{type = Vtype}, RestBin0, 0}.


write_U2GS_RequestRechargeGift_Ret(#pk_U2GS_RequestRechargeGift_Ret{retcode = Vretcode}) ->
    <<Vretcode:8/little>>.



binary_read_U2GS_RequestPlayerFightingCapacity(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestPlayerFightingCapacity{}, RestBin0, 0}.


write_U2GS_RequestPlayerFightingCapacity_Ret(#pk_U2GS_RequestPlayerFightingCapacity_Ret{fightingcapacity = Vfightingcapacity}) ->
    <<Vfightingcapacity:32/little>>.



binary_read_U2GS_RequestPetFightingCapacity(Bin0) ->
    <<Vpetid:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestPetFightingCapacity{petid = Vpetid}, RestBin0, 0}.


write_U2GS_RequestPetFightingCapacity_Ret(#pk_U2GS_RequestPetFightingCapacity_Ret{fightingcapacity = Vfightingcapacity}) ->
    <<Vfightingcapacity:32/little>>.



binary_read_U2GS_RequestMountFightingCapacity(Bin0) ->
    <<Vmountid:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestMountFightingCapacity{mountid = Vmountid}, RestBin0, 0}.


write_U2GS_RequestMountFightingCapacity_Ret(#pk_U2GS_RequestMountFightingCapacity_Ret{fightingcapacity = Vfightingcapacity}) ->
    <<Vfightingcapacity:32/little>>.



write_VariantData(#pk_VariantData{index = Vindex, value = Vvalue}) ->
    <<Vindex:16/little, Vvalue:32/little>>.

binary_read_VariantData(Bin0) ->
    <<Vindex:16/little, Vvalue:32/little, RestBin0/binary>> = Bin0,
    {#pk_VariantData{index = Vindex, value = Vvalue}, RestBin0, 0}.


write_GS2U_VariantDataSet(#pk_GS2U_VariantDataSet{variant_type = Vvariant_type, info_list = Vinfo_list}) ->
    Ainfo_list = write_array(Vinfo_list, fun(X) -> write_VariantData(X) end),
    <<Vvariant_type:8/little, Ainfo_list/binary>>.



binary_read_U2GS_GetRankList(Bin0) ->
    <<VmapDataID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_GetRankList{mapDataID = VmapDataID}, RestBin0, 0}.


write_GS2U_RankList(#pk_GS2U_RankList{
        mapID = VmapID,
        rankNum = VrankNum,
        name1 = Vname1,
        harm1 = Vharm1,
        name2 = Vname2,
        harm2 = Vharm2,
        name3 = Vname3,
        harm3 = Vharm3,
        name4 = Vname4,
        harm4 = Vharm4,
        name5 = Vname5,
        harm5 = Vharm5,
        name6 = Vname6,
        harm6 = Vharm6,
        name7 = Vname7,
        harm7 = Vharm7,
        name8 = Vname8,
        harm8 = Vharm8,
        name9 = Vname9,
        harm9 = Vharm9,
        name10 = Vname10,
        harm10 = Vharm10
    }) ->
    Lname1 = byte_size(Vname1),
    Lname2 = byte_size(Vname2),
    Lname3 = byte_size(Vname3),
    Lname4 = byte_size(Vname4),
    Lname5 = byte_size(Vname5),
    Lname6 = byte_size(Vname6),
    Lname7 = byte_size(Vname7),
    Lname8 = byte_size(Vname8),
    Lname9 = byte_size(Vname9),
    Lname10 = byte_size(Vname10),
    <<
        VmapID:32/little,
        VrankNum:32/little,
        Lname1:16/little, Vname1/binary,
        Vharm1:32/little,
        Lname2:16/little, Vname2/binary,
        Vharm2:32/little,
        Lname3:16/little, Vname3/binary,
        Vharm3:32/little,
        Lname4:16/little, Vname4/binary,
        Vharm4:32/little,
        Lname5:16/little, Vname5/binary,
        Vharm5:32/little,
        Lname6:16/little, Vname6/binary,
        Vharm6:32/little,
        Lname7:16/little, Vname7/binary,
        Vharm7:32/little,
        Lname8:16/little, Vname8/binary,
        Vharm8:32/little,
        Lname9:16/little, Vname9/binary,
        Vharm9:32/little,
        Lname10:16/little, Vname10/binary,
        Vharm10:32/little
    >>.



write_GS2U_WordBossCmd(#pk_GS2U_WordBossCmd{m_iCmd = Vm_iCmd, m_iParam = Vm_iParam}) ->
    <<Vm_iCmd:32/little, Vm_iParam:32/little>>.



binary_read_U2GS_ChangePlayerName(Bin0) ->
    <<Vid:64/little, Lname:16/little, Vname:Lname/binary, RestBin0/binary>> = Bin0,
    {#pk_U2GS_ChangePlayerName{id = Vid, name = Vname}, RestBin0, 0}.


write_GS2U_ChangePlayerNameResult(#pk_GS2U_ChangePlayerNameResult{retCode = VretCode}) ->
    <<VretCode:32/little>>.



binary_read_U2GS_SetProtectPwd(Bin0) ->
    <<
        Vid:64/little,
        Loldpwd:16/little, Voldpwd:Loldpwd/binary,
        Lpwd:16/little, Vpwd:Lpwd/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_SetProtectPwd{
        id = Vid,
        oldpwd = Voldpwd,
        pwd = Vpwd
    }, RestBin0, 0}.


write_GS2U_SetProtectPwdResult(#pk_GS2U_SetProtectPwdResult{retCode = VretCode}) ->
    <<VretCode:32/little>>.



binary_read_U2GS_HeartBeat(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_HeartBeat{}, RestBin0, 0}.


write_GS2U_CopyProgressUpdate(#pk_GS2U_CopyProgressUpdate{progress = Vprogress}) ->
    <<Vprogress:8/little>>.



binary_read_U2GS_QequestGiveGoldCheck(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_QequestGiveGoldCheck{}, RestBin0, 0}.


binary_read_U2GS_StartGiveGold(Bin0) ->
    <<RestBin0/binary>> = Bin0,
    {#pk_U2GS_StartGiveGold{}, RestBin0, 0}.


write_U2GS_StartGiveGoldResult(#pk_U2GS_StartGiveGoldResult{
        goldType = VgoldType,
        useCnt = VuseCnt,
        exp = Vexp,
        level = Vlevel,
        awardMoney = VawardMoney,
        retCode = VretCode
    }) ->
    <<
        VgoldType:8/little,
        VuseCnt:8/little,
        Vexp:32/little,
        Vlevel:32/little,
        VawardMoney:32/little,
        VretCode:32/little
    >>.



write_U2GS_GoldLineInfo(#pk_U2GS_GoldLineInfo{
        useCnt = VuseCnt,
        exp = Vexp,
        level = Vlevel
    }) ->
    <<
        VuseCnt:8/little,
        Vexp:32/little,
        Vlevel:32/little
    >>.



write_U2GS_GoldResetTimer(#pk_U2GS_GoldResetTimer{useCnt = VuseCnt}) ->
    <<VuseCnt:8/little>>.



write_GS2U_CopyMapSAData(#pk_GS2U_CopyMapSAData{
        map_id = Vmap_id,
        killed_count = Vkilled_count,
        finish_rate = Vfinish_rate,
        cost_time = Vcost_time,
        exp = Vexp,
        money = Vmoney,
        level = Vlevel,
        is_perfect = Vis_perfect
    }) ->
    <<
        Vmap_id:32/little,
        Vkilled_count:32/little,
        Vfinish_rate:8/little,
        Vcost_time:32/little,
        Vexp:32/little,
        Vmoney:32/little,
        Vlevel:8/little,
        Vis_perfect:8/little
    >>.



write_TokenStoreItemData(#pk_TokenStoreItemData{
        id = Vid,
        item_id = Vitem_id,
        price = Vprice,
        tokenType = VtokenType,
        isbind = Visbind
    }) ->
    <<
        Vid:64/little,
        Vitem_id:32/little,
        Vprice:32/little,
        VtokenType:32/little,
        Visbind:32/little
    >>.

binary_read_TokenStoreItemData(Bin0) ->
    <<
        Vid:64/little,
        Vitem_id:32/little,
        Vprice:32/little,
        VtokenType:32/little,
        Visbind:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_TokenStoreItemData{
        id = Vid,
        item_id = Vitem_id,
        price = Vprice,
        tokenType = VtokenType,
        isbind = Visbind
    }, RestBin0, 0}.


write_GetTokenStoreItemListAck(#pk_GetTokenStoreItemListAck{store_id = Vstore_id, itemList = VitemList}) ->
    AitemList = write_array(VitemList, fun(X) -> write_TokenStoreItemData(X) end),
    <<Vstore_id:32/little, AitemList/binary>>.



binary_read_RequestLookPlayer(Bin0) ->
    <<VplayerID:64/little, RestBin0/binary>> = Bin0,
    {#pk_RequestLookPlayer{playerID = VplayerID}, RestBin0, 0}.


write_RequestLookPlayer_Result(#pk_RequestLookPlayer_Result{
        baseInfo = VbaseInfo,
        propertyList = VpropertyList,
        petList = VpetList,
        equipList = VequipList,
        fightCapacity = VfightCapacity
    }) ->
    AbaseInfo = write_PlayerBaseInfo(VbaseInfo),
    ApropertyList = write_array(VpropertyList, fun(X) -> write_CharPropertyData(X) end),
    ApetList = write_array(VpetList, fun(X) -> write_PetProperty(X) end),
    AequipList = write_array(VequipList, fun(X) -> write_PlayerEquipNetData(X) end),
    <<
        AbaseInfo/binary,
        ApropertyList/binary,
        ApetList/binary,
        AequipList/binary,
        VfightCapacity:32/little
    >>.



write_RequestLookPlayerFailed_Result(#pk_RequestLookPlayerFailed_Result{result = Vresult}) ->
    <<Vresult:8/little>>.



binary_read_U2GS_PlayerClientInfo(Bin0) ->
    <<
        Vplayerid:64/little,
        Lplatform:16/little, Vplatform:Lplatform/binary,
        Lmachine:16/little, Vmachine:Lmachine/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_PlayerClientInfo{
        playerid = Vplayerid,
        platform = Vplatform,
        machine = Vmachine
    }, RestBin0, 0}.


binary_read_U2GS_RequestActiveCount(Bin0) ->
    <<Vn:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestActiveCount{n = Vn}, RestBin0, 0}.


write_ActiveCountData(#pk_ActiveCountData{daily_id = Vdaily_id, count = Vcount}) ->
    <<Vdaily_id:32/little, Vcount:32/little>>.

binary_read_ActiveCountData(Bin0) ->
    <<Vdaily_id:32/little, Vcount:32/little, RestBin0/binary>> = Bin0,
    {#pk_ActiveCountData{daily_id = Vdaily_id, count = Vcount}, RestBin0, 0}.


write_GS2U_ActiveCount(#pk_GS2U_ActiveCount{activeValue = VactiveValue, dailyList = VdailyList}) ->
    AdailyList = write_array(VdailyList, fun(X) -> write_ActiveCountData(X) end),
    <<VactiveValue:32/little, AdailyList/binary>>.



binary_read_U2GS_RequestConvertActive(Bin0) ->
    <<Vn:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestConvertActive{n = Vn}, RestBin0, 0}.


write_GS2U_WhetherTransferOldRecharge(#pk_GS2U_WhetherTransferOldRecharge{
        playerID = VplayerID,
        name = Vname,
        rechargeRmb = VrechargeRmb
    }) ->
    Lname = byte_size(Vname),
    <<
        VplayerID:64/little,
        Lname:16/little, Vname/binary,
        VrechargeRmb:32/little
    >>.



binary_read_U2GS_TransferOldRechargeToPlayer(Bin0) ->
    <<VplayerId:64/little, VisTransfer:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_TransferOldRechargeToPlayer{playerId = VplayerId, isTransfer = VisTransfer}, RestBin0, 0}.


write_GS2U_TransferOldRechargeResult(#pk_GS2U_TransferOldRechargeResult{errorCode = VerrorCode}) ->
    <<VerrorCode:32/little>>.



write_PlayerEquipActiveFailReason(#pk_PlayerEquipActiveFailReason{reason = Vreason}) ->
    <<Vreason:32/little>>.



write_PlayerEquipMinLevelChange(#pk_PlayerEquipMinLevelChange{playerid = Vplayerid, minEquipLevel = VminEquipLevel}) ->
    <<Vplayerid:64/little, VminEquipLevel:8/little>>.



binary_read_PlayerImportPassWord(Bin0) ->
    <<LpassWord:16/little, VpassWord:LpassWord/binary, VpassWordType:32/little, RestBin0/binary>> = Bin0,
    {#pk_PlayerImportPassWord{passWord = VpassWord, passWordType = VpassWordType}, RestBin0, 0}.


write_PlayerImportPassWordResult(#pk_PlayerImportPassWordResult{result = Vresult}) ->
    <<Vresult:32/little>>.



write_GS2U_UpdatePlayerGuildInfo(#pk_GS2U_UpdatePlayerGuildInfo{
        player_id = Vplayer_id,
        guild_id = Vguild_id,
        guild_name = Vguild_name,
        guild_rank = Vguild_rank
    }) ->
    Lguild_name = byte_size(Vguild_name),
    <<
        Vplayer_id:64/little,
        Vguild_id:64/little,
        Lguild_name:16/little, Vguild_name/binary,
        Vguild_rank:8/little
    >>.



binary_read_U2GS_RequestBazzarItemPrice(Bin0) ->
    <<Vitem_id:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestBazzarItemPrice{item_id = Vitem_id}, RestBin0, 0}.


write_U2GS_RequestBazzarItemPrice_Result(#pk_U2GS_RequestBazzarItemPrice_Result{item = Vitem}) ->
    Aitem = write_array(Vitem, fun(X) -> write_BazzarItem(X) end),
    <<Aitem/binary>>.



binary_read_RequestChangeGoldPassWord(Bin0) ->
    <<
        LoldGoldPassWord:16/little, VoldGoldPassWord:LoldGoldPassWord/binary,
        LnewGoldPassWord:16/little, VnewGoldPassWord:LnewGoldPassWord/binary,
        Vstatus:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_RequestChangeGoldPassWord{
        oldGoldPassWord = VoldGoldPassWord,
        newGoldPassWord = VnewGoldPassWord,
        status = Vstatus
    }, RestBin0, 0}.


write_PlayerGoldPassWordChanged(#pk_PlayerGoldPassWordChanged{result = Vresult}) ->
    <<Vresult:32/little>>.



write_PlayerImportGoldPassWordResult(#pk_PlayerImportGoldPassWordResult{result = Vresult}) ->
    <<Vresult:32/little>>.



write_PlayerGoldUnlockTimesChanged(#pk_PlayerGoldUnlockTimesChanged{unlockTimes = VunlockTimes}) ->
    <<VunlockTimes:32/little>>.



write_GS2U_LeftSmallMonsterNumber(#pk_GS2U_LeftSmallMonsterNumber{leftMonsterNum = VleftMonsterNum}) ->
    <<VleftMonsterNum:16/little>>.



write_GS2U_VipInfo(#pk_GS2U_VipInfo{
        vipLevel = VvipLevel,
        vipTime = VvipTime,
        vipTimeExpire = VvipTimeExpire,
        vipTimeBuy = VvipTimeBuy
    }) ->
    <<
        VvipLevel:32/little,
        VvipTime:32/little,
        VvipTimeExpire:32/little,
        VvipTimeBuy:32/little
    >>.



write_GS2U_TellMapLineID(#pk_GS2U_TellMapLineID{iLineID = ViLineID}) ->
    <<ViLineID:8/little>>.



binary_read_VIPPlayerOpenVIPStoreRequest(Bin0) ->
    <<Vrequest:32/little, RestBin0/binary>> = Bin0,
    {#pk_VIPPlayerOpenVIPStoreRequest{request = Vrequest}, RestBin0, 0}.


write_VIPPlayerOpenVIPStoreFail(#pk_VIPPlayerOpenVIPStoreFail{fail = Vfail}) ->
    <<Vfail:32/little>>.



write_UpdateVIPLevelInfo(#pk_UpdateVIPLevelInfo{playerID = VplayerID, vipLevel = VvipLevel}) ->
    <<VplayerID:64/little, VvipLevel:8/little>>.



binary_read_ActiveCodeRequest(Bin0) ->
    <<Lactive_code:16/little, Vactive_code:Lactive_code/binary, RestBin0/binary>> = Bin0,
    {#pk_ActiveCodeRequest{active_code = Vactive_code}, RestBin0, 0}.


write_ActiveCodeResult(#pk_ActiveCodeResult{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_U2GS_RequestOutFightPetPropetry(Bin0) ->
    <<Vn:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestOutFightPetPropetry{n = Vn}, RestBin0, 0}.


write_GS2U_RequestOutFightPetPropetryResult(#pk_GS2U_RequestOutFightPetPropetryResult{
        pet_id = Vpet_id,
        attack = Vattack,
        defence = Vdefence,
        hit = Vhit,
        dodge = Vdodge,
        block = Vblock,
        tough = Vtough,
        crit = Vcrit,
        crit_damage_rate = Vcrit_damage_rate,
        attack_speed = Vattack_speed,
        pierce = Vpierce,
        ph_def = Vph_def,
        fire_def = Vfire_def,
        ice_def = Vice_def,
        elec_def = Velec_def,
        poison_def = Vpoison_def,
        coma_def = Vcoma_def,
        hold_def = Vhold_def,
        silent_def = Vsilent_def,
        move_def = Vmove_def,
        max_life = Vmax_life
    }) ->
    <<
        Vpet_id:64/little,
        Vattack:32/little,
        Vdefence:32/little,
        Vhit:32/little,
        Vdodge:32/little,
        Vblock:32/little,
        Vtough:32/little,
        Vcrit:32/little,
        Vcrit_damage_rate:32/little,
        Vattack_speed:32/little,
        Vpierce:32/little,
        Vph_def:32/little,
        Vfire_def:32/little,
        Vice_def:32/little,
        Velec_def:32/little,
        Vpoison_def:32/little,
        Vcoma_def:32/little,
        Vhold_def:32/little,
        Vsilent_def:32/little,
        Vmove_def:32/little,
        Vmax_life:32/little
    >>.



binary_read_PlayerDirMove(Bin0) ->
    <<
        Vpos_x:16/little,
        Vpos_y:16/little,
        Vdir:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_PlayerDirMove{
        pos_x = Vpos_x,
        pos_y = Vpos_y,
        dir = Vdir
    }, RestBin0, 0}.


write_PlayerDirMove_S2C(#pk_PlayerDirMove_S2C{
        player_id = Vplayer_id,
        pos_x = Vpos_x,
        pos_y = Vpos_y,
        dir = Vdir
    }) ->
    <<
        Vplayer_id:64/little,
        Vpos_x:16/little,
        Vpos_y:16/little,
        Vdir:8/little
    >>.



binary_read_U2GS_EnRollCampusBattle(Bin0) ->
    <<VnpcID:64/little, VbattleID:16/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_EnRollCampusBattle{npcID = VnpcID, battleID = VbattleID}, RestBin0, 0}.


write_GSWithU_GameSetMenu_3(#pk_GSWithU_GameSetMenu_3{
        joinTeamOnoff = VjoinTeamOnoff,
        inviteGuildOnoff = VinviteGuildOnoff,
        tradeOnoff = VtradeOnoff,
        applicateFriendOnoff = VapplicateFriendOnoff,
        singleKeyOperateOnoff = VsingleKeyOperateOnoff,
        musicPercent = VmusicPercent,
        soundEffectPercent = VsoundEffectPercent,
        shieldEnermyCampPlayer = VshieldEnermyCampPlayer,
        shieldSelfCampPlayer = VshieldSelfCampPlayer,
        shieldOthersPet = VshieldOthersPet,
        shieldOthersName = VshieldOthersName,
        shieldSkillEffect = VshieldSkillEffect,
        dispPlayerLimit = VdispPlayerLimit,
        shieldOthersSoundEff = VshieldOthersSoundEff,
        noAttackGuildMate = VnoAttackGuildMate,
        reserve1 = Vreserve1,
        reserve2 = Vreserve2
    }) ->
    <<
        VjoinTeamOnoff:8/little,
        VinviteGuildOnoff:8/little,
        VtradeOnoff:8/little,
        VapplicateFriendOnoff:8/little,
        VsingleKeyOperateOnoff:8/little,
        VmusicPercent:8/little,
        VsoundEffectPercent:8/little,
        VshieldEnermyCampPlayer:8/little,
        VshieldSelfCampPlayer:8/little,
        VshieldOthersPet:8/little,
        VshieldOthersName:8/little,
        VshieldSkillEffect:8/little,
        VdispPlayerLimit:8/little,
        VshieldOthersSoundEff:8/little,
        VnoAttackGuildMate:8/little,
        Vreserve1:8/little,
        Vreserve2:8/little
    >>.

binary_read_GSWithU_GameSetMenu_3(Bin0) ->
    <<
        VjoinTeamOnoff:8/little,
        VinviteGuildOnoff:8/little,
        VtradeOnoff:8/little,
        VapplicateFriendOnoff:8/little,
        VsingleKeyOperateOnoff:8/little,
        VmusicPercent:8/little,
        VsoundEffectPercent:8/little,
        VshieldEnermyCampPlayer:8/little,
        VshieldSelfCampPlayer:8/little,
        VshieldOthersPet:8/little,
        VshieldOthersName:8/little,
        VshieldSkillEffect:8/little,
        VdispPlayerLimit:8/little,
        VshieldOthersSoundEff:8/little,
        VnoAttackGuildMate:8/little,
        Vreserve1:8/little,
        Vreserve2:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GSWithU_GameSetMenu_3{
        joinTeamOnoff = VjoinTeamOnoff,
        inviteGuildOnoff = VinviteGuildOnoff,
        tradeOnoff = VtradeOnoff,
        applicateFriendOnoff = VapplicateFriendOnoff,
        singleKeyOperateOnoff = VsingleKeyOperateOnoff,
        musicPercent = VmusicPercent,
        soundEffectPercent = VsoundEffectPercent,
        shieldEnermyCampPlayer = VshieldEnermyCampPlayer,
        shieldSelfCampPlayer = VshieldSelfCampPlayer,
        shieldOthersPet = VshieldOthersPet,
        shieldOthersName = VshieldOthersName,
        shieldSkillEffect = VshieldSkillEffect,
        dispPlayerLimit = VdispPlayerLimit,
        shieldOthersSoundEff = VshieldOthersSoundEff,
        noAttackGuildMate = VnoAttackGuildMate,
        reserve1 = Vreserve1,
        reserve2 = Vreserve2
    }, RestBin0, 0}.


binary_read_StartCompound(Bin0) ->
    <<
        VmakeItemID:32/little,
        VcompounBindedType:8/little,
        VisUseDoubleRule:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_StartCompound{
        makeItemID = VmakeItemID,
        compounBindedType = VcompounBindedType,
        isUseDoubleRule = VisUseDoubleRule
    }, RestBin0, 0}.


write_StartCompoundResult(#pk_StartCompoundResult{retCode = VretCode}) ->
    <<VretCode:8/little>>.



write_CompoundBaseInfo(#pk_CompoundBaseInfo{
        exp = Vexp,
        level = Vlevel,
        makeItemID = VmakeItemID
    }) ->
    <<
        Vexp:32/little,
        Vlevel:32/little,
        VmakeItemID:32/little
    >>.



binary_read_RequestEquipFastUpQuality(Bin0) ->
    <<VequipId:32/little, RestBin0/binary>> = Bin0,
    {#pk_RequestEquipFastUpQuality{equipId = VequipId}, RestBin0, 0}.


write_EquipQualityFastUPByTypeBack(#pk_EquipQualityFastUPByTypeBack{result = Vresult}) ->
    <<Vresult:32/little>>.



binary_read_PlayerTeleportMove(Bin0) ->
    <<Vpos_x:16/little, Vpos_y:16/little, RestBin0/binary>> = Bin0,
    {#pk_PlayerTeleportMove{pos_x = Vpos_x, pos_y = Vpos_y}, RestBin0, 0}.


write_PlayerTeleportMove_S2C(#pk_PlayerTeleportMove_S2C{
        player_id = Vplayer_id,
        pos_x = Vpos_x,
        pos_y = Vpos_y
    }) ->
    <<
        Vplayer_id:64/little,
        Vpos_x:16/little,
        Vpos_y:16/little
    >>.



binary_read_U2GS_leaveCampusBattle(Bin0) ->
    <<VunUsed:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_leaveCampusBattle{unUsed = VunUsed}, RestBin0, 0}.


binary_read_U2GS_LeaveBattleScene(Bin0) ->
    <<VunUsed:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_LeaveBattleScene{unUsed = VunUsed}, RestBin0, 0}.


write_battleResult(#pk_battleResult{
        name = Vname,
        campus = Vcampus,
        killPlayerNum = VkillPlayerNum,
        beenKiiledNum = VbeenKiiledNum,
        playerID = VplayerID,
        harm = Vharm,
        harmed = Vharmed
    }) ->
    Lname = byte_size(Vname),
    <<
        Lname:16/little, Vname/binary,
        Vcampus:8/little,
        VkillPlayerNum:16/little,
        VbeenKiiledNum:16/little,
        VplayerID:64/little,
        Vharm:32/little,
        Vharmed:32/little
    >>.

binary_read_battleResult(Bin0) ->
    <<
        Lname:16/little, Vname:Lname/binary,
        Vcampus:8/little,
        VkillPlayerNum:16/little,
        VbeenKiiledNum:16/little,
        VplayerID:64/little,
        Vharm:32/little,
        Vharmed:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_battleResult{
        name = Vname,
        campus = Vcampus,
        killPlayerNum = VkillPlayerNum,
        beenKiiledNum = VbeenKiiledNum,
        playerID = VplayerID,
        harm = Vharm,
        harmed = Vharmed
    }, RestBin0, 0}.


write_BattleResultList(#pk_BattleResultList{resultList = VresultList}) ->
    AresultList = write_array(VresultList, fun(X) -> write_battleResult(X) end),
    <<AresultList/binary>>.



write_GS2U_BattleEnrollResult(#pk_GS2U_BattleEnrollResult{enrollResult = VenrollResult, mapDataID = VmapDataID}) ->
    <<VenrollResult:8/little, VmapDataID:16/little>>.



binary_read_U2GS_requestEnrollInfo(Bin0) ->
    <<VunUsed:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_requestEnrollInfo{unUsed = VunUsed}, RestBin0, 0}.


write_GS2U_sendEnrollInfo(#pk_GS2U_sendEnrollInfo{enrollxuanzong = Venrollxuanzong, enrolltianji = Venrolltianji}) ->
    <<Venrollxuanzong:16/little, Venrolltianji:16/little>>.



write_GS2U_NowCanEnterBattle(#pk_GS2U_NowCanEnterBattle{battleID = VbattleID}) ->
    <<VbattleID:16/little>>.



binary_read_U2GS_SureEnterBattle(Bin0) ->
    <<VunUsed:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_SureEnterBattle{unUsed = VunUsed}, RestBin0, 0}.


write_GS2U_EnterBattleResult(#pk_GS2U_EnterBattleResult{faileReason = VfaileReason}) ->
    <<VfaileReason:8/little>>.



write_GS2U_BattleScore(#pk_GS2U_BattleScore{xuanzongScore = VxuanzongScore, tianjiScore = VtianjiScore}) ->
    <<VxuanzongScore:16/little, VtianjiScore:16/little>>.



binary_read_U2GS_RequestBattleResultList(Bin0) ->
    <<VunUsed:8/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_RequestBattleResultList{unUsed = VunUsed}, RestBin0, 0}.


write_GS2U_BattleEnd(#pk_GS2U_BattleEnd{unUsed = VunUsed}) ->
    <<VunUsed:8/little>>.



write_GS2U_LeftOpenTime(#pk_GS2U_LeftOpenTime{leftOpenTime = VleftOpenTime}) ->
    <<VleftOpenTime:32/little>>.



write_GS2U_HeartBeatAck(#pk_GS2U_HeartBeatAck{}) ->
    <<>>.



%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_PlayerBaseInfo{} = P) ->
	Bin = write_PlayerBaseInfo(P),
	pack:send(Socket, ?CMD_PlayerBaseInfo, Bin);
send(Socket, #pk_LookInfoPlayerList{} = P) ->
	Bin = write_LookInfoPlayerList(P),
	pack:send(Socket, ?CMD_LookInfoPlayerList, Bin);
send(Socket, #pk_LookInfoPetList{} = P) ->
	Bin = write_LookInfoPetList(P),
	pack:send(Socket, ?CMD_LookInfoPetList, Bin);
send(Socket, #pk_LookInfoMonsterList{} = P) ->
	Bin = write_LookInfoMonsterList(P),
	pack:send(Socket, ?CMD_LookInfoMonsterList, Bin);
send(Socket, #pk_LookInfoNpcList{} = P) ->
	Bin = write_LookInfoNpcList(P),
	pack:send(Socket, ?CMD_LookInfoNpcList, Bin);
send(Socket, #pk_LookInfoObjectList{} = P) ->
	Bin = write_LookInfoObjectList(P),
	pack:send(Socket, ?CMD_LookInfoObjectList, Bin);
send(Socket, #pk_ActorDisapearList{} = P) ->
	Bin = write_ActorDisapearList(P),
	pack:send(Socket, ?CMD_ActorDisapearList, Bin);
send(Socket, #pk_PlayerStopMove_S2C{} = P) ->
	Bin = write_PlayerStopMove_S2C(P),
	pack:send(Socket, ?CMD_PlayerStopMove_S2C, Bin);
send(Socket, #pk_PlayerMoveInfo{} = P) ->
	Bin = write_PlayerMoveInfo(P),
	pack:send(Socket, ?CMD_PlayerMoveInfo, Bin);
send(Socket, #pk_ChangeFlyState_S2C{} = P) ->
	Bin = write_ChangeFlyState_S2C(P),
	pack:send(Socket, ?CMD_ChangeFlyState_S2C, Bin);
send(Socket, #pk_MonsterMoveInfo{} = P) ->
	Bin = write_MonsterMoveInfo(P),
	pack:send(Socket, ?CMD_MonsterMoveInfo, Bin);
send(Socket, #pk_MonsterStopMove{} = P) ->
	Bin = write_MonsterStopMove(P),
	pack:send(Socket, ?CMD_MonsterStopMove, Bin);
send(Socket, #pk_PetMoveInfo{} = P) ->
	Bin = write_PetMoveInfo(P),
	pack:send(Socket, ?CMD_PetMoveInfo, Bin);
send(Socket, #pk_PetStopMove{} = P) ->
	Bin = write_PetStopMove(P),
	pack:send(Socket, ?CMD_PetStopMove, Bin);
send(Socket, #pk_ChangeMap{} = P) ->
	Bin = write_ChangeMap(P),
	pack:send(Socket, ?CMD_ChangeMap, Bin);
send(Socket, #pk_CollectFail{} = P) ->
	Bin = write_CollectFail(P),
	pack:send(Socket, ?CMD_CollectFail, Bin);
send(Socket, #pk_PlayerPropertyChanged{} = P) ->
	Bin = write_PlayerPropertyChanged(P),
	pack:send(Socket, ?CMD_PlayerPropertyChanged, Bin);
send(Socket, #pk_PlayerMoneyChanged{} = P) ->
	Bin = write_PlayerMoneyChanged(P),
	pack:send(Socket, ?CMD_PlayerMoneyChanged, Bin);
send(Socket, #pk_PlayerKickOuted{} = P) ->
	Bin = write_PlayerKickOuted(P),
	pack:send(Socket, ?CMD_PlayerKickOuted, Bin);
send(Socket, #pk_ActorStateFlagSet{} = P) ->
	Bin = write_ActorStateFlagSet(P),
	pack:send(Socket, ?CMD_ActorStateFlagSet, Bin);
send(Socket, #pk_ActorStateFlagSet_Broad{} = P) ->
	Bin = write_ActorStateFlagSet_Broad(P),
	pack:send(Socket, ?CMD_ActorStateFlagSet_Broad, Bin);
send(Socket, #pk_PlayerSkillInitInfo{} = P) ->
	Bin = write_PlayerSkillInitInfo(P),
	pack:send(Socket, ?CMD_PlayerSkillInitInfo, Bin);
send(Socket, #pk_GS2U_StudySkillResult{} = P) ->
	Bin = write_GS2U_StudySkillResult(P),
	pack:send(Socket, ?CMD_GS2U_StudySkillResult, Bin);
send(Socket, #pk_activeBranchIDResult{} = P) ->
	Bin = write_activeBranchIDResult(P),
	pack:send(Socket, ?CMD_activeBranchIDResult, Bin);
send(Socket, #pk_GS2U_AddSkillBranchAck{} = P) ->
	Bin = write_GS2U_AddSkillBranchAck(P),
	pack:send(Socket, ?CMD_GS2U_AddSkillBranchAck, Bin);
send(Socket, #pk_GS2U_UseSkillToObject{} = P) ->
	Bin = write_GS2U_UseSkillToObject(P),
	pack:send(Socket, ?CMD_GS2U_UseSkillToObject, Bin);
send(Socket, #pk_GS2U_UseSkillToPos{} = P) ->
	Bin = write_GS2U_UseSkillToPos(P),
	pack:send(Socket, ?CMD_GS2U_UseSkillToPos, Bin);
send(Socket, #pk_GS2U_AttackDamage{} = P) ->
	Bin = write_GS2U_AttackDamage(P),
	pack:send(Socket, ?CMD_GS2U_AttackDamage, Bin);
send(Socket, #pk_GS2U_CharactorDead{} = P) ->
	Bin = write_GS2U_CharactorDead(P),
	pack:send(Socket, ?CMD_GS2U_CharactorDead, Bin);
send(Socket, #pk_GS2U_AttackMiss{} = P) ->
	Bin = write_GS2U_AttackMiss(P),
	pack:send(Socket, ?CMD_GS2U_AttackMiss, Bin);
send(Socket, #pk_GS2U_AttackDodge{} = P) ->
	Bin = write_GS2U_AttackDodge(P),
	pack:send(Socket, ?CMD_GS2U_AttackDodge, Bin);
send(Socket, #pk_GS2U_AttackCrit{} = P) ->
	Bin = write_GS2U_AttackCrit(P),
	pack:send(Socket, ?CMD_GS2U_AttackCrit, Bin);
send(Socket, #pk_GS2U_AttackBlock{} = P) ->
	Bin = write_GS2U_AttackBlock(P),
	pack:send(Socket, ?CMD_GS2U_AttackBlock, Bin);
send(Socket, #pk_PlayerAllShortcut{} = P) ->
	Bin = write_PlayerAllShortcut(P),
	pack:send(Socket, ?CMD_PlayerAllShortcut, Bin);
send(Socket, #pk_PlayerEXPChanged{} = P) ->
	Bin = write_PlayerEXPChanged(P),
	pack:send(Socket, ?CMD_PlayerEXPChanged, Bin);
send(Socket, #pk_ActorLifeUpdate{} = P) ->
	Bin = write_ActorLifeUpdate(P),
	pack:send(Socket, ?CMD_ActorLifeUpdate, Bin);
send(Socket, #pk_ActorMoveSpeedUpdate{} = P) ->
	Bin = write_ActorMoveSpeedUpdate(P),
	pack:send(Socket, ?CMD_ActorMoveSpeedUpdate, Bin);
send(Socket, #pk_PlayerCombatIDInit{} = P) ->
	Bin = write_PlayerCombatIDInit(P),
	pack:send(Socket, ?CMD_PlayerCombatIDInit, Bin);
send(Socket, #pk_GS2U_CharactorRevived{} = P) ->
	Bin = write_GS2U_CharactorRevived(P),
	pack:send(Socket, ?CMD_GS2U_CharactorRevived, Bin);
send(Socket, #pk_GS2U_HeroPropertyResult{} = P) ->
	Bin = write_GS2U_HeroPropertyResult(P),
	pack:send(Socket, ?CMD_GS2U_HeroPropertyResult, Bin);
send(Socket, #pk_PlayerBagInit{} = P) ->
	Bin = write_PlayerBagInit(P),
	pack:send(Socket, ?CMD_PlayerBagInit, Bin);
send(Socket, #pk_PlayerGetItem{} = P) ->
	Bin = write_PlayerGetItem(P),
	pack:send(Socket, ?CMD_PlayerGetItem, Bin);
send(Socket, #pk_PlayerDestroyItem{} = P) ->
	Bin = write_PlayerDestroyItem(P),
	pack:send(Socket, ?CMD_PlayerDestroyItem, Bin);
send(Socket, #pk_PlayerItemLocationCellChanged{} = P) ->
	Bin = write_PlayerItemLocationCellChanged(P),
	pack:send(Socket, ?CMD_PlayerItemLocationCellChanged, Bin);
send(Socket, #pk_PlayerItemAmountChanged{} = P) ->
	Bin = write_PlayerItemAmountChanged(P),
	pack:send(Socket, ?CMD_PlayerItemAmountChanged, Bin);
send(Socket, #pk_PlayerItemParamChanged{} = P) ->
	Bin = write_PlayerItemParamChanged(P),
	pack:send(Socket, ?CMD_PlayerItemParamChanged, Bin);
send(Socket, #pk_PlayerBagOrderResult{} = P) ->
	Bin = write_PlayerBagOrderResult(P),
	pack:send(Socket, ?CMD_PlayerBagOrderResult, Bin);
send(Socket, #pk_PlayerUseItemResult{} = P) ->
	Bin = write_PlayerUseItemResult(P),
	pack:send(Socket, ?CMD_PlayerUseItemResult, Bin);
send(Socket, #pk_PlayerStorageBagPassWordChanged{} = P) ->
	Bin = write_PlayerStorageBagPassWordChanged(P),
	pack:send(Socket, ?CMD_PlayerStorageBagPassWordChanged, Bin);
send(Socket, #pk_PlayerBagCellEnableChanged{} = P) ->
	Bin = write_PlayerBagCellEnableChanged(P),
	pack:send(Socket, ?CMD_PlayerBagCellEnableChanged, Bin);
send(Socket, #pk_PlayerUnlockTimesChanged{} = P) ->
	Bin = write_PlayerUnlockTimesChanged(P),
	pack:send(Socket, ?CMD_PlayerUnlockTimesChanged, Bin);
send(Socket, #pk_ItemBagCellSet{} = P) ->
	Bin = write_ItemBagCellSet(P),
	pack:send(Socket, ?CMD_ItemBagCellSet, Bin);
send(Socket, #pk_GetNpcStoreItemListAck{} = P) ->
	Bin = write_GetNpcStoreItemListAck(P),
	pack:send(Socket, ?CMD_GetNpcStoreItemListAck, Bin);
send(Socket, #pk_BuyItemAck{} = P) ->
	Bin = write_BuyItemAck(P),
	pack:send(Socket, ?CMD_BuyItemAck, Bin);
send(Socket, #pk_GetNpcStoreBackBuyItemListAck{} = P) ->
	Bin = write_GetNpcStoreBackBuyItemListAck(P),
	pack:send(Socket, ?CMD_GetNpcStoreBackBuyItemListAck, Bin);
send(Socket, #pk_PlayerEquipInit{} = P) ->
	Bin = write_PlayerEquipInit(P),
	pack:send(Socket, ?CMD_PlayerEquipInit, Bin);
send(Socket, #pk_PlayerEquipActiveResult{} = P) ->
	Bin = write_PlayerEquipActiveResult(P),
	pack:send(Socket, ?CMD_PlayerEquipActiveResult, Bin);
send(Socket, #pk_PlayerEquipPutOnResult{} = P) ->
	Bin = write_PlayerEquipPutOnResult(P),
	pack:send(Socket, ?CMD_PlayerEquipPutOnResult, Bin);
send(Socket, #pk_QueryPlayerEquipResult{} = P) ->
	Bin = write_QueryPlayerEquipResult(P),
	pack:send(Socket, ?CMD_QueryPlayerEquipResult, Bin);
send(Socket, #pk_StudyResult{} = P) ->
	Bin = write_StudyResult(P),
	pack:send(Socket, ?CMD_StudyResult, Bin);
send(Socket, #pk_RebornAck{} = P) ->
	Bin = write_RebornAck(P),
	pack:send(Socket, ?CMD_RebornAck, Bin);
send(Socket, #pk_Chat2Player{} = P) ->
	Bin = write_Chat2Player(P),
	pack:send(Socket, ?CMD_Chat2Player, Bin);
send(Socket, #pk_Chat_Error_Result{} = P) ->
	Bin = write_Chat_Error_Result(P),
	pack:send(Socket, ?CMD_Chat_Error_Result, Bin);
send(Socket, #pk_RequestSendMailAck{} = P) ->
	Bin = write_RequestSendMailAck(P),
	pack:send(Socket, ?CMD_RequestSendMailAck, Bin);
send(Socket, #pk_RequestUnReadMailAck{} = P) ->
	Bin = write_RequestUnReadMailAck(P),
	pack:send(Socket, ?CMD_RequestUnReadMailAck, Bin);
send(Socket, #pk_RequestMailListAck{} = P) ->
	Bin = write_RequestMailListAck(P),
	pack:send(Socket, ?CMD_RequestMailListAck, Bin);
send(Socket, #pk_RequestMailItemInfoAck{} = P) ->
	Bin = write_RequestMailItemInfoAck(P),
	pack:send(Socket, ?CMD_RequestMailItemInfoAck, Bin);
send(Socket, #pk_RequestAcceptMailItemAck{} = P) ->
	Bin = write_RequestAcceptMailItemAck(P),
	pack:send(Socket, ?CMD_RequestAcceptMailItemAck, Bin);
send(Socket, #pk_InformNewMail{} = P) ->
	Bin = write_InformNewMail(P),
	pack:send(Socket, ?CMD_InformNewMail, Bin);
send(Socket, #pk_GS2U_LoginResult{} = P) ->
	Bin = write_GS2U_LoginResult(P),
	pack:send(Socket, ?CMD_GS2U_LoginResult, Bin);
send(Socket, #pk_GS2U_SelPlayerResult{} = P) ->
	Bin = write_GS2U_SelPlayerResult(P),
	pack:send(Socket, ?CMD_GS2U_SelPlayerResult, Bin);
send(Socket, #pk_GS2U_UserPlayerList{} = P) ->
	Bin = write_GS2U_UserPlayerList(P),
	pack:send(Socket, ?CMD_GS2U_UserPlayerList, Bin);
send(Socket, #pk_GS2U_CreatePlayerResult{} = P) ->
	Bin = write_GS2U_CreatePlayerResult(P),
	pack:send(Socket, ?CMD_GS2U_CreatePlayerResult, Bin);
send(Socket, #pk_GS2U_DeletePlayerResult{} = P) ->
	Bin = write_GS2U_DeletePlayerResult(P),
	pack:send(Socket, ?CMD_GS2U_DeletePlayerResult, Bin);
send(Socket, #pk_ConSales_GroundingItem_Result{} = P) ->
	Bin = write_ConSales_GroundingItem_Result(P),
	pack:send(Socket, ?CMD_ConSales_GroundingItem_Result, Bin);
send(Socket, #pk_ConSales_TakeDown_Result{} = P) ->
	Bin = write_ConSales_TakeDown_Result(P),
	pack:send(Socket, ?CMD_ConSales_TakeDown_Result, Bin);
send(Socket, #pk_ConSales_BuyItem_Result{} = P) ->
	Bin = write_ConSales_BuyItem_Result(P),
	pack:send(Socket, ?CMD_ConSales_BuyItem_Result, Bin);
send(Socket, #pk_ConSales_FindItems_Result{} = P) ->
	Bin = write_ConSales_FindItems_Result(P),
	pack:send(Socket, ?CMD_ConSales_FindItems_Result, Bin);
send(Socket, #pk_ConSales_GetSelfSell_Result{} = P) ->
	Bin = write_ConSales_GetSelfSell_Result(P),
	pack:send(Socket, ?CMD_ConSales_GetSelfSell_Result, Bin);
send(Socket, #pk_TradeAsk{} = P) ->
	Bin = write_TradeAsk(P),
	pack:send(Socket, ?CMD_TradeAsk, Bin);
send(Socket, #pk_TradeAskResult{} = P) ->
	Bin = write_TradeAskResult(P),
	pack:send(Socket, ?CMD_TradeAskResult, Bin);
send(Socket, #pk_CreateTrade{} = P) ->
	Bin = write_CreateTrade(P),
	pack:send(Socket, ?CMD_CreateTrade, Bin);
send(Socket, #pk_TradeInputItemResult_S2C{} = P) ->
	Bin = write_TradeInputItemResult_S2C(P),
	pack:send(Socket, ?CMD_TradeInputItemResult_S2C, Bin);
send(Socket, #pk_TradeInputItem_S2C{} = P) ->
	Bin = write_TradeInputItem_S2C(P),
	pack:send(Socket, ?CMD_TradeInputItem_S2C, Bin);
send(Socket, #pk_TradeTakeOutItemResult_S2C{} = P) ->
	Bin = write_TradeTakeOutItemResult_S2C(P),
	pack:send(Socket, ?CMD_TradeTakeOutItemResult_S2C, Bin);
send(Socket, #pk_TradeTakeOutItem_S2C{} = P) ->
	Bin = write_TradeTakeOutItem_S2C(P),
	pack:send(Socket, ?CMD_TradeTakeOutItem_S2C, Bin);
send(Socket, #pk_TradeChangeMoneyResult_S2C{} = P) ->
	Bin = write_TradeChangeMoneyResult_S2C(P),
	pack:send(Socket, ?CMD_TradeChangeMoneyResult_S2C, Bin);
send(Socket, #pk_TradeChangeMoney_S2C{} = P) ->
	Bin = write_TradeChangeMoney_S2C(P),
	pack:send(Socket, ?CMD_TradeChangeMoney_S2C, Bin);
send(Socket, #pk_TradeLock_S2C{} = P) ->
	Bin = write_TradeLock_S2C(P),
	pack:send(Socket, ?CMD_TradeLock_S2C, Bin);
send(Socket, #pk_CancelTrade_S2C{} = P) ->
	Bin = write_CancelTrade_S2C(P),
	pack:send(Socket, ?CMD_CancelTrade_S2C, Bin);
send(Socket, #pk_TradeAffirm_S2C{} = P) ->
	Bin = write_TradeAffirm_S2C(P),
	pack:send(Socket, ?CMD_TradeAffirm_S2C, Bin);
send(Socket, #pk_PlayerPetInfo{} = P) ->
	Bin = write_PlayerPetInfo(P),
	pack:send(Socket, ?CMD_PlayerPetInfo, Bin);
send(Socket, #pk_UpdatePetProerty{} = P) ->
	Bin = write_UpdatePetProerty(P),
	pack:send(Socket, ?CMD_UpdatePetProerty, Bin);
send(Socket, #pk_DelPet{} = P) ->
	Bin = write_DelPet(P),
	pack:send(Socket, ?CMD_DelPet, Bin);
send(Socket, #pk_PetOutFight_Result{} = P) ->
	Bin = write_PetOutFight_Result(P),
	pack:send(Socket, ?CMD_PetOutFight_Result, Bin);
send(Socket, #pk_PetTakeRest_Result{} = P) ->
	Bin = write_PetTakeRest_Result(P),
	pack:send(Socket, ?CMD_PetTakeRest_Result, Bin);
send(Socket, #pk_PetFreeCaptiveAnimals_Result{} = P) ->
	Bin = write_PetFreeCaptiveAnimals_Result(P),
	pack:send(Socket, ?CMD_PetFreeCaptiveAnimals_Result, Bin);
send(Socket, #pk_PetCompoundModel_Result{} = P) ->
	Bin = write_PetCompoundModel_Result(P),
	pack:send(Socket, ?CMD_PetCompoundModel_Result, Bin);
send(Socket, #pk_PetWashGrowUpValue_Result{} = P) ->
	Bin = write_PetWashGrowUpValue_Result(P),
	pack:send(Socket, ?CMD_PetWashGrowUpValue_Result, Bin);
send(Socket, #pk_PetReplaceGrowUpValue_Result{} = P) ->
	Bin = write_PetReplaceGrowUpValue_Result(P),
	pack:send(Socket, ?CMD_PetReplaceGrowUpValue_Result, Bin);
send(Socket, #pk_PetIntensifySoul_Result{} = P) ->
	Bin = write_PetIntensifySoul_Result(P),
	pack:send(Socket, ?CMD_PetIntensifySoul_Result, Bin);
send(Socket, #pk_PetOneKeyIntensifySoul_Result{} = P) ->
	Bin = write_PetOneKeyIntensifySoul_Result(P),
	pack:send(Socket, ?CMD_PetOneKeyIntensifySoul_Result, Bin);
send(Socket, #pk_PetFuse_Result{} = P) ->
	Bin = write_PetFuse_Result(P),
	pack:send(Socket, ?CMD_PetFuse_Result, Bin);
send(Socket, #pk_PetJumpTo{} = P) ->
	Bin = write_PetJumpTo(P),
	pack:send(Socket, ?CMD_PetJumpTo, Bin);
send(Socket, #pk_ActorSetPos{} = P) ->
	Bin = write_ActorSetPos(P),
	pack:send(Socket, ?CMD_ActorSetPos, Bin);
send(Socket, #pk_PetTakeBack{} = P) ->
	Bin = write_PetTakeBack(P),
	pack:send(Socket, ?CMD_PetTakeBack, Bin);
send(Socket, #pk_ChangePetAIState{} = P) ->
	Bin = write_ChangePetAIState(P),
	pack:send(Socket, ?CMD_ChangePetAIState, Bin);
send(Socket, #pk_PetExpChanged{} = P) ->
	Bin = write_PetExpChanged(P),
	pack:send(Socket, ?CMD_PetExpChanged, Bin);
send(Socket, #pk_PetLearnSkill_Result{} = P) ->
	Bin = write_PetLearnSkill_Result(P),
	pack:send(Socket, ?CMD_PetLearnSkill_Result, Bin);
send(Socket, #pk_PetDelSkill_Result{} = P) ->
	Bin = write_PetDelSkill_Result(P),
	pack:send(Socket, ?CMD_PetDelSkill_Result, Bin);
send(Socket, #pk_PetUnLoctSkillCell_Result{} = P) ->
	Bin = write_PetUnLoctSkillCell_Result(P),
	pack:send(Socket, ?CMD_PetUnLoctSkillCell_Result, Bin);
send(Socket, #pk_PetSkillSealAhs_Result{} = P) ->
	Bin = write_PetSkillSealAhs_Result(P),
	pack:send(Socket, ?CMD_PetSkillSealAhs_Result, Bin);
send(Socket, #pk_PetUpdateSealAhsStore{} = P) ->
	Bin = write_PetUpdateSealAhsStore(P),
	pack:send(Socket, ?CMD_PetUpdateSealAhsStore, Bin);
send(Socket, #pk_PetlearnSealAhsSkill_Result{} = P) ->
	Bin = write_PetlearnSealAhsSkill_Result(P),
	pack:send(Socket, ?CMD_PetlearnSealAhsSkill_Result, Bin);
send(Socket, #pk_GetPlayerEquipEnhanceByTypeBack{} = P) ->
	Bin = write_GetPlayerEquipEnhanceByTypeBack(P),
	pack:send(Socket, ?CMD_GetPlayerEquipEnhanceByTypeBack, Bin);
send(Socket, #pk_EquipEnhanceByTypeBack{} = P) ->
	Bin = write_EquipEnhanceByTypeBack(P),
	pack:send(Socket, ?CMD_EquipEnhanceByTypeBack, Bin);
send(Socket, #pk_EquipOnceEnhanceByTypeBack{} = P) ->
	Bin = write_EquipOnceEnhanceByTypeBack(P),
	pack:send(Socket, ?CMD_EquipOnceEnhanceByTypeBack, Bin);
send(Socket, #pk_GetPlayerEquipQualityByTypeBack{} = P) ->
	Bin = write_GetPlayerEquipQualityByTypeBack(P),
	pack:send(Socket, ?CMD_GetPlayerEquipQualityByTypeBack, Bin);
send(Socket, #pk_EquipQualityUPByTypeBack{} = P) ->
	Bin = write_EquipQualityUPByTypeBack(P),
	pack:send(Socket, ?CMD_EquipQualityUPByTypeBack, Bin);
send(Socket, #pk_GetEquipOldPropertyByType{} = P) ->
	Bin = write_GetEquipOldPropertyByType(P),
	pack:send(Socket, ?CMD_GetEquipOldPropertyByType, Bin);
send(Socket, #pk_GetEquipNewPropertyByType{} = P) ->
	Bin = write_GetEquipNewPropertyByType(P),
	pack:send(Socket, ?CMD_GetEquipNewPropertyByType, Bin);
send(Socket, #pk_RequestEquipChangeAddSavePropertyByType{} = P) ->
	Bin = write_RequestEquipChangeAddSavePropertyByType(P),
	pack:send(Socket, ?CMD_RequestEquipChangeAddSavePropertyByType, Bin);
send(Socket, #pk_GS2U_EnterMapResult{} = P) ->
	Bin = write_GS2U_EnterMapResult(P),
	pack:send(Socket, ?CMD_GS2U_EnterMapResult, Bin);
send(Socket, #pk_GS2U_MyCopyMapCDInfo{} = P) ->
	Bin = write_GS2U_MyCopyMapCDInfo(P),
	pack:send(Socket, ?CMD_GS2U_MyCopyMapCDInfo, Bin);
send(Socket, #pk_AddBuff{} = P) ->
	Bin = write_AddBuff(P),
	pack:send(Socket, ?CMD_AddBuff, Bin);
send(Socket, #pk_DelBuff{} = P) ->
	Bin = write_DelBuff(P),
	pack:send(Socket, ?CMD_DelBuff, Bin);
send(Socket, #pk_UpdateBuff{} = P) ->
	Bin = write_UpdateBuff(P),
	pack:send(Socket, ?CMD_UpdateBuff, Bin);
send(Socket, #pk_HeroBuffList{} = P) ->
	Bin = write_HeroBuffList(P),
	pack:send(Socket, ?CMD_HeroBuffList, Bin);
send(Socket, #pk_GS2U_FastTeamCopyMapResult{} = P) ->
	Bin = write_GS2U_FastTeamCopyMapResult(P),
	pack:send(Socket, ?CMD_GS2U_FastTeamCopyMapResult, Bin);
send(Socket, #pk_GS2U_TeamCopyMapQuery{} = P) ->
	Bin = write_GS2U_TeamCopyMapQuery(P),
	pack:send(Socket, ?CMD_GS2U_TeamCopyMapQuery, Bin);
send(Socket, #pk_GS2U_AddOrRemoveHatred{} = P) ->
	Bin = write_GS2U_AddOrRemoveHatred(P),
	pack:send(Socket, ?CMD_GS2U_AddOrRemoveHatred, Bin);
send(Socket, #pk_GS2U_QieCuoInviteQuery{} = P) ->
	Bin = write_GS2U_QieCuoInviteQuery(P),
	pack:send(Socket, ?CMD_GS2U_QieCuoInviteQuery, Bin);
send(Socket, #pk_GS2U_QieCuoInviteResult{} = P) ->
	Bin = write_GS2U_QieCuoInviteResult(P),
	pack:send(Socket, ?CMD_GS2U_QieCuoInviteResult, Bin);
send(Socket, #pk_GS2U_QieCuoResult{} = P) ->
	Bin = write_GS2U_QieCuoResult(P),
	pack:send(Socket, ?CMD_GS2U_QieCuoResult, Bin);
send(Socket, #pk_GS2U_PK_KillOpenResult{} = P) ->
	Bin = write_GS2U_PK_KillOpenResult(P),
	pack:send(Socket, ?CMD_GS2U_PK_KillOpenResult, Bin);
send(Socket, #pk_GS2U_Player_ChangeEquipResult{} = P) ->
	Bin = write_GS2U_Player_ChangeEquipResult(P),
	pack:send(Socket, ?CMD_GS2U_Player_ChangeEquipResult, Bin);
send(Socket, #pk_SysMessage{} = P) ->
	Bin = write_SysMessage(P),
	pack:send(Socket, ?CMD_SysMessage, Bin);
send(Socket, #pk_GS2U_AddLifeByItem{} = P) ->
	Bin = write_GS2U_AddLifeByItem(P),
	pack:send(Socket, ?CMD_GS2U_AddLifeByItem, Bin);
send(Socket, #pk_GS2U_AddLifeBySkill{} = P) ->
	Bin = write_GS2U_AddLifeBySkill(P),
	pack:send(Socket, ?CMD_GS2U_AddLifeBySkill, Bin);
send(Socket, #pk_GS2U_PlayerItemCDInit{} = P) ->
	Bin = write_GS2U_PlayerItemCDInit(P),
	pack:send(Socket, ?CMD_GS2U_PlayerItemCDInit, Bin);
send(Socket, #pk_GS2U_PlayerItemCDUpdate{} = P) ->
	Bin = write_GS2U_PlayerItemCDUpdate(P),
	pack:send(Socket, ?CMD_GS2U_PlayerItemCDUpdate, Bin);
send(Socket, #pk_GS2U_ItemDailyCount{} = P) ->
	Bin = write_GS2U_ItemDailyCount(P),
	pack:send(Socket, ?CMD_GS2U_ItemDailyCount, Bin);
send(Socket, #pk_GS2U_PlayerSigninInfo{} = P) ->
	Bin = write_GS2U_PlayerSigninInfo(P),
	pack:send(Socket, ?CMD_GS2U_PlayerSigninInfo, Bin);
send(Socket, #pk_GS2U_PlayerSignInResult{} = P) ->
	Bin = write_GS2U_PlayerSignInResult(P),
	pack:send(Socket, ?CMD_GS2U_PlayerSignInResult, Bin);
send(Socket, #pk_PetChangeModel{} = P) ->
	Bin = write_PetChangeModel(P),
	pack:send(Socket, ?CMD_PetChangeModel, Bin);
send(Socket, #pk_PetChangeName{} = P) ->
	Bin = write_PetChangeName(P),
	pack:send(Socket, ?CMD_PetChangeName, Bin);
send(Socket, #pk_PetChangeName_Result{} = P) ->
	Bin = write_PetChangeName_Result(P),
	pack:send(Socket, ?CMD_PetChangeName_Result, Bin);
send(Socket, #pk_BazzarPriceItemList{} = P) ->
	Bin = write_BazzarPriceItemList(P),
	pack:send(Socket, ?CMD_BazzarPriceItemList, Bin);
send(Socket, #pk_BazzarItemList{} = P) ->
	Bin = write_BazzarItemList(P),
	pack:send(Socket, ?CMD_BazzarItemList, Bin);
send(Socket, #pk_BazzarItemUpdate{} = P) ->
	Bin = write_BazzarItemUpdate(P),
	pack:send(Socket, ?CMD_BazzarItemUpdate, Bin);
send(Socket, #pk_BazzarBuyResult{} = P) ->
	Bin = write_BazzarBuyResult(P),
	pack:send(Socket, ?CMD_BazzarBuyResult, Bin);
send(Socket, #pk_PlayerBagCellOpenResult{} = P) ->
	Bin = write_PlayerBagCellOpenResult(P),
	pack:send(Socket, ?CMD_PlayerBagCellOpenResult, Bin);
send(Socket, #pk_GS2U_RemoveSkillBranch{} = P) ->
	Bin = write_GS2U_RemoveSkillBranch(P),
	pack:send(Socket, ?CMD_GS2U_RemoveSkillBranch, Bin);
send(Socket, #pk_U2GS_CopyMapAddActiveCountResult{} = P) ->
	Bin = write_U2GS_CopyMapAddActiveCountResult(P),
	pack:send(Socket, ?CMD_U2GS_CopyMapAddActiveCountResult, Bin);
send(Socket, #pk_GS2U_CurConvoyInfo{} = P) ->
	Bin = write_GS2U_CurConvoyInfo(P),
	pack:send(Socket, ?CMD_GS2U_CurConvoyInfo, Bin);
send(Socket, #pk_GS2U_CarriageQualityRefreshResult{} = P) ->
	Bin = write_GS2U_CarriageQualityRefreshResult(P),
	pack:send(Socket, ?CMD_GS2U_CarriageQualityRefreshResult, Bin);
send(Socket, #pk_GS2U_ConvoyCDResult{} = P) ->
	Bin = write_GS2U_ConvoyCDResult(P),
	pack:send(Socket, ?CMD_GS2U_ConvoyCDResult, Bin);
send(Socket, #pk_GS2U_BeginConvoyResult{} = P) ->
	Bin = write_GS2U_BeginConvoyResult(P),
	pack:send(Socket, ?CMD_GS2U_BeginConvoyResult, Bin);
send(Socket, #pk_GS2U_FinishConvoyResult{} = P) ->
	Bin = write_GS2U_FinishConvoyResult(P),
	pack:send(Socket, ?CMD_GS2U_FinishConvoyResult, Bin);
send(Socket, #pk_GS2U_GiveUpConvoyResult{} = P) ->
	Bin = write_GS2U_GiveUpConvoyResult(P),
	pack:send(Socket, ?CMD_GS2U_GiveUpConvoyResult, Bin);
send(Socket, #pk_GS2U_ConvoyNoticeTimerResult{} = P) ->
	Bin = write_GS2U_ConvoyNoticeTimerResult(P),
	pack:send(Socket, ?CMD_GS2U_ConvoyNoticeTimerResult, Bin);
send(Socket, #pk_GS2U_ConvoyState{} = P) ->
	Bin = write_GS2U_ConvoyState(P),
	pack:send(Socket, ?CMD_GS2U_ConvoyState, Bin);
send(Socket, #pk_GSWithU_GameSetMenu{} = P) ->
	Bin = write_GSWithU_GameSetMenu(P),
	pack:send(Socket, ?CMD_GSWithU_GameSetMenu, Bin);
send(Socket, #pk_U2GS_RequestRechargeGift_Ret{} = P) ->
	Bin = write_U2GS_RequestRechargeGift_Ret(P),
	pack:send(Socket, ?CMD_U2GS_RequestRechargeGift_Ret, Bin);
send(Socket, #pk_U2GS_RequestPlayerFightingCapacity_Ret{} = P) ->
	Bin = write_U2GS_RequestPlayerFightingCapacity_Ret(P),
	pack:send(Socket, ?CMD_U2GS_RequestPlayerFightingCapacity_Ret, Bin);
send(Socket, #pk_U2GS_RequestPetFightingCapacity_Ret{} = P) ->
	Bin = write_U2GS_RequestPetFightingCapacity_Ret(P),
	pack:send(Socket, ?CMD_U2GS_RequestPetFightingCapacity_Ret, Bin);
send(Socket, #pk_U2GS_RequestMountFightingCapacity_Ret{} = P) ->
	Bin = write_U2GS_RequestMountFightingCapacity_Ret(P),
	pack:send(Socket, ?CMD_U2GS_RequestMountFightingCapacity_Ret, Bin);
send(Socket, #pk_GS2U_VariantDataSet{} = P) ->
	Bin = write_GS2U_VariantDataSet(P),
	pack:send(Socket, ?CMD_GS2U_VariantDataSet, Bin);
send(Socket, #pk_GS2U_RankList{} = P) ->
	Bin = write_GS2U_RankList(P),
	pack:send(Socket, ?CMD_GS2U_RankList, Bin);
send(Socket, #pk_GS2U_WordBossCmd{} = P) ->
	Bin = write_GS2U_WordBossCmd(P),
	pack:send(Socket, ?CMD_GS2U_WordBossCmd, Bin);
send(Socket, #pk_GS2U_ChangePlayerNameResult{} = P) ->
	Bin = write_GS2U_ChangePlayerNameResult(P),
	pack:send(Socket, ?CMD_GS2U_ChangePlayerNameResult, Bin);
send(Socket, #pk_GS2U_SetProtectPwdResult{} = P) ->
	Bin = write_GS2U_SetProtectPwdResult(P),
	pack:send(Socket, ?CMD_GS2U_SetProtectPwdResult, Bin);
send(Socket, #pk_GS2U_CopyProgressUpdate{} = P) ->
	Bin = write_GS2U_CopyProgressUpdate(P),
	pack:send(Socket, ?CMD_GS2U_CopyProgressUpdate, Bin);
send(Socket, #pk_U2GS_StartGiveGoldResult{} = P) ->
	Bin = write_U2GS_StartGiveGoldResult(P),
	pack:send(Socket, ?CMD_U2GS_StartGiveGoldResult, Bin);
send(Socket, #pk_U2GS_GoldLineInfo{} = P) ->
	Bin = write_U2GS_GoldLineInfo(P),
	pack:send(Socket, ?CMD_U2GS_GoldLineInfo, Bin);
send(Socket, #pk_U2GS_GoldResetTimer{} = P) ->
	Bin = write_U2GS_GoldResetTimer(P),
	pack:send(Socket, ?CMD_U2GS_GoldResetTimer, Bin);
send(Socket, #pk_GS2U_CopyMapSAData{} = P) ->
	Bin = write_GS2U_CopyMapSAData(P),
	pack:send(Socket, ?CMD_GS2U_CopyMapSAData, Bin);
send(Socket, #pk_GetTokenStoreItemListAck{} = P) ->
	Bin = write_GetTokenStoreItemListAck(P),
	pack:send(Socket, ?CMD_GetTokenStoreItemListAck, Bin);
send(Socket, #pk_RequestLookPlayer_Result{} = P) ->
	Bin = write_RequestLookPlayer_Result(P),
	pack:send(Socket, ?CMD_RequestLookPlayer_Result, Bin);
send(Socket, #pk_RequestLookPlayerFailed_Result{} = P) ->
	Bin = write_RequestLookPlayerFailed_Result(P),
	pack:send(Socket, ?CMD_RequestLookPlayerFailed_Result, Bin);
send(Socket, #pk_GS2U_ActiveCount{} = P) ->
	Bin = write_GS2U_ActiveCount(P),
	pack:send(Socket, ?CMD_GS2U_ActiveCount, Bin);
send(Socket, #pk_GS2U_WhetherTransferOldRecharge{} = P) ->
	Bin = write_GS2U_WhetherTransferOldRecharge(P),
	pack:send(Socket, ?CMD_GS2U_WhetherTransferOldRecharge, Bin);
send(Socket, #pk_GS2U_TransferOldRechargeResult{} = P) ->
	Bin = write_GS2U_TransferOldRechargeResult(P),
	pack:send(Socket, ?CMD_GS2U_TransferOldRechargeResult, Bin);
send(Socket, #pk_PlayerEquipActiveFailReason{} = P) ->
	Bin = write_PlayerEquipActiveFailReason(P),
	pack:send(Socket, ?CMD_PlayerEquipActiveFailReason, Bin);
send(Socket, #pk_PlayerEquipMinLevelChange{} = P) ->
	Bin = write_PlayerEquipMinLevelChange(P),
	pack:send(Socket, ?CMD_PlayerEquipMinLevelChange, Bin);
send(Socket, #pk_PlayerImportPassWordResult{} = P) ->
	Bin = write_PlayerImportPassWordResult(P),
	pack:send(Socket, ?CMD_PlayerImportPassWordResult, Bin);
send(Socket, #pk_GS2U_UpdatePlayerGuildInfo{} = P) ->
	Bin = write_GS2U_UpdatePlayerGuildInfo(P),
	pack:send(Socket, ?CMD_GS2U_UpdatePlayerGuildInfo, Bin);
send(Socket, #pk_U2GS_RequestBazzarItemPrice_Result{} = P) ->
	Bin = write_U2GS_RequestBazzarItemPrice_Result(P),
	pack:send(Socket, ?CMD_U2GS_RequestBazzarItemPrice_Result, Bin);
send(Socket, #pk_PlayerGoldPassWordChanged{} = P) ->
	Bin = write_PlayerGoldPassWordChanged(P),
	pack:send(Socket, ?CMD_PlayerGoldPassWordChanged, Bin);
send(Socket, #pk_PlayerImportGoldPassWordResult{} = P) ->
	Bin = write_PlayerImportGoldPassWordResult(P),
	pack:send(Socket, ?CMD_PlayerImportGoldPassWordResult, Bin);
send(Socket, #pk_PlayerGoldUnlockTimesChanged{} = P) ->
	Bin = write_PlayerGoldUnlockTimesChanged(P),
	pack:send(Socket, ?CMD_PlayerGoldUnlockTimesChanged, Bin);
send(Socket, #pk_GS2U_LeftSmallMonsterNumber{} = P) ->
	Bin = write_GS2U_LeftSmallMonsterNumber(P),
	pack:send(Socket, ?CMD_GS2U_LeftSmallMonsterNumber, Bin);
send(Socket, #pk_GS2U_VipInfo{} = P) ->
	Bin = write_GS2U_VipInfo(P),
	pack:send(Socket, ?CMD_GS2U_VipInfo, Bin);
send(Socket, #pk_GS2U_TellMapLineID{} = P) ->
	Bin = write_GS2U_TellMapLineID(P),
	pack:send(Socket, ?CMD_GS2U_TellMapLineID, Bin);
send(Socket, #pk_VIPPlayerOpenVIPStoreFail{} = P) ->
	Bin = write_VIPPlayerOpenVIPStoreFail(P),
	pack:send(Socket, ?CMD_VIPPlayerOpenVIPStoreFail, Bin);
send(Socket, #pk_UpdateVIPLevelInfo{} = P) ->
	Bin = write_UpdateVIPLevelInfo(P),
	pack:send(Socket, ?CMD_UpdateVIPLevelInfo, Bin);
send(Socket, #pk_ActiveCodeResult{} = P) ->
	Bin = write_ActiveCodeResult(P),
	pack:send(Socket, ?CMD_ActiveCodeResult, Bin);
send(Socket, #pk_GS2U_RequestOutFightPetPropetryResult{} = P) ->
	Bin = write_GS2U_RequestOutFightPetPropetryResult(P),
	pack:send(Socket, ?CMD_GS2U_RequestOutFightPetPropetryResult, Bin);
send(Socket, #pk_PlayerDirMove_S2C{} = P) ->
	Bin = write_PlayerDirMove_S2C(P),
	pack:send(Socket, ?CMD_PlayerDirMove_S2C, Bin);
send(Socket, #pk_GSWithU_GameSetMenu_3{} = P) ->
	Bin = write_GSWithU_GameSetMenu_3(P),
	pack:send(Socket, ?CMD_GSWithU_GameSetMenu_3, Bin);
send(Socket, #pk_StartCompoundResult{} = P) ->
	Bin = write_StartCompoundResult(P),
	pack:send(Socket, ?CMD_StartCompoundResult, Bin);
send(Socket, #pk_CompoundBaseInfo{} = P) ->
	Bin = write_CompoundBaseInfo(P),
	pack:send(Socket, ?CMD_CompoundBaseInfo, Bin);
send(Socket, #pk_EquipQualityFastUPByTypeBack{} = P) ->
	Bin = write_EquipQualityFastUPByTypeBack(P),
	pack:send(Socket, ?CMD_EquipQualityFastUPByTypeBack, Bin);
send(Socket, #pk_PlayerTeleportMove_S2C{} = P) ->
	Bin = write_PlayerTeleportMove_S2C(P),
	pack:send(Socket, ?CMD_PlayerTeleportMove_S2C, Bin);
send(Socket, #pk_BattleResultList{} = P) ->
	Bin = write_BattleResultList(P),
	pack:send(Socket, ?CMD_BattleResultList, Bin);
send(Socket, #pk_GS2U_BattleEnrollResult{} = P) ->
	Bin = write_GS2U_BattleEnrollResult(P),
	pack:send(Socket, ?CMD_GS2U_BattleEnrollResult, Bin);
send(Socket, #pk_GS2U_sendEnrollInfo{} = P) ->
	Bin = write_GS2U_sendEnrollInfo(P),
	pack:send(Socket, ?CMD_GS2U_sendEnrollInfo, Bin);
send(Socket, #pk_GS2U_NowCanEnterBattle{} = P) ->
	Bin = write_GS2U_NowCanEnterBattle(P),
	pack:send(Socket, ?CMD_GS2U_NowCanEnterBattle, Bin);
send(Socket, #pk_GS2U_EnterBattleResult{} = P) ->
	Bin = write_GS2U_EnterBattleResult(P),
	pack:send(Socket, ?CMD_GS2U_EnterBattleResult, Bin);
send(Socket, #pk_GS2U_BattleScore{} = P) ->
	Bin = write_GS2U_BattleScore(P),
	pack:send(Socket, ?CMD_GS2U_BattleScore, Bin);
send(Socket, #pk_GS2U_BattleEnd{} = P) ->
	Bin = write_GS2U_BattleEnd(P),
	pack:send(Socket, ?CMD_GS2U_BattleEnd, Bin);
send(Socket, #pk_GS2U_LeftOpenTime{} = P) ->
	Bin = write_GS2U_LeftOpenTime(P),
	pack:send(Socket, ?CMD_GS2U_LeftOpenTime, Bin);
send(Socket, #pk_GS2U_HeartBeatAck{} = P) ->
	Bin = write_GS2U_HeartBeatAck(P),
	pack:send(Socket, ?CMD_GS2U_HeartBeatAck, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_PlayerMoveTo->
            {Data, _, _} = binary_read_PlayerMoveTo(Bin),
            messageOn:on_PlayerMoveTo(Socket, Data);
        ?CMD_PlayerStopMove->
            {Data, _, _} = binary_read_PlayerStopMove(Bin),
            messageOn:on_PlayerStopMove(Socket, Data);
        ?CMD_ChangeFlyState->
            {Data, _, _} = binary_read_ChangeFlyState(Bin),
            messageOn:on_ChangeFlyState(Socket, Data);
        ?CMD_ChangeMap->
            {Data, _, _} = binary_read_ChangeMap(Bin),
            messageOn:on_ChangeMap(Socket, Data);
        ?CMD_RequestGM->
            {Data, _, _} = binary_read_RequestGM(Bin),
            messageOn:on_RequestGM(Socket, Data);
        ?CMD_U2GS_StudySkill->
            {Data, _, _} = binary_read_U2GS_StudySkill(Bin),
            messageOn:on_U2GS_StudySkill(Socket, Data);
        ?CMD_activeBranchID->
            {Data, _, _} = binary_read_activeBranchID(Bin),
            messageOn:on_activeBranchID(Socket, Data);
        ?CMD_U2GS_AddSkillBranch->
            {Data, _, _} = binary_read_U2GS_AddSkillBranch(Bin),
            messageOn:on_U2GS_AddSkillBranch(Socket, Data);
        ?CMD_U2GS_UseSkillRequest->
            {Data, _, _} = binary_read_U2GS_UseSkillRequest(Bin),
            messageOn:on_U2GS_UseSkillRequest(Socket, Data);
        ?CMD_ShortcutSet->
            {Data, _, _} = binary_read_ShortcutSet(Bin),
            messageOn:on_ShortcutSet(Socket, Data);
        ?CMD_U2GS_InteractObject->
            {Data, _, _} = binary_read_U2GS_InteractObject(Bin),
            messageOn:on_U2GS_InteractObject(Socket, Data);
        ?CMD_U2GS_QueryHeroProperty->
            {Data, _, _} = binary_read_U2GS_QueryHeroProperty(Bin),
            messageOn:on_U2GS_QueryHeroProperty(Socket, Data);
        ?CMD_RequestDestroyItem->
            {Data, _, _} = binary_read_RequestDestroyItem(Bin),
            messageOn:on_RequestDestroyItem(Socket, Data);
        ?CMD_RequestGetItem->
            {Data, _, _} = binary_read_RequestGetItem(Bin),
            messageOn:on_RequestGetItem(Socket, Data);
        ?CMD_RequestPlayerBagOrder->
            {Data, _, _} = binary_read_RequestPlayerBagOrder(Bin),
            messageOn:on_RequestPlayerBagOrder(Socket, Data);
        ?CMD_PlayerRequestUseItem->
            {Data, _, _} = binary_read_PlayerRequestUseItem(Bin),
            messageOn:on_PlayerRequestUseItem(Socket, Data);
        ?CMD_RequestPlayerBagCellOpen->
            {Data, _, _} = binary_read_RequestPlayerBagCellOpen(Bin),
            messageOn:on_RequestPlayerBagCellOpen(Socket, Data);
        ?CMD_RequestChangeStorageBagPassWord->
            {Data, _, _} = binary_read_RequestChangeStorageBagPassWord(Bin),
            messageOn:on_RequestChangeStorageBagPassWord(Socket, Data);
        ?CMD_RequestPlayerBagSellItem->
            {Data, _, _} = binary_read_RequestPlayerBagSellItem(Bin),
            messageOn:on_RequestPlayerBagSellItem(Socket, Data);
        ?CMD_RequestClearTempBag->
            {Data, _, _} = binary_read_RequestClearTempBag(Bin),
            messageOn:on_RequestClearTempBag(Socket, Data);
        ?CMD_RequestMoveTempBagItem->
            {Data, _, _} = binary_read_RequestMoveTempBagItem(Bin),
            messageOn:on_RequestMoveTempBagItem(Socket, Data);
        ?CMD_RequestMoveAllTempBagItem->
            {Data, _, _} = binary_read_RequestMoveAllTempBagItem(Bin),
            messageOn:on_RequestMoveAllTempBagItem(Socket, Data);
        ?CMD_RequestMoveStorageBagItem->
            {Data, _, _} = binary_read_RequestMoveStorageBagItem(Bin),
            messageOn:on_RequestMoveStorageBagItem(Socket, Data);
        ?CMD_RequestMoveBagItemToStorage->
            {Data, _, _} = binary_read_RequestMoveBagItemToStorage(Bin),
            messageOn:on_RequestMoveBagItemToStorage(Socket, Data);
        ?CMD_RequestUnlockingStorageBagPassWord->
            {Data, _, _} = binary_read_RequestUnlockingStorageBagPassWord(Bin),
            messageOn:on_RequestUnlockingStorageBagPassWord(Socket, Data);
        ?CMD_RequestCancelUnlockingStorageBagPassWord->
            {Data, _, _} = binary_read_RequestCancelUnlockingStorageBagPassWord(Bin),
            messageOn:on_RequestCancelUnlockingStorageBagPassWord(Socket, Data);
        ?CMD_RequestGetNpcStoreItemList->
            {Data, _, _} = binary_read_RequestGetNpcStoreItemList(Bin),
            messageOn:on_RequestGetNpcStoreItemList(Socket, Data);
        ?CMD_RequestBuyItem->
            {Data, _, _} = binary_read_RequestBuyItem(Bin),
            messageOn:on_RequestBuyItem(Socket, Data);
        ?CMD_RequestSellItem->
            {Data, _, _} = binary_read_RequestSellItem(Bin),
            messageOn:on_RequestSellItem(Socket, Data);
        ?CMD_GetNpcStoreBackBuyItemList->
            {Data, _, _} = binary_read_GetNpcStoreBackBuyItemList(Bin),
            messageOn:on_GetNpcStoreBackBuyItemList(Socket, Data);
        ?CMD_RequestBackBuyItem->
            {Data, _, _} = binary_read_RequestBackBuyItem(Bin),
            messageOn:on_RequestBackBuyItem(Socket, Data);
        ?CMD_RequestPlayerEquipActive->
            {Data, _, _} = binary_read_RequestPlayerEquipActive(Bin),
            messageOn:on_RequestPlayerEquipActive(Socket, Data);
        ?CMD_RequestPlayerEquipPutOn->
            {Data, _, _} = binary_read_RequestPlayerEquipPutOn(Bin),
            messageOn:on_RequestPlayerEquipPutOn(Socket, Data);
        ?CMD_RequestQueryPlayerEquip->
            {Data, _, _} = binary_read_RequestQueryPlayerEquip(Bin),
            messageOn:on_RequestQueryPlayerEquip(Socket, Data);
        ?CMD_StudySkill->
            {Data, _, _} = binary_read_StudySkill(Bin),
            messageOn:on_StudySkill(Socket, Data);
        ?CMD_Reborn->
            {Data, _, _} = binary_read_Reborn(Bin),
            messageOn:on_Reborn(Socket, Data);
        ?CMD_Chat2Server->
            {Data, _, _} = binary_read_Chat2Server(Bin),
            messageOn:on_Chat2Server(Socket, Data);
        ?CMD_RequestSendMail->
            {Data, _, _} = binary_read_RequestSendMail(Bin),
            messageOn:on_RequestSendMail(Socket, Data);
        ?CMD_RequestRecvMail->
            {Data, _, _} = binary_read_RequestRecvMail(Bin),
            messageOn:on_RequestRecvMail(Socket, Data);
        ?CMD_RequestUnReadMail->
            {Data, _, _} = binary_read_RequestUnReadMail(Bin),
            messageOn:on_RequestUnReadMail(Socket, Data);
        ?CMD_RequestMailList->
            {Data, _, _} = binary_read_RequestMailList(Bin),
            messageOn:on_RequestMailList(Socket, Data);
        ?CMD_RequestMailItemInfo->
            {Data, _, _} = binary_read_RequestMailItemInfo(Bin),
            messageOn:on_RequestMailItemInfo(Socket, Data);
        ?CMD_RequestAcceptMailItem->
            {Data, _, _} = binary_read_RequestAcceptMailItem(Bin),
            messageOn:on_RequestAcceptMailItem(Socket, Data);
        ?CMD_MailReadNotice->
            {Data, _, _} = binary_read_MailReadNotice(Bin),
            messageOn:on_MailReadNotice(Socket, Data);
        ?CMD_RequestDeleteMail->
            {Data, _, _} = binary_read_RequestDeleteMail(Bin),
            messageOn:on_RequestDeleteMail(Socket, Data);
        ?CMD_RequestDeleteReadMail->
            {Data, _, _} = binary_read_RequestDeleteReadMail(Bin),
            messageOn:on_RequestDeleteReadMail(Socket, Data);
        ?CMD_RequestSystemMail->
            {Data, _, _} = binary_read_RequestSystemMail(Bin),
            messageOn:on_RequestSystemMail(Socket, Data);
        ?CMD_U2GS_RequestLogin->
            {Data, _, _} = binary_read_U2GS_RequestLogin(Bin),
            messageOn:on_U2GS_RequestLogin(Socket, Data);
        ?CMD_U2GS_SelPlayerEnterGame->
            {Data, _, _} = binary_read_U2GS_SelPlayerEnterGame(Bin),
            messageOn:on_U2GS_SelPlayerEnterGame(Socket, Data);
        ?CMD_U2GS_RequestCreatePlayer->
            {Data, _, _} = binary_read_U2GS_RequestCreatePlayer(Bin),
            messageOn:on_U2GS_RequestCreatePlayer(Socket, Data);
        ?CMD_U2GS_RequestDeletePlayer->
            {Data, _, _} = binary_read_U2GS_RequestDeletePlayer(Bin),
            messageOn:on_U2GS_RequestDeletePlayer(Socket, Data);
        ?CMD_ConSales_GroundingItem->
            {Data, _, _} = binary_read_ConSales_GroundingItem(Bin),
            messageOn:on_ConSales_GroundingItem(Socket, Data);
        ?CMD_ConSales_TakeDown->
            {Data, _, _} = binary_read_ConSales_TakeDown(Bin),
            messageOn:on_ConSales_TakeDown(Socket, Data);
        ?CMD_ConSales_BuyItem->
            {Data, _, _} = binary_read_ConSales_BuyItem(Bin),
            messageOn:on_ConSales_BuyItem(Socket, Data);
        ?CMD_ConSales_FindItems->
            {Data, _, _} = binary_read_ConSales_FindItems(Bin),
            messageOn:on_ConSales_FindItems(Socket, Data);
        ?CMD_ConSales_TrunPage->
            {Data, _, _} = binary_read_ConSales_TrunPage(Bin),
            messageOn:on_ConSales_TrunPage(Socket, Data);
        ?CMD_ConSales_Close->
            {Data, _, _} = binary_read_ConSales_Close(Bin),
            messageOn:on_ConSales_Close(Socket, Data);
        ?CMD_ConSales_GetSelfSell->
            {Data, _, _} = binary_read_ConSales_GetSelfSell(Bin),
            messageOn:on_ConSales_GetSelfSell(Socket, Data);
        ?CMD_TradeAsk->
            {Data, _, _} = binary_read_TradeAsk(Bin),
            messageOn:on_TradeAsk(Socket, Data);
        ?CMD_TradeAskResult->
            {Data, _, _} = binary_read_TradeAskResult(Bin),
            messageOn:on_TradeAskResult(Socket, Data);
        ?CMD_TradeInputItem_C2S->
            {Data, _, _} = binary_read_TradeInputItem_C2S(Bin),
            messageOn:on_TradeInputItem_C2S(Socket, Data);
        ?CMD_TradeTakeOutItem_C2S->
            {Data, _, _} = binary_read_TradeTakeOutItem_C2S(Bin),
            messageOn:on_TradeTakeOutItem_C2S(Socket, Data);
        ?CMD_TradeChangeMoney_C2S->
            {Data, _, _} = binary_read_TradeChangeMoney_C2S(Bin),
            messageOn:on_TradeChangeMoney_C2S(Socket, Data);
        ?CMD_TradeLock_C2S->
            {Data, _, _} = binary_read_TradeLock_C2S(Bin),
            messageOn:on_TradeLock_C2S(Socket, Data);
        ?CMD_CancelTrade_C2S->
            {Data, _, _} = binary_read_CancelTrade_C2S(Bin),
            messageOn:on_CancelTrade_C2S(Socket, Data);
        ?CMD_TradeAffirm_C2S->
            {Data, _, _} = binary_read_TradeAffirm_C2S(Bin),
            messageOn:on_TradeAffirm_C2S(Socket, Data);
        ?CMD_PetOutFight->
            {Data, _, _} = binary_read_PetOutFight(Bin),
            messageOn:on_PetOutFight(Socket, Data);
        ?CMD_PetTakeRest->
            {Data, _, _} = binary_read_PetTakeRest(Bin),
            messageOn:on_PetTakeRest(Socket, Data);
        ?CMD_PetFreeCaptiveAnimals->
            {Data, _, _} = binary_read_PetFreeCaptiveAnimals(Bin),
            messageOn:on_PetFreeCaptiveAnimals(Socket, Data);
        ?CMD_PetCompoundModel->
            {Data, _, _} = binary_read_PetCompoundModel(Bin),
            messageOn:on_PetCompoundModel(Socket, Data);
        ?CMD_PetWashGrowUpValue->
            {Data, _, _} = binary_read_PetWashGrowUpValue(Bin),
            messageOn:on_PetWashGrowUpValue(Socket, Data);
        ?CMD_PetReplaceGrowUpValue->
            {Data, _, _} = binary_read_PetReplaceGrowUpValue(Bin),
            messageOn:on_PetReplaceGrowUpValue(Socket, Data);
        ?CMD_PetIntensifySoul->
            {Data, _, _} = binary_read_PetIntensifySoul(Bin),
            messageOn:on_PetIntensifySoul(Socket, Data);
        ?CMD_PetOneKeyIntensifySoul->
            {Data, _, _} = binary_read_PetOneKeyIntensifySoul(Bin),
            messageOn:on_PetOneKeyIntensifySoul(Socket, Data);
        ?CMD_PetFuse->
            {Data, _, _} = binary_read_PetFuse(Bin),
            messageOn:on_PetFuse(Socket, Data);
        ?CMD_ChangePetAIState->
            {Data, _, _} = binary_read_ChangePetAIState(Bin),
            messageOn:on_ChangePetAIState(Socket, Data);
        ?CMD_PetLearnSkill->
            {Data, _, _} = binary_read_PetLearnSkill(Bin),
            messageOn:on_PetLearnSkill(Socket, Data);
        ?CMD_PetDelSkill->
            {Data, _, _} = binary_read_PetDelSkill(Bin),
            messageOn:on_PetDelSkill(Socket, Data);
        ?CMD_PetUnLockSkillCell->
            {Data, _, _} = binary_read_PetUnLockSkillCell(Bin),
            messageOn:on_PetUnLockSkillCell(Socket, Data);
        ?CMD_PetSkillSealAhs->
            {Data, _, _} = binary_read_PetSkillSealAhs(Bin),
            messageOn:on_PetSkillSealAhs(Socket, Data);
        ?CMD_PetlearnSealAhsSkill->
            {Data, _, _} = binary_read_PetlearnSealAhsSkill(Bin),
            messageOn:on_PetlearnSealAhsSkill(Socket, Data);
        ?CMD_RequestGetPlayerEquipEnhanceByType->
            {Data, _, _} = binary_read_RequestGetPlayerEquipEnhanceByType(Bin),
            messageOn:on_RequestGetPlayerEquipEnhanceByType(Socket, Data);
        ?CMD_RequestEquipEnhanceByType->
            {Data, _, _} = binary_read_RequestEquipEnhanceByType(Bin),
            messageOn:on_RequestEquipEnhanceByType(Socket, Data);
        ?CMD_RequestEquipOnceEnhanceByType->
            {Data, _, _} = binary_read_RequestEquipOnceEnhanceByType(Bin),
            messageOn:on_RequestEquipOnceEnhanceByType(Socket, Data);
        ?CMD_RequestGetPlayerEquipQualityByType->
            {Data, _, _} = binary_read_RequestGetPlayerEquipQualityByType(Bin),
            messageOn:on_RequestGetPlayerEquipQualityByType(Socket, Data);
        ?CMD_RequestEquipQualityUPByType->
            {Data, _, _} = binary_read_RequestEquipQualityUPByType(Bin),
            messageOn:on_RequestEquipQualityUPByType(Socket, Data);
        ?CMD_RequestEquipOldPropertyByType->
            {Data, _, _} = binary_read_RequestEquipOldPropertyByType(Bin),
            messageOn:on_RequestEquipOldPropertyByType(Socket, Data);
        ?CMD_RequestEquipChangePropertyByType->
            {Data, _, _} = binary_read_RequestEquipChangePropertyByType(Bin),
            messageOn:on_RequestEquipChangePropertyByType(Socket, Data);
        ?CMD_RequestEquipSaveNewPropertyByType->
            {Data, _, _} = binary_read_RequestEquipSaveNewPropertyByType(Bin),
            messageOn:on_RequestEquipSaveNewPropertyByType(Socket, Data);
        ?CMD_U2GS_EnterCopyMapRequest->
            {Data, _, _} = binary_read_U2GS_EnterCopyMapRequest(Bin),
            messageOn:on_U2GS_EnterCopyMapRequest(Socket, Data);
        ?CMD_U2GS_QueryMyCopyMapCD->
            {Data, _, _} = binary_read_U2GS_QueryMyCopyMapCD(Bin),
            messageOn:on_U2GS_QueryMyCopyMapCD(Socket, Data);
        ?CMD_U2GS_TransByWorldMap->
            {Data, _, _} = binary_read_U2GS_TransByWorldMap(Bin),
            messageOn:on_U2GS_TransByWorldMap(Socket, Data);
        ?CMD_U2GS_TransForSameScence->
            {Data, _, _} = binary_read_U2GS_TransForSameScence(Bin),
            messageOn:on_U2GS_TransForSameScence(Socket, Data);
        ?CMD_U2GS_FastTeamCopyMapRequest->
            {Data, _, _} = binary_read_U2GS_FastTeamCopyMapRequest(Bin),
            messageOn:on_U2GS_FastTeamCopyMapRequest(Socket, Data);
        ?CMD_U2GS_RestCopyMapRequest->
            {Data, _, _} = binary_read_U2GS_RestCopyMapRequest(Bin),
            messageOn:on_U2GS_RestCopyMapRequest(Socket, Data);
        ?CMD_U2GS_QieCuoInvite->
            {Data, _, _} = binary_read_U2GS_QieCuoInvite(Bin),
            messageOn:on_U2GS_QieCuoInvite(Socket, Data);
        ?CMD_U2GS_QieCuoInviteAck->
            {Data, _, _} = binary_read_U2GS_QieCuoInviteAck(Bin),
            messageOn:on_U2GS_QieCuoInviteAck(Socket, Data);
        ?CMD_U2GS_PK_KillOpenRequest->
            {Data, _, _} = binary_read_U2GS_PK_KillOpenRequest(Bin),
            messageOn:on_U2GS_PK_KillOpenRequest(Socket, Data);
        ?CMD_U2GS_BloodPoolAddLife->
            {Data, _, _} = binary_read_U2GS_BloodPoolAddLife(Bin),
            messageOn:on_U2GS_BloodPoolAddLife(Socket, Data);
        ?CMD_U2GS_GetSigninInfo->
            {Data, _, _} = binary_read_U2GS_GetSigninInfo(Bin),
            messageOn:on_U2GS_GetSigninInfo(Socket, Data);
        ?CMD_U2GS_Signin->
            {Data, _, _} = binary_read_U2GS_Signin(Bin),
            messageOn:on_U2GS_Signin(Socket, Data);
        ?CMD_U2GS_LeaveCopyMap->
            {Data, _, _} = binary_read_U2GS_LeaveCopyMap(Bin),
            messageOn:on_U2GS_LeaveCopyMap(Socket, Data);
        ?CMD_PetChangeName->
            {Data, _, _} = binary_read_PetChangeName(Bin),
            messageOn:on_PetChangeName(Socket, Data);
        ?CMD_BazzarListRequest->
            {Data, _, _} = binary_read_BazzarListRequest(Bin),
            messageOn:on_BazzarListRequest(Socket, Data);
        ?CMD_BazzarBuyRequest->
            {Data, _, _} = binary_read_BazzarBuyRequest(Bin),
            messageOn:on_BazzarBuyRequest(Socket, Data);
        ?CMD_U2GS_RemoveSkillBranch->
            {Data, _, _} = binary_read_U2GS_RemoveSkillBranch(Bin),
            messageOn:on_U2GS_RemoveSkillBranch(Socket, Data);
        ?CMD_U2GS_PetBloodPoolAddLife->
            {Data, _, _} = binary_read_U2GS_PetBloodPoolAddLife(Bin),
            messageOn:on_U2GS_PetBloodPoolAddLife(Socket, Data);
        ?CMD_U2GS_CopyMapAddActiveCount->
            {Data, _, _} = binary_read_U2GS_CopyMapAddActiveCount(Bin),
            messageOn:on_U2GS_CopyMapAddActiveCount(Socket, Data);
        ?CMD_U2GS_CarriageQualityRefresh->
            {Data, _, _} = binary_read_U2GS_CarriageQualityRefresh(Bin),
            messageOn:on_U2GS_CarriageQualityRefresh(Socket, Data);
        ?CMD_U2GS_ConvoyCDRequst->
            {Data, _, _} = binary_read_U2GS_ConvoyCDRequst(Bin),
            messageOn:on_U2GS_ConvoyCDRequst(Socket, Data);
        ?CMD_U2GS_BeginConvoy->
            {Data, _, _} = binary_read_U2GS_BeginConvoy(Bin),
            messageOn:on_U2GS_BeginConvoy(Socket, Data);
        ?CMD_GSWithU_GameSetMenu->
            {Data, _, _} = binary_read_GSWithU_GameSetMenu(Bin),
            messageOn:on_GSWithU_GameSetMenu(Socket, Data);
        ?CMD_U2GS_RequestRechargeGift->
            {Data, _, _} = binary_read_U2GS_RequestRechargeGift(Bin),
            messageOn:on_U2GS_RequestRechargeGift(Socket, Data);
        ?CMD_U2GS_RequestPlayerFightingCapacity->
            {Data, _, _} = binary_read_U2GS_RequestPlayerFightingCapacity(Bin),
            messageOn:on_U2GS_RequestPlayerFightingCapacity(Socket, Data);
        ?CMD_U2GS_RequestPetFightingCapacity->
            {Data, _, _} = binary_read_U2GS_RequestPetFightingCapacity(Bin),
            messageOn:on_U2GS_RequestPetFightingCapacity(Socket, Data);
        ?CMD_U2GS_RequestMountFightingCapacity->
            {Data, _, _} = binary_read_U2GS_RequestMountFightingCapacity(Bin),
            messageOn:on_U2GS_RequestMountFightingCapacity(Socket, Data);
        ?CMD_U2GS_GetRankList->
            {Data, _, _} = binary_read_U2GS_GetRankList(Bin),
            messageOn:on_U2GS_GetRankList(Socket, Data);
        ?CMD_U2GS_ChangePlayerName->
            {Data, _, _} = binary_read_U2GS_ChangePlayerName(Bin),
            messageOn:on_U2GS_ChangePlayerName(Socket, Data);
        ?CMD_U2GS_SetProtectPwd->
            {Data, _, _} = binary_read_U2GS_SetProtectPwd(Bin),
            messageOn:on_U2GS_SetProtectPwd(Socket, Data);
        ?CMD_U2GS_HeartBeat->
            {Data, _, _} = binary_read_U2GS_HeartBeat(Bin),
            messageOn:on_U2GS_HeartBeat(Socket, Data);
        ?CMD_U2GS_QequestGiveGoldCheck->
            {Data, _, _} = binary_read_U2GS_QequestGiveGoldCheck(Bin),
            messageOn:on_U2GS_QequestGiveGoldCheck(Socket, Data);
        ?CMD_U2GS_StartGiveGold->
            {Data, _, _} = binary_read_U2GS_StartGiveGold(Bin),
            messageOn:on_U2GS_StartGiveGold(Socket, Data);
        ?CMD_RequestLookPlayer->
            {Data, _, _} = binary_read_RequestLookPlayer(Bin),
            messageOn:on_RequestLookPlayer(Socket, Data);
        ?CMD_U2GS_PlayerClientInfo->
            {Data, _, _} = binary_read_U2GS_PlayerClientInfo(Bin),
            messageOn:on_U2GS_PlayerClientInfo(Socket, Data);
        ?CMD_U2GS_RequestActiveCount->
            {Data, _, _} = binary_read_U2GS_RequestActiveCount(Bin),
            messageOn:on_U2GS_RequestActiveCount(Socket, Data);
        ?CMD_U2GS_RequestConvertActive->
            {Data, _, _} = binary_read_U2GS_RequestConvertActive(Bin),
            messageOn:on_U2GS_RequestConvertActive(Socket, Data);
        ?CMD_U2GS_TransferOldRechargeToPlayer->
            {Data, _, _} = binary_read_U2GS_TransferOldRechargeToPlayer(Bin),
            messageOn:on_U2GS_TransferOldRechargeToPlayer(Socket, Data);
        ?CMD_PlayerImportPassWord->
            {Data, _, _} = binary_read_PlayerImportPassWord(Bin),
            messageOn:on_PlayerImportPassWord(Socket, Data);
        ?CMD_U2GS_RequestBazzarItemPrice->
            {Data, _, _} = binary_read_U2GS_RequestBazzarItemPrice(Bin),
            messageOn:on_U2GS_RequestBazzarItemPrice(Socket, Data);
        ?CMD_RequestChangeGoldPassWord->
            {Data, _, _} = binary_read_RequestChangeGoldPassWord(Bin),
            messageOn:on_RequestChangeGoldPassWord(Socket, Data);
        ?CMD_VIPPlayerOpenVIPStoreRequest->
            {Data, _, _} = binary_read_VIPPlayerOpenVIPStoreRequest(Bin),
            messageOn:on_VIPPlayerOpenVIPStoreRequest(Socket, Data);
        ?CMD_ActiveCodeRequest->
            {Data, _, _} = binary_read_ActiveCodeRequest(Bin),
            messageOn:on_ActiveCodeRequest(Socket, Data);
        ?CMD_U2GS_RequestOutFightPetPropetry->
            {Data, _, _} = binary_read_U2GS_RequestOutFightPetPropetry(Bin),
            messageOn:on_U2GS_RequestOutFightPetPropetry(Socket, Data);
        ?CMD_PlayerDirMove->
            {Data, _, _} = binary_read_PlayerDirMove(Bin),
            messageOn:on_PlayerDirMove(Socket, Data);
        ?CMD_U2GS_EnRollCampusBattle->
            {Data, _, _} = binary_read_U2GS_EnRollCampusBattle(Bin),
            messageOn:on_U2GS_EnRollCampusBattle(Socket, Data);
        ?CMD_GSWithU_GameSetMenu_3->
            {Data, _, _} = binary_read_GSWithU_GameSetMenu_3(Bin),
            messageOn:on_GSWithU_GameSetMenu_3(Socket, Data);
        ?CMD_StartCompound->
            {Data, _, _} = binary_read_StartCompound(Bin),
            messageOn:on_StartCompound(Socket, Data);
        ?CMD_RequestEquipFastUpQuality->
            {Data, _, _} = binary_read_RequestEquipFastUpQuality(Bin),
            messageOn:on_RequestEquipFastUpQuality(Socket, Data);
        ?CMD_PlayerTeleportMove->
            {Data, _, _} = binary_read_PlayerTeleportMove(Bin),
            messageOn:on_PlayerTeleportMove(Socket, Data);
        ?CMD_U2GS_leaveCampusBattle->
            {Data, _, _} = binary_read_U2GS_leaveCampusBattle(Bin),
            messageOn:on_U2GS_leaveCampusBattle(Socket, Data);
        ?CMD_U2GS_LeaveBattleScene->
            {Data, _, _} = binary_read_U2GS_LeaveBattleScene(Bin),
            messageOn:on_U2GS_LeaveBattleScene(Socket, Data);
        ?CMD_U2GS_requestEnrollInfo->
            {Data, _, _} = binary_read_U2GS_requestEnrollInfo(Bin),
            messageOn:on_U2GS_requestEnrollInfo(Socket, Data);
        ?CMD_U2GS_SureEnterBattle->
            {Data, _, _} = binary_read_U2GS_SureEnterBattle(Bin),
            messageOn:on_U2GS_SureEnterBattle(Socket, Data);
        ?CMD_U2GS_RequestBattleResultList->
            {Data, _, _} = binary_read_U2GS_RequestBattleResultList(Bin),
            messageOn:on_U2GS_RequestBattleResultList(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
