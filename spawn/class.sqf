#define CHECK1 if(typeName _x == "STRING")then{
#define CHECK2 if((isNil "_qty")||{typeName _qty == "STRING"})then{_qty=1;};
#define EXIT1 ,"PLAIN DOWN"];titleFadeOut 4;_go=0;};
#define GENDERC if(player isKindOf "SurvivorW2_DZ")then{_model=

classFill = {
	private ["_class","_index","_level","_uid"];
	#include "classConfig.sqf"
	disableSerialization;
	lbClear 8888;
	{
		_index = lbAdd [8888,_x select 0];
		_level = _x select 8;
		_hlevel = _x select 9;
		if (count _x > 11) then {_level = _x select 19;_hlevel = _x select 20;lbSetColor [8888,_index,[.97,.87,.35,1]];};
		if (_hlevel > 0) then {lbSetColor [8888,_index,[.38,.7,.9,1]];};
		if (_hlevel < 0) then {lbSetColor [8888,_index,[1,0,0,.8]];};
		if (_level > 0) then {lbSetColor [8888,_index,[0,1,0,.8]];};
	} forEach _publicClasses;
	_uid = getPlayerUID player;
	if (_uid in _customLoadout) then {
		{if (_uid == _x) then {_index = _forEachIndex;};} forEach _customLoadout;
		_class = _customLoadouts select _index;
		lbAdd [8888,_class select 0];
	};
};

classPick = {
	private ["_class","_go","_humanity","_level","_text","_uid"];
	#include "classConfig.sqf"
	disableSerialization;
	_go = 1;
	_text = lbText [8888,(lbCurSel 8888)];
	{if (_text == (_x select 0)) then {_class = _x;};} forEach _publicClasses+_customLoadouts;
	if (isNil "_class") exitWith {titleText ["Select a class!" EXIT1
	if (count _class > 8) then {
		_level = _class select 8;
		_hlevel = _class select 9;
		if (count _class > 11) then {_level = _class select 19;_hlevel = _class select 20;};
		_humanity = player getVariable ["humanity",0];
		_uid = getPlayerUID player;
		if ((_hlevel < 0) && {_humanity >= _hlevel}) exitWith {titleText [format["Your humanity must be less than %1 for this class.",_hlevel] EXIT1
		if ((_hlevel > 0) && {_humanity <= _hlevel}) exitWith {titleText [format["Your humanity must be greater than %1 for this class.",_hlevel] EXIT1
		if (_level == 1) then {if !(_uid in _classLevel1) exitWith {titleText ["This class is level 1 VIP only." EXIT1};
		if (_level == 2) then {if !(_uid in _classLevel2) exitWith {titleText ["This class is level 2 VIP only." EXIT1};
		if (_level == 3) then {if !(_uid in _classLevel3) exitWith {titleText ["This class is level 3 VIP only." EXIT1};
	};
	if (_go == 1) then {uiNamespace setVariable ["classChoice",_class];};
};

classPreview = {
	private ["_class","_dir","_model","_muzzle","_pos","_text","_unit","_wep"];
	#include "classConfig.sqf"
	{if !(_x isKindOf "Survivor1_DZ") then {deleteVehicle _x;};} count (player nearEntities ["Man",100]);
	disableSerialization;
	_text = lbText [8888,(lbCurSel 8888)];
	{if (_text == (_x select 0)) then {_class = _x;};} forEach _publicClasses+_customLoadouts;
	if (isNil "_class") then {_class = _publicClasses select 0;};
	_model = _class select 1;
	_weps = _class select 4;
	GENDERC _class select 2;};
	if (count _class > 11) then {
		_model = _model select 0;
		GENDERC (_class select 1) select 1;};
		_model = _model call BIS_fnc_selectRandom;
		_weps = _class select 6;
		if (count _weps > 0) then {_weps = [(_weps call BIS_fnc_selectRandom)];};
	};
	_dir = getDir player;
	_pos = getPosATL player;
	if (surfaceIsWater _pos) then {_pos = getPosASL player;};
	//_pos = [(_pos select 0)+3*sin(_dir),(_pos select 1)+3*cos(_dir),0];
	_unit = _model createVehicleLocal _pos;
	{_unit addWeapon _x;_qty=1;} count _weps+_startWeps;
	_wep = primaryWeapon _unit;
	if (_wep == "") then {deleteVehicle _unit;_unit = createAgent [_model,_pos,[],0,"CAN_COLLIDE"];};
	//if (surfaceIsWater _pos) then {_unit attachTo [player,[.34,3.5,1.1]];} else {_unit attachTo [player,[.34,3.5,0]];}; //.4,4,1.1 good
	_unit attachTo [player,[.34,2.25,.91]];
	_unit setDir (_dir + 180);
	_unit enableSimulation false;
	//player playMove "";
	///player playActionNow "stop";
};

private ["_class","_date","_mags","_model","_muzzle","_myModel","_pistol","_pistols","_pistolAmmo","_qty","_tool","_tools","_wep","_weps"];
#include "classConfig.sqf"
uiNamespace setVariable ["classChoice",[]];

if !(_isPZombie) then {
	removeAllWeapons player;
	removeAllItems player;
	removeBackpack player;
	_date = date;
	setDate [date select 0,date select 1,date select 2,12,0];
	while {count (uiNamespace getVariable "classChoice") == 0} do {
		_nearNow = call _inDebug;
		_nearFinal = _nearFinal + _nearNow;
		if (!dialog) then {_i="createDialog";createDialog "ClassDialog";call classFill;call classPreview;player switchMove "";};
		uiSleep 1;
	};
	closeDialog 0;
	setDate _date;
	{if !(_x isKindOf "Survivor1_DZ") then {deleteVehicle _x;};} count (player nearEntities ["Man",100]);

	_class = uiNamespace getVariable "classChoice";
	_myModel = typeOf player;
	_model = _class select 1;
	GENDERC _class select 2;};
	_mags = _class select 3;
	_weps = _class select 4;
	_bag = _class select 5;
	_bmags = _class select 6;
	_bweps = _class select 7;
	
	if (count _class > 11) then {
		_model = _model select 0;
		GENDERC (_class select 1) select 1;};
		_model = _model call BIS_fnc_selectRandom;
		_tools = _class select 4;
		_weps = _class select 6;
		_pistol = _class select 8;
		_bag = (_class select 10) call BIS_fnc_selectRandom;
		_btools = _class select 13;
		_bweps = _class select 15;
		_bpistol = _class select 17;
		if (count _weps > 0) then {_weps = [(_weps call BIS_fnc_selectRandom)];};
		if (count _pistol > 0) then {_pistol = [(_pistol call BIS_fnc_selectRandom)];};
		if (count _bweps > 0) then {_bweps = [(_bweps call BIS_fnc_selectRandom)];};
		if (count _bpistol > 0) then {_bpistol = [(_bpistol call BIS_fnc_selectRandom)];};
		if (count _tools > 0) then {_tools = [];while {count _tools < (_class select 5)} do {_tool = (_class select 4) call BIS_fnc_selectRandom;if !(_tool in _tools) then {_tools set [count _tools,_tool];};};};
		if (count _btools > 0) then {_btools = [];while {count _btools < (_class select 14)} do {_tool = (_class select 13) call BIS_fnc_selectRandom;if !(_tool in _btools) then {_btools set [count _btools,_tool];};};};
		_magFill = {
			private ["_a","_class","_index","_mag","_qty","_ret"];
			_a = _this select 0;
			_class = _this select 1;
			_index = _this select 2;
			_ret = [];
			if (count _a > 0) then {
				if (count _this < 4) then {
					_mag = [];
					_mag = getArray (configFile >> "cfgWeapons" >> (_a select 0) >> "magazines");
					if (count _mag > 0) then {for "_i" from 1 to (_class select _index) do {_ret set [count _ret,(_mag select 0)];};};
				} else {
					while {({typeName _x == "STRING"} count _ret) < (_class select (_this select 3))} do {
						_index = _a call BIS_fnc_randomIndex;
						_mag = _a select _index;
						if (typeName _mag == "STRING") then {
							if !(_mag in _ret) then {
								_ret set [count _ret,_mag];
								_qty = _a select (_index+1);CHECK2
								_ret set [count _ret,_qty];
							};
						};
					};
				};
			};
			_ret
		};
		_bmags = [(_class select 11),_class,11,12] call _magFill;
		_bmags2 = [_bweps,_class,16] call _magFill;
		_bmags3 = [_bpistol,_class,18] call _magFill;
		_mags = [(_class select 2),_class,2,3] call _magFill;
		_mags2 = [_weps,_class,7] call _magFill;
		_mags3 = [_pistol,_class,9] call _magFill;
		_mags = _mags+_mags2+_mags3;
		_bmags = _bmags+_bmags2+_bmags3;
		_bweps = _bweps+_btools+_bpistol;
		_weps = _weps+_pistol+_tools;
	};

	if (_model != _myModel) then {
		[dayz_playerUID,dayz_characterID,_model] spawn player_humanityMorph;
		waitUntil {typeOf player != _myModel};
		uiSleep 1;
	};
	
	player attachTo [_holder,[0,0,0]];
	removeAllWeapons player;
	removeAllItems player;
	removeBackpack player;
	
	{CHECK1 _qty = (_startMags select (_forEachIndex+1));CHECK2 for "_i" from 1 to _qty do {player addMagazine _x;_qty=1;};};} forEach _startMags;
	{player addWeapon _x;_qty=1;} count _startWeps;
	
	_hasBinoc = 0;
	_hasPistol = 0;
	_hasPistolAmmo = 0;
	_binoc = ["Binocular","Binocular_Vector"];
	_pistols = [
		"Colt1911","glock17_EP1","M9","M9SD","Makarov","MakarovSD","revolver_EP1","revolver_gold_EP1","UZI_EP1","UZI_SD_EP1","Sa61_EP1",
		"DDOPP_X26","RH_Deagleg","RH_Deaglem","RH_Deagles","RH_Deaglemz","RH_Deaglemzb","RH_deagle","RH_anac","RH_anacg","RH_bull","RH_python",
		"RH_browninghp","RH_p226","RH_p226s","RH_p38","RH_ppk","RH_mk22","RH_mk22sd","RH_mk22v","RH_mk22vsd","RH_usp","RH_uspm","RH_uspsd","RH_m1911",
		"RH_m1911old","RH_m1911sd","RH_tt33","RH_mk2","RH_m9","RH_m93r","RH_m9c","RH_m9csd","RH_m9sd","RH_muzi"
	];
	_pistolAmmo = [
		"15Rnd_9x19_M9","15Rnd_9x19_M9SD","17Rnd_9x19_glock17","20Rnd_B_765x17_Ball","30Rnd_9x19_UZI","30Rnd_9x19_UZI_SD","6Rnd_45ACP","7Rnd_45ACP_1911","8Rnd_9x18_Makarov","8Rnd_9x18_MakarovSD",
		"DDOPP_1Rnd_X26","RH_7Rnd_50_AE","RH_6Rnd_44_Mag","RH_6Rnd_357_Mag","RH_15Rnd_9x19_usp","RH_15Rnd_9x19_uspsd","RH_8Rnd_9x19_P38","RH_8Rnd_9x19_Mk","RH_8Rnd_9x19_Mksd","RH_8Rnd_45cal_m1911",
		"RH_32Rnd_9x19_Muzi","RH_13Rnd_9x19_bhp","RH_7Rnd_32cal_ppk","RH_12Rnd_45cal_usp","RH_8Rnd_762_tt33","RH_10Rnd_22LR_mk2","RH_20Rnd_9x19_M93","RH_19Rnd_9x19_g18","RH_17Rnd_9x19_g17",
		"RH_17Rnd_9x19_g17SD","RH_20Rnd_32cal_vz61","RH_30Rnd_9x19_tec","vil_bhp_mag","vil_usp45_mag","vil_usp45sd_mag","vil_32Rnd_uzi","vil_32Rnd_UZI_SD"
	];
	{
		if (_x in _binoc) then {_hasBinoc = 1;};
		if (_x in _pistols) then {_hasPistol = 1;};
		if (_x in _pistolAmmo) then {_hasPistolAmmo = 1;};
	} count _weps+_mags;
	if (_hasBinoc == 1) then {{player removeWeapon _x;} count _binoc;};	
	if (_hasPistol == 1) then {{player removeWeapon _x;} count _pistols;};
	if (_hasPistolAmmo == 1) then {{player removeMagazines _x;} count _pistolAmmo;};

	{CHECK1 _qty = (_mags select (_forEachIndex+1));CHECK2 for "_i" from 1 to _qty do {player addMagazine _x;_qty=1;};};} forEach _mags;
	{player addWeapon _x;_qty=1;} count _weps;
	
	if (_bag != "") then {player addBackpack _bag};
	_bag = unitBackpack player;
	if (isNull _bag) then {if (_startBag != "") then {player addBackpack _startBag;};};
	_bag = unitBackpack player;
	if (!isNull _bag) then {
		{CHECK1 _qty = (_bmags select (_forEachIndex+1));CHECK2 _bag addMagazineCargoGlobal [_x,_qty];_qty=1;};} forEach _bmags;
		{CHECK1 _qty = (_bweps select (_forEachIndex+1));CHECK2 _bag addWeaponCargoGlobal [_x,_qty];_qty=1;};} forEach _bweps;
	};

	_wep = primaryWeapon player;
	if (_wep != "") then {
		_muzzle = getArray(configFile >> "cfgWeapons" >> _wep >> "muzzles");
		if (count _muzzle > 1) then {player selectWeapon (_muzzle select 0);} else {player selectWeapon _wep;};
		reload player;
	};
};

classFill=nil;classPick=nil;classPreview=nil;