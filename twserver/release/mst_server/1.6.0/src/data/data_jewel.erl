-module(data_jewel).
-export([get/1]).
get(ids) -> [1,2,3,4,5];
get(1) -> [{rate_next, 70}, {rate, 100}, {rate2, 0}, {rate3, 0}, {rate4, 0}, {money, 1}, {num, 2000}, {money1, 1}, {num1, 500}];
get(2) -> [{rate_next, 60}, {rate, 80}, {rate2, 100}, {rate3, 0}, {rate4, 0}, {money, 2}, {num, 10}, {money1, 1}, {num1, 1000}];
get(3) -> [{rate_next, 50}, {rate, 70}, {rate2, 100}, {rate3, 0}, {rate4, 0}, {money, 2}, {num, 30}, {money1, 1}, {num1, 2000}];
get(4) -> [{rate_next, 40}, {rate, 60}, {rate2, 100}, {rate3, 0}, {rate4, 0}, {money, 2}, {num, 90}, {money1, 1}, {num1, 5000}];
get(5) -> [{rate_next, 0}, {rate, 50}, {rate2, 100}, {rate3, 0}, {rate4, 0}, {money, 2}, {num, 150}, {money1, 1}, {num1, 8000}];
get(_) -> undefined.