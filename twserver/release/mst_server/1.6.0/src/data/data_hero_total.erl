-module(data_hero_total).
-export([get/1]).
get(ids) -> [5,10,20,36];
get(5) -> [{maxcount, 2}];
get(10) -> [{maxcount, 3}];
get(20) -> [{maxcount, 4}];
get(36) -> [{maxcount, 5}];
get(_) -> undefined.