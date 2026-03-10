/**
 * DOTT_loadout_fnc_init
 *
 * Purpose: Initializes the loadout module on clients. Registers arsenal
 *          close handlers for both BI and ACE arsenals, and sets up
 *          insignia reapplication on respawn.
 *          Should be initialized after the radio module.
 *
 * Params:  None
 * Returns: Nothing
 */

if (hasInterface) then
{
    // --- BI Arsenal close handler ---
    [
        missionNamespace,
        "arsenalClosed",
        {
            // Skip if Zeus display is open (ZEN loadout editing).
            if !(isNull (findDisplay 312)) exitWith {};
            call DOTT_loadout_fnc_onArsenalClosed;
        }
    ] call BIS_fnc_addScriptedEventHandler;

    // --- ACE Arsenal close handler ---
    if (isClass (configFile >> "CfgPatches" >> "ace_main")) then
    {
        [
            "ace_arsenal_displayClosed",
            {
                if !(isNull (findDisplay 312)) exitWith {};
                call DOTT_loadout_fnc_onArsenalClosed;
            }
        ] call CBA_fnc_addEventHandler;
    };

    // --- Reapply insignia on respawn ---
    [
        "DOTT_loadout_setInsigniaRespawn",
        "Respawn",
        {(_this select 0) spawn DOTT_loadout_fnc_setInsignia}
    ] call CBA_fnc_addBISPlayerEventHandler;
};
