%%----------------------------------------------------
%% $Id: pt_task.erl 12041 2014-09-01 02:07:10Z piaohua $
%% @doc 协议36 - 任务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_task).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").
-include("prop.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
-endif.

%% 任务领奖
handle(36004, [Id], Rs) ->
    Mytask = Rs#role.task,
    %% ?DEBUG("==Id:~w,Mytask:~w", [Id,Mytask]),
    case lists:keyfind(Id, 1, Mytask) of
        false -> {ok, [127]};
        {Id, T, Con, 1} ->
            Data = data_task:get(Id),
            %% Target = data_task:get(Id),
            case util:get_val(award, Data) of
                undefined -> {ok, [128]};
                Item ->
                    case mod_item:add_items(Rs, Item) of
                        {ok, Rs1, PA, EA} ->
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            MyTask1 = lists:keyreplace(Id,1,Mytask,{Id,T,Con,2}),
                            Rs2 = Rs1#role{task = MyTask1},
                            %% Rs3 = mod_task:open_task(Rs2),
                            Rs3     = lib_role:add_attr_ok(gold, 65, Rs, Rs2),
                            Rs4     = lib_role:add_attr_ok(diamond, 65, Rs, Rs3),
                            {ok, [0], Rs4#role{save = [items,task]}};
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id,0,65,Title,Body,Item),
                            MyTask1 = lists:keyreplace(Id,1,Mytask,{Id,T,Con,2}),
                            Rs1 = Rs#role{task = MyTask1},
                            %% Rs2 = mod_task:open_task(Rs1),
                            {ok, [3], Rs1#role{save = [task]}};
                        {error, _} ->
                            {ok, [129]}
                    end
            end;
        {_, _, _, 2} ->
            {ok, [2]};
        _ ->
            {ok, [1]}
    end;

%% 初始化
handle(36005, [], Rs) ->
    #role{task = Mytask} = Rs,
    MyTask1 = [{Id,Con,St} || {Id,_T,Con,St} <- Mytask, St =/= 2],
    {ok, [MyTask1]};

handle(36006, [Id], Rs) ->
    Rs1 = case Id of
        1 ->
            mod_task:set_task(14,{1,1},Rs);
        _ -> Rs
    end,
    {ok, [0],Rs1};

handle(_Cmd, _Data, _RoleState) ->
    {error, bad_request}.


%% === 私有函数 ===

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
