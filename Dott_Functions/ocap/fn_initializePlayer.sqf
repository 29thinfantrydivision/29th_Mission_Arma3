/**
 * DOTT_ocap_fnc_initializePlayer
 *
 * Purpose:
 *   Registers a player unit with the OCAP recording system by
 *   assigning an ID, sending unit data to the extension, and
 *   attaching event handlers. Skips if a recording is already
 *   running (the capture loop handles it instead).
 *
 * Parameter(s):
 *   0: OBJECT - Player unit to initialize
 *
 * Returns: Nothing
 */

#define BOOL(_cond) ([0, 1] select (_cond))

// If recording is active and has a valid start time, the
// natural capture loop will handle initialization instead.
if (((missionNamespace getVariable
    ["ocap_recorder_recording", false])
    && missionNamespace getVariable
    ["ocap_recorder_startTime", -1] > -1)) exitWith {};

params ["_player"];

if !(_player getVariable
    ["ocap_isInitialized", false]) then
{
    _player setVariable ["ocap_id", ocap_recorder_nextId];

    [":NEW:UNIT:", [
        ocap_recorder_captureFrameNo,
        ocap_recorder_nextId,
        name _player,
        groupID (group _player),
        str side group _player,
        BOOL(isPlayer _player),
        roleDescription _player
    ]] call ocap_extension_fnc_sendData;

    [_player] spawn ocap_recorder_addUnitEventHandlers;

    ocap_recorder_nextId = ocap_recorder_nextId + 1;

    _player setVariable
        ["ocap_isInitialized", true, true];
};
