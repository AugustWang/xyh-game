%% $Id: s.hrl 11102 2014-03-27 11:24:58Z rolong $

%%  &1   - 暴击
%%  &2   - 闪避
%%  &4   - 复活
%%  &8   - 治疗
-define(STA_CRIT, 1).
-define(STA_DOD, 2).
-define(STA_REALIVE, 4).
-define(STA_CURE, 8).

-record(buff, {
        %% buff名称：
        %% dizzy ：炫晕
        %% ice   ：冰冻
        name
        ,args
        ,bout %% 持续回合数
        ,id   %% buff表中的ID
        ,trigger
    }).

%% soldier
-record(s, {
        pos        = 11
        ,tid       = 0
        ,hp_max    = 10000
        ,hp        = 0
        ,hp_ratio  = 0
        ,atk       = 0
        ,atk_init  = 0 %% 备份初始化时的攻击力
        ,def       = 0
        ,pun       = 0
        ,hit       = 0
        ,dod       = 0
        ,crit      = 0
        ,crit_num  = 0
        ,crit_anti = 0
        ,tou       = 0
        ,tou_anit  = 0
        ,job = 0
        %% 0  = 可出手
        %% >0 = 不可出手
        %% ,status = 0
        %% 前端表现状态:
        %%  &1   - 暴击
        %%  &2   - 闪避
        %%  &4   - 复活
        %%  &8   - 治疗
        %%  &16  -
        %%  &32  -
        %%  &64  -
        %%  &128 -
        ,state = 0
        ,damaged = 1 %% 附加被攻击量
        ,crited_must = 0 %% 是否必然被暴击
        ,atked  = 0 %% 累计被伤害值
        ,enable_wake_skill = true %% 是可使用觉醒技能
        ,buff_ids = []
        ,buffs = []
        ,skills = []
        ,iced_rate = undefined %% 被冰冻概率加成 dict:new()
        ,atk_type = undefined %% 1=远程 2=近身 3=治疗
    }
).
