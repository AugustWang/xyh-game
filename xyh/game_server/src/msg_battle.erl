


-module(msg_battle).
-export([send/2,dealMsg/3]).
-import(messageBase, [read_string/1, read_int/1,  read_int8/1,  read_int16/1, write_array/2,
             		 write_string/1, write_int/1,  write_int8/1,  write_int16/1, write_int64/1,read_array/2, sendPackage/3] ).
-import(common, [binary_read_int64/1,binary_read_int64/2,binary_read_int16/2, binary_read_int16/1,binary_read_int/2, binary_read_int/1, binary_read_int8/2,  binary_read_string/2, binary_read_array_head16/3]).
-include("package.hrl").


write_Skillcooldown(#pk_Skillcooldown{skillID = SkillID, time = Time}=P) -> 
    <<SkillID:32/little, Time:32/little>>.

binary_read_Skillcooldown(Bin0)->
    <<SkillID:32/little, Time:32/little>> = Bin0,
	{#pk_Skillcooldown{
		skillID=SkillID,
		time=Time
	},
	<<>>,
	0
	}.


send(Socket,#pk_Skillcooldown{}=P) ->

	Bin = write_Skillcooldown(P),
	sendPackage(Socket,?CMD_Skillcooldown,Bin);

send(_,_)-> 
	noMatch.


dealMsg(Socket,Cmd,Bin2) -> 
	case Cmd of
		_-> 
		noMatch
	end.
