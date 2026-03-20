params ["_unit"];

private _seat = _unit getVariable ["TN_vehicle_lockedSeat", []];
_seat params ["_vehicle", "_type", "_position"];

if (_seat isEqualTo []) exitWith {};

switch (_type) do {
    case "driver": {
        _vehicle lockDriver false;
    };

    case "cargo": {
        _vehicle lockCargo [_position, false];
    };

    case "turret": {
        _vehicle lockTurret [_position, false];
    };
};

_unit setVariable ["TN_vehicle_lockedSeat", nil, true];