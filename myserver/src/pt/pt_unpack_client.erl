-module(pt_unpack_client).
-export([p/2]).

p(10000, << VversionsL_:16,Vversions:VversionsL_/binary,VurlL_:16,Vurl:VurlL_/binary >>) ->
    {ok, [Vversions,Vurl]};

p(_, <<>>) ->
    {ok, []};

p(10001, << Vtype:8,Vcode:32 >>) ->
    {ok, [Vtype,Vcode]};

p(_, <<>>) ->
    {ok, []};

p(10005, << VnoticeAL_:16,Vnotice/binary >>) ->
    VnoticeF_ = fun({B_, R_}) ->
            << Vid1:32,Vmsg1L_:16,Vmsg1:Vmsg1L_/binary,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vmsg1]|R_]}
    end,
    {_, VnoticeR_} = protocol_fun:for(VnoticeAL_, VnoticeF_, {Vnotice, []}),
    {ok, [VnoticeR_]};

p(_, <<>>) ->
    {ok, []};

p(10010, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(10011, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(11000, << Vstatus:8,Vprogress:8,Vid:32 >>) ->
    {ok, [Vstatus,Vprogress,Vid]};

p(_, <<>>) ->
    {ok, []};

p(11003, << Vdiamond:32,Vcoin:32,Vtollgateid:32,Vtired:32,Vbagequ:16,Vbagprop:16,Vbagmat:16,VarenanameL_:16,Varenaname:VarenanameL_/binary,Vpicture:8,Vlucknum:32,Vhorn:32,Vchattime:8,Vtollgateprize:8,Vverify:32,Vlevel:8,Vherotab:8,Vviplev:8,Vfirstpay:8 >>) ->
    {ok, [Vdiamond,Vcoin,Vtollgateid,Vtired,Vbagequ,Vbagprop,Vbagmat,Varenaname,Vpicture,Vlucknum,Vhorn,Vchattime,Vtollgateprize,Vverify,Vlevel,Vherotab,Vviplev,Vfirstpay]};

p(_, <<>>) ->
    {ok, []};

p(11004, << Vhonor:32 >>) ->
    {ok, [Vhonor]};

p(_, <<>>) ->
    {ok, []};

p(11005, << Vcoin:32 >>) ->
    {ok, [Vcoin]};

p(_, <<>>) ->
    {ok, []};

p(11006, << Vdiamond:32 >>) ->
    {ok, [Vdiamond]};

p(_, <<>>) ->
    {ok, []};

p(11007, << Vtired:32,Vnum:16,Vtime:32 >>) ->
    {ok, [Vtired,Vnum,Vtime]};

p(_, <<>>) ->
    {ok, []};

p(11008, << Vluck:32 >>) ->
    {ok, [Vluck]};

p(_, <<>>) ->
    {ok, []};

p(11009, << Vhorn:32 >>) ->
    {ok, [Vhorn]};

p(_, <<>>) ->
    {ok, []};

p(11010, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(11011, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(11013, << Vvalue:8,Vvalue1:8 >>) ->
    {ok, [Vvalue,Vvalue1]};

p(_, <<>>) ->
    {ok, []};

p(11027, << Vcode:8,Vtired:32,Vnum:16 >>) ->
    {ok, [Vcode,Vtired,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(11103, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(11104, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(11111, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(11112, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13001, Bin) ->
    protocol_fun:unpack(13001, [int8,[int32,int32,int32,int8,int8,[int32,int32],int32,int32,int32,int32,int32,int32,int32,int32,int32,int32],[int32,int32,int8,int8,int32]], Bin);

p(_, <<>>) ->
    {ok, []};

p(13003, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13005, << Vcode:8,Vequid:32,Vlevel:8,Vtime:16 >>) ->
    {ok, [Vcode,Vequid,Vlevel,Vtime]};

p(_, <<>>) ->
    {ok, []};

p(13006, << Vcode:8,Vtime:16 >>) ->
    {ok, [Vcode,Vtime]};

p(_, <<>>) ->
    {ok, []};

p(13010, << Vcode:8,Vequid:32 >>) ->
    {ok, [Vcode,Vequid]};

p(_, <<>>) ->
    {ok, []};

p(13011, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13012, << Vcode:8,VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << Vid1:32,Vtype1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vtype1]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [Vcode,VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(13021, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13022, << Vcode:8,Vlevel:8,Vid:32,Vtype:32 >>) ->
    {ok, [Vcode,Vlevel,Vid,Vtype]};

p(_, <<>>) ->
    {ok, []};

p(13024, << VmagicOrbsAL_:16,VmagicOrbs/binary >>) ->
    VmagicOrbsF_ = fun({B_, R_}) ->
            << Vlevel1:8,Vstate1:8,RB_/binary >> = B_, 
            {RB_, [[Vlevel1,Vstate1]|R_]}
    end,
    {_, VmagicOrbsR_} = protocol_fun:for(VmagicOrbsAL_, VmagicOrbsF_, {VmagicOrbs, []}),
    {ok, [VmagicOrbsR_]};

p(_, <<>>) ->
    {ok, []};

p(13025, << Vcode:8,Vlevel:32,Vexp:32 >>) ->
    {ok, [Vcode,Vlevel,Vexp]};

p(_, <<>>) ->
    {ok, []};

p(13027, << Vcode:8,Vtab:8,Vbags:16 >>) ->
    {ok, [Vcode,Vtab,Vbags]};

p(_, <<>>) ->
    {ok, []};

p(13028, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13030, << VpropsAL_:16,Vprops/binary >>) ->
    VpropsF_ = fun({B_, R_}) ->
            << Vid1:32,Vpile1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vpile1]|R_]}
    end,
    {_, VpropsR_} = protocol_fun:for(VpropsAL_, VpropsF_, {Vprops, []}),
    {ok, [VpropsR_]};

p(_, <<>>) ->
    {ok, []};

p(13032, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13040, << Vcode:8,Vdiamond:32,Vpos:8 >>) ->
    {ok, [Vcode,Vdiamond,Vpos]};

p(_, <<>>) ->
    {ok, []};

p(13042, << VrecentAL_:16,Vrecent/binary >>) ->
    VrecentF_ = fun({B_, R_}) ->
            << Vname1L_:16,Vname1:Vname1L_/binary,Vreward_id1:32,Vreward_num1:32,RB_/binary >> = B_, 
            {RB_, [[Vname1,Vreward_id1,Vreward_num1]|R_]}
    end,
    {_, VrecentR_} = protocol_fun:for(VrecentAL_, VrecentF_, {Vrecent, []}),
    {ok, [VrecentR_]};

p(_, <<>>) ->
    {ok, []};

p(13044, << VrecentAL_:16,Vrecent/binary >>) ->
    VrecentF_ = fun({B_, R_}) ->
            << Vname1L_:16,Vname1:Vname1L_/binary,Vvalues1:32,Vsum1:32,RB_/binary >> = B_, 
            {RB_, [[Vname1,Vvalues1,Vsum1]|R_]}
    end,
    {_, VrecentR_} = protocol_fun:for(VrecentAL_, VrecentF_, {Vrecent, []}),
    {ok, [VrecentR_]};

p(_, <<>>) ->
    {ok, []};

p(13045, << Vid:8,Vluck:32,Vvalues:32 >>) ->
    {ok, [Vid,Vluck,Vvalues]};

p(_, <<>>) ->
    {ok, []};

p(13051, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13052, << Vcode:8,Vtype:8,Vdays1:8,Vdays2:8,VdaysAL_:16,Vdays/binary >>) ->
    VdaysF_ = fun({B_, R_}) ->
            << Vday1:8,Vstate1:8,RB_/binary >> = B_, 
            {RB_, [[Vday1,Vstate1]|R_]}
    end,
    {_, VdaysR_} = protocol_fun:for(VdaysAL_, VdaysF_, {Vdays, []}),
    {ok, [Vcode,Vtype,Vdays1,Vdays2,VdaysR_]};

p(_, <<>>) ->
    {ok, []};

p(13054, << Vcode:8,Vdays1:8,Vdays2:8,VdaysAL_:16,Vdays/binary >>) ->
    VdaysF_ = fun({B_, R_}) ->
            << Vday1:8,Vstate1:8,RB_/binary >> = B_, 
            {RB_, [[Vday1,Vstate1]|R_]}
    end,
    {_, VdaysR_} = protocol_fun:for(VdaysAL_, VdaysF_, {Vdays, []}),
    {ok, [Vcode,Vdays1,Vdays2,VdaysR_]};

p(_, <<>>) ->
    {ok, []};

p(13056, << Vcode:8,Vstate:8 >>) ->
    {ok, [Vcode,Vstate]};

p(_, <<>>) ->
    {ok, []};

p(13058, << Vid:8 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(13059, << Vcode:8,Vid:8,Vtype:8 >>) ->
    {ok, [Vcode,Vid,Vtype]};

p(_, <<>>) ->
    {ok, []};

p(13062, << VheroseAL_:16,Vherose/binary >>) ->
    VheroseF_ = fun({B_, R_}) ->
            << Vid1:32,RB_/binary >> = B_, 
            {RB_, [[Vid1]|R_]}
    end,
    {_, VheroseR_} = protocol_fun:for(VheroseAL_, VheroseF_, {Vherose, []}),
    {ok, [VheroseR_]};

p(_, <<>>) ->
    {ok, []};

p(13064, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(13066, << Vcode:8,VcustomL_:16,Vcustom:VcustomL_/binary >>) ->
    {ok, [Vcode,Vcustom]};

p(_, <<>>) ->
    {ok, []};

p(14001, << Vstatus:8 >>) ->
    {ok, [Vstatus]};

p(_, <<>>) ->
    {ok, []};

p(14002, << VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:32,Vtype1:32,Vseat1:8,Vquality1:8,Vlevel1:8,Vexp1:32,Vfoster1:8,Vhp1:32,Vattack1:32,Vdefend1:32,Vpuncture1:32,Vhit1:32,Vdodge1:32,Vcrit1:32,VcritPercentage1:32,VanitCrit1:32,Vtoughness1:32,Vseat11:32,Vseat21:32,Vseat31:32,Vseat41:32,Vseat51:32,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vtype1,Vseat1,Vquality1,Vlevel1,Vexp1,Vfoster1,Vhp1,Vattack1,Vdefend1,Vpuncture1,Vhit1,Vdodge1,Vcrit1,VcritPercentage1,VanitCrit1,Vtoughness1,Vseat11,Vseat21,Vseat31,Vseat41,Vseat51]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(14010, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(14015, << VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:32,RB_/binary >> = B_, 
            {RB_, [[Vid1]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(14019, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(14020, << Vcode:8,Vcd:32,VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:8,Vtype1:32,Vlock1:8,Vquality1:8,Vravity1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vtype1,Vlock1,Vquality1,Vravity1]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [Vcode,Vcd,VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(14022, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(14023, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(14025, << Vid:32,Vtype:32,Vseat:8,Vquality:8,Vlevel:8,Vexp:32,Vfoster:8,Vhp:32,Vattack:32,Vdefend:32,Vpuncture:32,Vhit:32,Vdodge:32,Vcrit:32,VcritPercentage:32,VanitCrit:32,Vtoughness:32,Vseat1:32,Vseat2:32,Vseat3:32,Vseat4:32,Vseat5:32 >>) ->
    {ok, [Vid,Vtype,Vseat,Vquality,Vlevel,Vexp,Vfoster,Vhp,Vattack,Vdefend,Vpuncture,Vhit,Vdodge,Vcrit,VcritPercentage,VanitCrit,Vtoughness,Vseat1,Vseat2,Vseat3,Vseat4,Vseat5]};

p(_, <<>>) ->
    {ok, []};

p(14030, << Vcode:8,Vheroid:32,Vlevel:8,Vexp:32 >>) ->
    {ok, [Vcode,Vheroid,Vlevel,Vexp]};

p(_, <<>>) ->
    {ok, []};

p(14032, << Vcode:8,Vnum:8 >>) ->
    {ok, [Vcode,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(14034, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(14035, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(22002, Bin) ->
    protocol_fun:unpack(22002, [int32,int16,int8,int8,[int8,int32,int32],[int8,[int32],[int8,int32,int8,[int32]],int32],[int32,int8,int32],[int32,int32,int32,int8,int8,[int32,int32],int32,int32,int32,int32,int32,int32,int32,int32,int32,int32],[int32,int32,int8,int8,int32]], Bin);

p(_, <<>>) ->
    {ok, []};

p(22010, << Vgate:16,Vnum:8,Vtime:32,Vnum2:8 >>) ->
    {ok, [Vgate,Vnum,Vtime,Vnum2]};

p(_, <<>>) ->
    {ok, []};

p(22014, << Vcode:8,Vgate:16,Vnum:8,Vnum2:8 >>) ->
    {ok, [Vcode,Vgate,Vnum,Vnum2]};

p(_, <<>>) ->
    {ok, []};

p(22020, << VnightmareInfoAL_:16,VnightmareInfo/binary >>) ->
    VnightmareInfoF_ = fun({B_, R_}) ->
            << Vid1:16,Vstar1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vstar1]|R_]}
    end,
    {_, VnightmareInfoR_} = protocol_fun:for(VnightmareInfoAL_, VnightmareInfoF_, {VnightmareInfo, []}),
    {ok, [VnightmareInfoR_]};

p(_, <<>>) ->
    {ok, []};

p(22021, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(23001, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(23004, << Vrank:32,Vpoint:32,Vhonor:32,Vlevel:8 >>) ->
    {ok, [Vrank,Vpoint,Vhonor,Vlevel]};

p(_, <<>>) ->
    {ok, []};

p(23012, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(23014, << VlistsAL_:16,Vlists/binary >>) ->
    VlistsF_ = fun({B_, R_}) ->
            << Vid1:32,Vname1L_:16,Vname1:Vname1L_/binary,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vname1]|R_]}
    end,
    {_, VlistsR_} = protocol_fun:for(VlistsAL_, VlistsF_, {Vlists, []}),
    {ok, [VlistsR_]};

p(_, <<>>) ->
    {ok, []};

p(23015, << Vnumber:8,Vcd:32,Vchance:8,Vteam1:8,Vteam2:8,VtargetsAL_:16,Vtargets/binary >>) ->
    VtargetsF_ = fun({B_, R_}) ->
            << Vid1:32,Vname1L_:16,Vname1:Vname1L_/binary,Vpicture1:8,Vbeat1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vname1,Vpicture1,Vbeat1]|R_]}
    end,
    {_, VtargetsR_} = protocol_fun:for(VtargetsAL_, VtargetsF_, {Vtargets, []}),
    {ok, [Vnumber,Vcd,Vchance,Vteam1,Vteam2,VtargetsR_]};

p(_, <<>>) ->
    {ok, []};

p(23016, << VlistsAL_:16,Vlists/binary >>) ->
    VlistsF_ = fun({B_, R_}) ->
            << Vindex1:16,Vid1:32,Vname1L_:16,Vname1:Vname1L_/binary,Vexp1:16,Vfighting1:32,RB_/binary >> = B_, 
            {RB_, [[Vindex1,Vid1,Vname1,Vexp1,Vfighting1]|R_]}
    end,
    {_, VlistsR_} = protocol_fun:for(VlistsAL_, VlistsF_, {Vlists, []}),
    {ok, [VlistsR_]};

p(_, <<>>) ->
    {ok, []};

p(23017, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(23018, << VactiveAL_:16,Vactive/binary >>) ->
    VactiveF_ = fun({B_, R_}) ->
            << Vid1:32,Vname11L_:16,Vname11:Vname11L_/binary,Vname21L_:16,Vname21:Vname21L_/binary,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vname11,Vname21]|R_]}
    end,
    {_, VactiveR_} = protocol_fun:for(VactiveAL_, VactiveF_, {Vactive, []}),
    {ok, [VactiveR_]};

p(_, <<>>) ->
    {ok, []};

p(23022, << Vcode:8,Vtime:32,Vteam1:8,Vteam2:8,VtargetsAL_:16,Vtargets/binary >>) ->
    VtargetsF_ = fun({B_, R_}) ->
            << Vid1:32,Vname1L_:16,Vname1:Vname1L_/binary,Vpicture1:8,Vbeat1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vname1,Vpicture1,Vbeat1]|R_]}
    end,
    {_, VtargetsR_} = protocol_fun:for(VtargetsAL_, VtargetsF_, {Vtargets, []}),
    {ok, [Vcode,Vtime,Vteam1,Vteam2,VtargetsR_]};

p(_, <<>>) ->
    {ok, []};

p(23024, << Vcode:8,Vnum:8 >>) ->
    {ok, [Vcode,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(23025, << Vcode:8,VmessegeAL_:16,Vmessege/binary >>) ->
    VmessegeF_ = fun({B_, R_}) ->
            << Vtype1:32,Vlevel1:16,Vhp1:32,Vseat1:16,Vweapon1:32,RB_/binary >> = B_, 
            {RB_, [[Vtype1,Vlevel1,Vhp1,Vseat1,Vweapon1]|R_]}
    end,
    {_, VmessegeR_} = protocol_fun:for(VmessegeAL_, VmessegeF_, {Vmessege, []}),
    {ok, [Vcode,VmessegeR_]};

p(_, <<>>) ->
    {ok, []};

p(23028, << Vcode:8,Vgold:32,Vhonor:32 >>) ->
    {ok, [Vcode,Vgold,Vhonor]};

p(_, <<>>) ->
    {ok, []};

p(23029, << Vcode:8,Vgold:32,Vhonor:32,Vpoint:16 >>) ->
    {ok, [Vcode,Vgold,Vhonor,Vpoint]};

p(_, <<>>) ->
    {ok, []};

p(23033, << Vgold:32,Vadd_exp:32,Vlev:8,Vexp:32 >>) ->
    {ok, [Vgold,Vadd_exp,Vlev,Vexp]};

p(_, <<>>) ->
    {ok, []};

p(23035, << VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:32,Vtype1:32,Vseat1:8,Vquality1:8,Vlevel1:8,Vexp1:32,Vfoster1:8,Vhp1:32,Vattack1:32,Vdefend1:32,Vpuncture1:32,Vhit1:32,Vdodge1:32,Vcrit1:32,VcritPercentage1:32,VanitCrit1:32,Vtoughness1:32,Vseat11:32,Vseat21:32,Vseat31:32,Vseat41:32,Vseat51:32,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vtype1,Vseat1,Vquality1,Vlevel1,Vexp1,Vfoster1,Vhp1,Vattack1,Vdefend1,Vpuncture1,Vhit1,Vdodge1,Vcrit1,VcritPercentage1,VanitCrit1,Vtoughness1,Vseat11,Vseat21,Vseat31,Vseat41,Vseat51]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(24001, << Vid:32 >>) ->
    {ok, [Vid]};

p(_, <<>>) ->
    {ok, []};

p(24002, << Vid:32,Vnum:32 >>) ->
    {ok, [Vid,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(24003, << Vid:32,Vnum:8 >>) ->
    {ok, [Vid,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(24004, << Vcode:8,Vid:16,Vtype:8 >>) ->
    {ok, [Vcode,Vid,Vtype]};

p(_, <<>>) ->
    {ok, []};

p(24006, << VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << Vid1:32,Vnum1:32,Vtype1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vnum1,Vtype1]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(25001, << VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << Vid1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(25002, << Vcode:32,VloadUrlL_:16,VloadUrl:VloadUrlL_/binary,VratingUrlL_:16,VratingUrl:VratingUrlL_/binary,VidsAL_:16,Vids/binary >>) ->
    VidsF_ = fun({B_, R_}) ->
            << Vid1:8,Vval1:32,Vnum1:8,Vstate1:8,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vval1,Vnum1,Vstate1]|R_]}
    end,
    {_, VidsR_} = protocol_fun:for(VidsAL_, VidsF_, {Vids, []}),
    {ok, [Vcode,VloadUrl,VratingUrl,VidsR_]};

p(_, <<>>) ->
    {ok, []};

p(25004, << Vcode:8,VitemsAL_:16,Vitems/binary >>) ->
    VitemsF_ = fun({B_, R_}) ->
            << Vtid1:32,Vnum1:8,RB_/binary >> = B_, 
            {RB_, [[Vtid1,Vnum1]|R_]}
    end,
    {_, VitemsR_} = protocol_fun:for(VitemsAL_, VitemsF_, {Vitems, []}),
    {ok, [Vcode,VitemsR_]};

p(_, <<>>) ->
    {ok, []};

p(25030, << Vcode:8,Vnum:32 >>) ->
    {ok, [Vcode,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(25031, << Vcode:8,Vnum:32 >>) ->
    {ok, [Vcode,Vnum]};

p(_, <<>>) ->
    {ok, []};

p(25032, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25033, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25034, << Vcode:8,Vnum:8,Vstate:8 >>) ->
    {ok, [Vcode,Vnum,Vstate]};

p(_, <<>>) ->
    {ok, []};

p(25035, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25036, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25038, << Vcode:8,Vnum:8,Vstate:8 >>) ->
    {ok, [Vcode,Vnum,Vstate]};

p(_, <<>>) ->
    {ok, []};

p(25040, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25041, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25044, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(25046, << VdoubleidsAL_:16,Vdoubleids/binary >>) ->
    VdoubleidsF_ = fun({B_, R_}) ->
            << V01:32,RB_/binary >> = B_, 
            {RB_, [[V01]|R_]}
    end,
    {_, VdoubleidsR_} = protocol_fun:for(VdoubleidsAL_, VdoubleidsF_, {Vdoubleids, []}),
    {ok, [VdoubleidsR_]};

p(_, <<>>) ->
    {ok, []};

p(26005, Bin) ->
    protocol_fun:unpack(26005, [[int32,string,string,int32,[int32,int32,int32]]], Bin);

p(_, <<>>) ->
    {ok, []};

p(26010, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(26015, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(27010, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(27020, << Vtype:8,Vid:32,VnameL_:16,Vname:VnameL_/binary,VcontentL_:16,Vcontent:VcontentL_/binary,Vattr:8 >>) ->
    {ok, [Vtype,Vid,Vname,Vcontent,Vattr]};

p(_, <<>>) ->
    {ok, []};

p(29010, << Vtype:8,Vnum:32,Vlev:8,VranksAL_:16,Vranks/binary >>) ->
    VranksF_ = fun({B_, R_}) ->
            << Vindex1:32,Vattr1:32,Vid1:32,Vname1L_:16,Vname1:Vname1L_/binary,Vpicture1:8,Vcustom1:32,RB_/binary >> = B_, 
            {RB_, [[Vindex1,Vattr1,Vid1,Vname1,Vpicture1,Vcustom1]|R_]}
    end,
    {_, VranksR_} = protocol_fun:for(VranksAL_, VranksF_, {Vranks, []}),
    {ok, [Vtype,Vnum,Vlev,VranksR_]};

p(_, <<>>) ->
    {ok, []};

p(29020, << VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:32,Vtype1:32,Vseat1:8,Vquality1:8,Vlevel1:8,Vexp1:32,Vfoster1:8,Vhp1:32,Vattack1:32,Vdefend1:32,Vpuncture1:32,Vhit1:32,Vdodge1:32,Vcrit1:32,VcritPercentage1:32,VanitCrit1:32,Vtoughness1:32,Vseat11:32,Vseat21:32,Vseat31:32,Vseat41:32,Vseat51:32,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vtype1,Vseat1,Vquality1,Vlevel1,Vexp1,Vfoster1,Vhp1,Vattack1,Vdefend1,Vpuncture1,Vhit1,Vdodge1,Vcrit1,VcritPercentage1,VanitCrit1,Vtoughness1,Vseat11,Vseat21,Vseat31,Vseat41,Vseat51]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(33001, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(33012, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(33014, << VlistsAL_:16,Vlists/binary >>) ->
    VlistsF_ = fun({B_, R_}) ->
            << Vid1:32,Vname1L_:16,Vname1:Vname1L_/binary,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vname1]|R_]}
    end,
    {_, VlistsR_} = protocol_fun:for(VlistsAL_, VlistsF_, {Vlists, []}),
    {ok, [VlistsR_]};

p(_, <<>>) ->
    {ok, []};

p(33024, << Vcode:8,Vnum:8,Vwars:32 >>) ->
    {ok, [Vcode,Vnum,Vwars]};

p(_, <<>>) ->
    {ok, []};

p(33025, << Vcode:8,Vid:32,VmessegeAL_:16,Vmessege/binary >>) ->
    VmessegeF_ = fun({B_, R_}) ->
            << Vtype1:32,Vlevel1:16,Vhp1:32,Vseat1:16,Vweapon1:32,RB_/binary >> = B_, 
            {RB_, [[Vtype1,Vlevel1,Vhp1,Vseat1,Vweapon1]|R_]}
    end,
    {_, VmessegeR_} = protocol_fun:for(VmessegeAL_, VmessegeF_, {Vmessege, []}),
    {ok, [Vcode,Vid,VmessegeR_]};

p(_, <<>>) ->
    {ok, []};

p(33035, << VheroesAL_:16,Vheroes/binary >>) ->
    VheroesF_ = fun({B_, R_}) ->
            << Vid1:32,Vtype1:32,Vseat1:8,Vquality1:8,Vlevel1:8,Vexp1:32,Vfoster1:8,Vhp1:32,Vattack1:32,Vdefend1:32,Vpuncture1:32,Vhit1:32,Vdodge1:32,Vcrit1:32,VcritPercentage1:32,VanitCrit1:32,Vtoughness1:32,Vseat11:32,Vseat21:32,Vseat31:32,Vseat41:32,Vseat51:32,RB_/binary >> = B_, 
            {RB_, [[Vid1,Vtype1,Vseat1,Vquality1,Vlevel1,Vexp1,Vfoster1,Vhp1,Vattack1,Vdefend1,Vpuncture1,Vhit1,Vdodge1,Vcrit1,VcritPercentage1,VanitCrit1,Vtoughness1,Vseat11,Vseat21,Vseat31,Vseat41,Vseat51]|R_]}
    end,
    {_, VheroesR_} = protocol_fun:for(VheroesAL_, VheroesF_, {Vheroes, []}),
    {ok, [VheroesR_]};

p(_, <<>>) ->
    {ok, []};

p(33037, << Vrank:32,Vexp:32,Vlevel:8,Vwars:8,Vchance:8,Vcd:32,VtargetsAL_:16,Vtargets/binary >>) ->
    VtargetsF_ = fun({B_, R_}) ->
            << Vpos1:32,Vid1:32,Vrid1:32,Vname1L_:16,Vname1:Vname1L_/binary,Vpicture1:8,Vpower1:32,RB_/binary >> = B_, 
            {RB_, [[Vpos1,Vid1,Vrid1,Vname1,Vpicture1,Vpower1]|R_]}
    end,
    {_, VtargetsR_} = protocol_fun:for(VtargetsAL_, VtargetsF_, {Vtargets, []}),
    {ok, [Vrank,Vexp,Vlevel,Vwars,Vchance,Vcd,VtargetsR_]};

p(_, <<>>) ->
    {ok, []};

p(33040, << Vtype:8 >>) ->
    {ok, [Vtype]};

p(_, <<>>) ->
    {ok, []};

p(33042, << Vdiamond:32,Vgold:32,Vhonor:32 >>) ->
    {ok, [Vdiamond,Vgold,Vhonor]};

p(_, <<>>) ->
    {ok, []};

p(34010, << VvideoRankInfoAL_:16,VvideoRankInfo/binary >>) ->
    VvideoRankInfoF_ = fun({B_, R_}) ->
            << Vname1L_:16,Vname1:Vname1L_/binary,Vpower1:32,Vpicture1:8,RB_/binary >> = B_, 
            {RB_, [[Vname1,Vpower1,Vpicture1]|R_]}
    end,
    {_, VvideoRankInfoR_} = protocol_fun:for(VvideoRankInfoAL_, VvideoRankInfoF_, {VvideoRankInfo, []}),
    {ok, [VvideoRankInfoR_]};

p(_, <<>>) ->
    {ok, []};

p(34020, Bin) ->
    protocol_fun:unpack(34020, [[int32,int32,int8,int8,int8,int32,int32,int32,int32,int32,int32,int32,int32,int32,int32,int32,int32,int32,int32,int32],[int8,[int8,int32,int32],[int8,[int32],[int8,int32,int8,[int32]],int32],[int32,int8,int32]]], Bin);

p(_, <<>>) ->
    {ok, []};

p(35001, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(35010, << Vlev:8,Vdiamond:32,Vfree:32,Vchattime:8,Vprize:8,Vfast:8,Vtired:8,Vcoli_buy:8,Vfb_buy:8 >>) ->
    {ok, [Vlev,Vdiamond,Vfree,Vchattime,Vprize,Vfast,Vtired,Vcoli_buy,Vfb_buy]};

p(_, <<>>) ->
    {ok, []};

p(35020, << Vcode:8 >>) ->
    {ok, [Vcode]};

p(_, <<>>) ->
    {ok, []};

p(Cmd, Data) -> 
    io:format("undefined_pt_unpack_client_cmd:~w, data:~w", [Cmd, Data]),
    {error, undefined_pt_unpack_client_cmd}.

%% vim: ft=erlang :
