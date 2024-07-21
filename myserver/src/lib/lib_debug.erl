%%----------------------------------------------------
%% $Id$
%% @doc 调试工具包
%% @author rolong@vip.qq.com
%% @end
%%----------------------------------------------------

-module(lib_debug).
-export([
        print_equ/1
        ,print_prop/1
        ,print_hero/1
        ,print_s/1
    ]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").
-include("s.hrl").

print_equ(Equ) ->
    print_equ(Equ, 0, "", []).

print_prop(Prop) ->
    print_prop(Prop, 0, "", []).

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

-define(s_format,
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
        " |~98w~n"     %% skill
       ).

-define(s_title_arg,
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
     ]).

print_s(Ss) ->
    io:format(?s_format, ?s_title_arg),
    io:format("~s~n", [string:copies("-", 181)]),
    print_s1(Ss).

print_s1([S | Ss]) ->
    io:format(?s_format, [
        S#s.pos
        ,S#s.hp
        ,S#s.atk
        ,S#s.def
        ,S#s.pun
        ,S#s.hit
        ,S#s.dod
        ,S#s.crit
        ,S#s.crit_num
        ,S#s.crit_anti
        ,S#s.tou
        ,S#s.tou_anit
        ,S#s.skills
       ]),
    print_s1(Ss);
print_s1([]) ->
    io:format("~s~n", [string:copies("-", 181)]),
    io:format(?s_format, ?s_title_arg),
    ok.

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
