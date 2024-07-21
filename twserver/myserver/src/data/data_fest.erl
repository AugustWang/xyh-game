-module(data_fest).
-export([get/1]).
get(ids) -> [1,2];
get(1) -> [{start_time, {{2013,1,31},{7,0,0}}}, {end_time, {{2013,2,7},{24,0,0}}}, {main_product, [{2,1,101}]}, {fb_product, [{2,1,101}]}];
get(2) -> [{start_time, {{2013,1,1},{0,0,0}}}, {end_time, {{2013,2,5},{23,59,59}}}, {main_product, [{2,1,101}]}, {fb_product, [{2,1,101}]}];
get(_) -> undefined.