/*
	File: fn_insertGang.sqf
	Author: msc
	
	Description:
	inserts a gang into the database
*/
private["_uid","_name","_query","_sql","_leaderid","_atmcash"];
_name = [_this,0,"",[""]] call BIS_fnc_param;
_leaderid = [_this,1,"",[""]] call BIS_fnc_param;
_locked = 0;


_atmcash = 0;
// Stop bad data...
if(_name == "" OR _leaderid == "") exitWith{diag_log format["Some nulls here: %1 %2",_name,_leaderid];};
diag_log "creating new gang in database";
_query = format["INSERT INTO gangs (gangname, atmcash, locked) VALUES ('%1','0','%2')",_name, _locked];
waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};

_query2 = format["INSERT INTO gang_players (gangid, playerid, rank) VALUES ((SELECT id FROM gangs WHERE gangname='%1'),'%2', '7')",_name, _leaderid];
waitUntil {!DB_Async_Active};
_thread = [_query2,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};
