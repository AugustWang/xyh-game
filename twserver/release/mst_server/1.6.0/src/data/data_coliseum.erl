-module(data_coliseum).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6];
get(1) -> [{num, 50}, {down, 30}, {exp, 1200}, {show, 1}, {produce, [{2,1,30001}]}];
get(2) -> [{num, 100}, {down, 50}, {exp, 800}, {show, 2}, {produce, [{2,1,30002}]}];
get(3) -> [{num, 200}, {down, 100}, {exp, 500}, {show, 3}, {produce, [{2,1,30003}]}];
get(4) -> [{num, 500}, {down, 300}, {exp, 300}, {show, 5}, {produce, [{2,1,30004}]}];
get(5) -> [{num, 1000}, {down, 500}, {exp, 200}, {show, 8}, {produce, [{2,1,30005}]}];
get(6) -> [{num, 5000}, {down, 0}, {exp, 80}, {show, 50}, {produce, [{2,1,30006}]}];
get(_) -> undefined.