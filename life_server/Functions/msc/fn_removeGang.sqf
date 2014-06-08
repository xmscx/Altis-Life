/*
	File: fn_removeGang.sqf
	Author: msc
	
	Description:
	removes gang
*/
private["_uid","_name","_query","_sql","_gangPlayer"];
_name = [_this,0,"",[""]] call BIS_fnc_param;


// Stop bad data...
if(_name == "") exitWith{};

_query = format["DELETE FROM gangs WHERE gangname = '%1'",_name];
waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};

_query2 = format["DELETE FROM gang_players WHERE gangid =(SELECT id FROM gangs WHERE gangname ='%1')",_name];
waitUntil {!DB_Async_Active};
_thread = [_query2,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};