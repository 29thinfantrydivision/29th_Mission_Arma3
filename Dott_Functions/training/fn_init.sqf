/**
 * Function: DOTT_training_fnc_init
 * Author: Bae [29th ID]
 *
 * Description:
 *     Initializes the training variation of the mission template.
 *     Sets up curator whitelisting, arsenal zone centers, base
 *     map markers, default loadouts, weather, and disconnect
 *     body cleanup. Should be called after round initialization.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 */

// Curator whitelist — controls who can access the Zeus
// module. All entries must be lowercase to match engine
// UID/slot lookups.
DOTT_curator_units =
[
    "#adminlogged",
    "blu_reg_o_1", "blu_reg_o_2",
    "blu_reg_snco_1", "blu_reg_snco_2",
    "blu_chq_co", "blu_chq_xo", "blu_chq_cs", "blu_chq_snco",
    "blu_plt1_pl", "blu_plt1_ps1", "blu_plt1_ps2",
    "blu_plt2_pl", "blu_plt2_ps1", "blu_plt2_ps2",
    "red_plt", "red_plt_1", "red_plt_2",
    "grn_plt", "grn_plt_1", "grn_plt_2"
];

// Center the arsenal zone between the respawn point and
// arsenal box so the radius check covers the full base area
// rather than being anchored to either edge.
private _findCenterObjs =
[
    [base_res_red, base_action_arsenal_red],
    [base_res_blu, base_action_arsenal_blu],
    [base_res_grn, base_action_arsenal_grn]
];
DOTT_arsenal_centers = [];

{
    private _respawnPos = getPosASL (_x select 0);
    private _arsenalPos = getPosASL (_x select 1);

    private _centerPos =
    [
        (_respawnPos#0 + _arsenalPos#0) / 2,
        (_respawnPos#1 + _arsenalPos#1) / 2,
        (_respawnPos#2 + _arsenalPos#2) / 2
    ];
    DOTT_arsenal_centers pushBack _centerPos;
} forEach _findCenterObjs;

if (hasInterface) then
{
    // Draw base location icons on the curator map
    DOTT_training_curatorBaseLogic = objNull;

    ["DOTT_enteredZeus",
    {
        // Re-run if the curator module changes (e.g. admin swap)
        if (DOTT_training_curatorBaseLogic
            isEqualTo getAssignedCuratorLogic player)
        exitWith {};

        DOTT_training_curatorBaseLogic =
            getAssignedCuratorLogic player;

        private _locationColors =
        [
            [1, 0, 0, 0.5],
            [0.5, 0.7, 1.0, 0.5],
            [0, 1, 0, 0.5]
        ];

        {
            [
                DOTT_training_curatorBaseLogic,
                [
                    "\A3\ui_f\data\map\markers\nato\b_unknown.paa",
                    _locationColors select _forEachIndex,
                    ASLtoAGL _x,
                    1,
                    1,
                    0,
                    "",
                    2,
                    0.05
                ],
                true,
                true
            ] call bis_fnc_addcuratoricon;
        } forEach DOTT_arsenal_centers;
    }
    ] call CBA_fnc_addEventHandler;

    [] spawn DOTT_training_fnc_initDefaultLoadouts;
};

if (isServer) then
{
    INDEPENDENT setFriend [WEST, 0];

    // Default date and weather
    private _forcedDate = [2018, 3, 30, 12, 0];
    private _forcedOvercast = 0.1;
    private _forcedFog = [0.1, 0.01, 0];
    [_forcedDate, _forcedOvercast, _forcedFog]
        call DOTT_training_fnc_initDateAndWeather;

    // Delete disconnecting player bodies inside base zones.
    // 75m radius is intentionally generous — it needs to cover
    // the entire base footprint (respawn + arsenal + staging)
    // so corpses don't litter the spawn area.
    addMissionEventHandler ["HandleDisconnect",
    {
        params ["_unit"];

        if (isNull _unit) exitWith {};

        private _pos = getPosASL _unit;

        {
            if (_pos distance _x < 75) exitWith
            {
                deleteVehicle _unit;
            };
        }
        forEach DOTT_arsenal_centers;

        // Must return false — returning true would make the
        // disconnected unit AI-controlled instead of removing it.
        false
    }];
};
