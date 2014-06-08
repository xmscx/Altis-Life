/*
	File: fn_removeGangPlayers.sqf
	Author: msc
	
	Description:
	removes player from gang
*/
private["_uid","_newleader","_query","_sql","_gangPlayer"];
_newleader = [_this,0,"",[""]] call BIS_fnc_param;
_gang = [_this,1,"",[""]] call BIS_fnc_param;


// Stop bad data...
if(_newleader == "" OR _gang == "") exitWith{};

_query = format["UPDATE gang_players SET rank='1' WHERE gangid=(SELECT id FROM gangs WHERE gangname='%1')", _gang];

_query2 = format["UPDATE gang_players SET rank='7' WHERE playerid='%1' ",_newleader];

waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};

waitUntil {!DB_Async_Active};
_thread = [_query2,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};