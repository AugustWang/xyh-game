-module(data_fun).
-export([
     power_speed/0,
     calc_crit_num/1,
     calc_hit_rate/2,
     calc_active_cure/4,
     up_spend/1,
     fb_spend/1,
     hero_offset/0,
     equ_offset/0,
     coliseum_buys/1,
     power_buy/1,
     fb_buy1/1,
     fb_buy2/1,
     fb_buy3/1,
     hero_dismissal/2,
     foster_succeed/1,
     foster_golds/1,
     foster_items/1,
     jewelry_upgrade/2,
     hero_foster/1
]).

power_speed() -> X = data_config:get(tired_max), round(1440/X*4).
calc_crit_num(X) -> Y = min(X, 1000),  1.5-4.5*(math:pow(10, -6)*Y*Y-2*math:pow(10, -3)*Y).
calc_hit_rate(DodB,HitA) -> X = min(DodB - HitA * 1.2, 1000),  1+0.5*(math:pow(10, -6)*X*X-2*math:pow(10, -3)*X).
calc_active_cure(Atk,Crit,Dmg,Arg) -> Atk*Crit*Dmg*Arg.
up_spend(X) -> X*0.2+500.
fb_spend(X) -> util:floor(0.6*X*X-2*X+3).
hero_offset() -> X=util:rand(1, 1000), (X*X/10000*0.1*0+100) / 100.
equ_offset() -> X=util:rand(1, 1000), (X*X/10000*0.1+90) / 100.
coliseum_buys(X) -> X*15+10*math:pow(2,X)+20.
power_buy(X) -> 50+30*(X+1).
fb_buy1(X) -> 5*math:pow((X+1),2).
fb_buy2(X) -> 10*math:pow((X+1),2).
fb_buy3(X) -> 20*math:pow((X+1),2).
hero_dismissal(X,Lev) -> X*0.0+Lev*2.
foster_succeed(X) -> max(95- 4*X,0.1).
foster_golds(X) -> X*3000+5000.
foster_items(X) -> (X+1)*3.
jewelry_upgrade(X,N) -> X*N*(1+N*0.1).
hero_foster(X) -> 1+X*0.2.
