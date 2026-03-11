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

if (!isServer) exitWith {}; //server only

scopeName "main";

/************************/

//get missions respawn type
private _respawnType =
    0 call BIS_fnc_missionRespawnType;
//true if respawn type is BIRD
//(I.E. players remain dead)
private _remainDead = (_respawnType == 1);

//wait until server is told event is live
waitUntil {
    sleep 10;
    call DOTT_round_fnc_isRoundActive
};


while {call DOTT_round_fnc_isRoundActive} do
{
    sleep 5;

    private _allPlayers =
        call BIS_fnc_listPlayers;

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
        };
    } forEach _allPlayers;

    private _numBluforDead = 0;
    private _numOpforDead = 0;
    private _numResistanceDead = 0;

    //if players remain dead, check who is
    //actually alive
    if (_remainDead) then
    {
        _numBluforDead =
            { !alive _x } count _bluforPlayers;
        _numOpforDead =
            { !alive _x } count _opforPlayers;
        _numResistanceDead =
            { !alive _x } count _resistancePlayers;
    }
    else
    {
        //create array of all players inside
        //the spectate area
        _numBluforDead = {
            (_x distance2D
                DOTT_event_spectateArea)
                < DOTT_event_spectateAreaRadius
        } count _bluforPlayers;

        _numOpforDead = {
            (_x distance2D
                DOTT_event_spectateArea)
                < DOTT_event_spectateAreaRadius
        } count _opforPlayers;

        _numResistanceDead = {
            (_x distance2D
                DOTT_event_spectateArea)
                < DOTT_event_spectateAreaRadius
        } count _resistancePlayers;
    };

    //get number of players of each side in
    //spectate area array
    private _isBluforAlive =
        (count _bluforPlayers) > _numBluforDead;
    private _isOpforAlive =
        (count _opforPlayers) > _numOpforDead;
    private _isResistanceAlive =
        (count _resistancePlayers)
            > _numResistanceDead;


    //if all sides are wiped out, return to start
    //of loop. Prevents niche case of last player
    //on either team trading causing an erroneous
    //victory. Admin can call game manually in
    //this case.
    if (!_isBluforAlive
        && !_isOpforAlive
        && !_isResistanceAlive) then
    {
        continue;
    };

    // Check if only one side is alive
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
        [true, _winnerSide]
            call DOTT_event_fnc_game;
        breakTo "main";
    };
};
