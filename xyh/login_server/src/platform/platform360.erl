%%----------------------------------------------------
%% $Id$
%% @doc 平台支持
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(platform360).

-include("common.hrl").
-include("platformDefine.hrl").

-export([
        init/1
        ,is_support/0
        ,verify/1
        ,user_info/1
    ]).

init({IP, Port})->
    ets:insert(platformtable,#platformTable{platformID=?PLATFORM_360,isSupport=1,ip=IP,port=Port}),
    ?INFO("~w supported: ~w", [?MODULE, ?PLATFORM_360]).

is_support()->
    case ets:lookup(platformtable, ?PLATFORM_360) of
        [{_,_,1,_,_} | _] -> yes;
        _ ->no
    end.

verify(Code)->
    RequestString="https://openapi.360.cn/oauth2/access_token?grant_type=authorization_code&code="++Code++"&client_id="++?APP_KEY_360++"&client_secret="++?APP_SECRET_360++"&redirect_uri=oob",
    ?DEBUG("verifyRequest360 ready.RequestString is:~p",[RequestString]),
    case httpc:request(get,{RequestString,[{"connection","false"}]},[],[]) of
        {error,Reason}->
            ?DEBUG("verifyRequest360 failed.Reason is:~p",[Reason]),
            error;
        {ok,Result}->
            {Header,Options,Content}=Result,
            ?DEBUG("verifyRequest360 ok.Header:~p,Options:~p,Content:~p",[Header,Options,Content]),
            Bin=unicode:characters_to_binary(Content),
            {ok,JsonObj,_}=rfc4627:decode(Bin),
            try
                Value0=rfc4627:get_field(JsonObj,"error_code",<<"0">>),
                Value1=rfc4627:get_field(JsonObj,"access_token",<<"null">>),
                Value2=rfc4627:get_field(JsonObj,"refresh_token",<<"null">>),
                {ErrorCode,_}=string:to_integer(binary_to_list(Value0)),
                Access_Token=binary_to_list(Value1),
                Refresh_Token=binary_to_list(Value2),
                ?DEBUG("verifyRequest360 ok.error_code:~p,AccessToken:~p,RefreshToken:~p",[ErrorCode,Access_Token,Refresh_Token]),
                case ErrorCode of
                    0-> user_info({Access_Token,Refresh_Token});
                    _->failed	
                end
            catch
                _:Why->
                    ?DEBUG("verifyRequest360 exception.Why:~p",[Why]),
                    failed
            end
    end.

user_info({Access_Token,Refresh_Token})->
    RequestString="https://openapi.360.cn/user/me.json?access_token="++Access_Token++"&fields=id,name",
    ?DEBUG("verifyRequest360 requestUserInfo ready.RequestString is:~p",[RequestString]),
    case httpc:request(get,{RequestString,[{"connection","false"}]},[],[]) of
        {error,Reason}->
            ?INFO("verifyRequest360 requestUserInfo failed.Reason is:~p",[Reason]),
            error;
        {ok,Result}->
            {Header,Options,Content}=Result,
            ?DEBUG("verifyRequest360 requestUserInfo ok.Header:~p,Options:~p,Content:~p",[Header,Options,Content]),
            Bin=unicode:characters_to_binary(Content),
            {ok,JsonObj,_}=rfc4627:decode(Bin),
            try
                Value0=rfc4627:get_field(JsonObj,"error_code",<<"0">>),
                Value1=rfc4627:get_field(JsonObj,"id",<<"null">>),
                Value2=rfc4627:get_field(JsonObj,"name",<<"null">>),
                {ErrorCode,_}=string:to_integer(binary_to_list(Value0)),
                UserId=binary_to_list(Value1),
                UserName=binary_to_list(Value2),
                ?DEBUG("verifyRequest360 requestUserInfo ok.error_code:~p,Id:~p,Name:~p",[ErrorCode,UserId,UserName]),
                case ErrorCode of
                    0->{success,UserId,UserName,Access_Token,Refresh_Token};
                    _->failed	
                end
            catch
                _:Why->
                    ?DEBUG("verifyRequest360 requestUserInfo exception.Why:~p",[Why]),
                    failed
            end
    end.
