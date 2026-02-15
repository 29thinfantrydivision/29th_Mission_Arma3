params ["_player"];

if (DOTT_curator_units find (vehicleVarName _player) == -1) exitWith {};

if !(isServer) exitWith {_this remoteExec ["DOTT_curator_fnc_createCuratorModule", 2]};

waitUntil { !isNil "DOTT_curator_group" && time > 0 };

isNil {
    private _curatorModuleName = format ["DOTT_curator_zeus_%1", vehicleVarName _player];

    if !(isNil _curatorModuleName) then 
    {
        deleteVehicle _curatorModuleName;
        missionNamespace setVariable [_curatorModuleName, nil];
    };


    private _logic = DOTT_curator_group createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];
    missionNamespace setVariable [_curatorModuleName, _logic];
    _logic setVariable ["owner", vehicleVarName _player, true];
    _logic setVariable ["name", roleDescription _player, true];    
    _logic setVariable ["Addons", 3, true];
    _logic setVariable ["BIS_fnc_initModules_disableAutoActivation", false];
    _logic setVariable ["isCuratorExcluded", true, false];
};