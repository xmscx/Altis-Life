/*
	File: fn_insertGangPlayers.sqf
	Author: msc
	
	Description:
	inserts player in gang
*/
private["_uid","_name","_query","_sql","_gangPlayer"];
_gangPlayer = [_this,0,"",[""]] call BIS_fnc_param;
_name = [_this,1,"",[""]] call BIS_fnc_param;


// Stop bad data...
if(_name == "" OR _gangPlayer == "") exitWith{};

_query = format["INSERT INTO gang_players (gangid, playerid) VALUES ((SELECT id FROM gangs WHERE gangname='%2'),'%1')",_gangPlayer, _name];
waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};
diag_log format ["query : %1", _query];
