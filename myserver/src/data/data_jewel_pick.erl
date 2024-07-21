-module(data_jewel_pick).
-export([get/1]).
get(ids) -> [1,2,3,4,5];
get(1) -> [{type, 1}, {num, 15000}];
get(2) -> [{type, 1}, {num, 30000}];
get(3) -> [{type, 1}, {num, 45000}];
get(4) -> [{type, 2}, {num, 10}];
get(5) -> [{type, 2}, {num, 30}];
get(_) -> undefined.