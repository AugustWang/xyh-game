-module(data_reg_prize).
-export([get/1]).
get(ids) -> [1];
get(1) -> [{prize, [{10101,1},{10102,1},{900002,1}]}];
get(_) -> undefined.