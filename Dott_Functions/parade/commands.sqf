/**
 * Module: parade commands
 * Author: Bae [29th ID]
 *
 * Description:
 *   Registers the "!parade" admin chat command. Forces all
 *   players within 125 meters of the caller into parade loadout.
 *
 * Parameters:
 *   None (self-registering)
 *
 * Returns:
 *   Nothing
 */

[
    [
        [
            "parade",
            {
                // 125m hardcoded radius around the calling player.
                [player, 125] spawn DOTT_parade_fnc_forceAll;
            }
        ]
    ],
    [
        [
            "parade",
            "Sets all players' loadout within 125m of your position to parade."
        ]
    ]
] call DOTT_commands_fnc_addModule;
