-module(data_picture).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,7,8];
get(1) -> [];
get(2) -> [];
get(3) -> [];
get(4) -> [];
get(5) -> [];
get(6) -> [];
get(7) -> [];
get(8) -> [];
get(_) -> undefined.