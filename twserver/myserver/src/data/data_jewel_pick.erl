-module(data_jewel_pick).
-export([get/1]).
get(ids) -> [1,2,3,4,5];
get(1) -> [{type, 1}, {num, 1000}];
get(2) -> [{type, 1}, {num, 2000}];
get(3) -> [{type, 1}, {num, 5000}];
get(4) -> [{type, 1}, {num, 8000}];
get(5) -> [{type, 1}, {num, 12000}];
get(_) -> undefined.