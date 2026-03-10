/**
 * DOTT_ocap_fnc_startRecording
 *
 * Purpose:
 *   Starts or resumes OCAP recording. If a recording is already
 *   well underway (>10 frames), it logs a warning and exits.
 *   Otherwise it sets the recording flag, kicks off the capture
 *   loop if needed, and updates timestamps.
 *   Modified from OCAP 2 Addon for this mission's round system.
 *
 * Parameter(s): None
 * Returns: Nothing
 */

#define OCAPEXTLOG(_args) \
    [":LOG:", _args] call ocap_extension_fnc_sendData

if (!ocap_enabled) exitWith {};

// Already recording with meaningful data captured.
if (ocap_recorder_recording
    && ocap_recorder_captureFrameNo > 10) exitWith
{
    OCAPEXTLOG(
        ["OCAP was asked to record and is already recording!"]);

    [
        ["OCAP was asked to record", 1, [1, 1, 1, 1]],
        ["and is already recording", 1, [1, 1, 1, 1]]
    ] remoteExecCall
        ["CBA_fnc_notify", [0, -2] select isDedicated];
};

ocap_recorder_recording = true;
publicVariable "ocap_recorder_recording";

if (ocap_recorder_captureFrameNo == 0) then
{
    call ocap_recorder_fnc_captureLoop;
};

[] call ocap_recorder_fnc_updateTime;
