/*
	File: fn_removeGangPlayers.sqf
	Author: msc
	
	Description:
	removes player from gang
*/
private["_uid","_query","_sql","_gangPlayer"];
_gangPlayer = [_this,0,"",[""]] call BIS_fnc_param;

// Stop bad data...
if(_gangPlayer == "") exitWith{};

_query = format["DELETE FROM gang_players WHERE playerid = '%1'",_gangPlayer];
waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};