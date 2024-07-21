%%----------------------------------------------------
%% $Id$
%% @doc 平台验证
%%----------------------------------------------------

-module(verify).

-include("platformDefine.hrl").
-include("common.hrl").

-export([
        verifyTest/2
        ,verify553/3
        ,verify553_android/3
        ,verifyAPPS/3
        ,verify360/1
    ]).

%% 测试平台验证
verifyTest(Account,IP)->
	?DEBUG("verifyTest Account=~p,IP=~p",[Account,IP]),
	case platform553:is_test_check() of
		true->
			case loginMysqlProc:get_platform_test(Account,IP) > 0 of
				true->success;
				false->
					?INFO("verifyTest failed. Account:[~p],IP:[~p]",[Account,IP]),failed
			end;
		false->
			success
	end.

%%553平台验证
verify553(Account,Time,Sign)->
	?DEBUG("verify553 Account:[~p],Time[~p],Sign[~p]",[Account,Time,Sign]),
	case util:md5(common:formatString(Time)++Account++?KEY_PLATFORM_553_VERIFY) of 
	Sign->
		success;
	_->
		?INFO("verify553 TimeString:[~p],Key:[~p],util:md5[~p]",[common:formatString(Time),?KEY_PLATFORM_553_VERIFY,util:md5(common:formatString(Time)++Account++?KEY_PLATFORM_553_VERIFY)]),
		failed
	end.

verify553_android(Account,Time,Sign)->
	?DEBUG("verify553_android Account:[~p],Time[~p],Sign[~p]",[Account,Time,Sign]),
	case util:md5(common:formatString(Time)++Account++?KEY_PLATFORM_553_ANDROID_VERIFY) of 
	Sign->
		success;
	_->
		?INFO("verify553_android TimeString:[~p],Key:[~p],util:md5[~p]",[common:formatString(Time),?KEY_PLATFORM_553_ANDROID_VERIFY,util:md5(common:formatString(Time)++Account++?KEY_PLATFORM_553_ANDROID_VERIFY)]),
		failed
	end.

%%苹果平台验证
verifyAPPS(Account,Time,Sign)->
	?DEBUG("verifyAPPS Account:[~p],Time[~p],Sign[~p]",[Account,Time,Sign]),
	case util:md5(common:formatString(Time)++Account++?KEY_PLATFORM_APPS_VERIFY) of 
	Sign->
		success;
	_->
		?INFO("verify553 TimeString:[~p],Key:[~p],util:md5[~p]",[common:formatString(Time),?KEY_PLATFORM_APPS_VERIFY,util:md5(common:formatString(Time)++Account++?KEY_PLATFORM_APPS_VERIFY)]),
		failed
	end.

%%360平台验证
verify360(Code)->
	?INFO("verify360 Code[~p]",[Code]),
	platform360:verify(Code).
