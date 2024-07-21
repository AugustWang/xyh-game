-module(data_diamond_shop2).
-export([get/1]).
get(ids) -> ["com.mst.diamond_60","com.mst.diamond_120","com.mst.diamond_315","com.mst.diamond_330","com.mst.diamond_600","com.mst.diamond_1078","com.mst.diamond_1274","com.mst.diamond_1702","com.mst.diamond_2072","com.mst.diamond_3420","com.mst.diamond_3696","com.mst.diamond_4928","com.mst.diamond_5376","com.mst.diamond_7725"];
get("com.mst.diamond_60") -> [{tier, 1}, {rmb, 6}, {diamond, 60}];
get("com.mst.diamond_120") -> [{tier, 2}, {rmb, 12}, {diamond, 120}];
get("com.mst.diamond_315") -> [{tier, 5}, {rmb, 30}, {diamond, 315}];
get("com.mst.diamond_330") -> [{tier, 5}, {rmb, 30}, {diamond, 330}];
get("com.mst.diamond_600") -> [{tier, 8}, {rmb, 50}, {diamond, 600}];
get("com.mst.diamond_1078") -> [{tier, 15}, {rmb, 98}, {diamond, 1078}];
get("com.mst.diamond_1274") -> [{tier, 15}, {rmb, 98}, {diamond, 1274}];
get("com.mst.diamond_1702") -> [{tier, 22}, {rmb, 148}, {diamond, 1702}];
get("com.mst.diamond_2072") -> [{tier, 22}, {rmb, 148}, {diamond, 2072}];
get("com.mst.diamond_3420") -> [{tier, 34}, {rmb, 228}, {diamond, 3420}];
get("com.mst.diamond_3696") -> [{tier, 48}, {rmb, 308}, {diamond, 3696}];
get("com.mst.diamond_4928") -> [{tier, 48}, {rmb, 308}, {diamond, 4928}];
get("com.mst.diamond_5376") -> [{tier, 54}, {rmb, 448}, {diamond, 5600}];
get("com.mst.diamond_7725") -> [{tier, 59}, {rmb, 618}, {diamond, 7725}];
get(_) -> undefined.