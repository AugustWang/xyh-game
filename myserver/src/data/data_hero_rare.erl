-module(data_hero_rare).
-export([get/1]).
get(ids) -> [{1,10000},{10001,15000},{15001,16000},{16001,16500},{16501,16550},{16551,16560},{16561,16565},{16566,16565}];
get({1,10000}) -> {1};
get({10001,15000}) -> {2};
get({15001,16000}) -> {3};
get({16001,16500}) -> {4};
get({16501,16550}) -> {5};
get({16551,16560}) -> {6};
get({16561,16565}) -> {7};
get({16566,16565}) -> {8};
get(range) -> {1, 16565};
get(_) -> undefined.