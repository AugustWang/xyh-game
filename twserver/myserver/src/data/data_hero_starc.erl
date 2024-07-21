-module(data_hero_starc).
-export([get/1]).
get(ids) -> [1,2,3,4,5];
get(1) -> [{type, 1}, {num, 10000}, {num1, 20}];
get(2) -> [{type, 1}, {num, 10000}, {num1, 35}];
get(3) -> [{type, 1}, {num, 10000}, {num1, 60}];
get(4) -> [{type, 1}, {num, 10000}, {num1, 100}];
get(5) -> [{type, 1}, {num, 10000}, {num1, 150}];
get(_) -> undefined.