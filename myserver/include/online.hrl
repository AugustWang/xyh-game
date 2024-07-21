%%----------------------------------------------------
%% 角色相关数据结构定义
%% 
%% @author Rolong<erlang6@qq.com>
%%----------------------------------------------------

%% 角色在线数据
-record(online,
    {
        id              = 0     %% 角色ID
        ,account_id     = 0
        ,status         = 0     %% 0=末登陆,1=已登陆
        ,pid                    %% 角色主进程ID (false=不在线)
        ,pid_sender     = 0     %% socket数据发包进程
        ,name           = <<>>
        ,growth         = 0
    }
).
