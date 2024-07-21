-module(data_bags).
-export([get/1]).
get(ids) -> [3,4,5,6,7,8,9,10,11,12,13,14,15];
get(3) -> [{price, 20}];
get(4) -> [{price, 30}];
get(5) -> [{price, 40}];
get(6) -> [{price, 50}];
get(7) -> [{price, 60}];
get(8) -> [{price, 70}];
get(9) -> [{price, 90}];
get(10) -> [{price, 120}];
get(11) -> [{price, 160}];
get(12) -> [{price, 200}];
get(13) -> [{price, 240}];
get(14) -> [{price, 280}];
get(15) -> [{price, 320}];
get(_) -> undefined.