-module(data_jewel).
-export([get/1]).
get(ids) -> [1,2,3,4,5];
get(1) -> [{rate_next, 80}, {rate, 100}, {rate2, 0}, {rate3, 0}, {rate4, 0}, {money, 2}, {num, 5}, {money1, 1}, {num1, 8000}];
get(2) -> [{rate_next, 65}, {rate, 50}, {rate2, 100}, {rate3, 0}, {rate4, 0}, {money, 2}, {num, 25}, {money1, 1}, {num1, 15000}];
get(3) -> [{rate_next, 50}, {rate, 25}, {rate2, 40}, {rate3, 100}, {rate4, 0}, {money, 2}, {num, 50}, {money1, 1}, {num1, 20000}];
get(4) -> [{rate_next, 35}, {rate, 10}, {rate2, 30}, {rate3, 50}, {rate4, 100}, {money, 2}, {num, 80}, {money1, 1}, {num1, 30000}];
get(5) -> [{rate_next, 0}, {rate, 5}, {rate2, 8}, {rate3, 18}, {rate4, 100}, {money, 2}, {num, 120}, {money1, 1}, {num1, 50000}];
get(_) -> undefined.