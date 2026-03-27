/*
 * Author: Bae [29th ID]
 * Waits for all module inits to finish, then either registers
 * a MEH to fire "TN_preloadFinished" later (JIP, where preload
 * hasn't finished for this client yet) or fires it immediately
 * (non-JIP, where preload is already complete).
 *
 * Consumers subscribe via:
 *     ["TN_preloadFinished", { ... }]
 *         call CBA_fnc_addEventHandler;
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_common_fnc_initPreloadFinished;
 */

["TN_initFinished",
{
    if (isNil "bis_fnc_preload_init") then
    {
        // JIP — preload hasn't finished for this client yet.
        addMissionEventHandler ["PreloadFinished",
        {
            ["TN_preloadFinished"] call CBA_fnc_localEvent;
            removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
        }];
    }
    else
    {
        // Non-JIP — preload already complete.
        ["TN_preloadFinished"] call CBA_fnc_localEvent;
    };
}] call CBA_fnc_addEventHandler;
