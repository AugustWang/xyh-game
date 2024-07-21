-module(data_mcard).
-export([get/1]).
get(ids) -> [1];
get(1) -> [{first, 300}, {day, 30}, {today, 100}];
get(_) -> undefined.