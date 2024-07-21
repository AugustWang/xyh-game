-module(data_power_multiple).
-export([get/1]).
get(ids) -> [1000,2000,5000,10000,30000,80000,120000,150000,180000,250000,500000,1000000,10000000];
get(1000) -> [{multiple, 2}];
get(2000) -> [{multiple, 3}];
get(5000) -> [{multiple, 4}];
get(10000) -> [{multiple, 5}];
get(30000) -> [{multiple, 6}];
get(80000) -> [{multiple, 7}];
get(120000) -> [{multiple, 8}];
get(150000) -> [{multiple, 9}];
get(180000) -> [{multiple, 10}];
get(250000) -> [{multiple, 12}];
get(500000) -> [{multiple, 15}];
get(1000000) -> [{multiple, 20}];
get(10000000) -> [{multiple, 50}];
get(_) -> undefined.