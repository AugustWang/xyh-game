%%----------------------------------------------------
%% $Id: pt_misc.erl 13280 2014-06-21 10:14:57Z rolong $
%% @doc 协议10 - 综合
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_misc).
-export([handle/3]).

-include("common.hrl").

handle(10005, [], Rs) ->
    gen_server:cast(admin, {send_notice, Rs#role.pid_sender}),
    {ok};

handle(10010, [Type, Content], Rs) when Type == 1 orelse Type == 2 ->
    Sql = "INSERT INTO `feedback` (`role_id`, `type`, `ctime`, `ip`, `aid`, `content`) "
    "VALUES (~s, ~s, ~s, ~s, ~s, ~s);",
    #role{id = Rid, ip = Ip, account_id = Aid} = Rs,
    case db:execute(Sql, [Rid, Type, util:unixtime(), Ip, Aid, Content]) of
        {ok, _} ->
            Title = data_text:get(2),
            Body = data_text:get(20),
            mod_mail:new_mail(Rid, 0, 0, Title, Body, []),
            {ok, [0]};
        {error, Reason} ->
            ?WARN("feedback error: ~w", [Reason]),
            {ok, [1]}
    end;

%%      android : String = "android";
%% 		ios_91 : String = "ios_91";
%% 		ios_tb : String = "ios_tb";
%% 		android_wdj : String = "android_wdj";
%% 		android_91 : String = "android_91";
%% 		android_uc : String = "android_uc";
%% 		android_xm : String = "android_xm";
%% 签名算法: md5(sid + key + account + rand)
handle(10011, [<<"ios">>, Receipt, Rand, Signature], Rs) ->
    #role{id = Rid, account_id = Aid, pid_sender = Sender} = Rs,
    case lib_role:in_app_purchase_check(Receipt) of
        {ok, ReceiptData} ->
            ProductId = util:get_val(product_id, ReceiptData, <<>>),
            TransactionId = util:get_val(transaction_id, ReceiptData, <<>>),
            Bvrs = util:get_val(bvrs, ReceiptData, <<>>),
            ChkSql = "select count(*) from app_store where role_id = ~s and transaction_id = ~s",
            SignatureChkStr = list_to_binary([
                    integer_to_list(env:get(server_id))
                    ,env:get(server_key)
                    ,Aid
                    ,integer_to_list(Rand)
                ]),
            SignatureChk = util:md5(SignatureChkStr),
            if
                Signature =/= SignatureChk ->
                    %% 签名不正确
                    ?DEBUG("Signature:~s", [Signature]),
                    ?DEBUG("SignatureChk:~s", [SignatureChk]),
                    ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Signature:~s~nSignatureChk:~s", [Aid, Signature, SignatureChk]),
                    {ok, [1]};
                true ->
                    case db:get_one(ChkSql, [Rid, TransactionId]) of
                        {ok, 0} ->
                            case data_diamond_shop:get(binary_to_list(ProductId)) of
                                undefined ->
                                    ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, product_id: ~s~nReceipt:~n~s", [Aid, ProductId, Receipt]),
                                    {ok, [1]};
                                DiamondData ->
                                    case util:get_val(diamond, DiamondData) of
                                        undefined ->
                                            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Diamond Data: ~w, product_id: ~s~nReceipt:~n~s", [Aid, DiamondData, ProductId, Receipt]),
                                            {ok, [1]};
                                        Diamond ->
                                            RMB = util:get_val(rmb, DiamondData),
                                            %% 充值购买钻石成功
                                            Rs1 = lib_role:add_attr(diamond, Diamond, Rs),
                                            case is_pid(Rs#role.pid_sender) of
                                                true -> lib_role:notice(Rs1);
                                                false -> ok
                                            end,
                                            Rs2 = lib_role:add_attr_ok(diamond, 35, Rs, Rs1),
                                            PurchaseDate = util:get_val(purchase_date_ms, ReceiptData, <<>>),
                                            db:execute("INSERT INTO `app_store`(`role_id`, `transaction_id`, `product_id`, `purchase_date`, `bvrs`, `diamond`, `rmb`, `ctime`) "
                                                "VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s);", [Rs#role.id, TransactionId, ProductId, PurchaseDate, Bvrs, Diamond, RMB, util:unixtime()]),
                                            ?INFO("[IN_APP_PURCHASE OK] Account: ~s, ProductId: ~s", [Aid, ProductId]),
                                            %% 土豪成就
                                            Rs3 = mod_attain:attain_state(33, RMB, Rs2),
                                            %% firstpay double
                                            %% Rs4 = case util:get_val(double, DiamondData) of
                                            %%     1 -> mod_fest:firstpay(Rs3, Diamond);
                                            %%     _ -> Rs3
                                            %% end,
                                            Rs4 = mod_fest:pay_double(Rs3, DiamondData),
                                            %% 首充推送
                                            {Rs5, FirstPaySt} = mod_fest:activity_first_pay(Rs4),
                                            case FirstPaySt =:= 0 of
                                                true ->
                                                    sender:pack_send(Sender, 25032, [0]);
                                                false -> ok
                                            end,
                                            %% vip 充值钻石累加
                                            Rs6 = mod_vip:set_vip(diamond, Diamond, 0, Rs5),
                                            %% lib_admin:new_server_active(Diamond, Rs#role.id),
                                            %% month card
                                            Rs7 = mod_vip:set_mcard(Rs6, DiamondData),
                                            SaveState = Rs7#role.save,
                                            {ok, [0], Rs7#role{save = [role, vip] ++ SaveState}}
                                    end
                            end;
                        {ok, Count} ->
                            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Resubmit Receipt: ~w~nReceipt:~n~s", [Aid, Count, Receipt]),
                            {ok, [1]};
                        {error, Reason} ->
                            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, ~w~nReceipt:~n~s", [Aid, Reason, Receipt]),
                            {ok, [2]}
                    end
            end;
        {error, {bid, Reason}} ->
            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Bid: ~s", [Aid, Reason]),
            {ok, [1]};
        {error, {httpc_request, Reason}} ->
            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, httpc_request: ~s", [Aid, Reason]),
            {ok, [2]};
        {error, Reason} ->
            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, ~w, ~nReceipt:~n~s", [Aid, Reason, Receipt]),
            {ok, [1]}
    end;


%% 非iOS官方平台充值处理
handle(10011, [Platform, Receipt, Rand, Signature], Rs) ->
    #role{account_id = Aid} = Rs,
    SignatureChkStr = list_to_binary([
            integer_to_list(env:get(server_id))
            ,env:get(server_key)
            ,Aid
            ,integer_to_list(Rand)
        ]),
    SignatureChk = util:md5(SignatureChkStr),
    if
        Signature =/= SignatureChk ->
            %% 签名不正确
            ?DEBUG("Signature:~s", [Signature]),
            ?DEBUG("SignatureChk:~s", [SignatureChk]),
            ?WARN("[PURCHASE ERROR] Aid: ~s, Signature:~s~nSignatureChk:~s, Data:~p", [Aid, Signature, SignatureChk, [Platform, Receipt, Rand, Signature]]),
            {ok, [1]};
        true ->
            ?INFO("Recv client charge notice:~s ~s", [Platform, Receipt]),
            self() ! {pt, 2088, [Platform, Receipt, 1]},
            {ok}
    end;

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
