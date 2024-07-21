%%----------------------------------------------------
%% $Id: mod_task.erl 11420 2014-08-25 08:26:32Z piaohua $
%% @doc 任务模块
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(mod_task).
-export([
        open_task/1
        ,open_task/2
        ,set_task/3
        ,enemy_task/3
        ,jewel_task/2
        ,upgrade_task/3
        ,init_task/1
        ,update_task/1
        ,unzip/1
        ,zip/1
    ]
).

-include("common.hrl").
-include("prop.hrl").
-include("equ.hrl").
-include("hero.hrl").


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
-endif.


%% @doc 完成任务{L1,L2}=L
-spec set_task(T,L,Rs) -> NewRs when
    T :: integer(),
    L :: tuple(),
    Rs :: #role{},
    NewRs :: #role{}.
set_task(T,L,Rs) ->
    MyTask = Rs#role.task,
    set_task(MyTask,T,L,Rs).
set_task([],_,_,Rs) -> Rs;
set_task([{Id,T,N,0}|Task],T,L,Rs) when is_tuple(L) ->
    %% ?DEBUG("==Id:~w,T:~w,N:~w,L~w", [Id,T,N,L]),
    Data = data_task:get(Id),
    Before2 = util:get_val(before2,Data),
    Lev2 = util:get_val(lev2,Data),
    Con = util:get_val(condition,Data,0),
    Rs1 = case max_hero_lev(Rs#role.heroes,Lev2) of
        true ->
            case before_task(Before2,Task) of
                true ->
                    send_task({Id,T,N,0},L,Con,Rs);
                false -> Rs
            end;
        false -> Rs
    end,
    set_task(Task,T,L,Rs1);
set_task([_|Task],T,Num,Rs) ->
    set_task(Task,T,Num,Rs).

%% @doc 条件开启,检测是否有任务可开启
-spec open_task(Target,Rs) -> NewRs when
    Target :: integer(),
    Rs :: #role{},
    NewRs :: #role{}.
open_task(Target,Rs) ->
    Ids = data_task:get(ids),
    List = target_list(Ids,Target,[]),
    open_task1(List, Rs).

open_task(Rs) ->
    Ids = data_task:get(ids),
    open_task1(Ids, Rs).

open_task1([], Rs) -> Rs;
open_task1([Id|T], Rs) ->
    #role{task = Task} = Rs,
    case lists:keymember(Id,1,Task) of
        true ->
            open_task1(T, Rs);
        false ->
            Rs1 = open_task2(Id,Rs),
            open_task1(T, Rs1)
    end.

open_task2(Id,Rs) ->
    #role{task = Task} = Rs,
    Data = data_task:get(Id),
    Before1 = util:get_val(before1,Data),
    Lev1 = util:get_val(lev1,Data),
    case max_hero_lev(Rs#role.heroes,Lev1) of
        true ->
            case before_task(Before1,Task) of
                true ->
                    add_task(Id,Rs);
                false -> Rs
            end;
        false -> Rs
    end.

enemy_task([],_,Rs) -> Rs;
enemy_task([H|SH],EH,Rs) ->
    case lists:keyfind(H#hero.tid,#hero.tid,EH) of
        false ->
            Rs1 = set_task(2,{H#hero.tid,1},Rs),
            enemy_task(SH,EH,Rs1);
        _ -> enemy_task(SH,EH,Rs)
    end.

jewel_task([],Rs) -> Rs;
jewel_task([[Tid]|Tids],Rs) ->
    case data_prop:get(Tid) of
        undefined ->
            jewel_task(Tids,Rs);
        Data ->
            case util:get_val(sort,Data) of
                4 ->
                    set_task(11,{1,1},Rs);
                _ ->
                    jewel_task(Tids,Rs)
            end
    end;
jewel_task(_,Rs) -> Rs.

upgrade_task([],_,Rs) -> Rs;
upgrade_task([H|HO],HN,Rs) ->
    case lists:keyfind(H#hero.id,#hero.id,HN) of
        false ->
            upgrade_task(HO,HN,Rs);
        HNI ->
            case HNI#hero.lev > H#hero.lev of
                true ->
                    Rs1 = open_task(Rs),
                    upgrade_task(HO,HN,Rs1);
                false ->
                    upgrade_task(HO,HN,Rs)
            end
    end.

%%' 数据库相关操作

%% @doc 初始化日常数据隔天重置
-spec init_task(Rs) -> {ok, Rs} | {error, Reason} when
    Rs :: #role{},
    Reason :: term().
init_task(Rs) ->
    Sql = list_to_binary([<<"SELECT `task` FROM `task` WHERE `id` = ">>, integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Bin]} ->
            Task = unzip(Bin),
            MyTask = filter_task(Task, []),
            Time = util:unixtime(today),
            case Rs#role.loginsign_time < Time of
                true ->
                    MyTask1 = refresh_task_today(MyTask),
                    {ok, Rs#role{task = MyTask1}};
                false ->
                    {ok, Rs#role{task = MyTask}}
            end;
        {error, null} ->
            Ids = data_task:get(ids),
            Rs1 = open_task1(Ids,Rs),
            MyTask1 = refresh_task_today(Rs1#role.task),
            {ok, Rs1#role{task = MyTask1,save=[task]}};
        {error, Reason} ->
            {error, Reason}
    end.

refresh_task_today(List2) ->
    List1 = init_task_today(),
    refresh_task_today(List1,List2).
refresh_task_today([],List) -> List;
refresh_task_today([{Id,T,N,S}|List1],List2) ->
    List3 = lists:keystore(Id,1,List2,{Id,T,N,S}),
    refresh_task_today(List1,List3).

init_task_today() ->
    Ids = data_task:get(ids),
    init_task_today(Ids,[]).
init_task_today([],Rt) -> Rt;
init_task_today([Id|Ids],Rt) ->
    Data = data_task:get(Id),
    case util:get_val(type,Data) of
        4 ->
            Target = util:get_val(target,Data),
            Con = util:get_val(condition,Data),
            N = [{N1,0} || {N1,_N2} <- Con],
            init_task_today(Ids,[{Id,Target,N,0}|Rt]);
        _ -> init_task_today(Ids,Rt)
    end.

filter_task([], Rt) -> Rt;
filter_task([Task|MyTasks], Rt) ->
    Id = element(1, Task),
    case data_task:get(Id) of
        undefined ->
            filter_task(MyTasks, Rt);
        _ ->
            Task1 = filter_task1(Task),
            filter_task(MyTasks, [Task1|Rt])
    end.

filter_task1({Id,T,N,0}) ->
    Data = data_task:get(Id),
    Con = util:get_val(condition,Data),
    N2 = filter_task2(N,Con,[]),
    N3 = filter_task3(Con,N2),
    {Id,T,N3,0};
filter_task1(T) -> T.

filter_task2([],_,Rt) -> Rt;
filter_task2([{C,N}|T],Con,Rt) ->
    case lists:keyfind(C,1,Con) of
        false ->
            filter_task2(T,Con,Rt);
        _ ->
            filter_task2(T,Con,[{C,N}|Rt])
    end.

filter_task3([],Rt) -> Rt;
filter_task3([{C,_N}|T],Rt) ->
    case lists:keyfind(C,1,Rt) of
        false ->
            filter_task3(T,[{C,0}|Rt]);
        _ ->
            filter_task3(T,Rt)
    end.

update_task(Rs) ->
    #role{
        id = Id
        ,task = Task
    } = Rs,
    Val = ?ESC_SINGLE_QUOTES(zip(Task)),
    Sql = list_to_binary([<<"UPDATE `task` SET `task` = '">>
            ,Val,<<"' ">>, <<" WHERE `id` = ">>, integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, 0} ->
            insert_task(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

insert_task(Rs) ->
    #role{
        id = Id
        ,task = Task
    } = Rs,
    Val = ?ESC_SINGLE_QUOTES(zip(Task)),
    Sql = list_to_binary([<<"SELECT count(*) FROM `task` WHERE id = ">>,integer_to_list(Id)]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `task` (`id`, `task`) VALUES (">>
                    ,integer_to_list(Id), <<",'">>, Val, <<"')">>]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.
%%.

%%' zip / unzip
%% unpack binary
unzip(<<>>) -> [];
unzip(Bin) ->
    <<Version:8,Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip1(Bin1,[]);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

unzip1(<<X1:32,X2:8,L:8,RestBin/binary>>,Rt) ->
    {X3,RestBin1} = unzip2(L,RestBin,[]),
    <<X4:8,RestBin2/binary>> = RestBin1,
    Rt1 = [{X1,X2,X3,X4} | Rt],
    unzip1(RestBin2, Rt1);
unzip1(<<>>, Rt) ->
    Rt.

unzip2(L,<<RestBin/binary>>,Rt) ->
    case L > 0 of
        true ->
            <<N1:32,N2:32,RestBin1/binary>> = RestBin,
            unzip2(L-1,RestBin1,[{N1,N2}|Rt]);
        false -> {Rt,RestBin}
    end.

%% pack binary
-define(TASK_ZIP_VERSION, 1).
zip([]) -> <<>>;
zip(Task) ->
    Bin = list_to_binary(zip1(Task,[])),
    <<?TASK_ZIP_VERSION:8,Bin/binary>>.

zip1([{X1,X2,X3,X4}|Task], Rt) when is_list(X3) ->
    Len = length(X3),
    Rt1 = [<<X1:32,X2:8,Len:8>>],
    Rt2 = zip2(X3,[]),
    Rt3 = [Rt1++Rt2|<<X4:8>>],
    zip1(Task,[Rt3|Rt]);
zip1(_,Rt) -> Rt.

zip2([],Rt) -> Rt;
zip2([{N1,N2}|N3],Rt) ->
    Rt1 = <<N1:32,N2:32>>,
    zip2(N3, [Rt1|Rt]).

%%.

%%' --- 私有函数 ---

add_task(Id,Rs) ->
    #role{task = Task} = Rs,
    Data = data_task:get(Id),
    Target = util:get_val(target,Data),
    case util:get_val(condition,Data) of
        undefined -> Rs;
        Con when is_list(Con) ->
            N = [{N1,0} || {N1,_N2} <- Con],
            Task1 = lists:keystore(Id,1,Task,{Id,Target,N,0}),
            sender:pack_send(Rs#role.pid_sender,36002,[Id]),
            Rs#role{task = Task1,save=[task]};
        _ -> Rs
    end.

send_task({Id,T,N,S},{L1,L2},Con,Rs) ->
    %% {1001,1,[{30001,0}],0},{30001,1},{30001,1}
    %% ?DEBUG("===Id:~w,T:~w,N:~w,S:~w",[Id,T,N,S]),
    %% ?DEBUG("==L1:~w,L2:~w,Con:~w",[L1,L2,Con]),
    #role{task = MyTask} = Rs,
    case lists:keyfind(L1,1,N) of
        false -> Rs;
        {L1,L3} ->
            N1 = lists:keyreplace(L1,1,N,{L1,L2+L3}),
            case send_task1(N1,Con) of
                true ->
                    MyTask1 = lists:keyreplace(Id,1,MyTask,{Id,T,N1,1}),
                    sender:pack_send(Rs#role.pid_sender,36001,[Id]),
                    Rs1 = Rs#role{task = MyTask1},
                    Rs2 = mod_task:open_task(Rs1),
                    Rs2#role{save=[task]};
                false ->
                    MyTask1 = lists:keyreplace(Id,1,MyTask,{Id,T,N1,S}),
                    sender:pack_send(Rs#role.pid_sender,36003,[Id,N1]),
                    Rs#role{task = MyTask1,save=[task]}
            end
    end.

send_task1([],_Con) -> true;
send_task1([{N1,N2}|N3],Con) ->
    case lists:keyfind(N1,1,Con) of
        false -> send_task1(N3,Con);
        {N1,C2} ->
            case N2 >= C2 of
                true -> send_task1(N3,Con);
                false -> false
            end
    end.

max_hero_lev(_, undefined) -> true;
max_hero_lev([], _Lev) -> false;
max_hero_lev([#hero{lev = Lev}|H],Lev1) ->
    case Lev >= Lev1 of
        true -> true;
        false ->
            max_hero_lev(H,Lev1)
    end;
max_hero_lev(_,_) -> false.

before_task(undefined,_) -> true;
before_task(Before,Task) when is_list(Before) ->
    F = fun(Id) ->
            case lists:keyfind(Id,1,Task) of
                false -> false;
                {Id,_,_,St} when St =/= 0 -> true;
                _ -> false
            end
    end,
    lists:all(F,Before);
before_task(_,_) -> false.

target_list([],_,List) -> List;
target_list([Id|Ids],Target,List) ->
    case data_task:get(Id) of
        undefined -> target_list(Ids,Target,List);
        Data ->
            case util:get_val(target,Data) of
                undefined -> target_list(Ids,Target,List);
                Target ->
                    target_list(Ids,Target,[Id|List]);
                _ -> target_list(Ids,Target,List)
            end
    end.
%%.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
