-module(data_shop).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,18,19,20,21,22,23,24,25,26];
get(1) -> [{tid, 10107}, {num1, 1}, {price1, 100}];
get(2) -> [{tid, 10108}, {num1, 1}, {price1, 200}];
get(3) -> [{tid, 10109}, {num1, 1}, {price1, 400}];
get(4) -> [{tid, 10107}, {num1, 5}, {price1, 80}];
get(5) -> [{tid, 10108}, {num1, 5}, {price1, 160}];
get(6) -> [{tid, 10109}, {num1, 5}, {price1, 320}];
get(18) -> [{tid, 3}, {num1, 1}, {price1, 110}];
get(19) -> [{tid, 3}, {num1, 5}, {price1, 100}];
get(20) -> [{tid, 3}, {num1, 10}, {price1, 90}];
get(21) -> [{tid, 1}, {num1, 500000}, {price1, 0.0002}];
get(22) -> [{tid, 1}, {num1, 1000000}, {price1, 0.0002}];
get(23) -> [{tid, 1}, {num1, 5000000}, {price1, 0.0001}];
get(24) -> [{tid, 8}, {num1, 10}, {price1, 7}];
get(25) -> [{tid, 8}, {num1, 30}, {price1, 6}];
get(26) -> [{tid, 8}, {num1, 50}, {price1, 5}];
get(_) -> undefined.