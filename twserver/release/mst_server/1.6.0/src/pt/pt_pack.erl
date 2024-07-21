-module(pt_pack).
-export([p/2]).

p(10000, [Versions,Url]) ->
    VersionsL_ = byte_size(Versions),    UrlL_ = byte_size(Url),    Data = << VersionsL_:16,Versions:VersionsL_/binary,UrlL_:16,Url:UrlL_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 10000:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(10001, [Type,Code]) ->
    Data = << Type:8,Code:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 10001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(10005, [Notice]) ->
    NoticeAL_ = length(Notice),
    NoticeF_ = fun
        ([Id1,Msg1]) ->
                Msg1L_ = byte_size(Msg1),<< Id1:32,Msg1L_:16,Msg1:Msg1L_/binary >>;
        ({Id1,Msg1}) ->
                Msg1L_ = byte_size(Msg1),<< Id1:32,Msg1L_:16,Msg1:Msg1L_/binary >>
    end,
    NoticeR_ = list_to_binary([NoticeF_(X)||X <- Notice]),
    Data = << NoticeAL_:16,NoticeR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 10005:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(10010, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 10010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(10011, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 10011:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11000, [Status,Progress,Id]) ->
    Data = << Status:8,Progress:8,Id:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11000:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11003, [Diamond,Coin,Tollgateid,Tired,Bagequ,Bagprop,Bagmat,Arenaname,Picture,Lucknum,Horn,Chattime,Tollgateprize,Verify,Level,Herotab,Viplev,Firstpay]) ->
    ArenanameL_ = byte_size(Arenaname),    Data = << Diamond:32,Coin:32,Tollgateid:32,Tired:32,Bagequ:16,Bagprop:16,Bagmat:16,ArenanameL_:16,Arenaname:ArenanameL_/binary,Picture:8,Lucknum:32,Horn:32,Chattime:8,Tollgateprize:8,Verify:32,Level:8,Herotab:8,Viplev:8,Firstpay:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11003:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11004, [Honor]) ->
    Data = << Honor:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11004:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11005, [Coin]) ->
    Data = << Coin:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11005:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11006, [Diamond]) ->
    Data = << Diamond:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11006:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11007, [Tired,Num,Time]) ->
    Data = << Tired:32,Num:16,Time:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11007:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11008, [Luck]) ->
    Data = << Luck:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11008:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11009, [Horn]) ->
    Data = << Horn:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11009:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11010, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11011, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11011:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11013, [Value,Value1]) ->
    Data = << Value:8,Value1:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11013:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11014, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11014:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11015, [List]) ->
    ListAL_ = length(List),
    ListF_ = fun
        ([Id1,Value1]) ->
            << Id1:8,Value1:8 >>;
        ({Id1,Value1}) ->
            << Id1:8,Value1:8 >>
    end,
    ListR_ = list_to_binary([ListF_(X)||X <- List]),
    Data = << ListAL_:16,ListR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11015:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11027, [Code,Tired,Num]) ->
    Data = << Code:8,Tired:32,Num:16 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11027:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11103, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11103:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11104, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11104:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11111, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11111:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(11112, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 11112:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13001, [Type,Equip,Props]) ->
    EquipAL_ = length(Equip),
    EquipF_ = fun
        ([Id1,Type1,Equip1,Level1,SocketsNum1,Sockets1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1]) ->
                Sockets1AL_ = length(Sockets1),
    Sockets1F_ = fun
        ([Id2,Value2]) ->
            << Id2:32,Value2:32 >>;
        ({Id2,Value2}) ->
            << Id2:32,Value2:32 >>
    end,
    Sockets1R_ = list_to_binary([Sockets1F_(X)||X <- Sockets1]),
<< Id1:32,Type1:32,Equip1:32,Level1:8,SocketsNum1:8,Sockets1AL_:16,Sockets1R_/binary,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32 >>;
        ({Id1,Type1,Equip1,Level1,SocketsNum1,Sockets1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1}) ->
                Sockets1AL_ = length(Sockets1),
    Sockets1F_ = fun
        ([Id2,Value2]) ->
            << Id2:32,Value2:32 >>;
        ({Id2,Value2}) ->
            << Id2:32,Value2:32 >>
    end,
    Sockets1R_ = list_to_binary([Sockets1F_(X)||X <- Sockets1]),
<< Id1:32,Type1:32,Equip1:32,Level1:8,SocketsNum1:8,Sockets1AL_:16,Sockets1R_/binary,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32 >>
    end,
    EquipR_ = list_to_binary([EquipF_(X)||X <- Equip]),
    PropsAL_ = length(Props),
    PropsF_ = fun
        ([Id1,Type1,Pile1,Level1,Exp1]) ->
            << Id1:32,Type1:32,Pile1:8,Level1:8,Exp1:32 >>;
        ({Id1,Type1,Pile1,Level1,Exp1}) ->
            << Id1:32,Type1:32,Pile1:8,Level1:8,Exp1:32 >>
    end,
    PropsR_ = list_to_binary([PropsF_(X)||X <- Props]),
    Data = << Type:8,EquipAL_:16,EquipR_/binary,PropsAL_:16,PropsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13003, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13003:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13005, [Code,Equid,Level,Time]) ->
    Data = << Code:8,Equid:32,Level:8,Time:16 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13005:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13006, [Code,Time]) ->
    Data = << Code:8,Time:16 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13006:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13010, [Code,Equid]) ->
    Data = << Code:8,Equid:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13011, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13011:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13012, [Code,Ids]) ->
    IdsAL_ = length(Ids),
    IdsF_ = fun
        ([Id1,Type1]) ->
            << Id1:32,Type1:8 >>;
        ({Id1,Type1}) ->
            << Id1:32,Type1:8 >>
    end,
    IdsR_ = list_to_binary([IdsF_(X)||X <- Ids]),
    Data = << Code:8,IdsAL_:16,IdsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13012:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13021, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13021:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13022, [Code,Level,Id,Type]) ->
    Data = << Code:8,Level:8,Id:32,Type:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13022:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13024, [MagicOrbs]) ->
    MagicOrbsAL_ = length(MagicOrbs),
    MagicOrbsF_ = fun
        ([Level1,State1]) ->
            << Level1:8,State1:8 >>;
        ({Level1,State1}) ->
            << Level1:8,State1:8 >>
    end,
    MagicOrbsR_ = list_to_binary([MagicOrbsF_(X)||X <- MagicOrbs]),
    Data = << MagicOrbsAL_:16,MagicOrbsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13024:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13025, [Code,Level,Exp]) ->
    Data = << Code:8,Level:32,Exp:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13025:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13026, [Code,Level,Exp]) ->
    Data = << Code:8,Level:32,Exp:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13026:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13027, [Code,Tab,Bags]) ->
    Data = << Code:8,Tab:8,Bags:16 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13027:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13028, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13028:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13030, [Props]) ->
    PropsAL_ = length(Props),
    PropsF_ = fun
        ([Id1,Pile1]) ->
            << Id1:32,Pile1:8 >>;
        ({Id1,Pile1}) ->
            << Id1:32,Pile1:8 >>
    end,
    PropsR_ = list_to_binary([PropsF_(X)||X <- Props]),
    Data = << PropsAL_:16,PropsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13030:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13032, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13032:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13040, [Code,Diamond,Pos]) ->
    Data = << Code:8,Diamond:32,Pos:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13040:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13042, [Recent]) ->
    RecentAL_ = length(Recent),
    RecentF_ = fun
        ([Name1,Reward_id1,Reward_num1]) ->
                Name1L_ = byte_size(Name1),<< Name1L_:16,Name1:Name1L_/binary,Reward_id1:32,Reward_num1:32 >>;
        ({Name1,Reward_id1,Reward_num1}) ->
                Name1L_ = byte_size(Name1),<< Name1L_:16,Name1:Name1L_/binary,Reward_id1:32,Reward_num1:32 >>
    end,
    RecentR_ = list_to_binary([RecentF_(X)||X <- Recent]),
    Data = << RecentAL_:16,RecentR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13042:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13044, [Recent]) ->
    RecentAL_ = length(Recent),
    RecentF_ = fun
        ([Name1,Values1,Sum1]) ->
                Name1L_ = byte_size(Name1),<< Name1L_:16,Name1:Name1L_/binary,Values1:32,Sum1:32 >>;
        ({Name1,Values1,Sum1}) ->
                Name1L_ = byte_size(Name1),<< Name1L_:16,Name1:Name1L_/binary,Values1:32,Sum1:32 >>
    end,
    RecentR_ = list_to_binary([RecentF_(X)||X <- Recent]),
    Data = << RecentAL_:16,RecentR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13044:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13045, [Id,Luck,Values]) ->
    Data = << Id:8,Luck:32,Values:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13045:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13051, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13051:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13052, [Code,Type,Days1,Days2,Days]) ->
    DaysAL_ = length(Days),
    DaysF_ = fun
        ([Day1,State1]) ->
            << Day1:8,State1:8 >>;
        ({Day1,State1}) ->
            << Day1:8,State1:8 >>
    end,
    DaysR_ = list_to_binary([DaysF_(X)||X <- Days]),
    Data = << Code:8,Type:8,Days1:8,Days2:8,DaysAL_:16,DaysR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13052:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13054, [Code,Days1,Days2,Days]) ->
    DaysAL_ = length(Days),
    DaysF_ = fun
        ([Day1,State1]) ->
            << Day1:8,State1:8 >>;
        ({Day1,State1}) ->
            << Day1:8,State1:8 >>
    end,
    DaysR_ = list_to_binary([DaysF_(X)||X <- Days]),
    Data = << Code:8,Days1:8,Days2:8,DaysAL_:16,DaysR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13054:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13056, [Code,State]) ->
    Data = << Code:8,State:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13056:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13058, [Id]) ->
    Data = << Id:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13058:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13059, [Code,Id,Type]) ->
    Data = << Code:8,Id:8,Type:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13059:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13062, [Herose]) ->
    HeroseAL_ = length(Herose),
    HeroseF_ = fun
        ([Id1]) ->
            << Id1:32 >>;
        ({Id1}) ->
            << Id1:32 >>
    end,
    HeroseR_ = list_to_binary([HeroseF_(X)||X <- Herose]),
    Data = << HeroseAL_:16,HeroseR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13062:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13064, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13064:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13066, [Code,Custom]) ->
    CustomL_ = byte_size(Custom),    Data = << Code:8,CustomL_:16,Custom:CustomL_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13066:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13067, [Code,Time,Coin_time,Lefttimes,Herosoul]) ->
    HerosoulAL_ = length(Herosoul),
    HerosoulF_ = fun
        ([Pos1,Id1,Type1,Rare1]) ->
            << Pos1:8,Id1:32,Type1:8,Rare1:8 >>;
        ({Pos1,Id1,Type1,Rare1}) ->
            << Pos1:8,Id1:32,Type1:8,Rare1:8 >>
    end,
    HerosoulR_ = list_to_binary([HerosoulF_(X)||X <- Herosoul]),
    Data = << Code:8,Time:32,Coin_time:32,Lefttimes:8,HerosoulAL_:16,HerosoulR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13067:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(13068, [Code,Time,Num,Pos,Id]) ->
    Data = << Code:8,Time:32,Num:8,Pos:8,Id:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 13068:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14001, [Status]) ->
    Data = << Status:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14002, [Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51]) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>;
        ({Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51}) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    Data = << HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14002:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14010, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14015, [Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesR_ = list_to_binary([<<X:32>>||X <- Heroes]),
    Data = << HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14015:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14019, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14019:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14020, [Code,Cd,Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,Type1,Lock1,Quality1,Ravity1]) ->
            << Id1:8,Type1:32,Lock1:8,Quality1:8,Ravity1:8 >>;
        ({Id1,Type1,Lock1,Quality1,Ravity1}) ->
            << Id1:8,Type1:32,Lock1:8,Quality1:8,Ravity1:8 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    Data = << Code:8,Cd:32,HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14020:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14022, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14022:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14023, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14023:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14025, [Id,Type,Seat,Quality,Level,Exp,Foster,Hp,Attack,Defend,Puncture,Hit,Dodge,Crit,CritPercentage,AnitCrit,Toughness,Seat1,Seat2,Seat3,Seat4,Seat5]) ->
    Data = << Id:32,Type:32,Seat:8,Quality:8,Level:8,Exp:32,Foster:8,Hp:32,Attack:32,Defend:32,Puncture:32,Hit:32,Dodge:32,Crit:32,CritPercentage:32,AnitCrit:32,Toughness:32,Seat1:32,Seat2:32,Seat3:32,Seat4:32,Seat5:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14025:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14030, [Code,Heroid,Level,Exp]) ->
    Data = << Code:8,Heroid:32,Level:8,Exp:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14030:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14032, [Code,Num]) ->
    Data = << Code:8,Num:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14032:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14034, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14034:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14036, [Code,Level,Exp]) ->
    Data = << Code:8,Level:8,Exp:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14036:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14037, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14037:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14038, [Code,Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,State1]) ->
            << Id1:32,State1:8 >>;
        ({Id1,State1}) ->
            << Id1:32,State1:8 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    Data = << Code:8,HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14038:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(14039, [State]) ->
    Data = << State:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 14039:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(22002, [Tried,CurrentCheckPoint,Success,Star,BattleHeroes,BattleCommands,Upgrade,Equip,Props]) ->
    BattleHeroesAL_ = length(BattleHeroes),
    BattleHeroesF_ = fun
        ([Pos1,Hp1,Power1]) ->
            << Pos1:8,Hp1:32,Power1:32 >>;
        ({Pos1,Hp1,Power1}) ->
            << Pos1:8,Hp1:32,Power1:32 >>
    end,
    BattleHeroesR_ = list_to_binary([BattleHeroesF_(X)||X <- BattleHeroes]),
    BattleCommandsAL_ = length(BattleCommands),
    BattleCommandsF_ = fun
        ([Bout1,Sponsor1,Buffid1,Targets1,Skill1]) ->
                Buffid1AL_ = length(Buffid1),
    Buffid1R_ = list_to_binary([<<X:32>>||X <- Buffid1]),
    Targets1AL_ = length(Targets1),
    Targets1F_ = fun
        ([Id2,Hp2,State2,Buffid2]) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
<< Id2:8,Hp2:32,State2:8,Buffid2AL_:16,Buffid2R_/binary >>;
        ({Id2,Hp2,State2,Buffid2}) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
<< Id2:8,Hp2:32,State2:8,Buffid2AL_:16,Buffid2R_/binary >>
    end,
    Targets1R_ = list_to_binary([Targets1F_(X)||X <- Targets1]),
<< Bout1:8,Sponsor1:8,Buffid1AL_:16,Buffid1R_/binary,Targets1AL_:16,Targets1R_/binary,Skill1:32 >>;
        ({Bout1,Sponsor1,Buffid1,Targets1,Skill1}) ->
                Buffid1AL_ = length(Buffid1),
    Buffid1R_ = list_to_binary([<<X:32>>||X <- Buffid1]),
    Targets1AL_ = length(Targets1),
    Targets1F_ = fun
        ([Id2,Hp2,State2,Buffid2]) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
<< Id2:8,Hp2:32,State2:8,Buffid2AL_:16,Buffid2R_/binary >>;
        ({Id2,Hp2,State2,Buffid2}) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
<< Id2:8,Hp2:32,State2:8,Buffid2AL_:16,Buffid2R_/binary >>
    end,
    Targets1R_ = list_to_binary([Targets1F_(X)||X <- Targets1]),
<< Bout1:8,Sponsor1:8,Buffid1AL_:16,Buffid1R_/binary,Targets1AL_:16,Targets1R_/binary,Skill1:32 >>
    end,
    BattleCommandsR_ = list_to_binary([BattleCommandsF_(X)||X <- BattleCommands]),
    UpgradeAL_ = length(Upgrade),
    UpgradeF_ = fun
        ([Id1,Level1,Exp1]) ->
            << Id1:32,Level1:8,Exp1:32 >>;
        ({Id1,Level1,Exp1}) ->
            << Id1:32,Level1:8,Exp1:32 >>
    end,
    UpgradeR_ = list_to_binary([UpgradeF_(X)||X <- Upgrade]),
    EquipAL_ = length(Equip),
    EquipF_ = fun
        ([Id1,Type1,Equip1,Level1,SocketsNum1,Sockets1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1]) ->
                Sockets1AL_ = length(Sockets1),
    Sockets1F_ = fun
        ([Id2,Value2]) ->
            << Id2:32,Value2:32 >>;
        ({Id2,Value2}) ->
            << Id2:32,Value2:32 >>
    end,
    Sockets1R_ = list_to_binary([Sockets1F_(X)||X <- Sockets1]),
<< Id1:32,Type1:32,Equip1:32,Level1:8,SocketsNum1:8,Sockets1AL_:16,Sockets1R_/binary,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32 >>;
        ({Id1,Type1,Equip1,Level1,SocketsNum1,Sockets1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1}) ->
                Sockets1AL_ = length(Sockets1),
    Sockets1F_ = fun
        ([Id2,Value2]) ->
            << Id2:32,Value2:32 >>;
        ({Id2,Value2}) ->
            << Id2:32,Value2:32 >>
    end,
    Sockets1R_ = list_to_binary([Sockets1F_(X)||X <- Sockets1]),
<< Id1:32,Type1:32,Equip1:32,Level1:8,SocketsNum1:8,Sockets1AL_:16,Sockets1R_/binary,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32 >>
    end,
    EquipR_ = list_to_binary([EquipF_(X)||X <- Equip]),
    PropsAL_ = length(Props),
    PropsF_ = fun
        ([Id1,Type1,Pile1,Level1,Exp1]) ->
            << Id1:32,Type1:32,Pile1:8,Level1:8,Exp1:32 >>;
        ({Id1,Type1,Pile1,Level1,Exp1}) ->
            << Id1:32,Type1:32,Pile1:8,Level1:8,Exp1:32 >>
    end,
    PropsR_ = list_to_binary([PropsF_(X)||X <- Props]),
    Data = << Tried:32,CurrentCheckPoint:16,Success:8,Star:8,BattleHeroesAL_:16,BattleHeroesR_/binary,BattleCommandsAL_:16,BattleCommandsR_/binary,UpgradeAL_:16,UpgradeR_/binary,EquipAL_:16,EquipR_/binary,PropsAL_:16,PropsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 22002:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(22010, [Gate,Num,Time,Num2]) ->
    Data = << Gate:16,Num:8,Time:32,Num2:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 22010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(22014, [Code,Gate,Num,Num2]) ->
    Data = << Code:8,Gate:16,Num:8,Num2:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 22014:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(22020, [NightmareInfo]) ->
    NightmareInfoAL_ = length(NightmareInfo),
    NightmareInfoF_ = fun
        ([Id1,Star1]) ->
            << Id1:16,Star1:8 >>;
        ({Id1,Star1}) ->
            << Id1:16,Star1:8 >>
    end,
    NightmareInfoR_ = list_to_binary([NightmareInfoF_(X)||X <- NightmareInfo]),
    Data = << NightmareInfoAL_:16,NightmareInfoR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 22020:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(22021, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 22021:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23001, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23004, [Rank,Point,Honor,Level]) ->
    Data = << Rank:32,Point:32,Honor:32,Level:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23004:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23012, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23012:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23014, [Lists]) ->
    ListsAL_ = length(Lists),
    ListsF_ = fun
        ([Id1,Name1]) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary >>;
        ({Id1,Name1}) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary >>
    end,
    ListsR_ = list_to_binary([ListsF_(X)||X <- Lists]),
    Data = << ListsAL_:16,ListsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23014:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23015, [Number,Cd,Chance,Team1,Team2,Targets]) ->
    TargetsAL_ = length(Targets),
    TargetsF_ = fun
        ([Id1,Name1,Picture1,Beat1]) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Beat1:8 >>;
        ({Id1,Name1,Picture1,Beat1}) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Beat1:8 >>
    end,
    TargetsR_ = list_to_binary([TargetsF_(X)||X <- Targets]),
    Data = << Number:8,Cd:32,Chance:8,Team1:8,Team2:8,TargetsAL_:16,TargetsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23015:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23016, [Lists]) ->
    ListsAL_ = length(Lists),
    ListsF_ = fun
        ([Index1,Id1,Name1,Exp1,Fighting1]) ->
                Name1L_ = byte_size(Name1),<< Index1:16,Id1:32,Name1L_:16,Name1:Name1L_/binary,Exp1:16,Fighting1:32 >>;
        ({Index1,Id1,Name1,Exp1,Fighting1}) ->
                Name1L_ = byte_size(Name1),<< Index1:16,Id1:32,Name1L_:16,Name1:Name1L_/binary,Exp1:16,Fighting1:32 >>
    end,
    ListsR_ = list_to_binary([ListsF_(X)||X <- Lists]),
    Data = << ListsAL_:16,ListsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23016:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23017, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23017:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23018, [Active]) ->
    ActiveAL_ = length(Active),
    ActiveF_ = fun
        ([Id1,Name11,Name21]) ->
                Name11L_ = byte_size(Name11),    Name21L_ = byte_size(Name21),<< Id1:32,Name11L_:16,Name11:Name11L_/binary,Name21L_:16,Name21:Name21L_/binary >>;
        ({Id1,Name11,Name21}) ->
                Name11L_ = byte_size(Name11),    Name21L_ = byte_size(Name21),<< Id1:32,Name11L_:16,Name11:Name11L_/binary,Name21L_:16,Name21:Name21L_/binary >>
    end,
    ActiveR_ = list_to_binary([ActiveF_(X)||X <- Active]),
    Data = << ActiveAL_:16,ActiveR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23018:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23022, [Code,Time,Team1,Team2,Targets]) ->
    TargetsAL_ = length(Targets),
    TargetsF_ = fun
        ([Id1,Name1,Picture1,Beat1]) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Beat1:8 >>;
        ({Id1,Name1,Picture1,Beat1}) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Beat1:8 >>
    end,
    TargetsR_ = list_to_binary([TargetsF_(X)||X <- Targets]),
    Data = << Code:8,Time:32,Team1:8,Team2:8,TargetsAL_:16,TargetsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23022:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23024, [Code,Num]) ->
    Data = << Code:8,Num:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23024:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23025, [Code,Messege]) ->
    MessegeAL_ = length(Messege),
    MessegeF_ = fun
        ([Type1,Level1,Hp1,Seat1,Weapon1]) ->
            << Type1:32,Level1:16,Hp1:32,Seat1:16,Weapon1:32 >>;
        ({Type1,Level1,Hp1,Seat1,Weapon1}) ->
            << Type1:32,Level1:16,Hp1:32,Seat1:16,Weapon1:32 >>
    end,
    MessegeR_ = list_to_binary([MessegeF_(X)||X <- Messege]),
    Data = << Code:8,MessegeAL_:16,MessegeR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23025:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23028, [Code,Gold,Honor]) ->
    Data = << Code:8,Gold:32,Honor:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23028:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23029, [Code,Gold,Honor,Point]) ->
    Data = << Code:8,Gold:32,Honor:32,Point:16 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23029:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23033, [Gold,Add_exp,Lev,Exp]) ->
    Data = << Gold:32,Add_exp:32,Lev:8,Exp:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23033:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(23035, [Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51]) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>;
        ({Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51}) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    Data = << HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 23035:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(24001, [Id]) ->
    Data = << Id:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 24001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(24002, [Id,Num]) ->
    Data = << Id:32,Num:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 24002:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(24003, [Id,Num]) ->
    Data = << Id:32,Num:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 24003:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(24004, [Code,Id,Type]) ->
    Data = << Code:8,Id:16,Type:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 24004:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(24006, [Ids]) ->
    IdsAL_ = length(Ids),
    IdsF_ = fun
        ([Id1,Num1,Type1]) ->
            << Id1:32,Num1:32,Type1:8 >>;
        ({Id1,Num1,Type1}) ->
            << Id1:32,Num1:32,Type1:8 >>
    end,
    IdsR_ = list_to_binary([IdsF_(X)||X <- Ids]),
    Data = << IdsAL_:16,IdsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 24006:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(24008, [Id]) ->
    Data = << Id:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 24008:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25001, [Ids]) ->
    IdsAL_ = length(Ids),
    IdsF_ = fun
        ([Id1]) ->
            << Id1:8 >>;
        ({Id1}) ->
            << Id1:8 >>
    end,
    IdsR_ = list_to_binary([IdsF_(X)||X <- Ids]),
    Data = << IdsAL_:16,IdsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25002, [Code,LoadUrl,RatingUrl,Ids]) ->
    LoadUrlL_ = byte_size(LoadUrl),    RatingUrlL_ = byte_size(RatingUrl),    IdsAL_ = length(Ids),
    IdsF_ = fun
        ([Id1,Val1,Num1,State1]) ->
            << Id1:8,Val1:32,Num1:8,State1:8 >>;
        ({Id1,Val1,Num1,State1}) ->
            << Id1:8,Val1:32,Num1:8,State1:8 >>
    end,
    IdsR_ = list_to_binary([IdsF_(X)||X <- Ids]),
    Data = << Code:32,LoadUrlL_:16,LoadUrl:LoadUrlL_/binary,RatingUrlL_:16,RatingUrl:RatingUrlL_/binary,IdsAL_:16,IdsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25002:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25004, [Code,Items]) ->
    ItemsAL_ = length(Items),
    ItemsF_ = fun
        ([Tid1,Num1]) ->
            << Tid1:32,Num1:8 >>;
        ({Tid1,Num1}) ->
            << Tid1:32,Num1:8 >>
    end,
    ItemsR_ = list_to_binary([ItemsF_(X)||X <- Items]),
    Data = << Code:8,ItemsAL_:16,ItemsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25004:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25030, [Code,Id,Num]) ->
    Data = << Code:8,Id:8,Num:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25030:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25031, [Code,Id,Num]) ->
    Data = << Code:8,Id:8,Num:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25031:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25032, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25032:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25033, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25033:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25034, [Code,Num,State]) ->
    Data = << Code:8,Num:8,State:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25034:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25035, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25035:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25036, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25036:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25038, [Code,Num,State]) ->
    Data = << Code:8,Num:8,State:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25038:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25040, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25040:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25041, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25041:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25044, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25044:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(25046, [Doubleids]) ->
    DoubleidsAL_ = length(Doubleids),
    DoubleidsR_ = list_to_binary([<<X:32>>||X <- Doubleids]),
    Data = << DoubleidsAL_:16,DoubleidsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 25046:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(26005, [Mail]) ->
    MailAL_ = length(Mail),
    MailF_ = fun
        ([Id1,From1,Content1,Time1,Items1]) ->
                From1L_ = byte_size(From1),    Content1L_ = byte_size(Content1),    Items1AL_ = length(Items1),
    Items1F_ = fun
        ([Type2,Num2,Custom2]) ->
            << Type2:32,Num2:32,Custom2:32 >>;
        ({Type2,Num2,Custom2}) ->
            << Type2:32,Num2:32,Custom2:32 >>
    end,
    Items1R_ = list_to_binary([Items1F_(X)||X <- Items1]),
<< Id1:32,From1L_:16,From1:From1L_/binary,Content1L_:16,Content1:Content1L_/binary,Time1:32,Items1AL_:16,Items1R_/binary >>;
        ({Id1,From1,Content1,Time1,Items1}) ->
                From1L_ = byte_size(From1),    Content1L_ = byte_size(Content1),    Items1AL_ = length(Items1),
    Items1F_ = fun
        ([Type2,Num2,Custom2]) ->
            << Type2:32,Num2:32,Custom2:32 >>;
        ({Type2,Num2,Custom2}) ->
            << Type2:32,Num2:32,Custom2:32 >>
    end,
    Items1R_ = list_to_binary([Items1F_(X)||X <- Items1]),
<< Id1:32,From1L_:16,From1:From1L_/binary,Content1L_:16,Content1:Content1L_/binary,Time1:32,Items1AL_:16,Items1R_/binary >>
    end,
    MailR_ = list_to_binary([MailF_(X)||X <- Mail]),
    Data = << MailAL_:16,MailR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 26005:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(26010, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 26010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(26015, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 26015:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(27010, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 27010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(27020, [Type,Id,Name,Content,Attr]) ->
    NameL_ = byte_size(Name),    ContentL_ = byte_size(Content),    Data = << Type:8,Id:32,NameL_:16,Name:NameL_/binary,ContentL_:16,Content:ContentL_/binary,Attr:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 27020:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(29010, [Type,Num,Lev,Ranks]) ->
    RanksAL_ = length(Ranks),
    RanksF_ = fun
        ([Index1,Attr1,Id1,Name1,Picture1,Custom1]) ->
                Name1L_ = byte_size(Name1),<< Index1:32,Attr1:32,Id1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Custom1:32 >>;
        ({Index1,Attr1,Id1,Name1,Picture1,Custom1}) ->
                Name1L_ = byte_size(Name1),<< Index1:32,Attr1:32,Id1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Custom1:32 >>
    end,
    RanksR_ = list_to_binary([RanksF_(X)||X <- Ranks]),
    Data = << Type:8,Num:32,Lev:8,RanksAL_:16,RanksR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 29010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(29020, [Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51]) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>;
        ({Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51}) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    Data = << HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 29020:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33001, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33012, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33012:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33014, [Lists]) ->
    ListsAL_ = length(Lists),
    ListsF_ = fun
        ([Id1,Name1]) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary >>;
        ({Id1,Name1}) ->
                Name1L_ = byte_size(Name1),<< Id1:32,Name1L_:16,Name1:Name1L_/binary >>
    end,
    ListsR_ = list_to_binary([ListsF_(X)||X <- Lists]),
    Data = << ListsAL_:16,ListsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33014:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33024, [Code,Num,Wars]) ->
    Data = << Code:8,Num:8,Wars:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33024:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33025, [Code,Id,Messege]) ->
    MessegeAL_ = length(Messege),
    MessegeF_ = fun
        ([Type1,Level1,Hp1,Seat1,Weapon1]) ->
            << Type1:32,Level1:16,Hp1:32,Seat1:16,Weapon1:32 >>;
        ({Type1,Level1,Hp1,Seat1,Weapon1}) ->
            << Type1:32,Level1:16,Hp1:32,Seat1:16,Weapon1:32 >>
    end,
    MessegeR_ = list_to_binary([MessegeF_(X)||X <- Messege]),
    Data = << Code:8,Id:32,MessegeAL_:16,MessegeR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33025:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33035, [Heroes]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51]) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>;
        ({Id1,Type1,Seat1,Quality1,Level1,Exp1,Foster1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41,Seat51}) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Foster1:8,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32,Seat51:32 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    Data = << HeroesAL_:16,HeroesR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33035:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33037, [Rank,Exp,Level,Wars,Chance,Cd,Targets]) ->
    TargetsAL_ = length(Targets),
    TargetsF_ = fun
        ([Pos1,Id1,Rid1,Name1,Picture1,Power1]) ->
                Name1L_ = byte_size(Name1),<< Pos1:32,Id1:32,Rid1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Power1:32 >>;
        ({Pos1,Id1,Rid1,Name1,Picture1,Power1}) ->
                Name1L_ = byte_size(Name1),<< Pos1:32,Id1:32,Rid1:32,Name1L_:16,Name1:Name1L_/binary,Picture1:8,Power1:32 >>
    end,
    TargetsR_ = list_to_binary([TargetsF_(X)||X <- Targets]),
    Data = << Rank:32,Exp:32,Level:8,Wars:8,Chance:8,Cd:32,TargetsAL_:16,TargetsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33037:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33040, [Type]) ->
    Data = << Type:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33040:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(33042, [Diamond,Gold,Honor]) ->
    Data = << Diamond:32,Gold:32,Honor:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 33042:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(34010, [VideoRankInfo]) ->
    VideoRankInfoAL_ = length(VideoRankInfo),
    VideoRankInfoF_ = fun
        ([Name1,Power1,Picture1]) ->
                Name1L_ = byte_size(Name1),<< Name1L_:16,Name1:Name1L_/binary,Power1:32,Picture1:8 >>;
        ({Name1,Power1,Picture1}) ->
                Name1L_ = byte_size(Name1),<< Name1L_:16,Name1:Name1L_/binary,Power1:32,Picture1:8 >>
    end,
    VideoRankInfoR_ = list_to_binary([VideoRankInfoF_(X)||X <- VideoRankInfo]),
    Data = << VideoRankInfoAL_:16,VideoRankInfoR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 34010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(34020, [Heroes,VideoData]) ->
    HeroesAL_ = length(Heroes),
    HeroesF_ = fun
        ([Id1,Type1,Seat1,Quality1,Level1,Exp1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41]) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32 >>;
        ({Id1,Type1,Seat1,Quality1,Level1,Exp1,Hp1,Attack1,Defend1,Puncture1,Hit1,Dodge1,Crit1,CritPercentage1,AnitCrit1,Toughness1,Seat11,Seat21,Seat31,Seat41}) ->
            << Id1:32,Type1:32,Seat1:8,Quality1:8,Level1:8,Exp1:32,Hp1:32,Attack1:32,Defend1:32,Puncture1:32,Hit1:32,Dodge1:32,Crit1:32,CritPercentage1:32,AnitCrit1:32,Toughness1:32,Seat11:32,Seat21:32,Seat31:32,Seat41:32 >>
    end,
    HeroesR_ = list_to_binary([HeroesF_(X)||X <- Heroes]),
    VideoDataAL_ = length(VideoData),
    VideoDataF_ = fun
        ([Iswin1,VideoHeroes1,VideoCommands1,VideoUpgrade1]) ->
                VideoHeroes1AL_ = length(VideoHeroes1),
    VideoHeroes1F_ = fun
        ([Pos2,Hp2,Power2]) ->
            << Pos2:8,Hp2:32,Power2:32 >>;
        ({Pos2,Hp2,Power2}) ->
            << Pos2:8,Hp2:32,Power2:32 >>
    end,
    VideoHeroes1R_ = list_to_binary([VideoHeroes1F_(X)||X <- VideoHeroes1]),
    VideoCommands1AL_ = length(VideoCommands1),
    VideoCommands1F_ = fun
        ([Bout2,Sponsor2,Buffid2,Targets2,Skill2]) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
    Targets2AL_ = length(Targets2),
    Targets2F_ = fun
        ([Id3,Hp3,State3,Buffid3]) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>;
        ({Id3,Hp3,State3,Buffid3}) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>
    end,
    Targets2R_ = list_to_binary([Targets2F_(X)||X <- Targets2]),
<< Bout2:8,Sponsor2:8,Buffid2AL_:16,Buffid2R_/binary,Targets2AL_:16,Targets2R_/binary,Skill2:32 >>;
        ({Bout2,Sponsor2,Buffid2,Targets2,Skill2}) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
    Targets2AL_ = length(Targets2),
    Targets2F_ = fun
        ([Id3,Hp3,State3,Buffid3]) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>;
        ({Id3,Hp3,State3,Buffid3}) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>
    end,
    Targets2R_ = list_to_binary([Targets2F_(X)||X <- Targets2]),
<< Bout2:8,Sponsor2:8,Buffid2AL_:16,Buffid2R_/binary,Targets2AL_:16,Targets2R_/binary,Skill2:32 >>
    end,
    VideoCommands1R_ = list_to_binary([VideoCommands1F_(X)||X <- VideoCommands1]),
    VideoUpgrade1AL_ = length(VideoUpgrade1),
    VideoUpgrade1F_ = fun
        ([Id2,Level2,Exp2]) ->
            << Id2:32,Level2:8,Exp2:32 >>;
        ({Id2,Level2,Exp2}) ->
            << Id2:32,Level2:8,Exp2:32 >>
    end,
    VideoUpgrade1R_ = list_to_binary([VideoUpgrade1F_(X)||X <- VideoUpgrade1]),
<< Iswin1:8,VideoHeroes1AL_:16,VideoHeroes1R_/binary,VideoCommands1AL_:16,VideoCommands1R_/binary,VideoUpgrade1AL_:16,VideoUpgrade1R_/binary >>;
        ({Iswin1,VideoHeroes1,VideoCommands1,VideoUpgrade1}) ->
                VideoHeroes1AL_ = length(VideoHeroes1),
    VideoHeroes1F_ = fun
        ([Pos2,Hp2,Power2]) ->
            << Pos2:8,Hp2:32,Power2:32 >>;
        ({Pos2,Hp2,Power2}) ->
            << Pos2:8,Hp2:32,Power2:32 >>
    end,
    VideoHeroes1R_ = list_to_binary([VideoHeroes1F_(X)||X <- VideoHeroes1]),
    VideoCommands1AL_ = length(VideoCommands1),
    VideoCommands1F_ = fun
        ([Bout2,Sponsor2,Buffid2,Targets2,Skill2]) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
    Targets2AL_ = length(Targets2),
    Targets2F_ = fun
        ([Id3,Hp3,State3,Buffid3]) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>;
        ({Id3,Hp3,State3,Buffid3}) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>
    end,
    Targets2R_ = list_to_binary([Targets2F_(X)||X <- Targets2]),
<< Bout2:8,Sponsor2:8,Buffid2AL_:16,Buffid2R_/binary,Targets2AL_:16,Targets2R_/binary,Skill2:32 >>;
        ({Bout2,Sponsor2,Buffid2,Targets2,Skill2}) ->
                Buffid2AL_ = length(Buffid2),
    Buffid2R_ = list_to_binary([<<X:32>>||X <- Buffid2]),
    Targets2AL_ = length(Targets2),
    Targets2F_ = fun
        ([Id3,Hp3,State3,Buffid3]) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>;
        ({Id3,Hp3,State3,Buffid3}) ->
                Buffid3AL_ = length(Buffid3),
    Buffid3R_ = list_to_binary([<<X:32>>||X <- Buffid3]),
<< Id3:8,Hp3:32,State3:8,Buffid3AL_:16,Buffid3R_/binary >>
    end,
    Targets2R_ = list_to_binary([Targets2F_(X)||X <- Targets2]),
<< Bout2:8,Sponsor2:8,Buffid2AL_:16,Buffid2R_/binary,Targets2AL_:16,Targets2R_/binary,Skill2:32 >>
    end,
    VideoCommands1R_ = list_to_binary([VideoCommands1F_(X)||X <- VideoCommands1]),
    VideoUpgrade1AL_ = length(VideoUpgrade1),
    VideoUpgrade1F_ = fun
        ([Id2,Level2,Exp2]) ->
            << Id2:32,Level2:8,Exp2:32 >>;
        ({Id2,Level2,Exp2}) ->
            << Id2:32,Level2:8,Exp2:32 >>
    end,
    VideoUpgrade1R_ = list_to_binary([VideoUpgrade1F_(X)||X <- VideoUpgrade1]),
<< Iswin1:8,VideoHeroes1AL_:16,VideoHeroes1R_/binary,VideoCommands1AL_:16,VideoCommands1R_/binary,VideoUpgrade1AL_:16,VideoUpgrade1R_/binary >>
    end,
    VideoDataR_ = list_to_binary([VideoDataF_(X)||X <- VideoData]),
    Data = << HeroesAL_:16,HeroesR_/binary,VideoDataAL_:16,VideoDataR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 34020:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(35001, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 35001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(35010, [Lev,Diamond,Free,Chattime,Prize,Fast,Tired,Coli_buy,Fb_buy]) ->
    Data = << Lev:8,Diamond:32,Free:32,Chattime:8,Prize:8,Fast:8,Tired:8,Coli_buy:8,Fb_buy:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 35010:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(35020, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 35020:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(36001, [Id]) ->
    Data = << Id:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 36001:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(36002, [Id]) ->
    Data = << Id:32 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 36002:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(36003, [Id,Num]) ->
    NumAL_ = length(Num),
    NumF_ = fun
        ([Type1,Number1]) ->
            << Type1:32,Number1:32 >>;
        ({Type1,Number1}) ->
            << Type1:32,Number1:32 >>
    end,
    NumR_ = list_to_binary([NumF_(X)||X <- Num]),
    Data = << Id:32,NumAL_:16,NumR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 36003:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(36004, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 36004:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(36005, [Ids]) ->
    IdsAL_ = length(Ids),
    IdsF_ = fun
        ([Id1,Num1,State1]) ->
                Num1AL_ = length(Num1),
    Num1F_ = fun
        ([Type2,Number2]) ->
            << Type2:32,Number2:32 >>;
        ({Type2,Number2}) ->
            << Type2:32,Number2:32 >>
    end,
    Num1R_ = list_to_binary([Num1F_(X)||X <- Num1]),
<< Id1:32,Num1AL_:16,Num1R_/binary,State1:8 >>;
        ({Id1,Num1,State1}) ->
                Num1AL_ = length(Num1),
    Num1F_ = fun
        ([Type2,Number2]) ->
            << Type2:32,Number2:32 >>;
        ({Type2,Number2}) ->
            << Type2:32,Number2:32 >>
    end,
    Num1R_ = list_to_binary([Num1F_(X)||X <- Num1]),
<< Id1:32,Num1AL_:16,Num1R_/binary,State1:8 >>
    end,
    IdsR_ = list_to_binary([IdsF_(X)||X <- Ids]),
    Data = << IdsAL_:16,IdsR_/binary >>,
    Len = byte_size(Data),
    {ok, << Len:16, 36005:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(36006, [Code]) ->
    Data = << Code:8 >>,
    Len = byte_size(Data),
    {ok, << Len:16, 36006:16, Data/binary >>};

p(Cmd, []) -> {ok, <<0:16, Cmd:16>>};

p(Cmd, Data) -> 
    io:format("undefined_pack_cmd:~w, data:~w", [Cmd, Data]),
    {error, undefined_pack_cmd}.

%% vim: ft=erlang :
