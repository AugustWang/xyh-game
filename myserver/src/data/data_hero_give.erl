-module(data_hero_give).
-export([get/1]).
get(ids) -> [30008];
get(30008) -> [{quality, 1}];
get(_) -> undefined.