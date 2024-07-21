%%----------------------------------------------------
%% $Id$
%% @doc 内部协议09 - 开发调试相关
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(pt_09).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").

%% 打印物品数据
handle(9010, [], Rs) ->
    Items = Rs#role.items,
    io:format("Count Items: ~w", [length(Items)]),
    F = fun(Item, {E, P, M}) ->
            case Item#item.tab of
                ?TAB_EQU  -> {[Item | E], P, M};
                ?TAB_PROP -> {E, [Item | P], M};
                ?TAB_MAT  -> {E, P, [Item | M]}
            end
    end,
    {Equ, Prop, Mat} = lists:foldl(F, {[], [], []}, Items),
    io:format("~n[ROLE ITEMS ~w] Id: ~w, Aid: ~s~n",
        [length(Equ), Rs#role.id, Rs#role.account_id]),
    print_equ(Equ, 0, "", []),
    io:format("~n=== Prop:~w ===", [length(Prop)]),
    print_prop(Prop, 0, "", []),
    io:format("~n=== Mat:~w ===", [length(Mat)]),
    print_prop(Mat, 0, "", []),
    io:format("~n"),
    {ok};

handle(9012, [], _Rs) ->
    erlang:send_after(500, self(), {pt, 9013, []}),
    {ok};

handle(9013, [], Rs) ->
    io:format("~n[ROLE HEROES ~w] Id: ~w, Aid: ~s~n",
        [length(Rs#role.heroes), Rs#role.id, Rs#role.account_id]),
    print_hero(Rs#role.heroes),
    {ok};

handle(9015, [], Rs) ->
    io:format("~n[ROLE STATE] Id: ~w, Aid: ~s~n",
        [Rs#role.id, Rs#role.account_id]),
    print_role_state(Rs),
    {ok};

%% 清空数据
handle(9016, [], Rs) ->
    db:execute("delete from item where role_id = ~s", [Rs#role.id]),
    db:execute("delete from hero where role_id = ~s", [Rs#role.id]),
    {ok, Rs#role{items = [], heroes = []}};

handle(9018, [], Rs) ->
    util:sleep(100),
    ?INFO("All Heroes:"),
    lib_debug:print_hero(Rs#role.heroes),
    Heroes = mod_hero:get_combat_heroes(Rs#role.heroes, Rs#role.items),
    util:sleep(100),
    ?INFO("CombatHeroes:"),
    lib_debug:print_hero(Heroes),
    self() ! {pt, 9010, []},
    {ok};

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

print_role_state(Rs) ->
    io:format("\nRole State:\n
         id                = ~w
        ,growth            = ~w
        ,gold              = ~w
        ,diamond           = ~w
        ,status            = ~w
        ,max_hero_id       = ~w
        ,max_item_id       = ~w
        ,tollgate_id       = ~w
        ,power             = ~w
        ,power_time        = ~w
        ,buy_power         = ~w
        ,buy_power_time    = ~w
        ,sign              = ~w
        ,givehero          = ~w
        ,tavern_time       = ~w
        ,bag_equ_max       = ~w
        ,bag_prop_max      = ~w
        ,bag_mat_max       = ~w
        ,fb_combat1        = ~w
        ,fb_combat2        = ~w
        ,fb_combat3        = ~w
        ,fb_time1          = ~w
        ,fb_time2          = ~w
        ,fb_time3          = ~w
        ,fb_gate           = ~w
        ,fb_buys           = ~w
        ,fb_buys_time      = ~w
        ,arena_id          = ~w
        ,arena_lev         = ~w
        ,arena_exp         = ~w
        ,arena_rank        = ~w
        ,arena_picture     = ~w
        ,arena_time        = ~w
        ,arena_honor       = ~w
        ,arena_wars        = ~w
        ,arena_chance      = ~w
        ,arena_rank_box    = ~w
        ,arena_revenge     = ~w
        ,arena_prize       = ~w
        ,arena_combat_box1 = ~w
        ,arena_combat_box2 = ~w
        ,attain_time       = ~w
        ,loginsign_time    = ~w
        ,loginsign_type    = ~w
        ,pid               = ~w
        ,pid_conn          = ~w
        ,pid_sender        = ~w
        ,socket            = ~w
        ,port              = ~w
        ,ip                = ~w
        ,name              = ~s
        ,account_id        = ~s
        ,password          = ~s
        ,luck              = ~w
        ,produce_pass      = ~w
        ,save              = ~w
        ,save_delay        = ~w
        ,jewel             = ~w
        ,tavern            = ~w
        ,arena             = ~w
        ,attain            = ~w
        ,arena_lost_report = ~w
        ,loginsign         = ~w
        ,activity          = ~w
        ,friends           = ~w
        ,verify            = ~w
        ",
        [
         Rs#role.id
        ,Rs#role.growth
        ,Rs#role.gold
        ,Rs#role.diamond
        ,Rs#role.status
        ,Rs#role.max_hero_id
        ,Rs#role.max_item_id
        ,Rs#role.tollgate_id
        ,Rs#role.power
        ,Rs#role.power_time
        ,Rs#role.buy_power
        ,Rs#role.buy_power_time
        ,Rs#role.sign
        ,Rs#role.givehero
        ,Rs#role.tavern_time
        ,Rs#role.bag_equ_max
        ,Rs#role.bag_prop_max
        ,Rs#role.bag_mat_max
        ,Rs#role.fb_combat1
        ,Rs#role.fb_combat2
        ,Rs#role.fb_combat3
        ,Rs#role.fb_time1
        ,Rs#role.fb_time2
        ,Rs#role.fb_time3
        ,Rs#role.fb_gate
        ,Rs#role.fb_buys
        ,Rs#role.fb_buys_time
        ,Rs#role.arena_id
        ,Rs#role.arena_lev
        ,Rs#role.arena_exp
        ,Rs#role.arena_rank
        ,Rs#role.arena_picture
        ,Rs#role.arena_time
        ,Rs#role.arena_honor
        ,Rs#role.arena_wars
        ,Rs#role.arena_chance
        ,Rs#role.arena_rank_box
        ,Rs#role.arena_revenge
        ,Rs#role.arena_prize
        ,Rs#role.arena_combat_box1
        ,Rs#role.arena_combat_box2
        ,Rs#role.attain_time
        ,Rs#role.loginsign_time
        ,Rs#role.loginsign_type
        ,Rs#role.pid
        ,Rs#role.pid_conn
        ,Rs#role.pid_sender
        ,Rs#role.socket
        ,Rs#role.port
        ,Rs#role.ip
        ,Rs#role.name
        ,Rs#role.account_id
        ,Rs#role.password
        ,Rs#role.luck
        ,Rs#role.produce_pass
        ,Rs#role.save
        ,Rs#role.save_delay
        ,Rs#role.jewel
        ,Rs#role.tavern
        ,Rs#role.arena
        ,Rs#role.attain
        ,Rs#role.arena_lost_report
        ,Rs#role.loginsign
        ,Rs#role.activity
        ,Rs#role.friends
        ,Rs#role.verify
    ]).

print_prop([Item | Items], Index, RtF, RtV) ->
    Index1 = Index + 1,
    Data = [
        % ---------- BASE ----------
        {id      , "| ~3w ", Item#item.id             },
        {tid     , "| ~5w ", Item#item.tid            },
        {sort    , "| ~4w ", Item#item.sort           },
        {tab     , "| ~3w ", Item#item.tab            },
        {c       , "| ~1w ", Item#item.changed        },
        % ---------- ATTR ----------
        {num     , "| ~3w ", Item#item.attr#prop.num    },
        {quality , "| ~7w |", Item#item.attr#prop.quality}
    ],
    Line = string:copies("-", 48),
    {Titles, Formats, Values} = get_print_arg(Data),
    {Formats1, Values1} = case Index == 0 of
        true ->
            {"~n"++Line++"~n"++Formats++"~n"++Line++"~n"++Formats++"~n", Titles++Values};
        false -> {RtF++Formats++"~n", RtV++Values}
    end,
    {Formats2, Values2} = case Items == [] of
        true -> {Formats1++Line++"~n"++Formats++"~n"++Line++"~n", Values1++Titles};
        false -> {Formats1, Values1}
    end,
    print_prop(Items, Index1, Formats2, Values2);
print_prop([], _Index, F, V) ->
    io:format(F, V),
    ok.

print_equ([Item | Items], Index, RtF, RtV) ->
    Index1 = Index + 1,
    Embed = [{X1, X3} || {X1, _, X3} <- Item#item.attr#equ.embed],
    Atime = Item#item.attr#equ.atime,
    Rest1 = Atime - util:unixtime(),
    Rest2 = if
        Rest1 =< 0 -> integer_to_list(0);
        Rest1 > 3600*48 ->
            integer_to_list(Rest1 div 3600 div 24)++"d";
        Rest1 > 3600*2 ->
            integer_to_list(Rest1 div 3600)++"h";
        Rest1 > 3600 ->
            integer_to_list(Rest1 div 60)++"m";
        true ->
            integer_to_list(Rest1)
    end,
    Data = [
        % ---------- BASE ----------
        {id      , "| ~3w ", Item#item.id             },
        {tid     , " | ~6w ", Item#item.tid            },
        {sort    , " | ~4w ", Item#item.sort           },
        {tab     , " | ~3w ", Item#item.tab            },
        {c       , " | ~1w ", Item#item.changed        },
        % ---------- ATTR ----------
        {hero      , " | ~5w", Item#item.attr#equ.hero_id  },
        {"cd"      , " | ~4s", Rest2},
        {lev       , " | ~3w", Item#item.attr#equ.lev      },
        {q         , " | ~1w", Item#item.attr#equ.quality  },
        {hp        , " | ~6w", Item#item.attr#equ.hp       },
        {atk       , " | ~6w", Item#item.attr#equ.atk      },
        {def       , " | ~4w", Item#item.attr#equ.def      },
        {pun       , " | ~4w", Item#item.attr#equ.pun      },
        {hit       , " | ~4w", Item#item.attr#equ.hit      },
        {dod       , " | ~4w", Item#item.attr#equ.dod      },
        {crit      , " | ~4w", Item#item.attr#equ.crit     },
        {crit_num  , " | ~8w", Item#item.attr#equ.crit_num },
        {crit_anti , " | ~9w", Item#item.attr#equ.crit_anti},
        {tou       , " | ~4w", Item#item.attr#equ.tou      },
        {tou_anit  , " | ~8w", Item#item.attr#equ.tou_anit },
        {sock      , " | ~4w", Item#item.attr#equ.sockets  },
        {'embed --->'     , "| ~w ", Embed    }
    ],
    Line = string:copies("-", 179),
    {Titles, Formats, Values} = get_print_arg(Data),
    {Formats1, Values1} = case Index == 0 of
        true -> {"~n"++Line++"~n"++Formats++"~n"++Line++"~n"++Formats++"~n", Titles++Values};
        false -> {RtF++Formats++"~n", RtV++Values}
    end,
    {Formats2, Values2} = case Items == [] of
        true -> {Formats1++Line++"~n"++Formats++"~n"++Line++"~n", Values1++Titles};
        false -> {Formats1, Values1}
    end,
    print_equ(Items, Index1, Formats2, Values2);
print_equ([], _Index, F, V) ->
    io:format(F, V),
    ok.

get_print_arg(Data) ->
    get_print_arg(Data, [], [], []).

get_print_arg([{Title, Format, Value} | Data], Titles, Formats, Values) ->
    get_print_arg(Data, [Title | Titles], Formats ++ Format, [Value | Values]);
get_print_arg([], Titles, Formats, Values) ->
    {
        lists:reverse(Titles),
        Formats,
        lists:reverse(Values)
    }.

-define(hero_format,
        "| ~2w"    %% pos
        " |~5w"      %% hp
        " |~5w"      %% atk
        " |~5w"      %% def
        " |~5w"      %% pun
        " |~5w"      %% hit
        " |~5w"      %% dod
        " |~5w"      %% crit
        " |~5w"      %% cnum
        " |~5w"      %% canti
        " |~5w"      %% tou
        " |~5w"      %% tanit
        " |~11w"     %% skill
        " |~5w"      %% id
        " |~5w"      %% tid
        " | ~1w"      %% job
        " |~2w"      %% sort
        " | ~1w"      %% rare
        " | ~1w"      %% changed
        " |~5w"      %% exp
        " |~2w"      %% lev
        " | ~1w"   %% quality.
        " | ~w~n"   %% equ_grids
       ).

-define(hero_title_arg,
    [
       ps
      ,hp
      ,atk
      ,def
      ,pun
      ,hit
      ,dod
      ,crit
      ,cnum
      ,canti
      ,tou
      ,tanit
      ,skill
      ,id
      ,tid
      ,j
      ,s
      ,r
      ,c
      ,exp
      ,lv
      ,q
      ,equ_grids
     ]).

print_hero(Heroes) ->
    io:format(?hero_format, ?hero_title_arg),
    io:format("~s~n", [string:copies("-", 181)]),
    print_hero1(Heroes).

print_hero1([Hero | Heroes]) ->
    io:format(?hero_format, [
        Hero#hero.pos
        ,Hero#hero.hp
        ,Hero#hero.atk
        ,Hero#hero.def
        ,Hero#hero.pun
        ,Hero#hero.hit
        ,Hero#hero.dod
        ,Hero#hero.crit
        ,Hero#hero.crit_num
        ,Hero#hero.crit_anti
        ,Hero#hero.tou
        ,Hero#hero.tou_anit
        ,Hero#hero.skills
        ,Hero#hero.id
        ,Hero#hero.tid
        ,Hero#hero.job
        ,Hero#hero.sort
        ,Hero#hero.rare
        ,Hero#hero.changed
        ,Hero#hero.exp
        ,Hero#hero.lev
        ,Hero#hero.quality
        ,Hero#hero.equ_grids
       ]),
    print_hero1(Heroes);
print_hero1([]) ->
    io:format("~s~n", [string:copies("-", 181)]),
    io:format(?hero_format, ?hero_title_arg),
    ok.
%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
