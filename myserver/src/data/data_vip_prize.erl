-module(data_vip_prize).
-export([get/1]).
get(ids) -> [1,2,3,4,5];
get(1) -> [{prize, [{2,30},{1,10000},{10106,3},{8,3},{15001,2},{15002,2}]}];
get(2) -> [{prize, [{2,50},{1,20000},{10107,3},{8,5},{15002,2},{15003,2}]}];
get(3) -> [{prize, [{2,100},{1,30000},{10108,3},{8,7},{15002,3},{15003,3}]}];
get(4) -> [{prize, [{2,150},{1,40000},{10109,3},{8,10},{15002,4},{15003,4}]}];
get(5) -> [{prize, [{2,200},{1,50000},{10109,10},{8,15},{15002,5},{15003,5}]}];
get(_) -> undefined.