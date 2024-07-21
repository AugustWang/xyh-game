-module(forbidden).

-include("common.hrl").


%%
%% Exported Functions
%%
-compile(export_all).

%% 封号检查
forbiddenCheck(Account)->
	?DEBUG("forbiddenCheck Account:[~p]",[Account]),
	case loginMysqlProc:get_forbidden_user(Account) of
		{error,_}->false;
		{ok,Count}->
			case Count =:= 0 of
				true->false;
				false->true
			end
	end.
	
