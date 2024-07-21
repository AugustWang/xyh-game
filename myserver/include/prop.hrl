%% $Id: prop.hrl 13120 2014-06-03 11:36:51Z piaohua $

%% 道具属性
-record(prop, {
        num      = 1 %% 堆叠数量
        ,quality = 0
        ,level   = 1  %% 宝珠等级
        ,exp     = 0  %% 宝珠经验
    }).
