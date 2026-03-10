/**
 * Include: fn_fixVehicleRadio.inc.sqf
 * Author:  Bae [29th ID]
 *
 * Description:
 *   Inline include that fixes a TFAR bug where entering an
 *   unoccupied vehicle with a different-faction LR backpack
 *   causes the vehicle radio to inherit the wrong side's
 *   encryption. Optionally forces the vehicle LR to match
 *   the player's side when TN_forceSideLRVic is enabled.
 *
 *   Included by fn_initTransferSettings.sqf and
 *   XEH_preInit.sqf (setting change callback).
 *
 * Parameters:
 *   None (operates on player context)
 *
 * Returns:
 *   Nothing
 */

private _radios = player call TFAR_fnc_vehicleLr;
if (isNil "_radios") exitWith {};

private _vehicle = _radios select 0;

// Determine which side's encryption to use.
private _correctSide = switch (TN_forceSideLRVic) do
{
    case true:  { side group player };
    case false: { _vehicle call TFAR_fnc_getVehicleSide };
};

private _encryptionCode = "";
switch (_correctSide) do
{
    case west:
    {
        _encryptionCode = "tf_west_radio_code";
    };
    case east:
    {
        _encryptionCode = "tf_east_radio_code";
    };
    default
    {
        _encryptionCode = "tf_independent_radio_code";
    };
};

_encryptionCode = missionNamespace getVariable [
    _encryptionCode, ""
];

[_radios, _encryptionCode] call TFAR_fnc_setLrRadioCode;
