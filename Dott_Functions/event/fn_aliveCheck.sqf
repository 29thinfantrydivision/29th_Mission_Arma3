/**
 * DOTT_event_fnc_aliveCheck
 *
 * Monitors alive player counts per side and triggers game end
 * when only one side remains. Supports both permadeath (BIRD
 * respawn) and spectate-area-based death detection.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Requires:
 *     DOTT_event_fnc_game
 *     DOTT_round_fnc_isRoundActive
 *     DOTT_event_spectateArea (global, if respawn-based)
 *     DOTT_event_spectateAreaRadius (global, if respawn-based)
 */

if (!isServer) exitWith {};

scopeName "main";

/* --- Determine respawn mode --- */

private _respawnType = 0 call BIS_fnc_missionRespawnType;

// BIRD respawn means players stay dead for real.
private _remainDead = (_respawnType == 1);

waitUntil { sleep 10; call DOTT_round_fnc_isRoundActive };

/* --- Main alive-check loop --- */

while {call DOTT_round_fnc_isRoundActive} do
{
    sleep 5;

    private _allPlayers = call BIS_fnc_listPlayers;

    private _bluforPlayers = [];
    private _opforPlayers = [];
    private _resistancePlayers = [];

    {
        private _side = side group _x;
        switch (_side) do
        {
            case west:
            {
                _bluforPlayers pushBack _x;
            };
            case east:
            {
                _opforPlayers pushBack _x;
            };
            case resistance:
            {
                _resistancePlayers pushBack _x;
            };
            default {};
        };
    } forEach _allPlayers;

    private _numBluforDead = 0;
    private _numOpforDead = 0;
    private _numResistanceDead = 0;

    if (_remainDead) then
    {
        // Permadeath -- count actually dead units.
        _numBluforDead =
            {!alive _x} count _bluforPlayers;
        _numOpforDead =
            {!alive _x} count _opforPlayers;
        _numResistanceDead =
            {!alive _x} count _resistancePlayers;
    }
    else
    {
        // Respawn -- players inside spectate area count as dead.
        _numBluforDead = {
            (_x distance2D DOTT_event_spectateArea)
                < DOTT_event_spectateAreaRadius
        } count _bluforPlayers;

        _numOpforDead = {
            (_x distance2D DOTT_event_spectateArea)
                < DOTT_event_spectateAreaRadius
        } count _opforPlayers;

        _numResistanceDead = {
            (_x distance2D DOTT_event_spectateArea)
                < DOTT_event_spectateAreaRadius
        } count _resistancePlayers;
    };

    /* --- Determine which sides still have living players --- */

    private _isBluforAlive =
        (count _bluforPlayers) > _numBluforDead;
    private _isOpforAlive =
        (count _opforPlayers) > _numOpforDead;
    private _isResistanceAlive =
        (count _resistancePlayers) > _numResistanceDead;

    // All sides wiped -- skip to avoid erroneous victory on
    // mutual kills. Admin can call game manually.
    if (!_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) then
    {
        continue;
    };

    /* --- Check for a single surviving side --- */

    private _winnerSide = civilian;

    if (_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) then
    {
        _winnerSide = west;
    };
    if (!_isBluforAlive
        && _isOpforAlive
        && !_isResistanceAlive) then
    {
        _winnerSide = east;
    };
    if (!_isBluforAlive
        && !_isOpforAlive
        && _isResistanceAlive) then
    {
        _winnerSide = resistance;
    };

    if (_winnerSide != civilian) then
    {
        [true, _winnerSide] call DOTT_event_fnc_game;
        breakTo "main";
    };
};
