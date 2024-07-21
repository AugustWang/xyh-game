%%----------------------------------------------------
%% ROBOT
%%
%% @author Rolong<erlang6@qq.com>
%%----------------------------------------------------

-define(AID_PREFIX, <<"robot">>).

-record(robot, {
        id
        ,sex = 0
        ,growth = 0
        ,gold = 0
        ,diamond = 0
        ,essence = 0
        ,bag_equ_max    = 16    %% 装备背包格子数，默认2行16个
        ,bag_prop_max   = 16    %% 道具背包格子数，默认2行16个
        ,bag_mat_max    = 16    %% 材料背包格子数，默认2行16个
        ,power
        ,tollgateid
        ,picture

        ,aid %% account id
        ,name
        ,tmp_package = <<>>

        ,pid
        ,pid_sender
        ,socket
        ,stop_ref

        ,handle_name = robot_handle

        %% --
        ,luck = {1, 0, 0, 0}
        ,horn = 0
        ,tollgate_prize = 1
        ,verify = 0
    }
).
