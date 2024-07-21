-module(data_vip).
-export([get/1]).
get(ids) -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
get(1) -> [{diamond, 0}, {free, 0}, {chat, 5}, {reward, 0}, {prize, 0}, {fast, 15}, {buys1, 1}, {buys2, 2}, {buys3, 2}, {mcard, 0}];
get(2) -> [{diamond, 100}, {free, 0}, {chat, 5}, {reward, 2}, {prize, 1}, {fast, 20}, {buys1, 2}, {buys2, 3}, {buys3, 3}, {mcard, 0}];
get(3) -> [{diamond, 500}, {free, 0}, {chat, 5}, {reward, 3}, {prize, 1}, {fast, 20}, {buys1, 3}, {buys2, 4}, {buys3, 4}, {mcard, 0}];
get(4) -> [{diamond, 1500}, {free, 0}, {chat, 5}, {reward, 4}, {prize, 1}, {fast, 30}, {buys1, 3}, {buys2, 4}, {buys3, 4}, {mcard, 0}];
get(5) -> [{diamond, 2500}, {free, 0}, {chat, 5}, {reward, 5}, {prize, 1}, {fast, 30}, {buys1, 3}, {buys2, 4}, {buys3, 4}, {mcard, 0}];
get(6) -> [{diamond, 5000}, {free, 0}, {chat, 5}, {reward, 6}, {prize, 2}, {fast, 35}, {buys1, 4}, {buys2, 5}, {buys3, 5}, {mcard, 0}];
get(7) -> [{diamond, 8000}, {free, 0}, {chat, 5}, {reward, 7}, {prize, 2}, {fast, 35}, {buys1, 4}, {buys2, 5}, {buys3, 5}, {mcard, 0}];
get(8) -> [{diamond, 12000}, {free, 0}, {chat, 5}, {reward, 8}, {prize, 3}, {fast, 35}, {buys1, 4}, {buys2, 5}, {buys3, 5}, {mcard, 0}];
get(9) -> [{diamond, 20000}, {free, 0}, {chat, 5}, {reward, 9}, {prize, 3}, {fast, 35}, {buys1, 4}, {buys2, 5}, {buys3, 5}, {mcard, 0}];
get(10) -> [{diamond, 40000}, {free, 0}, {chat, 5}, {reward, 10}, {prize, 3}, {fast, 35}, {buys1, 5}, {buys2, 6}, {buys3, 6}, {mcard, 0}];
get(11) -> [{diamond, 60000}, {free, 0}, {chat, 5}, {reward, 11}, {prize, 3}, {fast, 35}, {buys1, 5}, {buys2, 6}, {buys3, 6}, {mcard, 0}];
get(12) -> [{diamond, 90000}, {free, 0}, {chat, 5}, {reward, 12}, {prize, 4}, {fast, 35}, {buys1, 5}, {buys2, 6}, {buys3, 6}, {mcard, 0}];
get(13) -> [{diamond, 120000}, {free, 0}, {chat, 5}, {reward, 13}, {prize, 4}, {fast, 35}, {buys1, 6}, {buys2, 6}, {buys3, 6}, {mcard, 0}];
get(14) -> [{diamond, 150000}, {free, 0}, {chat, 5}, {reward, 14}, {prize, 4}, {fast, 35}, {buys1, 6}, {buys2, 7}, {buys3, 7}, {mcard, 0}];
get(15) -> [{diamond, 180000}, {free, 0}, {chat, 5}, {reward, 15}, {prize, 5}, {fast, 35}, {buys1, 6}, {buys2, 7}, {buys3, 7}, {mcard, 0}];
get(16) -> [{diamond, 200000}, {free, 0}, {chat, 5}, {reward, 16}, {prize, 5}, {fast, 35}, {buys1, 7}, {buys2, 8}, {buys3, 8}, {mcard, 0}];
get(_) -> undefined.