-module(data_sign).
-export([get/1]).
get(ids) -> [{1,1},{1,2},{1,3},{1,4},{1,5},{1,6},{1,7},{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{2,7}];
get({1,1}) -> [{coin, 10000}, {diamond, 10}, {tid_num, [{14041,8},{13002,2},{3,2},{30005,1}]}, {resign_cost, 0}];
get({1,2}) -> [{coin, 25000}, {diamond, 50}, {tid_num, [{10102,5},{13002,2},{3,2},{30005,1}]}, {resign_cost, 60}];
get({1,3}) -> [{coin, 40000}, {diamond, 100}, {tid_num, [{10103,5},{3,2},{30005,1}]}, {resign_cost, 120}];
get({1,4}) -> [{coin, 55000}, {diamond, 120}, {tid_num, [{10103,5},{3,2},{30005,1}]}, {resign_cost, 180}];
get({1,5}) -> [{coin, 70000}, {diamond, 150}, {tid_num, [{10103,8},{3,2},{14042,8},{30005,1}]}, {resign_cost, 240}];
get({1,6}) -> [{coin, 85000}, {diamond, 200}, {tid_num, [{10104,10},{3,2},{30005,1}]}, {resign_cost, 300}];
get({1,7}) -> [{coin, 99999}, {diamond, 666}, {tid_num, [{10104,20},{3,2},{30005,1}]}, {resign_cost, 0}];
get({2,1}) -> [{coin, 3000}, {diamond, 10}, {tid_num, [{10101,5},{3,1},{30005,1}]}, {resign_cost, 0}];
get({2,2}) -> [{coin, 8000}, {diamond, 20}, {tid_num, [{10102,5},{3,1},{30005,1}]}, {resign_cost, 42}];
get({2,3}) -> [{coin, 13000}, {diamond, 30}, {tid_num, [{10103,5},{3,1},{30005,1}]}, {resign_cost, 84}];
get({2,4}) -> [{coin, 18000}, {diamond, 40}, {tid_num, [{10104,5},{3,1},{30005,1}]}, {resign_cost, 125}];
get({2,5}) -> [{coin, 23000}, {diamond, 50}, {tid_num, [{10105,5},{3,1},{30005,1}]}, {resign_cost, 168}];
get({2,6}) -> [{coin, 28000}, {diamond, 60}, {tid_num, [{10105,7},{3,2},{30005,1}]}, {resign_cost, 210}];
get({2,7}) -> [{coin, 50000}, {diamond, 80}, {tid_num, [{10105,10},{3,2},{30005,1}]}, {resign_cost, 0}];
get(_) -> undefined.