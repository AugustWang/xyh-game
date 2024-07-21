-module(data_shop).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,18,19,20,21,22,23,24,25,26];
get(1) -> [{tid, 10107}, {num1, 1}, {price1, 80}];
get(2) -> [{tid, 10108}, {num1, 1}, {price1, 150}];
get(3) -> [{tid, 10109}, {num1, 1}, {price1, 200}];
get(4) -> [{tid, 10107}, {num1, 5}, {price1, 70}];
get(5) -> [{tid, 10108}, {num1, 5}, {price1, 130}];
get(6) -> [{tid, 10109}, {num1, 5}, {price1, 160}];
get(18) -> [{tid, 3}, {num1, 1}, {price1, 30}];
get(19) -> [{tid, 3}, {num1, 5}, {price1, 27}];
get(20) -> [{tid, 3}, {num1, 10}, {price1, 25}];
get(21) -> [{tid, 1}, {num1, 50000}, {price1, 0.0025}];
get(22) -> [{tid, 1}, {num1, 100000}, {price1, 0.0023}];
get(23) -> [{tid, 1}, {num1, 500000}, {price1, 0.002}];
get(24) -> [{tid, 8}, {num1, 10}, {price1, 7}];
get(25) -> [{tid, 8}, {num1, 30}, {price1, 6}];
get(26) -> [{tid, 8}, {num1, 50}, {price1, 5}];
get(_) -> undefined.