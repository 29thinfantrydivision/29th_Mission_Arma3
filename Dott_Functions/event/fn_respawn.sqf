/**
 * DOTT_event_fnc_respawn
 *
 * Tracks player deaths during a live round and teleports
 * the player to the spectate area when they exhaust their
 * limited lives. Optionally strips weapons on final respawn.
 *
 * Paramaters:
 *     _storeDeaths (bool) - When true, records the player's
 *         current death count and exits. Used at round start
 *         to baseline.
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

//client only
if (!hasInterface) exitWith {};

//exit script if the number of lives setting should
//permit unlimited respawns (just in case)
if (DOTT_event_numberOfLives isEqualTo 0) exitWith {};

//exit if the event isn't live
if !(call DOTT_round_fnc_isRoundActive) exitWith {};

//if instead deaths should be stored, record them
//locally and then exit
if (_storeDeaths) exitWith
{
    DOTT_event_liveDeaths =
        getPlayerScores Player select 4;
};

//get local players deaths
private _playerDeaths =
    getPlayerScores player select 4;

//if deaths on live is nil, make it zero to
//prevent errors
if (isNil "DOTT_event_liveDeaths") then
{
    DOTT_event_liveDeaths = 0;
};

//adjust number of deaths by the amount the player
//had on live
_playerDeaths =
    (_playerDeaths - DOTT_event_liveDeaths);

//if the number of deaths is equal to or greater
//then the number of lives
if (_playerDeaths >= DOTT_event_numberOfLives) then
{
    //teleport them to the spectate area

    //get position of spectate area
    private _point =
        getPosASL DOTT_event_spectateArea;

    //cut to black with title
    titleText [
        "<t color='#ffffff' size='4'>"
            + "Out of Lives!</t>",
        "BLACK OUT", 0.5, true, true
    ];
    player allowDamage false;
    sleep 0.2;

    //simulation and damage off to prevent
    //death/accidents during teleport

    player enableSimulationGlobal false;
    sleep 0.3;

    //set player's position to specified point (ASL)
    private _dir = random 359;
    player SetPosASL [
        (_point select 0) - 6 * sin(_dir),
        (_point select 1) - 6 * cos(_dir),
        (_point select 2)
    ];
    sleep 0.1;

    //enable simulation so they call fall if
    //above terrain
    player enableSimulationGlobal true;
    sleep 0.4;

    //check if the player is touching ground
    private _ground = isTouchingGround player;

    //if not touching ground then
    if (!_ground) then
    {
        //get current height above
        //water/terrain/objects
        private _curr = getPos player;
        private _height = _curr select 2;

        //if more then 2 meters in height set
        //height to water/terrain
        if (_height > 2) then
        {
            player setPos [
                _curr select 0,
                _curr select 1,
                0
            ];
        }
        //otherwise a little extra time to fall
        else
        {
            sleep 0.4;
        };
    };

    sleep 0.2;

    //return to normal state
    player allowDamage true;
    titleText [
        "<t color='#ffffff' size='4'>"
            + "Out of Lives!</t>",
        "BLACK IN", 0.5, true, true
    ];

    //handle weapon removal for respawning players
    //(if enabled in events)
    if (DOTT_event_respawnDisarmPlayers) then
    {
        removeAllWeapons player;
    };
};
