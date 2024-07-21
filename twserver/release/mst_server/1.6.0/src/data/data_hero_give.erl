-module(data_hero_give).
-export([get/1]).
get(ids) -> [30005];
get(30005) -> [{quality, 3}];
get(_) -> undefined.