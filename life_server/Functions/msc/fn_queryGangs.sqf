/* 
	File: fn_queryGangs.sqf
	Author: msc
	
	Description:
	get all gangs
*/
private["_sql","_query","_name","_atmCash","_gangPlayers","_group","_leaderid","_locked","_leadername"];

_query = "SELECT gangs.gangname, gangs.atmCash, gang_players.playerid, gangs.locked, players.name FROM gangs LEFT JOIN gang_players on gang_players.gangid = gangs.id LEFT JOIN players on gang_players.playerid = players.playerid WHERE gang_players.rank='7'";
diag_log format ["query player gangs: %1", _query];
_sql = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['%2', '%1']", _query,(call LIFE_SCHEMA_NAME)];
waitUntil {typeName _sql == "STRING"};
_sql = call compile format["%1", _sql];
diag_log format ["sql : %1 (%2)", _sql, typeName _sql];

_ret = [];
	
if(count (_sql select 0) == 0) exitWith {[]};
_i = 0;
{	
	_name = (_x select 0);
	_atmCash = (_x select 1);
	_leaderid = (_x select 2);
	_locked = (_x select 3);
	_leadername = (_x select 4);
	
	diag_log format ["New Gang : %1 - %2 - %3 - %4 - %5", _name, _atmCash, _leaderid, _locked, _leadername];
	_ret set [_i, [_name, _atmCash, _leaderid, _locked, _leadername]];
	_i = _i + 1;
} forEach (_sql select 0);
_ret;