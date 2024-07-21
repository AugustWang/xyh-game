-module(data_reg_prize).
-export([get/1]).
get(ids) -> [1];
get(1) -> [{prize, [{2,200},{1,10000},{10101,1},{10102,1},{900001,1}]}];
get(_) -> undefined.