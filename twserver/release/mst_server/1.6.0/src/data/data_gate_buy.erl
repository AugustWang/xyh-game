-module(data_gate_buy).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,7,8];
get(1) -> [{heroID, 30002}, {quality, 1}, {star, 0}, {level, 5}, {pointID, 5}, {sellCount, 1}, {payType, 1}, {sellPrice, 5000}];
get(2) -> [{heroID, 30001}, {quality, 3}, {star, 1}, {level, 10}, {pointID, 11}, {sellCount, 1}, {payType, 1}, {sellPrice, 15000}];
get(3) -> [{heroID, 30004}, {quality, 2}, {star, 2}, {level, 18}, {pointID, 21}, {sellCount, 1}, {payType, 1}, {sellPrice, 30000}];
get(4) -> [{heroID, 30009}, {quality, 3}, {star, 2}, {level, 23}, {pointID, 38}, {sellCount, 1}, {payType, 1}, {sellPrice, 70000}];
get(5) -> [{heroID, 30011}, {quality, 3}, {star, 2}, {level, 31}, {pointID, 90}, {sellCount, 1}, {payType, 1}, {sellPrice, 120000}];
get(6) -> [{heroID, 30003}, {quality, 4}, {star, 3}, {level, 42}, {pointID, 150}, {sellCount, 1}, {payType, 1}, {sellPrice, 200000}];
get(7) -> [{heroID, 30006}, {quality, 5}, {star, 3}, {level, 52}, {pointID, 201}, {sellCount, 1}, {payType, 1}, {sellPrice, 400000}];
get(8) -> [{heroID, 30013}, {quality, 6}, {star, 3}, {level, 58}, {pointID, 240}, {sellCount, 1}, {payType, 1}, {sellPrice, 1000000}];
get(_) -> undefined.