-module(data_first_pay).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,7,8];
get(1) -> [{tid, 10107}, {num, 10}];
get(2) -> [{tid, 10108}, {num, 10}];
get(3) -> [{tid, 10109}, {num, 10}];
get(4) -> [{tid, 1}, {num, 150000}];
get(5) -> [{tid, 2}, {num, 200}];
get(6) -> [{tid, 5}, {num, {30015,4}}];
get(7) -> [{tid, 33}, {num, 5}];
get(8) -> [{tid, 13001}, {num, 10}];
get(_) -> undefined.