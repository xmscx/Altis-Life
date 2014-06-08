/*
	File: fn_updateHouseWeaponStorage.sqf
	Author: Mario2002
	
	Description:
	updates the house weapon storage
*/
private["_sql","_query","_data","_house","_houseId"];
_house = [_this,0] call BIS_fnc_param;
_container = [_this,1] call BIS_fnc_param;
_data = [_this,2] call BIS_fnc_param;
_side = civilian;


_houseId = [_house] call life_fnc_getBuildID;
_data = [_data] call DB_fnc_mresArray;
//diag_log format ["data: %1", _data];
switch (_side) do
{	
	case civilian:
	{
		switch (_container) do
		{
			case "Land_Box_AmmoOld_F":
			{
				_query = format["UPDATE houses SET weapon_storage2='%1' WHERE house_id = '%2'", _data, _houseId];
			};
			case "B_supplyCrate_F":
			{
				_query = format["UPDATE houses SET weapon_storage='%1' WHERE house_id = '%2'", _data, _houseId];
			};
		};
		//diag_log format ["query: %1 - Container: %2", _query,_container];
	};
};
waitUntil {!DB_Async_Active};
_thread = [_query,false] spawn DB_fnc_asyncCall;
waitUntil {scriptDone _thread};