%%----------------------------------------------------
%% $Id: pt_module_map.erl 12072 2014-04-21 08:56:51Z piaohua $
%% @doc ===协议模块映射===
%%      通过协议号前两位映射模块名，
%%      如果没有做映射，默认为pt_xx（xx为协议开头的两们数字），
%%      如果有新增模块，需要在这里添加映射，
%%      如：
%%      ```
%%      get($1, $0) -> pt_misc;
%%      get($1, $1) -> pt_role;
%%      ...
%%      '''
%% @end
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_module_map).
-export([get/1]).

%%----------------------------------------------------
%% @doc 通过协议号获取映射的模块名
%% @end
%%----------------------------------------------------
-spec get(Cmd) -> ModuleName when
    Cmd :: integer(),
    ModuleName :: atom().

get(Cmd) ->
    [H1, H2 | _] = case integer_to_list(Cmd) of
        [L1, L2, _, _, _] ->
            %% 五位的协议号为和客户端交互的协议
            [L1, L2];
        [L1, _, _, _] ->
            %% 四位的协议号为内部协议，前面补0
            [$0, L1]
    end,
    get(H1, H2).

get($1, $0) -> pt_misc;
get($1, $1) -> pt_role;
get($1, $3) -> pt_item;
get($1, $4) -> pt_hero;
get($1, $5) -> pt_skill;
get($2, $2) -> pt_combat;
get($2, $3) -> pt_arena;
get($2, $4) -> pt_attain;
get($2, $5) -> pt_fest;
get($2, $6) -> pt_mail;
get($2, $7) -> pt_chat;
get($2, $9) -> pt_rank;
get($3, $3) -> pt_coliseum;
get($3, $4) -> pt_video;
get($3, $5) -> pt_vip;
get($3, $6) -> pt_task;

%% ^^^^^ 协议模块映射在此行上面添加 ^^^^^
get(H1, H2) -> list_to_atom("pt_" ++ [H1, H2]).
