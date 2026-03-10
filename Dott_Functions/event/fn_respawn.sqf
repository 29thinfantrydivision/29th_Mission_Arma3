/**
 * DOTT_event_fnc_respawn
 *
 * Tracks player deaths during a live round and teleports
 * the player to the spectate area when they exhaust their
 * limited lives. Optionally strips weapons on final respawn.
 *
 * Parameters:
 *     _storeDeaths (bool) - When true, records the player's
 *                           current death count and exits.
 *                           Used at round start to baseline.
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     DOTT_event_numberOfLives (global)
 *     DOTT_event_spectateArea (global object)
 *     DOTT_event_liveDeaths (global, set at round start)
 *     DOTT_event_respawnDisarmPlayers (global bool)
 *     DOTT_round_fnc_isRoundActive
 */

params
[
    ["_storeDeaths", false, [false]]
];

if (!hasInterface) exitWith {};

if (DOTT_event_numberOfLives isEqualTo 0) exitWith {};

if !(call DOTT_round_fnc_isRoundActive) exitWith {};

/* --- Baseline death snapshot (called once at round start) --- */

if (_storeDeaths) exitWith
{
    DOTT_event_liveDeaths =
        getPlayerScores player select 4;
};

/* --- Count deaths since round went live --- */

private _playerDeaths =
    getPlayerScores player select 4;

if (isNil "DOTT_event_liveDeaths") then
{
    DOTT_event_liveDeaths = 0;
};

_playerDeaths =
    _playerDeaths - DOTT_event_liveDeaths;

/* --- Out of lives: teleport to spectate area --- */

if (_playerDeaths >= DOTT_event_numberOfLives) then
{
    private _point = getPosASL DOTT_event_spectateArea;

    titleText [
        "<t color='#ffffff' size='4'>Out of Lives!</t>",
        "BLACK OUT", 0.5, true, true
    ];
    player allowDamage false;

    // Brief pause so the screen fade completes.
    sleep 0.2;

    // Freeze simulation to prevent death during teleport.
    player enableSimulationGlobal false;
    sleep 0.3;

    // Place player in a circle 6m from the spectate point.
    private _dir = random 360;
    player setPosASL [
        (_point select 0) - 6 * sin(_dir),
        (_point select 1) - 6 * cos(_dir),
        (_point select 2)
    ];

    // Re-enable simulation so physics can settle.
    sleep 0.1;
    player enableSimulationGlobal true;

    // Allow time to land on terrain.
    sleep 0.4;

    private _ground = isTouchingGround player;

    if (!_ground) then
    {
        private _curr = getPos player;
        private _height = _curr select 2;

        if (_height > 2) then
        {
            // More than 2m up -- snap to ground.
            player setPos [
                _curr select 0,
                _curr select 1,
                0
            ];
        }
        else
        {
            // Low enough to fall naturally.
            sleep 0.4;
        };
    };

    // Final settle before restoring damage.
    sleep 0.2;

    player allowDamage true;
    titleText [
        "<t color='#ffffff' size='4'>Out of Lives!</t>",
        "BLACK IN", 0.5, true, true
    ];

    if (DOTT_event_respawnDisarmPlayers) then
    {
        removeAllWeapons player;
    };
};
