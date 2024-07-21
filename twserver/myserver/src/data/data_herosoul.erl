-module(data_herosoul).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,7,8,9];
get(1) -> [{proportion, [{1,100},{2,50},{3,30}]}, {rate, 100}];
get(2) -> [{proportion, [{3,100},{4,50},{5,30}]}, {rate, 70}];
get(3) -> [{proportion, [{3,100},{4,50},{5,30}]}, {rate, 70}];
get(4) -> [{proportion, [{1,100},{2,50},{3,30}]}, {rate, 50}];
get(5) -> [{proportion, [{6,100},{7,50},{8,30}]}, {rate, 35}];
get(6) -> [{proportion, [{5,100},{6,50},{7,30}]}, {rate, 40}];
get(7) -> [{proportion, [{3,100},{4,50},{5,30}]}, {rate, 100}];
get(8) -> [{proportion, [{1,100},{2,50},{3,30}]}, {rate, 100}];
get(9) -> [{proportion, [{1,100},{2,50},{3,30}]}, {rate, 100}];
get(_) -> undefined.