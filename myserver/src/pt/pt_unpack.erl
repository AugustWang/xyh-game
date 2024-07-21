-module(pt_unpack).
-export([p/2]).

p(10010, << Vtype:8,VcontentL_:16,Vcontent:VcontentL_/binary >>) ->
    {ok, [Vtype,Vcontent]};

p(_, <<>>) ->
    {ok, []};

p(10011, << VplatformL_:16,Vplatform:VplatformL_/binary,VreceiptL_:16,Vreceipt:VreceiptL_/binary,Vrand:32,VsignatureL_:16,Vsignature:VsignatureL_/binary >>) ->
    {ok, [Vplatform,Vreceipt,Vrand,Vsignature]};

p(_, <<>>) ->
    {ok, []};

p(11000, << Vtype:8,Vrand:32,Vsid:16,VaccountL_:16,Vaccount:VaccountL_/binary,VpasswordL_:16,Vpassword:VpasswordL_/binary,VsignatureL_:16,Vsignature:VsignatureL_/binary >>) ->
    {ok, [Vtype,Vrand,Vsid,Vaccount,Vpassword,Vsignature]};

p(_, <<>>) ->
    {ok, []};

p(11010, << Vgrowth:8 >>) ->
    {ok, [Vgrowth]};

p(_, <<>>) ->
    {ok, []};

p(11011, << Vvalue:8,Vvalue1:8 >>) ->
    {ok, [Vvalue,Vvalue1]};

p(_, <<>>) ->
    {ok, []};

p(11103, << VaccountL_:16,Vaccount:VaccountL_/binary >>) ->
    {ok, [Vaccount]};

p(_, <<>>) ->
    {ok, []};

p(11111, << VaccountL_:16,Vaccount:VaccountL_/binary >>) ->
    {ok, [Vaccount]};

p(_, <<>>) ->
    {ok, []};

p(11112, << VaccountL_:16,Vaccount:VaccountL_/binary,VverifyCode:32,VpasswordL_:16,Vpassword:VpasswordL_/binary >>) ->
    {ok, [Vaccount,VverifyCode,Vpassword]};

p(_, <<>>) ->
    {ok, []};

p(13001, << Vtype:8 >>) ->
    {ok, [Vtype]};

p(_, <<>>) ->
    {ok, []};

p(13003, << VaotoEquipVOAL_:16,VaotoEquipVO/binary >>) ->
    VaotoEquipVOF_ = fun({B_, R_}) ->
            << VheroID1:32,Vseat1:8,VequipID1:32,RB_/binary >> = B_, 
            {RB_, [[VheroID1,Vseat1,VequipID1]|R_]}
    end,
    {_, VaotoEquipVOR_} = protocol_fun:for(VaotoEquipVOAL_, VaotoEquipVOF_, {VaotoEquipVO, []}),
    {ok, [VaotoEquipVOR_]};

p(_, <<>>) ->
    {ok, []};

p(13005, << Vequid:32,VenId1:32,VenId2:32,VenId3:32,Vpay:8 >>) ->
    {ok, [Vequid,VenId1,VenId2,VenId3,Vpay]};

p(_, <<>>) ->
    {ok, []};

p(13006, << Vequid:32 >>) ->
    {ok, [Vequid]};

p(_, <<>>) ->
    {ok, []};

p(13010, << Vequid:32,Vgemid:32 >>) ->
    {ok, [Vequid,Vgemid]};

p(_, <<>>) ->
    {ok, []};

p(13011, << Vequid:32,Vgemid:32 >>) ->
    {ok, [Vequid,Vgemid]};

p(_, <<>>) ->
    {ok, []};

p(13012, << VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << Vid1:32,RB_/binary >> = B_, 
            {RB_, [[Vid1]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(13021, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(13022, << Vlevel:8 >>) ->
    {ok, [Vlevel]};

p(_, <<>>) ->
    {ok, []};

p(13025, << Vid:32,VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << V01:32,RB_/binary >> = B_, 
            {RB_, [[V01]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [Vid,VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(13027, << Vtype:8,Vline:8,Vtab:8 >>) ->
    {ok, [Vtype,Vline,Vtab]};

p(_, <<>>) ->
    {ok, []};

p(13028, << Vtab:8,VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << V01:32,RB_/binary >> = B_, 
            {RB_, [[V01]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [Vtab,VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(13032, << Vtab:8,VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << Vid1:32,Vnum1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vnum1]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [Vtab,VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(13044, << Vtype:8 >>) ->
    {ok, [Vtype]};

p(_, <<>>) ->
    {ok, []};

p(13056, << Vday:8 >>) ->
    {ok, [Vday]};

p(_, <<>>) ->
    {ok, []};

p(13064, << Vid:8 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(13066, << Vtype:8,Vkey:8,VvalueL_:16,Vvalue:VvalueL_/binary >>) ->
    {ok, [Vtype,Vkey,Vvalue]};

p(_, <<>>) ->
    {ok, []};

p(14001, << VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:32,Vposition1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vposition1]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(14010, << Vheroid:32 >>) ->
    {ok, [Vheroid]};

p(_, <<>>) ->
    {ok, []};

p(14019, << Vid:32,Vlock:8 >>) ->
    {ok, [Vid,Vlock]};

p(_, <<>>) ->
    {ok, []};

p(14020, << Vtype:8 >>) ->
    {ok, [Vtype]};

p(_, <<>>) ->
    {ok, []};

p(14022, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(14023, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(14030, << Vheroid:32,Vid1:32,Vid2:32,Vid3:32,Vid4:32 >>) ->
    {ok, [Vheroid,Vid1,Vid2,Vid3,Vid4]};

p(_, <<>>) ->
    {ok, []};

p(14034, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(14035, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(22002, << Vtype:8,VcurrentCheckPoint:16,Vpos:8 >>) ->
    {ok, [Vtype,VcurrentCheckPoint,Vpos]};

p(_, <<>>) ->
    {ok, []};

p(22010, << Vid:8,Vtype:8 >>) ->
    {ok, [Vid,Vtype]};

p(_, <<>>) ->
    {ok, []};

p(22014, << Vid:8,Vtype:8 >>) ->
    {ok, [Vid,Vtype]};

p(_, <<>>) ->
    {ok, []};

p(22021, << Vid:16 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(23001, << VnameL_:16,Vname:VnameL_/binary,Vpicture:8 >>) ->
    {ok, [Vname,Vpicture]};

p(_, <<>>) ->
    {ok, []};

p(23012, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(23025, << Vid:32,Vtype:8 >>) ->
    {ok, [Vid,Vtype]};

p(_, <<>>) ->
    {ok, []};

p(23029, << Vtype:8 >>) ->
    {ok, [Vtype]};

p(_, <<>>) ->
    {ok, []};

p(23035, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(24004, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(25004, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(25040, << Vaccount:32 >>) ->
    {ok, [Vaccount]};

p(_, <<>>) ->
    {ok, []};

p(25044, << VkeyL_:16,Vkey:VkeyL_/binary >>) ->
    {ok, [Vkey]};

p(_, <<>>) ->
    {ok, []};

p(26005, << VmaxId:32 >>) ->
    {ok, [VmaxId]};

p(_, <<>>) ->
    {ok, []};

p(26010, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(26015, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(27010, << Vtype:8,VcontentL_:16,Vcontent:VcontentL_/binary >>) ->
    {ok, [Vtype,Vcontent]};

p(_, <<>>) ->
    {ok, []};

p(29010, << Vtype:8 >>) ->
    {ok, [Vtype]};

p(_, <<>>) ->
    {ok, []};

p(29020, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(33001, << VnameL_:16,Vname:VnameL_/binary,Vpicture:8 >>) ->
    {ok, [Vname,Vpicture]};

p(_, <<>>) ->
    {ok, []};

p(33012, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(33025, << Vid:32,Vtype:8,Vindex:32 >>) ->
    {ok, [Vid,Vtype,Vindex]};

p(_, <<>>) ->
    {ok, []};

p(33035, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(34010, << Vtollgateid:32 >>) ->
    {ok, [Vtollgateid]};

p(_, <<>>) ->
    {ok, []};

p(34020, << Vtollgateid:32,Vid:32 >>) ->
    {ok, [Vtollgateid,Vid]};

p(_, <<>>) ->
    {ok, []};

p(Cmd, Data) -> 
    io:format("undefined_pt_unpack_cmd:~w, data:~w", [Cmd, Data]),
    {error, undefined_unpack_cmd}.

%% vim: ft=erlang :
