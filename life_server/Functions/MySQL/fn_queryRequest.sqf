/*
	File: fn_queryRequest.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Handles the incoming request and sends an asynchronous query 
	request to the database.
	
	Return:
	ARRAY - If array has 0 elements it should be handled as an error in client-side files.
	STRING - The request had invalid handles or an unknown error and is logged to the RPT.
*/
private["_uid","_side","_query","_return","_queryResult","_qResult","_handler","_thread","_handlerhousing","_queryHousingResult"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_ownerID = [_this,2,ObjNull,[ObjNull]] call BIS_fnc_param;

if(isNull _ownerID) exitWith {};
_ownerID = owner _ownerID;
//if(_uid == "" || _side == sideUnknown) exitWith {"The UID or side passed had invalid inputs."};

_handler = {
	private["_thread"];
	_thread = [_this select 0,true,_this select 1] spawn DB_fnc_asyncCall;
	waitUntil {scriptDone _thread};
};

//compile our query request
_query = switch(_side) do {
	case west: {format["SELECT playerid, name, cash, bankacc, adminlevel, donatorlvl, cop_licenses, coplevel, cop_gear, blacklist FROM players WHERE playerid='%1'",_uid];};
	case civilian: {format["SELECT playerid, name, cash, bankacc, adminlevel, donatorlvl, civ_licenses, arrested, civ_gear FROM players WHERE playerid='%1'",_uid];};
	case independent: {format["SELECT playerid, name, cash, bankacc, adminlevel, donatorlvl, med_licenses, mediclevel FROM players WHERE playerid='%1'",_uid];};
};

waitUntil{!DB_Async_Active};

while {true} do {
	_thread = [_query,_uid] spawn _handler;
	waitUntil {scriptDone _thread};
	sleep 0.2;
	_queryResult = missionNamespace getVariable format["QUERY_%1",_uid];
	if(!isNil "_queryResult") exitWith {};
};

missionNamespace setVariable[format["QUERY_%1",_uid],nil]; //Unset the variable.

if(typeName _queryResult == "STRING") exitWith {
	[[],"SOCK_fnc_insertPlayerInfo",_ownerID,false,true] spawn life_fnc_MP;
};


//Parse licenses (Always index 6)
_new = [(_queryResult select 6)] call DB_fnc_mresToArray;
if(typeName _new == "STRING") then {_new = call compile format["%1", _new];};
_queryResult set[6,_new];

//Convert tinyint to boolean
_old = _queryResult select 6;
for "_i" from 0 to (count _old)-1 do
{
	_data = _old select _i;
	_old set[_i,[_data select 0, ([_data select 1,1] call DB_fnc_bool)]];
};

_queryResult set[6,_old];

//Parse data for specific side.
switch (_side) do {
	case west: {
		_new = [(_queryResult select 8)] call DB_fnc_mresToArray;
		if(typeName _new == "STRING") then {_new = call compile format["%1", _new];};
		_queryResult set[8,_new];
	};
	
	case civilian: {
		_new = [(_queryResult select 8)] call DB_fnc_mresToArray;
		if(typeName _new == "STRING") then {_new = call compile format["%1", _new];};
		_queryResult set[8,_new];
	};
};

_ret = [];
_queryGangResult = [];
switch (_side) do {
	case civilian: {
		//compile our query request
		_query = format["SELECT houses.position, houses.storage, houses.weapon_storage FROM houses WHERE pid='%1'",_uid];
		waitUntil{!DB_Async_Active};

		_handlerhousing = {
			private["_thread"];
			_thread = [_this select 0,true,_this select 1,false] spawn DB_fnc_asyncCall;
			waitUntil {scriptDone _thread};
		};
		
		while {true} do {
			_thread = [_query,_uid] spawn _handlerhousing;
			waitUntil {scriptDone _thread};
			sleep 0.2;
			_queryHousingResult = missionNamespace getVariable format["QUERY_%1", _uid];
			if(!isNil "_queryHousingResult") exitWith {};
		};
		missionNamespace setVariable[format["QUERY_%1",_uid],nil];
		if(typeName _queryHousingResult == "ARRAY") then {
			
			// Parse Housing Data:
			_i = 0;
			{	
				_new = [(_x select 0)] call DB_fnc_mresToArray;
				if(typeName _new == "STRING") then {_new = call compile format["%1", _new];};
				//diag_log format ["pos : %1 (%2)", _new, typeName _new];
				
				_storage = [(_x select 1)] call DB_fnc_mresToArray;
				if(typeName _storage == "STRING") then {_storage = call compile format["%1", _storage];};
				//diag_log format ["storage : %1 (%2)", _storage, typeName _storage];
				
				_weaponStorage = [(_x select 2)] call DB_fnc_mresToArray;
				if(typeName _weaponStorage == "STRING") then {_weaponStorage = call compile format["%1", _weaponStorage];};
				//diag_log format ["_weaponStorage : %1 (%2)", _weaponStorage, typeName _weaponStorage];
					
				_ret set[_i, [_new,_storage, _weaponStorage]];
				//_ret set[_i, _new];
				_i = _i + 1;
			}forEach (_queryHousingResult);
		};
		_queryResult set[9, _ret];
	};
};

//* diag_log format["got Player Housing Information: Return: %1",_ret];
//* diag_log format["Returning Player Information: %1", _queryResult];
[_queryResult,"SOCK_fnc_requestReceived",_ownerID,false] spawn life_fnc_MP;