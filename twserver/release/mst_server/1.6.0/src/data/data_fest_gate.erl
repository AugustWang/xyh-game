-module(data_fest_gate).
-export([get/1]).
get(ids) -> [{1,1},{1,2},{1,3},{2,1},{2,2},{2,3}];
get({1,1}) -> [{gate_id, 10001}, {cd, 600}];
get({1,2}) -> [{gate_id, 10001}, {cd, 600}];
get({1,3}) -> [{gate_id, 3}, {cd, 600}];
get({2,1}) -> [{gate_id, 4}, {cd, 600}];
get({2,2}) -> [{gate_id, 5}, {cd, 600}];
get({2,3}) -> [{gate_id, 6}, {cd, 600}];
get(_) -> undefined.