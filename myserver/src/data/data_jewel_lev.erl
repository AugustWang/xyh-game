-module(data_jewel_lev).
-export([get/1]).
get(ids) -> [{1,1},{2,1},{3,1},{4,1},{1,2},{2,2},{3,2},{4,2},{5,2},{6,2},{1,3},{2,3},{3,3},{4,3},{5,3},{6,3},{7,3},{8,3},{9,3},{1,4},{2,4},{3,4},{4,4},{5,4},{6,4},{7,4},{8,4},{9,4},{10,4},{11,4},{12,4},{1,5},{2,5},{3,5},{4,5},{5,5},{6,5},{7,5},{8,5},{9,5},{10,5},{11,5},{12,5},{13,5},{14,5},{15,5}];
get({1,1}) -> [{exp, 12}, {expend, 1200}, {provide, 6}];
get({2,1}) -> [{exp, 48}, {expend, 3000}, {provide, 40}];
get({3,1}) -> [{exp, 160}, {expend, 5000}, {provide, 200}];
get({4,1}) -> [{exp, 320}, {expend, 8000}, {provide, 500}];
get({1,2}) -> [{exp, 20}, {expend, 1680}, {provide, 8}];
get({2,2}) -> [{exp, 80}, {expend, 4200}, {provide, 80}];
get({3,2}) -> [{exp, 280}, {expend, 7000}, {provide, 350}];
get({4,2}) -> [{exp, 500}, {expend, 11200}, {provide, 760}];
get({5,2}) -> [{exp, 800}, {expend, 15420}, {provide, 1500}];
get({6,2}) -> [{exp, 1200}, {expend, 21500}, {provide, 2400}];
get({1,3}) -> [{exp, 32}, {expend, 2016}, {provide, 10}];
get({2,3}) -> [{exp, 156}, {expend, 5040}, {provide, 166}];
get({3,3}) -> [{exp, 320}, {expend, 8400}, {provide, 486}];
get({4,3}) -> [{exp, 600}, {expend, 13440}, {provide, 900}];
get({5,3}) -> [{exp, 1060}, {expend, 18504}, {provide, 1856}];
get({6,3}) -> [{exp, 1440}, {expend, 25800}, {provide, 3200}];
get({7,3}) -> [{exp, 1960}, {expend, 31500}, {provide, 4581}];
get({8,3}) -> [{exp, 2440}, {expend, 36550}, {provide, 6540}];
get({9,3}) -> [{exp, 2860}, {expend, 42500}, {provide, 7500}];
get({1,4}) -> [{exp, 48}, {expend, 2500}, {provide, 30}];
get({2,4}) -> [{exp, 208}, {expend, 6048}, {provide, 238}];
get({3,4}) -> [{exp, 440}, {expend, 10080}, {provide, 678}];
get({4,4}) -> [{exp, 780}, {expend, 16128}, {provide, 1458}];
get({5,4}) -> [{exp, 1468}, {expend, 22200}, {provide, 2926}];
get({6,4}) -> [{exp, 1988}, {expend, 30960}, {provide, 4914}];
get({7,4}) -> [{exp, 2548}, {expend, 37800}, {provide, 5441}];
get({8,4}) -> [{exp, 3172}, {expend, 43860}, {provide, 7553}];
get({9,4}) -> [{exp, 3852}, {expend, 51000}, {provide, 8554}];
get({10,4}) -> [{exp, 4400}, {expend, 55800}, {provide, 9550}];
get({11,4}) -> [{exp, 4964}, {expend, 64220}, {provide, 11501}];
get({12,4}) -> [{exp, 5512}, {expend, 75220}, {provide, 12000}];
get({1,5}) -> [{exp, 96}, {expend, 3250}, {provide, 96}];
get({2,5}) -> [{exp, 416}, {expend, 7900}, {provide, 409}];
get({3,5}) -> [{exp, 880}, {expend, 13104}, {provide, 1113}];
get({4,5}) -> [{exp, 1560}, {expend, 21000}, {provide, 2361}];
get({5,5}) -> [{exp, 2936}, {expend, 28860}, {provide, 4710}];
get({6,5}) -> [{exp, 3976}, {expend, 40248}, {provide, 7891}];
get({7,5}) -> [{exp, 5096}, {expend, 49140}, {provide, 11968}];
get({8,5}) -> [{exp, 6344}, {expend, 57018}, {provide, 17043}];
get({9,5}) -> [{exp, 7704}, {expend, 66300}, {provide, 23206}];
get({10,5}) -> [{exp, 8800}, {expend, 72540}, {provide, 30246}];
get({11,5}) -> [{exp, 9928}, {expend, 83486}, {provide, 38188}];
get({12,5}) -> [{exp, 11024}, {expend, 97786}, {provide, 47008}];
get({13,5}) -> [{exp, 13000}, {expend, 120000}, {provide, 57408}];
get({14,5}) -> [{exp, 15420}, {expend, 150000}, {provide, 62000}];
get({15,5}) -> [{exp, 18040}, {expend, 180000}, {provide, 68000}];
get(_) -> undefined.