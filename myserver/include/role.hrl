%%----------------------------------------------------
%% 角色相关数据结构定义
%%
%% @author Rolong<erlang6@qq.com>
%%----------------------------------------------------

%% 角色进程状态数据结构
-record(role, {
        % --- int ---
        id                 = 0      %% 角色ID
        ,sex
        ,growth            = 0      %% 0未创建角色,1已创建,2已选英雄
        ,gold              = 0      %% 金币
        ,diamond           = 0      %% 钻石
        ,status            = 0      %% 0=末登陆,1=登陆
        ,max_hero_id       = 0
        ,max_item_id       = 0
        ,tollgate_id       = 1      %% 主线关卡ID
        ,tollgate_newid    = 1      %% 新主线关卡ID
        ,power             = 100    %% 疲劳值
        ,power_time        = 0      %% 上次计算疲劳值的时间
        ,buy_power         = 0      %% 购买疲劳次数
        ,buy_power_time    = 0      %% 购买疲劳时间
        ,sign              = 0      %% 32位布尔标记
        ,givehero          = 0      %% 酒馆引导赠送英雄次数
        ,horn              = 0      %% 喇叭数量
        ,combat            = 0      %% 战斗力
        ,tollgate_prize    = 1      %% 关卡礼包
        ,herotab           = 6      %% 英雄携带数

        %% 英雄酒馆刷新时间
        %% 未初始化时值为undefined
        ,tavern_time       = undefined
        ,bag_equ_max       = 16     %% 装备背包格子数，默认2行16个
        ,bag_prop_max      = 16     %% 道具背包格子数，默认2行16个
        ,bag_mat_max       = 16     %% 材料背包格子数，默认2行16个
        %% 副本
        ,fb_combat1        = 0      %% 副本战斗当前可用次数（初）
        ,fb_combat2        = 0      %% 副本战斗当前可用次数（中）
        ,fb_combat3        = 0      %% 副本战斗当前可用次数（高）
        ,fb_time1          = 0      %% 上次刷新时间（初）
        ,fb_time2          = 0      %% 上次刷新时间（中）
        ,fb_time3          = 0      %% 上次刷新时间（高）
        ,fb_gate           = undefined    %% 副本关卡 {Type, 副本关卡ID}
        ,fb_buys           = {0,0,0} %% 副本购买次数(初,中,高)
        ,fb_buys_time      = 0      %% 购买副本时间
        ,fb_nightware      = []     %% 噩梦副本
        % --- ~~ ---
        ,arena_id          = 0      %% 竞技ID
        ,arena_lev         = 1      %% 竞技场段位
        ,arena_exp         = 0      %% 竞技场积分
        ,arena_rank        = 0      %% 竞技场排名(0表示没有上榜)
        ,arena_picture     = 1      %% 竞技场头像
        % --- ~~ ---
        ,arena_time        = 0      %% 竞技场上次刷新时间
        ,arena_honor       = 0      %% 竞技场荣誉值
        % --- ~~ ---
        ,arena_wars        = 20     %% 竞技场挑战次数
        ,arena_chance      = 0      %% 竞技场购买挑战机会次数(新版有用)
        ,arena_rank_box    = 0      %% 竞技场排行榜宝箱(0未领取,1已领取)
        ,arena_revenge     = 0      %% 竞技场悬赏次数
        ,arena_prize       = 0      %% 竞技场揭榜次数
        % --- ~~ ---
        ,arena_combat_box1 = 0      %% 竞技场挑战宝箱(0未领取,1已领取)
        ,arena_combat_box2 = 0      %% 竞技场挑战宝箱(0未领取,1已领取)
        % --- ~~ ---
        ,attain_time       = 0      %% 成就上次刷新时间
        ,loginsign_time    = 0      %% 上次登录签到时间
        ,loginsign_type    = 1      %% 签到奖励类型(1,2)
        % --- pid ---
        ,pid               = 0      %% 角色主进程ID
        ,pid_conn          = 0      %% 连接处理进程ID
        ,pid_sender        = 0      %% Socket数据发包进程
        % --- port ---
        ,socket            = 0      %% socket
        ,port
        % --- binary ---
        ,ip
        ,name              = <<>>  %% 角色名称
        ,account_id
        ,password          = <<>>  %% 密码
        % --- tuple ---
        ,luck    = {1, 0, 0, 0}    %% = {幸运星,幸运钻石,累计使用幸运星, 总价值}
        ,produce_pass              %% = {Type, PassId}  %% 当前掉落关卡
        ,fb                        %% #fb
        % --- list ---
        ,save    = []

        %% ------------------------------------------------------------------
        %% save_delay: 延迟回存标识，
        %% 如果在save里的内容保存失败，
        %% 将转到这里，进程退出时再尝试保存
        %% ------------------------------------------------------------------
        ,save_delay = []

        ,heroes = []
        ,items  = []

        % --- ~yes or no identifier~ ---
        % &1=new tollgate_newid reward
        % 1=&1, 2=&2, 3=&4, 4=&8...
        % &2, &4, &8, &16, &32, &64, &128
        ,identifier        = 0

        %% ------------------------------------------------------------------
        %% jewel: 宝珠抽取状态
        %% 如为[]时会初始化为: [{1, 1}, {2, 0}, {3, 0}, {4, 0}, {5, 0}]
        %% 格式: [{Quality, Status}, ...]
        %%         Quality : 宝珠品质等级
        %%         Status : 是否开始(1=是,0=否)
        %% ------------------------------------------------------------------
        ,jewel  = []

        ,tavern = [] %% [{Id, IsLock, #hero}]
        %% ------------------------------------------------------------------
        %% [[Id, name, picture, IsBeat]]
        %% IsBeat:0=未击败, 1=已击败
        %% ------------------------------------------------------------------
        ,arena  = []
        ,arena_lost_report = []

        %% ------------------------------------------------------------------
        %% [{Id, NextId, Type, Condition, State}]
        %% State:0=未完成, 1=可领取, 2=全部完成
        %% ------------------------------------------------------------------
        ,attain = []

        %% ------------------------------------------------------------------
        %% day1=当前签到天数
        %% day2=已经签到天数
        %% State:0=未签到,1=可领取,2=已领取
        %% [day1, day2, [{day, State}]]
        %% ------------------------------------------------------------------
        ,loginsign = []

        ,guide     = {0, 0}    %% 引导完成情况

        %% ------------------------------------------------------------------
        %% 非节日活动
        %% Id1  = 活动id
        %% V    = 完成数量/分享时间(default=0)
        %% N    = 当前阶段(default=1)
        %% St   = (0=不可领取,1=可以领取,2=已经领取)
        %% ------------------------------------------------------------------
        ,activity = []         %% [{Id1, V, N, St}, {Id2, V, N, St}..]
        ,friends  = []         %% [id1,id2..]游戏内好友关系(绑定激活码)
        ,verify   = 0          %% 激活码

        %% ,logintime= 0       %% 登录时间
        %% ,email_max_id       %% 邮件最大id,登录时初始化
        %% ,email_enclosure    %% 邮件附件
        ,email                 %% [{id,fromid,from,content,items,ctime}..]邮件
        %% 新版竞技场
        %% Id=竞技场唯一id
        %% HighRank=历史最高排名
        %% PrizeTime=领奖时间
        %% [{Rid,Name,Time}]=战报
        %% [Id,Lev,Exp,Pic,WarsNum,HighRank,PrizeTime,[{Rid,Name,Time}]]
        ,coliseum = []
        ,pictorialial = []     %% 图鉴

        %% vip  = vip等级
        %% id1  = vip特权类型
        %% Val  = vip特权值
        %% N    = vip当天已经使用次数或累计值,默认=0
        %% Custom    = vip特权使用时间或其他状态值,默认=0
        %% vip=[vip,time,[{id1,Val,N,Custom},{id2,Val,N,Custom}...]]
        ,vip = []
        ,paydouble = []   %% pay double [{id,paynum}]
    }
).
