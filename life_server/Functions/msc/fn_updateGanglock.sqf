/*
	File: fn_removeGangPlayers.sqf
	Author: msc
	
	Description:
	removes player from gang
*/
private["_uid","_lock","_query","_sql","_gangPlayer"];
_lock = [_this,0,"",[""]] call BIS_fnc_param;
_gang = [_this,1,"",[""]] call BIS_fnc_param;



// Stop bad data...
if(_lock == "" OR _gang == "") exitWith{};

_query = format["UPDATE gangs SET locked='%1' WHERE gangname='%2' ",_lock, _gang];
waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};
