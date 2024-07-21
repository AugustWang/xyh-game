-module(data_diamond_shop).
-export([get/1]).
get(ids) -> ["com.mst.diamond_60","com.mst.diamond_315","com.mst.diamond_1078","com.mst.diamond_1702","com.mst.diamond_3696","com.mst.diamond_5376","com.mst.diamond_7725","com.mst.diamond_yueka"];
get("com.mst.diamond_60") -> [{tier, 1}, {rmb, 6}, {diamond, 60}, {shopid, 1}, {double, 0}];
get("com.mst.diamond_315") -> [{tier, 5}, {rmb, 30}, {diamond, 315}, {shopid, 2}, {double, 0}];
get("com.mst.diamond_1078") -> [{tier, 15}, {rmb, 98}, {diamond, 1078}, {shopid, 3}, {double, 0}];
get("com.mst.diamond_1702") -> [{tier, 22}, {rmb, 148}, {diamond, 1702}, {shopid, 4}, {double, 1}];
get("com.mst.diamond_3696") -> [{tier, 48}, {rmb, 308}, {diamond, 3696}, {shopid, 5}, {double, 1}];
get("com.mst.diamond_5376") -> [{tier, 54}, {rmb, 448}, {diamond, 5600}, {shopid, 6}, {double, 1}];
get("com.mst.diamond_7725") -> [{tier, 60}, {rmb, 618}, {diamond, 7725}, {shopid, 7}, {double, 1}];
get("com.mst.diamond_yueka") -> [{tier, 5}, {rmb, 30}, {diamond, 300}, {mcard, 1}, {shopid, 8}, {double, 0}];
get(_) -> undefined.