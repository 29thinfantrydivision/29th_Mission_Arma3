/**
 * Function: DOTT_parade_fnc_handleInitialInventory
 * Author:   Hill [29th ID]
 *
 * Description:
 *   Ensures a joining player receives the correct parade loadout
 *   on their first spawn. BLUFOR uses fn_load (which supports
 *   custom "Forced Parade" loadouts); OPFOR and INDEPENDENT use
 *   their respective CfgRespawnInventory configs directly.
 *
 *   Handles both JIP (via PreloadFinished event) and non-JIP
 *   (immediate call) cases.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   Nothing
 */

if (!hasInterface) exitWith {};

private _fn_loadParade =
{
    private _side = side (group player);

    switch (_side) do
    {
        case WEST:
        {
            call DOTT_parade_fnc_load;
        };
        case EAST:
        {
            [
                player,
                missionConfigFile
                    >> "CfgRespawnInventory"
                    >> "29TH_PARADE_EAST"
            ] call BIS_fnc_loadInventory;
        };
        case INDEPENDENT:
        {
            [
                player,
                missionConfigFile
                    >> "CfgRespawnInventory"
                    >> "29TH_PARADE_INDEPENDENT"
            ] call BIS_fnc_loadInventory;
        };
        default {};
    };
};

// JIP players need to wait for preload before applying loadout.
if (isNil "bis_fnc_preload_init") then
{
    addMissionEventHandler
    [
        "PreloadFinished",
        {
            call (_thisArgs select 0);
            removeMissionEventHandler [
                "PreloadFinished", _thisEventHandler
            ];
        },
        [_fn_loadParade]
    ];
}
else
{
    call _fn_loadParade;
};
