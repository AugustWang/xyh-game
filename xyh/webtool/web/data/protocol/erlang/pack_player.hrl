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

-define(CMD_CharProperty, 701).
-define(CMD_ObjectBuff, 702).
-define(CMD_PlayerBaseInfo, 703).
-define(CMD_rideInfo, 704).
-define(CMD_LookInfoPlayer, 705).
-define(CMD_LookInfoPlayerList, 706).
-define(CMD_LookInfoPet, 707).
-define(CMD_LookInfoPetList, 708).
-define(CMD_LookInfoMonster, 709).
-define(CMD_LookInfoMonsterList, 710).
-define(CMD_LookInfoNpc, 711).
-define(CMD_LookInfoNpcList, 712).
-define(CMD_LookInfoObject, 713).
-define(CMD_LookInfoObjectList, 714).
-define(CMD_ActorDisapearList, 715).
-define(CMD_PosInfo, 716).
-define(CMD_PlayerMoveTo, 717).
-define(CMD_PlayerStopMove, 718).
-define(CMD_PlayerStopMove_S2C, 719).
-define(CMD_MoveInfo, 720).
-define(CMD_PlayerMoveInfo, 721).
-define(CMD_ChangeFlyState, 722).
-define(CMD_ChangeFlyState_S2C, 723).
-define(CMD_MonsterMoveInfo, 724).
-define(CMD_MonsterStopMove, 725).
-define(CMD_PetMoveInfo, 726).
-define(CMD_PetStopMove, 727).
-define(CMD_ChangeMap, 728).
-define(CMD_CollectFail, 729).
-define(CMD_RequestGM, 730).
-define(CMD_PlayerPropertyChangeValue, 731).
-define(CMD_PlayerPropertyChanged, 732).
-define(CMD_PlayerMoneyChanged, 733).
-define(CMD_PlayerKickOuted, 734).
-define(CMD_ActorStateFlagSet, 735).
-define(CMD_ActorStateFlagSet_Broad, 736).
-define(CMD_PlayerSkillInitData, 737).
-define(CMD_PlayerSkillInitInfo, 738).
-define(CMD_U2GS_StudySkill, 739).
-define(CMD_GS2U_StudySkillResult, 740).
-define(CMD_activeBranchID, 741).
-define(CMD_activeBranchIDResult, 742).
-define(CMD_U2GS_AddSkillBranch, 743).
-define(CMD_GS2U_AddSkillBranchAck, 744).
-define(CMD_U2GS_UseSkillRequest, 745).
-define(CMD_GS2U_UseSkillToObject, 746).
-define(CMD_GS2U_UseSkillToPos, 747).
-define(CMD_GS2U_AttackDamage, 748).
-define(CMD_GS2U_CharactorDead, 749).
-define(CMD_GS2U_AttackMiss, 750).
-define(CMD_GS2U_AttackDodge, 751).
-define(CMD_GS2U_AttackCrit, 752).
-define(CMD_GS2U_AttackBlock, 753).
-define(CMD_PlayerAllShortcut, 754).
-define(CMD_ShortcutSet, 755).
-define(CMD_PlayerEXPChanged, 756).
-define(CMD_ActorLifeUpdate, 757).
-define(CMD_ActorMoveSpeedUpdate, 758).
-define(CMD_PlayerCombatIDInit, 759).
-define(CMD_GS2U_CharactorRevived, 760).
-define(CMD_U2GS_InteractObject, 761).
-define(CMD_U2GS_QueryHeroProperty, 762).
-define(CMD_CharPropertyData, 763).
-define(CMD_GS2U_HeroPropertyResult, 764).
-define(CMD_ItemInfo, 765).
-define(CMD_PlayerBagInit, 766).
-define(CMD_PlayerGetItem, 767).
-define(CMD_PlayerDestroyItem, 768).
-define(CMD_PlayerItemLocationCellChanged, 769).
-define(CMD_RequestDestroyItem, 770).
-define(CMD_RequestGetItem, 771).
-define(CMD_PlayerItemAmountChanged, 772).
-define(CMD_PlayerItemParamChanged, 773).
-define(CMD_PlayerBagOrderData, 774).
-define(CMD_RequestPlayerBagOrder, 775).
-define(CMD_PlayerBagOrderResult, 776).
-define(CMD_PlayerRequestUseItem, 777).
-define(CMD_PlayerUseItemResult, 778).
-define(CMD_RequestPlayerBagCellOpen, 779).
-define(CMD_RequestChangeStorageBagPassWord, 780).
-define(CMD_PlayerStorageBagPassWordChanged, 781).
-define(CMD_PlayerBagCellEnableChanged, 782).
-define(CMD_RequestPlayerBagSellItem, 783).
-define(CMD_RequestClearTempBag, 784).
-define(CMD_RequestMoveTempBagItem, 785).
-define(CMD_RequestMoveAllTempBagItem, 786).
-define(CMD_RequestMoveStorageBagItem, 787).
-define(CMD_RequestMoveBagItemToStorage, 788).
-define(CMD_RequestUnlockingStorageBagPassWord, 789).
-define(CMD_RequestCancelUnlockingStorageBagPassWord, 790).
-define(CMD_PlayerUnlockTimesChanged, 791).
-define(CMD_ItemBagCellSetData, 792).
-define(CMD_ItemBagCellSet, 793).
-define(CMD_NpcStoreItemData, 794).
-define(CMD_RequestGetNpcStoreItemList, 795).
-define(CMD_GetNpcStoreItemListAck, 796).
-define(CMD_RequestBuyItem, 797).
-define(CMD_BuyItemAck, 798).
-define(CMD_RequestSellItem, 799).
-define(CMD_GetNpcStoreBackBuyItemList, 800).
-define(CMD_GetNpcStoreBackBuyItemListAck, 801).
-define(CMD_RequestBackBuyItem, 802).
-define(CMD_PlayerEquipNetData, 803).
-define(CMD_PlayerEquipInit, 804).
-define(CMD_RequestPlayerEquipActive, 805).
-define(CMD_PlayerEquipActiveResult, 806).
-define(CMD_RequestPlayerEquipPutOn, 807).
-define(CMD_PlayerEquipPutOnResult, 808).
-define(CMD_RequestQueryPlayerEquip, 809).
-define(CMD_QueryPlayerEquipResult, 810).
-define(CMD_StudySkill, 811).
-define(CMD_StudyResult, 812).
-define(CMD_Reborn, 813).
-define(CMD_RebornAck, 814).
-define(CMD_Chat2Player, 815).
-define(CMD_Chat2Server, 816).
-define(CMD_Chat_Error_Result, 817).
-define(CMD_RequestSendMail, 818).
-define(CMD_RequestSendMailAck, 819).
-define(CMD_RequestRecvMail, 820).
-define(CMD_RequestUnReadMail, 821).
-define(CMD_RequestUnReadMailAck, 822).
-define(CMD_RequestMailList, 823).
-define(CMD_MailInfo, 824).
-define(CMD_RequestMailListAck, 825).
-define(CMD_RequestMailItemInfo, 826).
-define(CMD_RequestMailItemInfoAck, 827).
-define(CMD_RequestAcceptMailItem, 828).
-define(CMD_RequestAcceptMailItemAck, 829).
-define(CMD_MailReadNotice, 830).
-define(CMD_RequestDeleteMail, 831).
-define(CMD_InformNewMail, 832).
-define(CMD_RequestDeleteReadMail, 833).
-define(CMD_RequestSystemMail, 834).
-define(CMD_U2GS_RequestLogin, 835).
-define(CMD_U2GS_SelPlayerEnterGame, 836).
-define(CMD_U2GS_RequestCreatePlayer, 837).
-define(CMD_U2GS_RequestDeletePlayer, 838).
-define(CMD_GS2U_LoginResult, 839).
-define(CMD_GS2U_SelPlayerResult, 840).
-define(CMD_UserPlayerData, 841).
-define(CMD_GS2U_UserPlayerList, 842).
-define(CMD_GS2U_CreatePlayerResult, 843).
-define(CMD_GS2U_DeletePlayerResult, 844).
-define(CMD_ConSales_GroundingItem, 845).
-define(CMD_ConSales_GroundingItem_Result, 846).
-define(CMD_ConSales_TakeDown, 847).
-define(CMD_ConSales_TakeDown_Result, 848).
-define(CMD_ConSales_BuyItem, 849).
-define(CMD_ConSales_BuyItem_Result, 850).
-define(CMD_ConSales_FindItems, 851).
-define(CMD_ConSalesItem, 852).
-define(CMD_ConSales_FindItems_Result, 853).
-define(CMD_ConSales_TrunPage, 854).
-define(CMD_ConSales_Close, 855).
-define(CMD_ConSales_GetSelfSell, 856).
-define(CMD_ConSales_GetSelfSell_Result, 857).
-define(CMD_TradeAsk, 858).
-define(CMD_TradeAskResult, 859).
-define(CMD_CreateTrade, 860).
-define(CMD_TradeInputItem_C2S, 861).
-define(CMD_TradeInputItemResult_S2C, 862).
-define(CMD_TradeInputItem_S2C, 863).
-define(CMD_TradeTakeOutItem_C2S, 864).
-define(CMD_TradeTakeOutItemResult_S2C, 865).
-define(CMD_TradeTakeOutItem_S2C, 866).
-define(CMD_TradeChangeMoney_C2S, 867).
-define(CMD_TradeChangeMoneyResult_S2C, 868).
-define(CMD_TradeChangeMoney_S2C, 869).
-define(CMD_TradeLock_C2S, 870).
-define(CMD_TradeLock_S2C, 871).
-define(CMD_CancelTrade_S2C, 872).
-define(CMD_CancelTrade_C2S, 873).
-define(CMD_TradeAffirm_C2S, 874).
-define(CMD_TradeAffirm_S2C, 875).
-define(CMD_PetSkill, 876).
-define(CMD_PetProperty, 877).
-define(CMD_PlayerPetInfo, 878).
-define(CMD_UpdatePetProerty, 879).
-define(CMD_DelPet, 880).
-define(CMD_PetOutFight, 881).
-define(CMD_PetOutFight_Result, 882).
-define(CMD_PetTakeRest, 883).
-define(CMD_PetTakeRest_Result, 884).
-define(CMD_PetFreeCaptiveAnimals, 885).
-define(CMD_PetFreeCaptiveAnimals_Result, 886).
-define(CMD_PetCompoundModel, 887).
-define(CMD_PetCompoundModel_Result, 888).
-define(CMD_PetWashGrowUpValue, 889).
-define(CMD_PetWashGrowUpValue_Result, 890).
-define(CMD_PetReplaceGrowUpValue, 891).
-define(CMD_PetReplaceGrowUpValue_Result, 892).
-define(CMD_PetIntensifySoul, 893).
-define(CMD_PetIntensifySoul_Result, 894).
-define(CMD_PetOneKeyIntensifySoul, 895).
-define(CMD_PetOneKeyIntensifySoul_Result, 896).
-define(CMD_PetFuse, 897).
-define(CMD_PetFuse_Result, 898).
-define(CMD_PetJumpTo, 899).
-define(CMD_ActorSetPos, 900).
-define(CMD_PetTakeBack, 901).
-define(CMD_ChangePetAIState, 902).
-define(CMD_PetExpChanged, 903).
-define(CMD_PetLearnSkill, 904).
-define(CMD_PetLearnSkill_Result, 905).
-define(CMD_PetDelSkill, 906).
-define(CMD_PetDelSkill_Result, 907).
-define(CMD_PetUnLockSkillCell, 908).
-define(CMD_PetUnLoctSkillCell_Result, 909).
-define(CMD_PetSkillSealAhs, 910).
-define(CMD_PetSkillSealAhs_Result, 911).
-define(CMD_PetUpdateSealAhsStore, 912).
-define(CMD_PetlearnSealAhsSkill, 913).
-define(CMD_PetlearnSealAhsSkill_Result, 914).
-define(CMD_RequestGetPlayerEquipEnhanceByType, 915).
-define(CMD_GetPlayerEquipEnhanceByTypeBack, 916).
-define(CMD_RequestEquipEnhanceByType, 917).
-define(CMD_EquipEnhanceByTypeBack, 918).
-define(CMD_RequestEquipOnceEnhanceByType, 919).
-define(CMD_EquipOnceEnhanceByTypeBack, 920).
-define(CMD_RequestGetPlayerEquipQualityByType, 921).
-define(CMD_GetPlayerEquipQualityByTypeBack, 922).
-define(CMD_RequestEquipQualityUPByType, 923).
-define(CMD_EquipQualityUPByTypeBack, 924).
-define(CMD_RequestEquipOldPropertyByType, 925).
-define(CMD_GetEquipOldPropertyByType, 926).
-define(CMD_RequestEquipChangePropertyByType, 927).
-define(CMD_GetEquipNewPropertyByType, 928).
-define(CMD_RequestEquipSaveNewPropertyByType, 929).
-define(CMD_RequestEquipChangeAddSavePropertyByType, 930).
-define(CMD_U2GS_EnterCopyMapRequest, 931).
-define(CMD_GS2U_EnterMapResult, 932).
-define(CMD_U2GS_QueryMyCopyMapCD, 933).
-define(CMD_MyCopyMapCDInfo, 934).
-define(CMD_GS2U_MyCopyMapCDInfo, 935).
-define(CMD_AddBuff, 936).
-define(CMD_DelBuff, 937).
-define(CMD_UpdateBuff, 938).
-define(CMD_HeroBuffList, 939).
-define(CMD_U2GS_TransByWorldMap, 940).
-define(CMD_U2GS_TransForSameScence, 941).
-define(CMD_U2GS_FastTeamCopyMapRequest, 942).
-define(CMD_GS2U_FastTeamCopyMapResult, 943).
-define(CMD_GS2U_TeamCopyMapQuery, 944).
-define(CMD_U2GS_RestCopyMapRequest, 945).
-define(CMD_GS2U_AddOrRemoveHatred, 946).
-define(CMD_U2GS_QieCuoInvite, 947).
-define(CMD_GS2U_QieCuoInviteQuery, 948).
-define(CMD_U2GS_QieCuoInviteAck, 949).
-define(CMD_GS2U_QieCuoInviteResult, 950).
-define(CMD_GS2U_QieCuoResult, 951).
-define(CMD_U2GS_PK_KillOpenRequest, 952).
-define(CMD_GS2U_PK_KillOpenResult, 953).
-define(CMD_GS2U_Player_ChangeEquipResult, 954).
-define(CMD_SysMessage, 955).
-define(CMD_GS2U_AddLifeByItem, 956).
-define(CMD_GS2U_AddLifeBySkill, 957).
-define(CMD_PlayerItemCDInfo, 958).
-define(CMD_GS2U_PlayerItemCDInit, 959).
-define(CMD_GS2U_PlayerItemCDUpdate, 960).
-define(CMD_U2GS_BloodPoolAddLife, 961).
-define(CMD_GS2U_ItemDailyCount, 962).
-define(CMD_U2GS_GetSigninInfo, 963).
-define(CMD_GS2U_PlayerSigninInfo, 964).
-define(CMD_U2GS_Signin, 965).
-define(CMD_GS2U_PlayerSignInResult, 966).
-define(CMD_U2GS_LeaveCopyMap, 967).
-define(CMD_PetChangeModel, 968).
-define(CMD_PetChangeName, 969).
-define(CMD_PetChangeName_Result, 970).
-define(CMD_BazzarItem, 971).
-define(CMD_BazzarListRequest, 972).
-define(CMD_BazzarPriceItemList, 973).
-define(CMD_BazzarItemList, 974).
-define(CMD_BazzarItemUpdate, 975).
-define(CMD_BazzarBuyRequest, 976).
-define(CMD_BazzarBuyResult, 977).
-define(CMD_PlayerBagCellOpenResult, 978).
-define(CMD_U2GS_RemoveSkillBranch, 979).
-define(CMD_GS2U_RemoveSkillBranch, 980).
-define(CMD_U2GS_PetBloodPoolAddLife, 981).
-define(CMD_U2GS_CopyMapAddActiveCount, 982).
-define(CMD_U2GS_CopyMapAddActiveCountResult, 983).
-define(CMD_GS2U_CurConvoyInfo, 984).
-define(CMD_U2GS_CarriageQualityRefresh, 985).
-define(CMD_GS2U_CarriageQualityRefreshResult, 986).
-define(CMD_U2GS_ConvoyCDRequst, 987).
-define(CMD_GS2U_ConvoyCDResult, 988).
-define(CMD_U2GS_BeginConvoy, 989).
-define(CMD_GS2U_BeginConvoyResult, 990).
-define(CMD_GS2U_FinishConvoyResult, 991).
-define(CMD_GS2U_GiveUpConvoyResult, 992).
-define(CMD_GS2U_ConvoyNoticeTimerResult, 993).
-define(CMD_GS2U_ConvoyState, 994).
-define(CMD_GSWithU_GameSetMenu, 995).
-define(CMD_U2GS_RequestRechargeGift, 996).
-define(CMD_U2GS_RequestRechargeGift_Ret, 997).
-define(CMD_U2GS_RequestPlayerFightingCapacity, 998).
-define(CMD_U2GS_RequestPlayerFightingCapacity_Ret, 999).
-define(CMD_U2GS_RequestPetFightingCapacity, 1000).
-define(CMD_U2GS_RequestPetFightingCapacity_Ret, 1001).
-define(CMD_U2GS_RequestMountFightingCapacity, 1002).
-define(CMD_U2GS_RequestMountFightingCapacity_Ret, 1003).
-define(CMD_VariantData, 1004).
-define(CMD_GS2U_VariantDataSet, 1005).
-define(CMD_U2GS_GetRankList, 1006).
-define(CMD_GS2U_RankList, 1007).
-define(CMD_GS2U_WordBossCmd, 1008).
-define(CMD_U2GS_ChangePlayerName, 1009).
-define(CMD_GS2U_ChangePlayerNameResult, 1010).
-define(CMD_U2GS_SetProtectPwd, 1011).
-define(CMD_GS2U_SetProtectPwdResult, 1012).
-define(CMD_U2GS_HeartBeat, 1013).
-define(CMD_GS2U_CopyProgressUpdate, 1014).
-define(CMD_U2GS_QequestGiveGoldCheck, 1015).
-define(CMD_U2GS_StartGiveGold, 1016).
-define(CMD_U2GS_StartGiveGoldResult, 1017).
-define(CMD_U2GS_GoldLineInfo, 1018).
-define(CMD_U2GS_GoldResetTimer, 1019).
-define(CMD_GS2U_CopyMapSAData, 1020).
-define(CMD_TokenStoreItemData, 1021).
-define(CMD_GetTokenStoreItemListAck, 1022).
-define(CMD_RequestLookPlayer, 1023).
-define(CMD_RequestLookPlayer_Result, 1024).
-define(CMD_RequestLookPlayerFailed_Result, 1025).
-define(CMD_U2GS_PlayerClientInfo, 1026).
-define(CMD_U2GS_RequestActiveCount, 1027).
-define(CMD_ActiveCountData, 1028).
-define(CMD_GS2U_ActiveCount, 1029).
-define(CMD_U2GS_RequestConvertActive, 1030).
-define(CMD_GS2U_WhetherTransferOldRecharge, 1031).
-define(CMD_U2GS_TransferOldRechargeToPlayer, 1032).
-define(CMD_GS2U_TransferOldRechargeResult, 1033).
-define(CMD_PlayerEquipActiveFailReason, 1034).
-define(CMD_PlayerEquipMinLevelChange, 1035).
-define(CMD_PlayerImportPassWord, 1036).
-define(CMD_PlayerImportPassWordResult, 1037).
-define(CMD_GS2U_UpdatePlayerGuildInfo, 1038).
-define(CMD_U2GS_RequestBazzarItemPrice, 1039).
-define(CMD_U2GS_RequestBazzarItemPrice_Result, 1040).
-define(CMD_RequestChangeGoldPassWord, 1041).
-define(CMD_PlayerGoldPassWordChanged, 1042).
-define(CMD_PlayerImportGoldPassWordResult, 1043).
-define(CMD_PlayerGoldUnlockTimesChanged, 1044).
-define(CMD_GS2U_LeftSmallMonsterNumber, 1045).
-define(CMD_GS2U_VipInfo, 1046).
-define(CMD_GS2U_TellMapLineID, 1047).
-define(CMD_VIPPlayerOpenVIPStoreRequest, 1048).
-define(CMD_VIPPlayerOpenVIPStoreFail, 1049).
-define(CMD_UpdateVIPLevelInfo, 1050).
-define(CMD_ActiveCodeRequest, 1051).
-define(CMD_ActiveCodeResult, 1052).
-define(CMD_U2GS_RequestOutFightPetPropetry, 1053).
-define(CMD_GS2U_RequestOutFightPetPropetryResult, 1054).
-define(CMD_PlayerDirMove, 1055).
-define(CMD_PlayerDirMove_S2C, 1056).
-define(CMD_U2GS_EnRollCampusBattle, 1057).
-define(CMD_GSWithU_GameSetMenu_3, 1058).
-define(CMD_StartCompound, 1059).
-define(CMD_StartCompoundResult, 1060).
-define(CMD_CompoundBaseInfo, 1061).
-define(CMD_RequestEquipFastUpQuality, 1062).
-define(CMD_EquipQualityFastUPByTypeBack, 1063).
-define(CMD_PlayerTeleportMove, 1064).
-define(CMD_PlayerTeleportMove_S2C, 1065).
-define(CMD_U2GS_leaveCampusBattle, 1066).
-define(CMD_U2GS_LeaveBattleScene, 1067).
-define(CMD_battleResult, 1068).
-define(CMD_BattleResultList, 1069).
-define(CMD_GS2U_BattleEnrollResult, 1070).
-define(CMD_U2GS_requestEnrollInfo, 1071).
-define(CMD_GS2U_sendEnrollInfo, 1072).
-define(CMD_GS2U_NowCanEnterBattle, 1073).
-define(CMD_U2GS_SureEnterBattle, 1074).
-define(CMD_GS2U_EnterBattleResult, 1075).
-define(CMD_GS2U_BattleScore, 1076).
-define(CMD_U2GS_RequestBattleResultList, 1077).
-define(CMD_GS2U_BattleEnd, 1078).
-define(CMD_GS2U_LeftOpenTime, 1079).
-define(CMD_GS2U_HeartBeatAck, 1080).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_CharProperty, {
        attack,
        defence,
        ph_def,
        fire_def,
        ice_def,
        elec_def,
        poison_def,
        max_life,
        life_recover,
        been_attack_recover,
        damage_recover,
        coma_def,
        hold_def,
        silent_def,
        move_def,
        hit,
        dodge,
        block,
        crit,
        pierce,
        attack_speed,
        tough,
        crit_damage_rate,
        block_dec_damage,
        phy_attack_rate,
        fire_attack_rate,
        ice_attack_rate,
        elec_attack_rate,
        poison_attack_rate,
        phy_def_rate,
        fire_def_rate,
        ice_def_rate,
        elec_def_rate,
        poison_def_rate,
        treat_rate,
        on_treat_rate,
        move_speed
	}).
-record(pk_ObjectBuff, {
        buff_id,
        allValidTime,
        remainTriggerCount
	}).
-record(pk_PlayerBaseInfo, {
        id,
        name,
        x,
        y,
        sex,
        face,
        weapon,
        level,
        camp,
        faction,
        vip,
        maxEnabledBagCells,
        maxEnabledStorageBagCells,
        storageBagPassWord,
        unlockTimes,
        money,
        moneyBinded,
        gold,
        goldBinded,
        rechargeAmmount,
        ticket,
        guildContribute,
        honor,
        credit,
        exp,
        bloodPool,
        petBloodPool,
        life,
        lifeMax,
        guildID,
        mountDataID,
        pK_Kill_RemainTime,
        exp15Add,
        exp20Add,
        exp30Add,
        pk_Kill_Value,
        pkFlags,
        minEquipLevel,
        guild_name,
        guild_rank,
        goldPassWord
	}).
-record(pk_rideInfo, {
        mountDataID,
        rideFlage
	}).
-record(pk_LookInfoPlayer, {
        id,
        name,
        lifePercent,
        x,
        y,
        move_target_x,
        move_target_y,
        move_dir,
        move_speed,
        level,
        value_flags,
        charState,
        weapon,
        coat,
        buffList,
        convoyFlags,
        guild_id,
        guild_name,
        guild_rank,
        vip
	}).
-record(pk_LookInfoPlayerList, {
        info_list
	}).
-record(pk_LookInfoPet, {
        id,
        masterId,
        data_id,
        name,
        titleid,
        modelId,
        lifePercent,
        level,
        x,
        y,
        move_target_x,
        move_target_y,
        move_speed,
        charState,
        buffList
	}).
-record(pk_LookInfoPetList, {
        info_list
	}).
-record(pk_LookInfoMonster, {
        id,
        move_target_x,
        move_target_y,
        move_speed,
        x,
        y,
        monster_data_id,
        lifePercent,
        faction,
        charState,
        buffList
	}).
-record(pk_LookInfoMonsterList, {
        info_list
	}).
-record(pk_LookInfoNpc, {
        id,
        x,
        y,
        npc_data_id,
        move_target_x,
        move_target_y
	}).
-record(pk_LookInfoNpcList, {
        info_list
	}).
-record(pk_LookInfoObject, {
        id,
        x,
        y,
        object_data_id,
        object_type,
        param
	}).
-record(pk_LookInfoObjectList, {
        info_list
	}).
-record(pk_ActorDisapearList, {
        info_list
	}).
-record(pk_PosInfo, {
        x,
        y
	}).
-record(pk_PlayerMoveTo, {
        posX,
        posY,
        posInfos
	}).
-record(pk_PlayerStopMove, {
        posX,
        posY
	}).
-record(pk_PlayerStopMove_S2C, {
        id,
        posX,
        posY
	}).
-record(pk_MoveInfo, {
        id,
        posX,
        posY,
        posInfos
	}).
-record(pk_PlayerMoveInfo, {
        ids
	}).
-record(pk_ChangeFlyState, {
        flyState
	}).
-record(pk_ChangeFlyState_S2C, {
        id,
        flyState
	}).
-record(pk_MonsterMoveInfo, {
        ids
	}).
-record(pk_MonsterStopMove, {
        id,
        x,
        y
	}).
-record(pk_PetMoveInfo, {
        ids
	}).
-record(pk_PetStopMove, {
        id,
        x,
        y
	}).
-record(pk_ChangeMap, {
        mapDataID,
        mapId,
        x,
        y
	}).
-record(pk_CollectFail, {
        
	}).
-record(pk_RequestGM, {
        strCMD
	}).
-record(pk_PlayerPropertyChangeValue, {
        proType,
        value
	}).
-record(pk_PlayerPropertyChanged, {
        changeValues
	}).
-record(pk_PlayerMoneyChanged, {
        changeReson,
        moneyType,
        moneyValue
	}).
-record(pk_PlayerKickOuted, {
        reserve
	}).
-record(pk_ActorStateFlagSet, {
        nSetStateFlag
	}).
-record(pk_ActorStateFlagSet_Broad, {
        nActorID,
        nSetStateFlag
	}).
-record(pk_PlayerSkillInitData, {
        nSkillID,
        nCD,
        nActiveBranch1,
        nActiveBranch2,
        nBindedBranch
	}).
-record(pk_PlayerSkillInitInfo, {
        info_list
	}).
-record(pk_U2GS_StudySkill, {
        nSkillID
	}).
-record(pk_GS2U_StudySkillResult, {
        nSkillID,
        nResult
	}).
-record(pk_activeBranchID, {
        nWhichBranch,
        nSkillID,
        branchID
	}).
-record(pk_activeBranchIDResult, {
        result,
        nSkillID,
        branckID
	}).
-record(pk_U2GS_AddSkillBranch, {
        nSkillID,
        nBranchID
	}).
-record(pk_GS2U_AddSkillBranchAck, {
        result,
        nSkillID,
        nBranchID
	}).
-record(pk_U2GS_UseSkillRequest, {
        nSkillID,
        nTargetIDList,
        nCombatID
	}).
-record(pk_GS2U_UseSkillToObject, {
        nUserActorID,
        nSkillID,
        nTargetActorIDList,
        nCombatID
	}).
-record(pk_GS2U_UseSkillToPos, {
        nUserActorID,
        nSkillID,
        x,
        y,
        nCombatID,
        id_list
	}).
-record(pk_GS2U_AttackDamage, {
        nDamageTarget,
        nCombatID,
        nSkillID,
        nDamageLife,
        nTargetLifePer100,
        isBlocked,
        isCrited
	}).
-record(pk_GS2U_CharactorDead, {
        nDeadActorID,
        nKiller,
        nCombatNumber
	}).
-record(pk_GS2U_AttackMiss, {
        nActorID,
        nTargetID,
        nCombatID
	}).
-record(pk_GS2U_AttackDodge, {
        nActorID,
        nTargetID,
        nCombatID
	}).
-record(pk_GS2U_AttackCrit, {
        nActorID,
        nCombatID
	}).
-record(pk_GS2U_AttackBlock, {
        nActorID,
        nCombatID
	}).
-record(pk_PlayerAllShortcut, {
        index1ID,
        index2ID,
        index3ID,
        index4ID,
        index5ID,
        index6ID,
        index7ID,
        index8ID,
        index9ID,
        index10ID,
        index11ID,
        index12ID
	}).
-record(pk_ShortcutSet, {
        index,
        data
	}).
-record(pk_PlayerEXPChanged, {
        curEXP,
        changeReson
	}).
-record(pk_ActorLifeUpdate, {
        nActorID,
        nLife,
        nMaxLife
	}).
-record(pk_ActorMoveSpeedUpdate, {
        nActorID,
        nSpeed
	}).
-record(pk_PlayerCombatIDInit, {
        nBeginCombatID
	}).
-record(pk_GS2U_CharactorRevived, {
        nActorID,
        nLife,
        nMaxLife
	}).
-record(pk_U2GS_InteractObject, {
        nActorID
	}).
-record(pk_U2GS_QueryHeroProperty, {
        nReserve
	}).
-record(pk_CharPropertyData, {
        nPropertyType,
        nValue
	}).
-record(pk_GS2U_HeroPropertyResult, {
        info_list
	}).
-record(pk_ItemInfo, {
        id,
        owner_type,
        owner_id,
        location,
        cell,
        amount,
        item_data_id,
        param1,
        param2,
        binded,
        remain_time
	}).
-record(pk_PlayerBagInit, {
        items
	}).
-record(pk_PlayerGetItem, {
        item_info
	}).
-record(pk_PlayerDestroyItem, {
        itemDBID,
        reson
	}).
-record(pk_PlayerItemLocationCellChanged, {
        itemDBID,
        location,
        cell
	}).
-record(pk_RequestDestroyItem, {
        itemDBID
	}).
-record(pk_RequestGetItem, {
        itemDataID,
        amount
	}).
-record(pk_PlayerItemAmountChanged, {
        itemDBID,
        amount,
        reson
	}).
-record(pk_PlayerItemParamChanged, {
        itemDBID,
        param1,
        param2,
        reson
	}).
-record(pk_PlayerBagOrderData, {
        itemDBID,
        amount,
        cell
	}).
-record(pk_RequestPlayerBagOrder, {
        location
	}).
-record(pk_PlayerBagOrderResult, {
        location,
        cell
	}).
-record(pk_PlayerRequestUseItem, {
        location,
        cell,
        useCount
	}).
-record(pk_PlayerUseItemResult, {
        location,
        cell,
        result
	}).
-record(pk_RequestPlayerBagCellOpen, {
        cell,
        location
	}).
-record(pk_RequestChangeStorageBagPassWord, {
        oldStorageBagPassWord,
        newStorageBagPassWord,
        status
	}).
-record(pk_PlayerStorageBagPassWordChanged, {
        result
	}).
-record(pk_PlayerBagCellEnableChanged, {
        cell,
        location,
        gold,
        item_count
	}).
-record(pk_RequestPlayerBagSellItem, {
        cell
	}).
-record(pk_RequestClearTempBag, {
        reserve
	}).
-record(pk_RequestMoveTempBagItem, {
        cell
	}).
-record(pk_RequestMoveAllTempBagItem, {
        reserve
	}).
-record(pk_RequestMoveStorageBagItem, {
        cell
	}).
-record(pk_RequestMoveBagItemToStorage, {
        cell
	}).
-record(pk_RequestUnlockingStorageBagPassWord, {
        passWordType
	}).
-record(pk_RequestCancelUnlockingStorageBagPassWord, {
        passWordType
	}).
-record(pk_PlayerUnlockTimesChanged, {
        unlockTimes
	}).
-record(pk_ItemBagCellSetData, {
        location,
        cell,
        itemDBID
	}).
-record(pk_ItemBagCellSet, {
        cells
	}).
-record(pk_NpcStoreItemData, {
        id,
        item_id,
        price,
        isbind
	}).
-record(pk_RequestGetNpcStoreItemList, {
        store_id
	}).
-record(pk_GetNpcStoreItemListAck, {
        store_id,
        itemList
	}).
-record(pk_RequestBuyItem, {
        item_id,
        amount,
        store_id
	}).
-record(pk_BuyItemAck, {
        count
	}).
-record(pk_RequestSellItem, {
        item_cell
	}).
-record(pk_GetNpcStoreBackBuyItemList, {
        count
	}).
-record(pk_GetNpcStoreBackBuyItemListAck, {
        itemList
	}).
-record(pk_RequestBackBuyItem, {
        item_id
	}).
-record(pk_PlayerEquipNetData, {
        dbID,
        nEquip,
        type,
        nQuality,
        isEquiped,
        enhanceLevel,
        property1Type,
        property1FixOrPercent,
        property1Value,
        property2Type,
        property2FixOrPercent,
        property2Value,
        property3Type,
        property3FixOrPercent,
        property3Value,
        property4Type,
        property4FixOrPercent,
        property4Value,
        property5Type,
        property5FixOrPercent,
        property5Value
	}).
-record(pk_PlayerEquipInit, {
        equips
	}).
-record(pk_RequestPlayerEquipActive, {
        equip_data_id
	}).
-record(pk_PlayerEquipActiveResult, {
        equip
	}).
-record(pk_RequestPlayerEquipPutOn, {
        equip_dbID
	}).
-record(pk_PlayerEquipPutOnResult, {
        equip_dbID,
        equiped
	}).
-record(pk_RequestQueryPlayerEquip, {
        playerid
	}).
-record(pk_QueryPlayerEquipResult, {
        equips
	}).
-record(pk_StudySkill, {
        id,
        lvl
	}).
-record(pk_StudyResult, {
        result,
        id,
        lvl
	}).
-record(pk_Reborn, {
        type
	}).
-record(pk_RebornAck, {
        x,
        y
	}).
-record(pk_Chat2Player, {
        channel,
        sendID,
        receiveID,
        sendName,
        receiveName,
        content,
        vipLevel
	}).
-record(pk_Chat2Server, {
        channel,
        sendID,
        receiveID,
        sendName,
        receiveName,
        content
	}).
-record(pk_Chat_Error_Result, {
        reason
	}).
-record(pk_RequestSendMail, {
        targetPlayerID,
        targetPlayerName,
        strTitle,
        strContent,
        attachItemDBID1,
        attachItem1Cnt,
        attachItemDBID2,
        attachItem2Cnt,
        moneySend,
        moneyPay
	}).
-record(pk_RequestSendMailAck, {
        result
	}).
-record(pk_RequestRecvMail, {
        mailID,
        deleteMail
	}).
-record(pk_RequestUnReadMail, {
        playerID
	}).
-record(pk_RequestUnReadMailAck, {
        unReadCount
	}).
-record(pk_RequestMailList, {
        playerID
	}).
-record(pk_MailInfo, {
        id,
        type,
        recvPlayerID,
        isOpen,
        timeOut,
        senderType,
        senderName,
        title,
        content,
        haveItem,
        moneySend,
        moneyPay,
        mailTimerType,
        mailRecTime
	}).
-record(pk_RequestMailListAck, {
        mailList
	}).
-record(pk_RequestMailItemInfo, {
        mailID
	}).
-record(pk_RequestMailItemInfoAck, {
        mailID,
        mailItem
	}).
-record(pk_RequestAcceptMailItem, {
        mailID,
        isDeleteMail
	}).
-record(pk_RequestAcceptMailItemAck, {
        result
	}).
-record(pk_MailReadNotice, {
        mailID
	}).
-record(pk_RequestDeleteMail, {
        mailID
	}).
-record(pk_InformNewMail, {
        
	}).
-record(pk_RequestDeleteReadMail, {
        readMailID
	}).
-record(pk_RequestSystemMail, {
        
	}).
-record(pk_U2GS_RequestLogin, {
        userID,
        identity,
        protocolVer
	}).
-record(pk_U2GS_SelPlayerEnterGame, {
        playerID
	}).
-record(pk_U2GS_RequestCreatePlayer, {
        name,
        camp,
        classValue,
        sex
	}).
-record(pk_U2GS_RequestDeletePlayer, {
        playerID
	}).
-record(pk_GS2U_LoginResult, {
        result
	}).
-record(pk_GS2U_SelPlayerResult, {
        result
	}).
-record(pk_UserPlayerData, {
        playerID,
        name,
        level,
        classValue,
        sex,
        faction
	}).
-record(pk_GS2U_UserPlayerList, {
        info
	}).
-record(pk_GS2U_CreatePlayerResult, {
        errorCode
	}).
-record(pk_GS2U_DeletePlayerResult, {
        playerID,
        errorCode
	}).
-record(pk_ConSales_GroundingItem, {
        dbId,
        count,
        money,
        timeType,
	}).
-record(pk_ConSales_GroundingItem_Result, {
        result
	}).
-record(pk_ConSales_TakeDown, {
        conSalesId
	}).
-record(pk_ConSales_TakeDown_Result, {
        allTakeDown,
        result,
        protectTime
	}).
-record(pk_ConSales_BuyItem, {
        conSalesOderId
	}).
-record(pk_ConSales_BuyItem_Result, {
        result
	}).
-record(pk_ConSales_FindItems, {
        offsetCount,
        ignoreOption,
        type,
        detType,
        levelMin,
        levelMax,
        occ,
        quality,
        idLimit,
        idList
	}).
-record(pk_ConSalesItem, {
        conSalesId,
        conSalesMoney,
        groundingTime,
        timeType,
        playerId,
        playerName,
        itemDBId,
        itemId,
        itemCount,
        itemType,
        itemQuality,
        itemLevel,
        itemOcc
	}).
-record(pk_ConSales_FindItems_Result, {
        result,
        allCount,
        page,
        itemList
	}).
-record(pk_ConSales_TrunPage, {
        mode
	}).
-record(pk_ConSales_Close, {
        n
	}).
-record(pk_ConSales_GetSelfSell, {
        n
	}).
-record(pk_ConSales_GetSelfSell_Result, {
        itemList
	}).
-record(pk_TradeAsk, {
        playerID,
        playerName
	}).
-record(pk_TradeAskResult, {
        playerID,
        playerName,
        result
	}).
-record(pk_CreateTrade, {
        playerID,
        playerName,
        result
	}).
-record(pk_TradeInputItem_C2S, {
        cell,
        itemDBID,
        count
	}).
-record(pk_TradeInputItemResult_S2C, {
        itemDBID,
        item_data_id,
        count,
        cell,
        result
	}).
-record(pk_TradeInputItem_S2C, {
        itemDBID,
        item_data_id,
        count
	}).
-record(pk_TradeTakeOutItem_C2S, {
        itemDBID
	}).
-record(pk_TradeTakeOutItemResult_S2C, {
        cell,
        itemDBID,
        result
	}).
-record(pk_TradeTakeOutItem_S2C, {
        itemDBID
	}).
-record(pk_TradeChangeMoney_C2S, {
        money
	}).
-record(pk_TradeChangeMoneyResult_S2C, {
        money,
        result
	}).
-record(pk_TradeChangeMoney_S2C, {
        money
	}).
-record(pk_TradeLock_C2S, {
        lock
	}).
-record(pk_TradeLock_S2C, {
        person,
        lock
	}).
-record(pk_CancelTrade_S2C, {
        person,
        reason
	}).
-record(pk_CancelTrade_C2S, {
        reason
	}).
-record(pk_TradeAffirm_C2S, {
        bAffrim
	}).
-record(pk_TradeAffirm_S2C, {
        person,
        bAffirm
	}).
-record(pk_PetSkill, {
        id,
        coolDownTime
	}).
-record(pk_PetProperty, {
        db_id,
        data_id,
        master_id,
        level,
        exp,
        name,
        titleId,
        aiState,
        showModel,
        exModelId,
        soulLevel,
        soulRate,
        attackGrowUp,
        defGrowUp,
        lifeGrowUp,
        isWashGrow,
        attackGrowUpWash,
        defGrowUpWash,
        lifeGrowUpWash,
        convertRatio,
        exerciseLevel,
        moneyExrciseNum,
        exerciseExp,
        maxSkillNum,
        skills,
        life,
        maxLife,
        attack,
        def,
        crit,
        block,
        hit,
        dodge,
        tough,
        pierce,
        crit_damage_rate,
        attack_speed,
        ph_def,
        fire_def,
        ice_def,
        elec_def,
        poison_def,
        coma_def,
        hold_def,
        silent_def,
        move_def,
        atkPowerGrowUp_Max,
        defClassGrowUp_Max,
        hpGrowUp_Max,
        benison_Value
	}).
-record(pk_PlayerPetInfo, {
        petSkillBag,
        petInfos
	}).
-record(pk_UpdatePetProerty, {
        petInfo
	}).
-record(pk_DelPet, {
        petId
	}).
-record(pk_PetOutFight, {
        petId
	}).
-record(pk_PetOutFight_Result, {
        result,
        petId
	}).
-record(pk_PetTakeRest, {
        petId
	}).
-record(pk_PetTakeRest_Result, {
        result,
        petId
	}).
-record(pk_PetFreeCaptiveAnimals, {
        petId
	}).
-record(pk_PetFreeCaptiveAnimals_Result, {
        result,
        petId
	}).
-record(pk_PetCompoundModel, {
        petId
	}).
-record(pk_PetCompoundModel_Result, {
        result,
        petId
	}).
-record(pk_PetWashGrowUpValue, {
        petId
	}).
-record(pk_PetWashGrowUpValue_Result, {
        result,
        petId,
        attackGrowUp,
        defGrowUp,
        lifeGrowUp
	}).
-record(pk_PetReplaceGrowUpValue, {
        petId
	}).
-record(pk_PetReplaceGrowUpValue_Result, {
        result,
        petId
	}).
-record(pk_PetIntensifySoul, {
        petId
	}).
-record(pk_PetIntensifySoul_Result, {
        result,
        petId,
        soulLevel,
        soulRate,
        benison_Value
	}).
-record(pk_PetOneKeyIntensifySoul, {
        petId
	}).
-record(pk_PetOneKeyIntensifySoul_Result, {
        petId,
        result,
        itemCount,
        money
	}).
-record(pk_PetFuse, {
        petSrcId,
        petDestId
	}).
-record(pk_PetFuse_Result, {
        result,
        petSrcId,
        petDestId
	}).
-record(pk_PetJumpTo, {
        petId,
        x,
        y
	}).
-record(pk_ActorSetPos, {
        actorId,
        x,
        y
	}).
-record(pk_PetTakeBack, {
        petId
	}).
-record(pk_ChangePetAIState, {
        state
	}).
-record(pk_PetExpChanged, {
        petId,
        curExp,
        reason
	}).
-record(pk_PetLearnSkill, {
        petId,
        skillId
	}).
-record(pk_PetLearnSkill_Result, {
        result,
        petId,
        oldSkillId,
        newSkillId
	}).
-record(pk_PetDelSkill, {
        petId,
        skillId
	}).
-record(pk_PetDelSkill_Result, {
        result,
        petId,
        skillid
	}).
-record(pk_PetUnLockSkillCell, {
        petId
	}).
-record(pk_PetUnLoctSkillCell_Result, {
        result,
        petId,
        newSkillCellNum
	}).
-record(pk_PetSkillSealAhs, {
        petId,
        skillid
	}).
-record(pk_PetSkillSealAhs_Result, {
        result,
        petId,
        skillid
	}).
-record(pk_PetUpdateSealAhsStore, {
        petSkillBag
	}).
-record(pk_PetlearnSealAhsSkill, {
        petId,
        skillId
	}).
-record(pk_PetlearnSealAhsSkill_Result, {
        result,
        petId,
        oldSkillId,
        newSkillId
	}).
-record(pk_RequestGetPlayerEquipEnhanceByType, {
        type
	}).
-record(pk_GetPlayerEquipEnhanceByTypeBack, {
        type,
        level,
        progress,
        blessValue
	}).
-record(pk_RequestEquipEnhanceByType, {
        type
	}).
-record(pk_EquipEnhanceByTypeBack, {
        result
	}).
-record(pk_RequestEquipOnceEnhanceByType, {
        type
	}).
-record(pk_EquipOnceEnhanceByTypeBack, {
        result,
        times,
        itemnumber,
        money
	}).
-record(pk_RequestGetPlayerEquipQualityByType, {
        type
	}).
-record(pk_GetPlayerEquipQualityByTypeBack, {
        type,
        quality
	}).
-record(pk_RequestEquipQualityUPByType, {
        type
	}).
-record(pk_EquipQualityUPByTypeBack, {
        result
	}).
-record(pk_RequestEquipOldPropertyByType, {
        type
	}).
-record(pk_GetEquipOldPropertyByType, {
        type,
        property1Type,
        property1FixOrPercent,
        property1Value,
        property2Type,
        property2FixOrPercent,
        property2Value,
        property3Type,
        property3FixOrPercent,
        property3Value,
        property4Type,
        property4FixOrPercent,
        property4Value,
        property5Type,
        property5FixOrPercent,
        property5Value
	}).
-record(pk_RequestEquipChangePropertyByType, {
        type,
        property1,
        property2,
        property3,
        property4,
        property5
	}).
-record(pk_GetEquipNewPropertyByType, {
        type,
        property1Type,
        property1FixOrPercent,
        property1Value,
        property2Type,
        property2FixOrPercent,
        property2Value,
        property3Type,
        property3FixOrPercent,
        property3Value,
        property4Type,
        property4FixOrPercent,
        property4Value,
        property5Type,
        property5FixOrPercent,
        property5Value
	}).
-record(pk_RequestEquipSaveNewPropertyByType, {
        type
	}).
-record(pk_RequestEquipChangeAddSavePropertyByType, {
        result
	}).
-record(pk_U2GS_EnterCopyMapRequest, {
        npcActorID,
        enterMapID
	}).
-record(pk_GS2U_EnterMapResult, {
        result
	}).
-record(pk_U2GS_QueryMyCopyMapCD, {
        reserve
	}).
-record(pk_MyCopyMapCDInfo, {
        mapDataID,
        mapEnteredCount,
        mapActiveCount
	}).
-record(pk_GS2U_MyCopyMapCDInfo, {
        info_list
	}).
-record(pk_AddBuff, {
        actor_id,
        buff_data_id,
        allValidTime,
        remainTriggerCount
	}).
-record(pk_DelBuff, {
        actor_id,
        buff_data_id
	}).
-record(pk_UpdateBuff, {
        actor_id,
        buff_data_id,
        remainTriggerCount
	}).
-record(pk_HeroBuffList, {
        buffList
	}).
-record(pk_U2GS_TransByWorldMap, {
        mapDataID,
        posX,
        posY
	}).
-record(pk_U2GS_TransForSameScence, {
        mapDataID,
        posX,
        posY
	}).
-record(pk_U2GS_FastTeamCopyMapRequest, {
        npcActorID,
        mapDataID,
        enterOrQuit
	}).
-record(pk_GS2U_FastTeamCopyMapResult, {
        mapDataID,
        result,
        enterOrQuit
	}).
-record(pk_GS2U_TeamCopyMapQuery, {
        nReadyEnterMapDataID,
        nCurMapID,
        nPosX,
        nPosY,
        nDistanceSQ
	}).
-record(pk_U2GS_RestCopyMapRequest, {
        nNpcID,
        nMapDataID
	}).
-record(pk_GS2U_AddOrRemoveHatred, {
        nActorID,
        nAddOrRemove
	}).
-record(pk_U2GS_QieCuoInvite, {
        nActorID
	}).
-record(pk_GS2U_QieCuoInviteQuery, {
        nActorID,
        strName
	}).
-record(pk_U2GS_QieCuoInviteAck, {
        nActorID,
        agree
	}).
-record(pk_GS2U_QieCuoInviteResult, {
        nActorID,
        result
	}).
-record(pk_GS2U_QieCuoResult, {
        nWinner_ActorID,
        strWinner_Name,
        nLoser_ActorID,
        strLoser_Name,
        reson
	}).
-record(pk_U2GS_PK_KillOpenRequest, {
        reserve
	}).
-record(pk_GS2U_PK_KillOpenResult, {
        result,
        pK_Kill_RemainTime,
        pk_Kill_Value
	}).
-record(pk_GS2U_Player_ChangeEquipResult, {
        playerID,
        equipID
	}).
-record(pk_SysMessage, {
        type,
        text
	}).
-record(pk_GS2U_AddLifeByItem, {
        actorID,
        addLife,
        percent
	}).
-record(pk_GS2U_AddLifeBySkill, {
        actorID,
        addLife,
        percent,
        crite
	}).
-record(pk_PlayerItemCDInfo, {
        cdTypeID,
        remainTime,
        allTime
	}).
-record(pk_GS2U_PlayerItemCDInit, {
        info_list
	}).
-record(pk_GS2U_PlayerItemCDUpdate, {
        info
	}).
-record(pk_U2GS_BloodPoolAddLife, {
        actorID
	}).
-record(pk_GS2U_ItemDailyCount, {
        remainCount,
        task_data_id
	}).
-record(pk_U2GS_GetSigninInfo, {
        
	}).
-record(pk_GS2U_PlayerSigninInfo, {
        isAlreadySign,
        days
	}).
-record(pk_U2GS_Signin, {
        
	}).
-record(pk_GS2U_PlayerSignInResult, {
        nResult,
        awardDays
	}).
-record(pk_U2GS_LeaveCopyMap, {
        reserve
	}).
-record(pk_PetChangeModel, {
        petId,
        modelID
	}).
-record(pk_PetChangeName, {
        petId,
        newName
	}).
-record(pk_PetChangeName_Result, {
        result,
        petId,
        newName
	}).
-record(pk_BazzarItem, {
        db_id,
        item_id,
        item_column,
        gold,
        binded_gold,
        remain_count,
        remain_time
	}).
-record(pk_BazzarListRequest, {
        seed
	}).
-record(pk_BazzarPriceItemList, {
        itemList
	}).
-record(pk_BazzarItemList, {
        seed,
        itemList
	}).
-record(pk_BazzarItemUpdate, {
        item
	}).
-record(pk_BazzarBuyRequest, {
        db_id,
        isBindGold,
        count
	}).
-record(pk_BazzarBuyResult, {
        result
	}).
-record(pk_PlayerBagCellOpenResult, {
        result
	}).
-record(pk_U2GS_RemoveSkillBranch, {
        nSkillID
	}).
-record(pk_GS2U_RemoveSkillBranch, {
        result,
        nSkillID
	}).
-record(pk_U2GS_PetBloodPoolAddLife, {
        n
	}).
-record(pk_U2GS_CopyMapAddActiveCount, {
        map_data_id
	}).
-record(pk_U2GS_CopyMapAddActiveCountResult, {
        result
	}).
-record(pk_GS2U_CurConvoyInfo, {
        isDead,
        convoyType,
        carriageQuality,
        remainTime,
        lowCD,
        highCD,
        freeCnt
	}).
-record(pk_U2GS_CarriageQualityRefresh, {
        isRefreshLegend,
        isCostGold,
        curConvoyType,
        curCarriageQuality,
        curTaskID
	}).
-record(pk_GS2U_CarriageQualityRefreshResult, {
        retCode,
        newConvoyType,
        newCarriageQuality,
        freeCnt
	}).
-record(pk_U2GS_ConvoyCDRequst, {
        
	}).
-record(pk_GS2U_ConvoyCDResult, {
        retCode
	}).
-record(pk_U2GS_BeginConvoy, {
        nTaskID,
        curConvoyType,
        curCarriageQuality,
        nNpcActorID
	}).
-record(pk_GS2U_BeginConvoyResult, {
        retCode,
        curConvoyType,
        curCarriageQuality,
        remainTime,
        lowCD,
        highCD
	}).
-record(pk_GS2U_FinishConvoyResult, {
        curConvoyType,
        curCarriageQuality
	}).
-record(pk_GS2U_GiveUpConvoyResult, {
        curConvoyType,
        curCarriageQuality
	}).
-record(pk_GS2U_ConvoyNoticeTimerResult, {
        isDead,
        remainTime
	}).
-record(pk_GS2U_ConvoyState, {
        convoyFlags,
        quality,
        actorID
	}).
-record(pk_GSWithU_GameSetMenu, {
        joinTeamOnoff,
        inviteGuildOnoff,
        tradeOnoff,
        applicateFriendOnoff,
        singleKeyOperateOnoff,
        musicPercent,
        soundEffectPercent,
        shieldEnermyCampPlayer,
        shieldSelfCampPlayer,
        shieldOthersPet,
        shieldOthersName,
        shieldSkillEffect,
        dispPlayerLimit
	}).
-record(pk_U2GS_RequestRechargeGift, {
        type
	}).
-record(pk_U2GS_RequestRechargeGift_Ret, {
        retcode
	}).
-record(pk_U2GS_RequestPlayerFightingCapacity, {
        
	}).
-record(pk_U2GS_RequestPlayerFightingCapacity_Ret, {
        fightingcapacity
	}).
-record(pk_U2GS_RequestPetFightingCapacity, {
        petid
	}).
-record(pk_U2GS_RequestPetFightingCapacity_Ret, {
        fightingcapacity
	}).
-record(pk_U2GS_RequestMountFightingCapacity, {
        mountid
	}).
-record(pk_U2GS_RequestMountFightingCapacity_Ret, {
        fightingcapacity
	}).
-record(pk_VariantData, {
        index,
        value
	}).
-record(pk_GS2U_VariantDataSet, {
        variant_type,
        info_list
	}).
-record(pk_U2GS_GetRankList, {
        mapDataID
	}).
-record(pk_GS2U_RankList, {
        mapID,
        rankNum,
        name1,
        harm1,
        name2,
        harm2,
        name3,
        harm3,
        name4,
        harm4,
        name5,
        harm5,
        name6,
        harm6,
        name7,
        harm7,
        name8,
        harm8,
        name9,
        harm9,
        name10,
        harm10
	}).
-record(pk_GS2U_WordBossCmd, {
        m_iCmd,
        m_iParam
	}).
-record(pk_U2GS_ChangePlayerName, {
        id,
        name
	}).
-record(pk_GS2U_ChangePlayerNameResult, {
        retCode
	}).
-record(pk_U2GS_SetProtectPwd, {
        id,
        oldpwd,
        pwd
	}).
-record(pk_GS2U_SetProtectPwdResult, {
        retCode
	}).
-record(pk_U2GS_HeartBeat, {
        
	}).
-record(pk_GS2U_CopyProgressUpdate, {
        progress
	}).
-record(pk_U2GS_QequestGiveGoldCheck, {
        
	}).
-record(pk_U2GS_StartGiveGold, {
        
	}).
-record(pk_U2GS_StartGiveGoldResult, {
        goldType,
        useCnt,
        exp,
        level,
        awardMoney,
        retCode
	}).
-record(pk_U2GS_GoldLineInfo, {
        useCnt,
        exp,
        level
	}).
-record(pk_U2GS_GoldResetTimer, {
        useCnt
	}).
-record(pk_GS2U_CopyMapSAData, {
        map_id,
        killed_count,
        finish_rate,
        cost_time,
        exp,
        money,
        level,
        is_perfect
	}).
-record(pk_TokenStoreItemData, {
        id,
        item_id,
        price,
        tokenType,
        isbind
	}).
-record(pk_GetTokenStoreItemListAck, {
        store_id,
        itemList
	}).
-record(pk_RequestLookPlayer, {
        playerID
	}).
-record(pk_RequestLookPlayer_Result, {
        baseInfo,
        propertyList,
        petList,
        equipList,
        fightCapacity
	}).
-record(pk_RequestLookPlayerFailed_Result, {
        result
	}).
-record(pk_U2GS_PlayerClientInfo, {
        playerid,
        platform,
        machine
	}).
-record(pk_U2GS_RequestActiveCount, {
        n
	}).
-record(pk_ActiveCountData, {
        daily_id,
        count
	}).
-record(pk_GS2U_ActiveCount, {
        activeValue,
        dailyList
	}).
-record(pk_U2GS_RequestConvertActive, {
        n
	}).
-record(pk_GS2U_WhetherTransferOldRecharge, {
        playerID,
        name,
        rechargeRmb
	}).
-record(pk_U2GS_TransferOldRechargeToPlayer, {
        playerId,
        isTransfer
	}).
-record(pk_GS2U_TransferOldRechargeResult, {
        errorCode
	}).
-record(pk_PlayerEquipActiveFailReason, {
        reason
	}).
-record(pk_PlayerEquipMinLevelChange, {
        playerid,
        minEquipLevel
	}).
-record(pk_PlayerImportPassWord, {
        passWord,
        passWordType
	}).
-record(pk_PlayerImportPassWordResult, {
        result
	}).
-record(pk_GS2U_UpdatePlayerGuildInfo, {
        player_id,
        guild_id,
        guild_name,
        guild_rank
	}).
-record(pk_U2GS_RequestBazzarItemPrice, {
        item_id
	}).
-record(pk_U2GS_RequestBazzarItemPrice_Result, {
        item
	}).
-record(pk_RequestChangeGoldPassWord, {
        oldGoldPassWord,
        newGoldPassWord,
        status
	}).
-record(pk_PlayerGoldPassWordChanged, {
        result
	}).
-record(pk_PlayerImportGoldPassWordResult, {
        result
	}).
-record(pk_PlayerGoldUnlockTimesChanged, {
        unlockTimes
	}).
-record(pk_GS2U_LeftSmallMonsterNumber, {
        leftMonsterNum
	}).
-record(pk_GS2U_VipInfo, {
        vipLevel,
        vipTime,
        vipTimeExpire,
        vipTimeBuy
	}).
-record(pk_GS2U_TellMapLineID, {
        iLineID
	}).
-record(pk_VIPPlayerOpenVIPStoreRequest, {
        request
	}).
-record(pk_VIPPlayerOpenVIPStoreFail, {
        fail
	}).
-record(pk_UpdateVIPLevelInfo, {
        playerID,
        vipLevel
	}).
-record(pk_ActiveCodeRequest, {
        active_code
	}).
-record(pk_ActiveCodeResult, {
        result
	}).
-record(pk_U2GS_RequestOutFightPetPropetry, {
        n
	}).
-record(pk_GS2U_RequestOutFightPetPropetryResult, {
        pet_id,
        attack,
        defence,
        hit,
        dodge,
        block,
        tough,
        crit,
        crit_damage_rate,
        attack_speed,
        pierce,
        ph_def,
        fire_def,
        ice_def,
        elec_def,
        poison_def,
        coma_def,
        hold_def,
        silent_def,
        move_def,
        max_life
	}).
-record(pk_PlayerDirMove, {
        pos_x,
        pos_y,
        dir
	}).
-record(pk_PlayerDirMove_S2C, {
        player_id,
        pos_x,
        pos_y,
        dir
	}).
-record(pk_U2GS_EnRollCampusBattle, {
        npcID,
        battleID
	}).
-record(pk_GSWithU_GameSetMenu_3, {
        joinTeamOnoff,
        inviteGuildOnoff,
        tradeOnoff,
        applicateFriendOnoff,
        singleKeyOperateOnoff,
        musicPercent,
        soundEffectPercent,
        shieldEnermyCampPlayer,
        shieldSelfCampPlayer,
        shieldOthersPet,
        shieldOthersName,
        shieldSkillEffect,
        dispPlayerLimit,
        shieldOthersSoundEff,
        noAttackGuildMate,
        reserve1,
        reserve2
	}).
-record(pk_StartCompound, {
        makeItemID,
        compounBindedType,
        isUseDoubleRule
	}).
-record(pk_StartCompoundResult, {
        retCode
	}).
-record(pk_CompoundBaseInfo, {
        exp,
        level,
        makeItemID
	}).
-record(pk_RequestEquipFastUpQuality, {
        equipId
	}).
-record(pk_EquipQualityFastUPByTypeBack, {
        result
	}).
-record(pk_PlayerTeleportMove, {
        pos_x,
        pos_y
	}).
-record(pk_PlayerTeleportMove_S2C, {
        player_id,
        pos_x,
        pos_y
	}).
-record(pk_U2GS_leaveCampusBattle, {
        unUsed
	}).
-record(pk_U2GS_LeaveBattleScene, {
        unUsed
	}).
-record(pk_battleResult, {
        name,
        campus,
        killPlayerNum,
        beenKiiledNum,
        playerID,
        harm,
        harmed
	}).
-record(pk_BattleResultList, {
        resultList
	}).
-record(pk_GS2U_BattleEnrollResult, {
        enrollResult,
        mapDataID
	}).
-record(pk_U2GS_requestEnrollInfo, {
        unUsed
	}).
-record(pk_GS2U_sendEnrollInfo, {
        enrollxuanzong,
        enrolltianji
	}).
-record(pk_GS2U_NowCanEnterBattle, {
        battleID
	}).
-record(pk_U2GS_SureEnterBattle, {
        unUsed
	}).
-record(pk_GS2U_EnterBattleResult, {
        faileReason
	}).
-record(pk_GS2U_BattleScore, {
        xuanzongScore,
        tianjiScore
	}).
-record(pk_U2GS_RequestBattleResultList, {
        unUsed
	}).
-record(pk_GS2U_BattleEnd, {
        unUsed
	}).
-record(pk_GS2U_LeftOpenTime, {
        leftOpenTime
	}).
-record(pk_GS2U_HeartBeatAck, {
        
	}).
