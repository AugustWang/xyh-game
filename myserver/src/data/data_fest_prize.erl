-module(data_fest_prize).
-export([get/1]).
get(ids) -> [{62,1},{64,1},{66,1},{63,1},{63,2},{63,3},{63,4},{63,5},{63,6},{65,1},{65,2},{65,3},{65,4},{67,1},{67,2}];
get({62,1}) -> [{condition, 1}, {tid, [{7,50}]}];
get({64,1}) -> [{condition, 1}, {tid, [{2,200}]}];
get({66,1}) -> [{condition, 1}, {tid, [{3,15}]}];
get({63,1}) -> [{condition, 5}, {tid, [{2,200}]}];
get({63,2}) -> [{condition, 10}, {tid, [{2,300}]}];
get({63,3}) -> [{condition, 15}, {tid, [{2,400}]}];
get({63,4}) -> [{condition, 20}, {tid, [{2,600}]}];
get({63,5}) -> [{condition, 30}, {tid, [{2,800}]}];
get({63,6}) -> [{condition, 50}, {tid, [{2,1000}]}];
get({65,1}) -> [{condition, 3}, {tid, [{2,10}]}];
get({65,2}) -> [{condition, 5}, {tid, [{2,20}]}];
get({65,3}) -> [{condition, 10}, {tid, [{2,30}]}];
get({65,4}) -> [{condition, 15}, {tid, [{2,50}]}];
get({67,1}) -> [{condition, 1}, {tid, [{2,200},{3,5}]}];
get({67,2}) -> [{condition, 1}, {tid, [{2,500},{3,10}]}];
get(_) -> undefined.