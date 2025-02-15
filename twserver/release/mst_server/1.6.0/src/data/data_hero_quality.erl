-module(data_hero_quality).
-export([get/1]).
get(ids) -> [{1,6000},{6001,8000},{8001,9000},{9001,9400},{9401,9600},{9601,9700},{9701,9750}];
get({1,6000}) -> {1,1};
get({6001,8000}) -> {2,1.25};
get({8001,9000}) -> {3,1.5};
get({9001,9400}) -> {4,1.8};
get({9401,9600}) -> {5,2.1};
get({9601,9700}) -> {6,2.4};
get({9701,9750}) -> {7,2.7};
get(range) -> {1, 9750};
get(_) -> undefined.