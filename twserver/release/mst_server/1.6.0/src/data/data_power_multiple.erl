-module(data_power_multiple).
-export([get/1]).
get(ids) -> [1000,2000,5000,10000,30000,80000,100000,150000,180000,250000,500000,1000000,10000000];
get(1000) -> [{multiple, 1}];
get(2000) -> [{multiple, 1.3}];
get(5000) -> [{multiple, 1.6}];
get(10000) -> [{multiple, 1.9}];
get(30000) -> [{multiple, 2.4}];
get(80000) -> [{multiple, 2.7}];
get(100000) -> [{multiple, 3.2}];
get(150000) -> [{multiple, 3.7}];
get(180000) -> [{multiple, 4.2}];
get(250000) -> [{multiple, 4.4}];
get(500000) -> [{multiple, 4.6}];
get(1000000) -> [{multiple, 4.8}];
get(10000000) -> [{multiple, 5}];
get(_) -> undefined.