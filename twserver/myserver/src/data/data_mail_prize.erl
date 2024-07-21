-module(data_mail_prize).
-export([get/1]).
get(ids) -> [24];
get(24) -> [{prize, [{2,50},{1,5000},{12022,1}]}];
get(_) -> undefined.