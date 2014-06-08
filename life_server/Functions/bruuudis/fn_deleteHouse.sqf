/*
	File: fn_deleteHouse.sqf
	Author: Mario2002
	
	Description:
	deletes a house
*/
private["_sql","_sql2","_query","_houseId","_ret","_new", "_query", "_query2"];
_houseId = [_this,0,"",[""]] call BIS_fnc_param;;
_query = format["DELETE FROM houses WHERE house_id='%1'",_houseId];

waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};