%%----------------------------------------------------
%% $Id$
%% @doc 
%% (Mark By Rolong)
%%----------------------------------------------------
-module(myBits).


%%
%% Exported Functions
%%
-compile(export_all). 

%% 检测Bin中的Pos位置是否为1
%% -> true or false
%% Pos start at 0
isBitOn(Bin,Pos) ->
	Len = bit_size(Bin),
	case Len > Pos of
		true ->
			<<_Before:Pos,TheBit:1,_/bits>> = Bin,
			case TheBit of
				1 -> true;
				_ -> false
			end;
		false ->false
	end.

%% 设置Bin中的Pos位置为1
%% -> <<newBits>>
%% Pos start at 0
setBit(Bin,Pos) ->
	Len = bit_size(Bin),
	case Len > Pos of
		true ->
			<<Before:Pos,_TheBit:1,Left/bits>> = Bin,
			<<Before:Pos,1:1,Left/bits>>;
		false -> 
			NewLen = ((Pos+8) div 8) * 8, %%
			AddLen = NewLen - Len,
			NewPos = Pos - Len,
			LeftLen = AddLen - NewPos - 1,
			AddBin = <<0:NewPos,1:1,0:LeftLen>>,
			list_to_binary([Bin,AddBin])
	end.

%% 设置Bin中的Pos位置为0
%% -> <<newBits>>
%% Pos start at 0
clearBit(Bin,Pos) ->
	Len = bit_size(Bin),
	case Len > Pos of
		true ->
			<<Before:Pos,_TheBit:1,Left/bits>> = Bin,
			<<Before:Pos,0:1,Left/bits>>;
		false -> 
			Bin
	end.

