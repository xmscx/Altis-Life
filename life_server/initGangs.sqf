/*
	File: initGangs.sqf
	Author: msc
	
	Description:
	init
*/
private["_allGangs","_name","_gangPlayers","_atmCash","_leaderid","_locked","_groupid","_group"];
diag_log "INIT GANGS";
life_gang_list = [];
_allGangs = [] call MSC_fnc_queryGangs;
// Create all Groups for Gangs
// diag_log format ["ALL Gangs : %1 (%2)", _allGangs, typeName _allHouses];
if (isNil "_allGangs") then {
	diag_log "No Gangs in Database";
}
else
{
	{
		_name = (_x select 0);
		_atmCash = (_x select 1);
		_leaderid = (_x select 2);
		_locked =  [parseNumber(_x select 3), 1] call DB_fnc_bool;
		_leadername = (_x select 4);
		_group = objNull;
		life_gang_list set[count life_gang_list,[_name, _group, _locked, "", _leaderid]];
		diag_log format ["Created Gang Group - %1 - %2 - %3 - %4", _name, _locked, _leadername, _leaderid];
	}forEach _allGangs;
};
publicVariable "life_gang_list";

diag_log "GANGS INITIATED";
