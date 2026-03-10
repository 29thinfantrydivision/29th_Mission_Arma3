/**
 * DOTT_loadout_fnc_flexibleReset
 *
 * Purpose: All-in-one reset function that optionally rearms, heals,
 *          and teleports the local player, then shows a notification.
 *          Must be spawned on the client.
 *
 * Params (all optional):
 *   _inventory - Array|Bool: CBA extended loadout array, or true to
 *                use the saved resetLoadout variable. Default: []
 *   _heal      - Bool: true to ACE full-heal the player. Default: false
 *   _point     - Array: position ASL to teleport to. Default: []
 *   _pointRad  - Number: skip teleport if player is already within
 *                this distance of _point. Default: 50
 *   _msgClass  - String: CfgNotifications class. Empty = auto-pick.
 *   _msgTitle  - String: notification title
 *   _msgDesc   - String: notification description
 *
 * Returns: Nothing
 */

params
[
    ["_inventory", [], [[], true]],
    ["_heal", false, [false]],
    ["_point", [], [[]]],
    ["_pointRad", 50, [0]],
    ["_msgClass", "", [""]],
    ["_msgTitle", "", [""]],
    ["_msgDesc", "", [""]]
];

if (!hasInterface) exitWith {};

// --- Rearm ---
private _resetInventory = false;

// Allow passing true to pull from the saved global loadout.
if (_inventory isEqualTo true) then
{
    _inventory = missionNamespace getVariable ["resetLoadout", []];
};

if (count _inventory != 0) then
{
    if (!isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}) exitWith
    {
        systemChat "Player in spectator, skipping rearm.";
    };

    if (arsenalActionId != -1) exitWith
    {
        systemChat "Player in base, skipping rearm.";
    };

    [player, _inventory, true]
        spawn DOTT_loadout_fnc_fullSetUnitLoadout;
    _resetInventory = true;
};

// --- Heal ---
if (_heal) then
{
    [player] call ACE_medical_treatment_fnc_fullHealLocal;

    if (["ace_hearing"] call ace_common_fnc_isModLoaded) then
    {
        ace_hearing_deafnessDV = 0;
    };
};

// --- Teleport ---
private _pointCount = count _point;
private _teleport = false;

if (_pointCount < 3) then
{
    // Non-empty but undersized array is a caller mistake.
    if (_point isNotEqualTo []) then
    {
        hint "DOTT_fnc_roundReset Error: Position Array wrong size!";
    };
}
else
{
    // Wait up to 30s for a dead player to respawn before teleporting.
    private _timeStart = time;
    waitUntil
    {
        sleep 1;
        time - _timeStart > 30
            || (!isNull player && alive player)
    };

    call DOTT_spectator_fnc_exit;

    DOTT_loadout_teleporting = true;

    private _tries = 0;
    player allowDamage false;

    while {_tries < 3} do
    {
        waitUntil
        {
            uiSleep 0.1;
            !(player getVariable ["emr_main_isClimbing", false])
        };

        private _pointDist = player distance2D _point;
        if (_pointDist < _pointRad || !alive player) exitWith {};

        titleText [
            "<t color='#ffffff' size='4'>Teleporting...</t>",
            "BLACK OUT", 0.5, true, true
        ];

        sleep 0.1;

        moveOut player;
        sleep 0.1;

        // Scatter position randomly around the target point.
        private _dir = random 359;
        player setPosASL [
            (_point select 0) - 6 * sin(_dir),
            (_point select 1) - 6 * cos(_dir),
            (_point select 2)
        ];
        sleep 0.1;

        private _ground = isTouchingGround player;

        if (!_ground) then
        {
            private _curr = getPos player;
            private _height = _curr select 2;

            if (_height > 2) then
            {
                // High enough to be dangerous; snap to ground.
                player setPos [_curr select 0, _curr select 1, 0];
            }
            else
            {
                // Close to ground, just give a moment to settle.
                sleep 0.4;
            };
        };

        sleep 0.2;

        titleText [
            "<t color='#ffffff' size='4'>Teleporting...</t>",
            "BLACK IN", 0.5, true, true
        ];

        _tries = _tries + 1;
    };

    // Restore normal state after a short delay.
    [] spawn
    {
        sleep 2;
        player allowDamage true;
        DOTT_loadout_teleporting = nil;
    };

    _teleport = _tries > 0;
};

// --- Notification ---
// If caller provided a custom notification class, use that (not shown
// here because the exitWith above only fires for the auto-pick path).
if (_msgClass isEqualTo "") exitWith
{
    // TODO: Support custom _msgClass notifications.
    switch (true) do
    {
        case (_resetInventory && !_heal && !_teleport):
        {
            ["Reset", ["Rearmed", "Player is Rearmed!"]]
                call BIS_fnc_showNotification;
        };
        case (_resetInventory && _heal && !_teleport):
        {
            ["Reset", ["Reset", "Rearmed and Healed!"]]
                call BIS_fnc_showNotification;
        };
        case (_resetInventory && _heal && _teleport):
        {
            ["Reset", ["Full Reset", "Rearmed, healed, and teleported!"]]
                call BIS_fnc_showNotification;
        };
        case (!_resetInventory && _heal && _teleport):
        {
            ["Document", ["Debrief", "Teleported for debrief!"]]
                call BIS_fnc_showNotification;
        };
        case (!_resetInventory && !_heal && _teleport):
        {
            ["Document", ["Teleported", "Player teleported!"]]
                call BIS_fnc_showNotification;
        };
        case (!_resetInventory && _heal && !_teleport):
        {
            ["Health", ["Healed", "Player is healed!"]]
                call BIS_fnc_showNotification;
        };
        default {};
    };
};
