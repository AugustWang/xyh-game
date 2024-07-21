-module(data_task).
-export([get/1]).
get(ids) -> [1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012];
get(1001) -> [{type, 1}, {target, 1}, {condition, [{30001,1}]}, {award, [{1,10000},{2,10},{41001,1}]}];
get(1002) -> [{type, 1}, {target, 1}, {condition, [{30002,1}]}, {award, [{1,20000},{2,10},{41001,1}]}, {before1, [1001,101]}, {lev1, 5}];
get(1003) -> [{type, 1}, {target, 1}, {condition, [{30003,1}]}, {award, [{1,30000},{2,10},{41001,1}]}, {before1, [1002,102]}, {lev1, 10}];
get(1004) -> [{type, 1}, {target, 1}, {condition, [{30004,1}]}, {award, [{1,50000},{2,10},{41001,1}]}, {before1, [1003,104]}, {lev1, 17}];
get(1005) -> [{type, 1}, {target, 1}, {condition, [{30005,1}]}, {award, [{1,80000},{2,10},{41001,1}]}, {before1, [1004,106]}, {lev1, 22}];
get(1006) -> [{type, 1}, {target, 1}, {condition, [{30006,0}]}, {award, [{1,100000},{2,10},{41001,2}]}, {before1, [1005,108]}, {lev1, 27}];
get(1007) -> [{type, 1}, {target, 1}, {condition, [{30007,1}]}, {award, [{1,120000},{2,10},{41001,3}]}, {before1, [1006,110]}, {lev1, 32}];
get(1008) -> [{type, 1}, {target, 1}, {condition, [{30008,1}]}, {award, [{1,150000},{2,10},{41001,4}]}, {before1, [1007,112]}, {lev1, 36}];
get(1009) -> [{type, 1}, {target, 1}, {condition, [{30009,1}]}, {award, [{1,180000},{2,10},{41001,5}]}, {before1, [1008,114]}, {lev1, 40}];
get(1010) -> [{type, 1}, {target, 1}, {condition, [{30010,0}]}, {award, [{1,220000},{2,10},{41001,10}]}, {before1, [1009,116]}, {lev1, 45}];
get(1011) -> [{type, 1}, {target, 1}, {condition, [{30011,1}]}, {award, [{1,250000},{2,10},{41001,10}]}, {before1, [1010,118]}, {lev1, 49}];
get(1012) -> [{type, 1}, {target, 1}, {condition, [{30012,1}]}, {award, [{1,300000},{2,10},{41001,15}]}, {before1, [1011,120]}, {lev1, 52}];
get(1013) -> [{type, 1}, {target, 1}, {condition, [{30013,0}]}, {award, [{1,350000},{2,10},{41001,1}]}, {before1, [1012,122]}, {lev1, 57}];
get(101) -> [{type, 2}, {target, 1}, {condition, [{9,1}]}, {award, [{1,7000},{2,10}]}, {before1, [1001]}];
get(102) -> [{type, 2}, {target, 1}, {condition, [{18,1}]}, {award, [{1,7000},{2,10},{13001,2}]}, {before1, [101]}];
get(103) -> [{type, 2}, {target, 1}, {condition, [{24,1}]}, {award, [{1,7000},{2,10}]}, {before1, [102]}];
get(104) -> [{type, 2}, {target, 1}, {condition, [{33,1}]}, {award, [{1,7000},{2,10}]}, {before1, [103]}];
get(105) -> [{type, 2}, {target, 1}, {condition, [{45,1}]}, {award, [{1,7000},{2,10}]}, {before1, [104]}];
get(106) -> [{type, 2}, {target, 1}, {condition, [{57,1}]}, {award, [{1,8000},{2,20}]}, {before1, [105]}];
get(107) -> [{type, 2}, {target, 1}, {condition, [{66,1}]}, {award, [{1,8000},{2,20}]}, {before1, [106]}];
get(108) -> [{type, 2}, {target, 1}, {condition, [{75,1}]}, {award, [{1,8000},{2,20}]}, {before1, [107]}];
get(109) -> [{type, 2}, {target, 1}, {condition, [{87,1}]}, {award, [{1,8000},{2,20}]}, {before1, [108]}];
get(110) -> [{type, 2}, {target, 1}, {condition, [{99,1}]}, {award, [{1,8000},{2,20}]}, {before1, [109]}];
get(111) -> [{type, 2}, {target, 1}, {condition, [{108,1}]}, {award, [{1,9000},{2,30}]}, {before1, [110]}];
get(112) -> [{type, 2}, {target, 1}, {condition, [{117,1}]}, {award, [{1,9000},{2,30}]}, {before1, [111]}];
get(113) -> [{type, 2}, {target, 1}, {condition, [{129,1}]}, {award, [{1,9000},{2,30}]}, {before1, [112]}];
get(114) -> [{type, 2}, {target, 1}, {condition, [{141,1}]}, {award, [{1,9000},{2,30}]}, {before1, [113]}];
get(115) -> [{type, 2}, {target, 1}, {condition, [{153,1}]}, {award, [{1,9000},{2,30}]}, {before1, [114]}];
get(116) -> [{type, 2}, {target, 1}, {condition, [{162,1}]}, {award, [{1,10000},{2,40}]}, {before1, [115]}];
get(117) -> [{type, 2}, {target, 1}, {condition, [{174,1}]}, {award, [{1,10000},{2,40}]}, {before1, [116]}];
get(118) -> [{type, 2}, {target, 1}, {condition, [{183,1}]}, {award, [{1,10000},{2,40}]}, {before1, [117]}];
get(119) -> [{type, 2}, {target, 1}, {condition, [{198,1}]}, {award, [{1,10000},{2,40}]}, {before1, [118]}];
get(120) -> [{type, 2}, {target, 1}, {condition, [{210,1}]}, {award, [{1,20000},{2,50}]}, {before1, [119]}];
get(121) -> [{type, 2}, {target, 1}, {condition, [{222,1}]}, {award, [{1,20000},{2,50}]}, {before1, [120]}];
get(122) -> [{type, 2}, {target, 1}, {condition, [{243,1}]}, {award, [{1,20000},{2,50}]}, {before1, [121]}];
get(123) -> [{type, 2}, {target, 1}, {condition, [{264,1}]}, {award, [{1,20000},{2,50}]}, {before1, [122]}];
get(201) -> [{type, 3}, {target, 2}, {condition, [{28,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [1001]}];
get(202) -> [{type, 3}, {target, 1}, {condition, [{3,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [201]}];
get(203) -> [{type, 3}, {target, 2}, {condition, [{104,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [201]}];
get(204) -> [{type, 3}, {target, 1}, {condition, [{6,1}]}, {award, [{1,2000},{10101,2},{2113001,1}]}, {before1, [203]}];
get(205) -> [{type, 3}, {target, 2}, {condition, [{60,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [101]}];
get(206) -> [{type, 3}, {target, 1}, {condition, [{12,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [205]}];
get(207) -> [{type, 3}, {target, 2}, {condition, [{94,1}]}, {award, [{1,2000},{10101,2},{2114001,1}]}, {before1, [205]}];
get(208) -> [{type, 3}, {target, 1}, {condition, [{15,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [207]}];
get(209) -> [{type, 3}, {target, 2}, {condition, [{22,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [102]}];
get(210) -> [{type, 3}, {target, 1}, {condition, [{21,1}]}, {award, [{1,2000},{10101,2},{2115001,1}]}, {before1, [209]}];
get(211) -> [{type, 3}, {target, 2}, {condition, [{20028,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [209]}];
get(212) -> [{type, 3}, {target, 1}, {condition, [{1001,1}]}, {award, [{1,2000},{10101,2}]}, {before1, [211]}];
get(213) -> [{type, 3}, {target, 2}, {condition, [{29,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [103]}];
get(214) -> [{type, 3}, {target, 1}, {condition, [{27,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [213]}];
get(215) -> [{type, 3}, {target, 2}, {condition, [{113,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [213]}];
get(216) -> [{type, 3}, {target, 1}, {condition, [{30,1}]}, {award, [{1,2000},{30005,2},{2113002,1}]}, {before1, [215]}];
get(217) -> [{type, 3}, {target, 2}, {condition, [{108,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [104]}];
get(218) -> [{type, 3}, {target, 1}, {condition, [{36,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [217]}];
get(219) -> [{type, 3}, {target, 2}, {condition, [{98,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [217]}];
get(220) -> [{type, 3}, {target, 1}, {condition, [{39,1}]}, {award, [{1,3000},{30005,2},{2114002,1}]}, {before1, [219]}];
get(221) -> [{type, 3}, {target, 2}, {condition, [{117,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [219]}];
get(222) -> [{type, 3}, {target, 1}, {condition, [{42,1}]}, {award, [{1,2000},{10102,1},{30005,2}]}, {before1, [221]}];
get(223) -> [{type, 3}, {target, 2}, {condition, [{20054,1}]}, {award, [{1,3000},{10102,1},{30002,2}]}, {before1, [105]}];
get(224) -> [{type, 3}, {target, 1}, {condition, [{1014,1}]}, {award, [{1,3000},{30002,2},{2115002,1}]}, {before1, [223]}];
get(225) -> [{type, 3}, {target, 2}, {condition, [{61,1}]}, {award, [{1,3000},{10102,1},{30002,2}]}, {before1, [105]}];
get(226) -> [{type, 3}, {target, 1}, {condition, [{48,1}]}, {award, [{1,3000},{13002,2},{30002,2}]}, {before1, [225]}];
get(227) -> [{type, 3}, {target, 2}, {condition, [{15,1}]}, {award, [{1,3000},{13002,2},{30002,2}]}, {before1, [225]}];
get(228) -> [{type, 3}, {target, 1}, {condition, [{51,1}]}, {award, [{1,3000},{10103,1},{31,2}]}, {before1, [227]}];
get(229) -> [{type, 3}, {target, 2}, {condition, [{93,1}]}, {award, [{1,3000},{10103,1},{31,2}]}, {before1, [227]}];
get(230) -> [{type, 3}, {target, 1}, {condition, [{54,1}]}, {award, [{1,3000},{10103,1},{31,2}]}, {before1, [229]}];
get(231) -> [{type, 3}, {target, 2}, {condition, [{20029,1}]}, {award, [{1,3000},{10103,1},{31,2}]}, {before1, [227]}];
get(232) -> [{type, 3}, {target, 1}, {condition, [{1002,1}]}, {award, [{1,3000},{10103,2},{2113003,1}]}, {before1, [231]}];
get(233) -> [{type, 3}, {target, 2}, {condition, [{40,1}]}, {award, [{1,3000},{10103,1},{31,2}]}, {before1, [106]}];
get(234) -> [{type, 3}, {target, 1}, {condition, [{60,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [233]}];
get(235) -> [{type, 3}, {target, 2}, {condition, [{120,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [233]}];
get(236) -> [{type, 3}, {target, 1}, {condition, [{63,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [235]}];
get(237) -> [{type, 3}, {target, 2}, {condition, [{20,2}]}, {award, [{1,4000},{10102,2},{2114003,1}]}, {before1, [107]}];
get(238) -> [{type, 3}, {target, 1}, {condition, [{69,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [237]}];
get(239) -> [{type, 3}, {target, 2}, {condition, [{23,2}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [237]}];
get(240) -> [{type, 3}, {target, 1}, {condition, [{72,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [239]}];
get(241) -> [{type, 3}, {target, 2}, {condition, [{20055,2}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [108]}];
get(242) -> [{type, 3}, {target, 1}, {condition, [{1015,1}]}, {award, [{1,4000},{10103,2},{2115003,1}]}, {before1, [241]}];
get(243) -> [{type, 3}, {target, 2}, {condition, [{46,2}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [108]}];
get(244) -> [{type, 3}, {target, 1}, {condition, [{78,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [243]}];
get(245) -> [{type, 3}, {target, 2}, {condition, [{123,2}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [243]}];
get(246) -> [{type, 3}, {target, 1}, {condition, [{81,1}]}, {award, [{1,4000},{10103,1},{31,2}]}, {before1, [245]}];
get(247) -> [{type, 3}, {target, 2}, {condition, [{20032,2}]}, {award, [{1,5000},{13002,1},{12012,1}]}, {before1, [245]}];
get(248) -> [{type, 3}, {target, 1}, {condition, [{1003,1}]}, {award, [{1,5000},{13002,1},{12022,1}]}, {before1, [247]}];
get(249) -> [{type, 3}, {target, 2}, {condition, [{125,2}]}, {award, [{1,5000},{13002,1},{12032,1}]}, {before1, [245]}];
get(250) -> [{type, 3}, {target, 1}, {condition, [{84,1}]}, {award, [{1,5000},{13002,1},{12042,1}]}, {before1, [249]}];
get(251) -> [{type, 3}, {target, 2}, {condition, [{127,2}]}, {award, [{1,5000},{13002,1},{12052,1}]}, {before1, [109]}];
get(252) -> [{type, 3}, {target, 1}, {condition, [{90,1}]}, {award, [{1,5000},{12062,1},{2113004,1}]}, {before1, [251]}];
get(253) -> [{type, 3}, {target, 2}, {condition, [{129,2}]}, {award, [{1,5000},{13002,1},{12072,1}]}, {before1, [251]}];
get(254) -> [{type, 3}, {target, 1}, {condition, [{93,1}]}, {award, [{1,5000},{13002,1},{12082,1}]}, {before1, [253]}];
get(255) -> [{type, 3}, {target, 2}, {condition, [{131,2}]}, {award, [{1,5000},{13002,1},{12092,1}]}, {before1, [253]}];
get(256) -> [{type, 3}, {target, 1}, {condition, [{96,1}]}, {award, [{1,5000},{13002,1},{12102,1}]}, {before1, [255]}];
get(257) -> [{type, 3}, {target, 2}, {condition, [{107,2}]}, {award, [{1,5000},{12012,1},{2114004,1}]}, {before1, [110]}];
get(258) -> [{type, 3}, {target, 1}, {condition, [{102,1}]}, {award, [{1,5000},{13002,1},{12022,1}]}, {before1, [257]}];
get(259) -> [{type, 3}, {target, 2}, {condition, [{218,2}]}, {award, [{1,5000},{13002,1},{12032,1}]}, {before1, [257]}];
get(260) -> [{type, 3}, {target, 1}, {condition, [{105,1}]}, {award, [{1,5000},{13002,1},{12042,1}]}, {before1, [259]}];
get(261) -> [{type, 3}, {target, 2}, {condition, [{20034,2},{20080,2}]}, {award, [{1,5000},{13002,1},{12052,1}]}, {before1, [111]}];
get(262) -> [{type, 3}, {target, 1}, {condition, [{1004,1}]}, {award, [{1,5000},{12062,1},{2115004,1}]}, {before1, [261]}];
get(263) -> [{type, 3}, {target, 2}, {condition, [{37,2}]}, {award, [{1,5000},{13002,1},{12072,1}]}, {before1, [111]}];
get(264) -> [{type, 3}, {target, 1}, {condition, [{111,1}]}, {award, [{1,5000},{13002,1},{12082,1}]}, {before1, [263]}];
get(265) -> [{type, 3}, {target, 2}, {condition, [{139,2}]}, {award, [{1,5000},{13002,1},{12092,1}]}, {before1, [263]}];
get(266) -> [{type, 3}, {target, 1}, {condition, [{114,1}]}, {award, [{1,5000},{13002,1},{12102,1}]}, {before1, [265]}];
get(267) -> [{type, 3}, {target, 2}, {condition, [{100,2}]}, {award, [{1,5000},{13003,1},{30002,2}]}, {before1, [112]}];
get(268) -> [{type, 3}, {target, 1}, {condition, [{120,1}]}, {award, [{1,6000},{13003,1},{2113005,1}]}, {before1, [267]}];
get(269) -> [{type, 3}, {target, 2}, {condition, [{141,2}]}, {award, [{1,6000},{13003,1},{30002,2}]}, {before1, [267]}];
get(270) -> [{type, 3}, {target, 1}, {condition, [{123,1}]}, {award, [{1,6000},{13003,1},{30002,2}]}, {before1, [269]}];
get(271) -> [{type, 3}, {target, 2}, {condition, [{20036,2}]}, {award, [{1,6000},{13003,1},{2114005,1}]}, {before1, [113]}];
get(272) -> [{type, 3}, {target, 1}, {condition, [{1005,1}]}, {award, [{1,6000},{13003,1},{30002,2}]}, {before1, [271]}];
get(273) -> [{type, 3}, {target, 2}, {condition, [{86,2}]}, {award, [{1,6000},{13003,1},{30002,2}]}, {before1, [113]}];
get(274) -> [{type, 3}, {target, 1}, {condition, [{132,1}]}, {award, [{1,6000},{13003,1},{2115005,1}]}, {before1, [273]}];
get(275) -> [{type, 3}, {target, 2}, {condition, [{146,2}]}, {award, [{1,6000},{13003,1},{30002,2}]}, {before1, [273]}];
get(276) -> [{type, 3}, {target, 1}, {condition, [{135,1}]}, {award, [{1,6000},{13003,1},{30002,2}]}, {before1, [275]}];
get(277) -> [{type, 3}, {target, 2}, {condition, [{87,2}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [275]}];
get(278) -> [{type, 3}, {target, 1}, {condition, [{138,1}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [277]}];
get(279) -> [{type, 3}, {target, 2}, {condition, [{20060,2},{20081,2}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [275]}];
get(280) -> [{type, 3}, {target, 1}, {condition, [{1017,1}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [279]}];
get(281) -> [{type, 3}, {target, 2}, {condition, [{67,2}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [114]}];
get(282) -> [{type, 3}, {target, 1}, {condition, [{144,1}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [281]}];
get(283) -> [{type, 3}, {target, 2}, {condition, [{148,2}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [281]}];
get(284) -> [{type, 3}, {target, 1}, {condition, [{147,1}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [283]}];
get(285) -> [{type, 3}, {target, 2}, {condition, [{150,2}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [283]}];
get(286) -> [{type, 3}, {target, 1}, {condition, [{150,1}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [285]}];
get(287) -> [{type, 3}, {target, 2}, {condition, [{20038,2}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [285]}];
get(288) -> [{type, 3}, {target, 1}, {condition, [{1006,1}]}, {award, [{1,7000},{10104,1},{2113006,1}]}, {before1, [287]}];
get(289) -> [{type, 3}, {target, 2}, {condition, [{20062,2}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [115]}];
get(290) -> [{type, 3}, {target, 1}, {condition, [{1018,1}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [289]}];
get(291) -> [{type, 3}, {target, 2}, {condition, [{152,2}]}, {award, [{1,7000},{10104,1},{32,1}]}, {before1, [115]}];
get(292) -> [{type, 3}, {target, 1}, {condition, [{156,1}]}, {award, [{1,7000},{10104,1},{2114006,1}]}, {before1, [291]}];
get(293) -> [{type, 3}, {target, 2}, {condition, [{83,2}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [291]}];
get(294) -> [{type, 3}, {target, 1}, {condition, [{159,1}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [293]}];
get(295) -> [{type, 3}, {target, 2}, {condition, [{155,2}]}, {award, [{1,7000},{10104,1},{32,2}]}, {before1, [116]}];
get(296) -> [{type, 3}, {target, 1}, {condition, [{165,1}]}, {award, [{1,7000},{10104,1},{2115006,1}]}, {before1, [295]}];
get(297) -> [{type, 3}, {target, 2}, {condition, [{156,2}]}, {award, [{1,8000},{10104,1},{32,2}]}, {before1, [295]}];
get(298) -> [{type, 3}, {target, 1}, {condition, [{168,1}]}, {award, [{1,8000},{10105,1},{13004,3}]}, {before1, [297]}];
get(299) -> [{type, 3}, {target, 2}, {condition, [{157,2}]}, {award, [{1,8000},{10105,1},{13004,3}]}, {before1, [297]}];
get(300) -> [{type, 3}, {target, 1}, {condition, [{171,1}]}, {award, [{1,8000},{10105,1},{13004,3}]}, {before1, [299]}];
get(301) -> [{type, 3}, {target, 2}, {condition, [{20023,2}]}, {award, [{1,8000},{10105,1},{13004,3}]}, {before1, [297]}];
get(302) -> [{type, 3}, {target, 1}, {condition, [{1007,1}]}, {award, [{1,8000},{10105,1},{13004,3}]}, {before1, [301]}];
get(303) -> [{type, 3}, {target, 2}, {condition, [{20063,2}]}, {award, [{1,9000},{12014,1},{2113007,1}]}, {before1, [117]}];
get(304) -> [{type, 3}, {target, 1}, {condition, [{1019,1}]}, {award, [{1,9000},{10105,1},{12024,1}]}, {before1, [303]}];
get(305) -> [{type, 3}, {target, 2}, {condition, [{90,3}]}, {award, [{1,9000},{10105,1},{12034,1}]}, {before1, [117]}];
get(306) -> [{type, 3}, {target, 1}, {condition, [{177,1}]}, {award, [{1,9000},{10105,1},{12044,1}]}, {before1, [305]}];
get(307) -> [{type, 3}, {target, 2}, {condition, [{162,3}]}, {award, [{1,9000},{10105,1},{12054,1}]}, {before1, [305]}];
get(308) -> [{type, 3}, {target, 1}, {condition, [{180,1}]}, {award, [{1,9000},{12064,1},{2114007,1}]}, {before1, [307]}];
get(309) -> [{type, 3}, {target, 2}, {condition, [{165,2}]}, {award, [{1,9000},{10105,1},{12074,1}]}, {before1, [118]}];
get(310) -> [{type, 3}, {target, 1}, {condition, [{186,1}]}, {award, [{1,9000},{10105,1},{12084,1}]}, {before1, [309]}];
get(311) -> [{type, 3}, {target, 2}, {condition, [{20087,2}]}, {award, [{1,9000},{10105,1},{12094,1}]}, {before1, [309]}];
get(312) -> [{type, 3}, {target, 1}, {condition, [{1008,1}]}, {award, [{1,9000},{10105,1},{12104,1}]}, {before1, [311]}];
get(313) -> [{type, 3}, {target, 2}, {condition, [{167,2}]}, {award, [{1,9000},{12014,1},{2115007,1}]}, {before1, [309]}];
get(314) -> [{type, 3}, {target, 1}, {condition, [{189,1}]}, {award, [{1,9000},{10105,1},{12024,1}]}, {before1, [313]}];
get(315) -> [{type, 3}, {target, 2}, {condition, [{169,3}]}, {award, [{1,9000},{10105,1},{12034,1}]}, {before1, [313]}];
get(316) -> [{type, 3}, {target, 1}, {condition, [{192,1}]}, {award, [{1,9000},{10105,1},{12044,1}]}, {before1, [315]}];
get(317) -> [{type, 3}, {target, 2}, {condition, [{76,3}]}, {award, [{1,10000},{10106,1},{12054,1}]}, {before1, [315]}];
get(318) -> [{type, 3}, {target, 1}, {condition, [{195,1}]}, {award, [{1,10000},{10106,1},{12064,1}]}, {before1, [317]}];
get(319) -> [{type, 3}, {target, 2}, {condition, [{174,2}]}, {award, [{1,10000},{10106,1},{12074,1}]}, {before1, [119]}];
get(320) -> [{type, 3}, {target, 1}, {condition, [{201,1}]}, {award, [{1,10000},{10106,1},{12084,1}]}, {before1, [319]}];
get(321) -> [{type, 3}, {target, 2}, {condition, [{175,3}]}, {award, [{1,10000},{10106,1},{12094,1}]}, {before1, [319]}];
get(322) -> [{type, 3}, {target, 1}, {condition, [{204,1}]}, {award, [{1,10000},{10106,1},{12104,1}]}, {before1, [321]}];
get(323) -> [{type, 3}, {target, 2}, {condition, [{20082,3}]}, {award, [{1,10000},{10106,1},{13004,2}]}, {before1, [321]}];
get(324) -> [{type, 3}, {target, 1}, {condition, [{1020,1}]}, {award, [{1,10000},{10106,1},{13004,2}]}, {before1, [323]}];
get(325) -> [{type, 3}, {target, 2}, {condition, [{177,2}]}, {award, [{1,10000},{13004,2},{2113008,1}]}, {before1, [321]}];
get(326) -> [{type, 3}, {target, 1}, {condition, [{207,1}]}, {award, [{1,10000},{10106,1},{13004,2}]}, {before1, [325]}];
get(327) -> [{type, 3}, {target, 2}, {condition, [{181,3}]}, {award, [{1,10000},{10106,1},{13004,2}]}, {before1, [120]}];
get(328) -> [{type, 3}, {target, 1}, {condition, [{213,1}]}, {award, [{1,10000},{10106,1},{13004,2}]}, {before1, [327]}];
get(329) -> [{type, 3}, {target, 2}, {condition, [{43,3}]}, {award, [{1,11000},{13005,2},{2114008,1}]}, {before1, [327]}];
get(330) -> [{type, 3}, {target, 1}, {condition, [{216,1}]}, {award, [{1,11000},{10106,1},{13005,2}]}, {before1, [329]}];
get(331) -> [{type, 3}, {target, 2}, {condition, [{20043,3}]}, {award, [{1,11000},{10106,1},{13005,2}]}, {before1, [329]}];
get(332) -> [{type, 3}, {target, 1}, {condition, [{1009,1}]}, {award, [{1,11000},{10106,1},{13005,2}]}, {before1, [331]}];
get(333) -> [{type, 3}, {target, 2}, {condition, [{184,3}]}, {award, [{1,11000},{13005,2},{2115008,1}]}, {before1, [329]}];
get(334) -> [{type, 3}, {target, 1}, {condition, [{219,1}]}, {award, [{1,11000},{10106,1},{13005,2}]}, {before1, [333]}];
get(335) -> [{type, 3}, {target, 2}, {condition, [{186,3}]}, {award, [{1,11000},{10106,1},{13005,2}]}, {before1, [121]}];
get(336) -> [{type, 3}, {target, 1}, {condition, [{225,1}]}, {award, [{1,11000},{10106,1},{13005,2}]}, {before1, [335]}];
get(337) -> [{type, 3}, {target, 2}, {condition, [{188,3}]}, {award, [{1,12000},{10107,1},{2113009,1}]}, {before1, [335]}];
get(338) -> [{type, 3}, {target, 1}, {condition, [{228,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [337]}];
get(339) -> [{type, 3}, {target, 2}, {condition, [{20088,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [337]}];
get(340) -> [{type, 3}, {target, 1}, {condition, [{1021,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [339]}];
get(341) -> [{type, 3}, {target, 2}, {condition, [{190,3}]}, {award, [{1,12000},{10107,1},{2114009,1}]}, {before1, [337]}];
get(342) -> [{type, 3}, {target, 1}, {condition, [{231,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [341]}];
get(343) -> [{type, 3}, {target, 2}, {condition, [{20045,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [341]}];
get(344) -> [{type, 3}, {target, 1}, {condition, [{1010,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [343]}];
get(345) -> [{type, 3}, {target, 2}, {condition, [{91,3}]}, {award, [{1,12000},{10107,1},{2115009,1}]}, {before1, [341]}];
get(346) -> [{type, 3}, {target, 1}, {condition, [{234,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [345]}];
get(347) -> [{type, 3}, {target, 2}, {condition, [{101,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [345]}];
get(348) -> [{type, 3}, {target, 1}, {condition, [{237,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [347]}];
get(349) -> [{type, 3}, {target, 2}, {condition, [{20069,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [347]}];
get(350) -> [{type, 3}, {target, 1}, {condition, [{1022,1}]}, {award, [{1,12000},{10107,1},{2113010,1}]}, {before1, [349]}];
get(351) -> [{type, 3}, {target, 2}, {condition, [{193,3}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [347]}];
get(352) -> [{type, 3}, {target, 1}, {condition, [{240,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [351]}];
get(353) -> [{type, 3}, {target, 2}, {condition, [{20047,2}]}, {award, [{1,12000},{10107,1},{2114010,1}]}, {before1, [122]}];
get(354) -> [{type, 3}, {target, 1}, {condition, [{1011,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [353]}];
get(355) -> [{type, 3}, {target, 2}, {condition, [{199,2}]}, {award, [{1,12000},{13002,1},{31,1}]}, {before1, [122]}];
get(356) -> [{type, 3}, {target, 1}, {condition, [{246,1}]}, {award, [{1,12000},{13002,1},{2115010,1}]}, {before1, [355]}];
get(357) -> [{type, 3}, {target, 2}, {condition, [{20071,2}]}, {award, [{1,12000},{10103,1},{12012,1}]}, {before1, [355]}];
get(358) -> [{type, 3}, {target, 1}, {condition, [{1023,1}]}, {award, [{1,12000},{10103,1},{12012,1}]}, {before1, [357]}];
get(359) -> [{type, 3}, {target, 2}, {condition, [{34,2}]}, {award, [{1,12000},{10108,1},{12015,1}]}, {before1, [355]}];
get(360) -> [{type, 3}, {target, 1}, {condition, [{249,1}]}, {award, [{1,12000},{10108,1},{12025,1}]}, {before1, [359]}];
get(361) -> [{type, 3}, {target, 2}, {condition, [{102,3}]}, {award, [{1,12000},{12035,1},{2113011,1}]}, {before1, [359]}];
get(362) -> [{type, 3}, {target, 1}, {condition, [{252,1}]}, {award, [{1,12000},{10108,1},{12045,1}]}, {before1, [361]}];
get(363) -> [{type, 3}, {target, 2}, {condition, [{20073,2}]}, {award, [{1,12000},{10108,1},{12055,1}]}, {before1, [361]}];
get(364) -> [{type, 3}, {target, 1}, {condition, [{1024,1}]}, {award, [{1,12000},{12065,1},{2114011,1}]}, {before1, [363]}];
get(365) -> [{type, 3}, {target, 2}, {condition, [{203,2}]}, {award, [{1,12000},{10108,1},{12075,1}]}, {before1, [361]}];
get(366) -> [{type, 3}, {target, 1}, {condition, [{255,1}]}, {award, [{1,12000},{10108,1},{12085,1}]}, {before1, [365]}];
get(367) -> [{type, 3}, {target, 2}, {condition, [{205,2}]}, {award, [{1,12000},{12095,1},{2115011,1}]}, {before1, [365]}];
get(368) -> [{type, 3}, {target, 1}, {condition, [{258,1}]}, {award, [{1,12000},{10108,1},{12105,1}]}, {before1, [367]}];
get(369) -> [{type, 3}, {target, 2}, {condition, [{20049,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [367]}];
get(370) -> [{type, 3}, {target, 1}, {condition, [{1012,1}]}, {award, [{1,12000},{10107,1},{2113012,1}]}, {before1, [369]}];
get(371) -> [{type, 3}, {target, 2}, {condition, [{209,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [367]}];
get(372) -> [{type, 3}, {target, 1}, {condition, [{261,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [371]}];
get(373) -> [{type, 3}, {target, 2}, {condition, [{20075,2}]}, {award, [{1,12000},{10107,1},{2114012,1}]}, {before1, [371]}];
get(374) -> [{type, 3}, {target, 1}, {condition, [{1025,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [373]}];
get(375) -> [{type, 3}, {target, 2}, {condition, [{20003,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [123]}];
get(376) -> [{type, 3}, {target, 1}, {condition, [{1013,1}]}, {award, [{1,12000},{10107,1},{2115012,1}]}, {before1, [375]}];
get(377) -> [{type, 3}, {target, 2}, {condition, [{20008,2}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [375]}];
get(378) -> [{type, 3}, {target, 1}, {condition, [{1026,1}]}, {award, [{1,12000},{10107,1},{33,1}]}, {before1, [377]}];
get(379) -> [{type, 3}, {target, 2}, {condition, [{20058,2}]}, {award, [{1,5000},{10103,1},{12012,1}]}, {before1, [270]}];
get(380) -> [{type, 3}, {target, 1}, {condition, [{1016,1}]}, {award, [{1,5000},{10103,1},{12012,1}]}, {before1, [379]}];
get(381) -> [{type, 3}, {target, 2}, {condition, [{220,2}]}, {award, [{1,5000},{10103,1},{12012,1}]}, {before1, [269]}];
get(382) -> [{type, 3}, {target, 1}, {condition, [{126,1}]}, {award, [{1,5000},{10103,1},{12012,1}]}, {before1, [381]}];
get(383) -> [{type, 3}, {target, 3}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [205]}];
get(384) -> [{type, 3}, {target, 4}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [217]}];
get(385) -> [{type, 3}, {target, 5}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [201]}];
get(386) -> [{type, 3}, {target, 7}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [220]}];
get(387) -> [{type, 3}, {target, 8}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [213]}];
get(388) -> [{type, 3}, {target, 9}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [239]}];
get(389) -> [{type, 3}, {target, 10}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [245]}];
get(390) -> [{type, 3}, {target, 11}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [257]}];
get(391) -> [{type, 3}, {target, 12}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [285]}];
get(392) -> [{type, 3}, {target, 6}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [201]}];
get(393) -> [{type, 3}, {target, 6}, {condition, [{2,1}]}, {award, [{1,1000},{2,10}]}, {before1, [392]}];
get(394) -> [{type, 3}, {target, 6}, {condition, [{3,1}]}, {award, [{1,1000},{2,10}]}, {before1, [393]}];
get(395) -> [{type, 3}, {target, 6}, {condition, [{4,1}]}, {award, [{1,1000},{2,10}]}, {before1, [394]}];
get(396) -> [{type, 3}, {target, 6}, {condition, [{5,1}]}, {award, [{1,1000},{2,10}]}, {before1, [395]}];
get(397) -> [{type, 3}, {target, 6}, {condition, [{6,1}]}, {award, [{1,1000},{2,10}]}, {before1, [396]}];
get(398) -> [{type, 3}, {target, 6}, {condition, [{7,1}]}, {award, [{1,1000},{2,10}]}, {before1, [397]}];
get(399) -> [{type, 3}, {target, 6}, {condition, [{8,1}]}, {award, [{1,1000},{2,10}]}, {before1, [398]}];
get(400) -> [{type, 3}, {target, 13}, {condition, [{1,1}]}, {award, [{1,1000},{2,10}]}, {before1, [1001]}];
get(401) -> [{type, 5}, {target, 14}, {condition, [{1,1}]}, {award, [{1,10000},{2,50}]}, {before1, [1002]}];
get(10001) -> [{type, 4}, {target, 15}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10002) -> [{type, 4}, {target, 16}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10003) -> [{type, 4}, {target, 17}, {condition, [{1,3}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10004) -> [{type, 4}, {target, 5}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10005) -> [{type, 4}, {target, 18}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10006) -> [{type, 4}, {target, 19}, {condition, [{1,3}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10007) -> [{type, 4}, {target, 20}, {condition, [{1,5}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10008) -> [{type, 4}, {target, 12}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10009) -> [{type, 4}, {target, 21}, {condition, [{1,10}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10010) -> [{type, 4}, {target, 22}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10011) -> [{type, 4}, {target, 23}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(10012) -> [{type, 4}, {target, 24}, {condition, [{1,2}]}, {award, [{1,10000},{2,10},{7,10}]}];
get(_) -> undefined.