/*
 * Loadout Commands Module
 *
 * Registers admin chat commands for heal, rearm, reset, debrief,
 * and goto. Commands dispatch flexibleReset calls to players via
 * remoteExec, filtered by side.
 */

// Maps lowercase side name -> [engineSide, displayName].
DOTT_loadout_cmdSideMap = createHashMapFromArray [
    ["blufor",  [west,       "Blufor"]],
    ["opfor",   [east,       "Opfor"]],
    ["grnfor",  [resistance, "Grnfor"]]
];

// Maps side name -> reset spawn object variable name.
DOTT_loadout_cmdResetBases = createHashMapFromArray [
    ["blufor",  "base_res_blu"],
    ["opfor",   "base_res_red"],
    ["grnfor",  "base_res_grn"]
];

/*
 * Dispatches a code block to all players on the named side.
 *
 * _sideName - String: "blufor", "opfor", or "grnfor"
 * _code     - Code: block to remoteExec on that side
 * _msgFmt   - String: format string with one %1 for display name
 *
 * Returns false if side is invalid, true otherwise.
 */
DOTT_loadout_fnc_cmdDispatch =
{
    params ["_sideName", "_code", "_msgFmt"];
    private _entry = DOTT_loadout_cmdSideMap get _sideName;
    if (isNil "_entry") exitWith { false };
    _entry params ["_target", "_displayName"];
    [_code] remoteExec ["call", _target];
    systemChat format [_msgFmt, _displayName];
    true;
};

/*
 * Dispatches a reset-with-teleport to the named side.
 * Builds the code block dynamically to reference the correct
 * per-side base object.
 *
 * _sideName - String: "blufor", "opfor", or "grnfor"
 * _silent   - Bool: true to suppress systemChat (default: false)
 *
 * Returns false if side is invalid, true otherwise.
 */
DOTT_loadout_fnc_cmdResetTeleport =
{
    params ["_sideName", ["_silent", false, [false]]];
    private _entry = DOTT_loadout_cmdSideMap get _sideName;
    private _baseName = DOTT_loadout_cmdResetBases get _sideName;
    if (isNil "_entry" || isNil "_baseName") exitWith { false };
    _entry params ["_target", "_displayName"];
    private _code = compile format [
        "[resetLoadout, true, getPosASL %1] spawn DOTT_loadout_fnc_flexibleReset",
        _baseName
    ];
    [_code] remoteExec ["call", _target];
    if (!_silent) then
    {
        systemChat format [
            "Rearming, healing, and teleporting %1 players to spawn!",
            _displayName
        ];
    };
    true;
};

[
    [
        [
            "heal",
            {
                private _argument = _this select 0;

                // No argument = heal everyone.
                if (_argument isEqualTo "") exitWith
                {
                    [
                        [[], true],
                        DOTT_loadout_fnc_flexibleReset
                    ] remoteExec ["spawn"];
                    systemChat "Healing all players!";
                };

                private _side = toLower _argument;
                private _code =
                {
                    [[], true]
                        spawn DOTT_loadout_fnc_flexibleReset;
                };

                private _ok = [
                    _side, _code, "Healing %1 players!"
                ] call DOTT_loadout_fnc_cmdDispatch;

                if (!_ok) then
                {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'";
                };
            }
        ],
        [
            "rearm",
            {
                private _argument = _this select 0;

                if (_argument isEqualTo "") exitWith
                {
                    [{
                        [resetLoadout]
                            spawn DOTT_loadout_fnc_flexibleReset;
                    }] remoteExec ["call"];
                    systemChat "Rearming all players!";
                };

                private _side = toLower _argument;
                private _code =
                {
                    [resetLoadout]
                        spawn DOTT_loadout_fnc_flexibleReset;
                };

                private _ok = [
                    _side, _code, "Rearming %1 players!"
                ] call DOTT_loadout_fnc_cmdDispatch;

                if (!_ok) then
                {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'";
                };
            }
        ],
        [
            "reset",
            {
                private _argument = _this select 0;

                // No argument = full reset + teleport everyone.
                if (_argument isEqualTo "") exitWith
                {
                    {
                        [_x, true] call DOTT_loadout_fnc_cmdResetTeleport;
                    } forEach ["blufor", "opfor", "grnfor"];
                    systemChat "Rearming, healing, and teleporting all players to spawn!";
                };

                private _argArr = (toLower _argument) splitString " ";

                private _stayArg = _argArr find "stay";

                if (_stayArg != -1) exitWith
                {
                    // "stay" alone = rearm + heal everyone.
                    if (count _argArr isEqualTo 1) exitWith
                    {
                        [
                            [resetLoadout, true],
                            DOTT_loadout_fnc_flexibleReset
                        ] remoteExec ["spawn"];
                        systemChat "Rearming and healing all players!";
                    };

                    // "stay" + side name.
                    private _sideArg = _argArr select (1 - _stayArg);
                    private _code =
                    {
                        [resetLoadout, true]
                            spawn DOTT_loadout_fnc_flexibleReset;
                    };

                    private _ok = [
                        _sideArg, _code, "Rearming and healing %1 players!"
                    ] call DOTT_loadout_fnc_cmdDispatch;

                    if (!_ok) then
                    {
                        systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'";
                    };
                };

                // Side only = full reset + teleport.
                private _side = toLower _argument;
                private _ok = [_side] call DOTT_loadout_fnc_cmdResetTeleport;

                if (!_ok) then
                {
                    systemChat "Error: Invalid input(s)! Must be 'stay', 'blufor', 'opfor', 'grnfor'";
                };
            }
        ],
        [
            "debrief",
            {
                private _argument = _this select 0;

                if (_argument isEqualTo "") then
                {
                    private _pos = getPosASL base_res_blu;
                    [
                        [true, true, _pos],
                        DOTT_loadout_fnc_flexibleReset
                    ] remoteExec ["spawn"];
                    systemChat "Healing, rearming, and teleporting all players to Blufor base!";
                }
                else
                {
                    // "here": teleport everyone 15m in front of the admin.
                    private _dir = getDir player;
                    private _pos = getPosASL player;
                    private _offset = _pos getPos [15, _dir];

                    // Use offset x/y but player z (satisfies ASL requirement).
                    private _telePos = [
                        _offset select 0,
                        _offset select 1,
                        _pos select 2
                    ];

                    [
                        [true, true, _telePos],
                        DOTT_loadout_fnc_flexibleReset
                    ] remoteExec ["spawn"];
                    systemChat "Healing, rearming, and teleporting all players to you!";
                };

                // Timestamp used by baseObjectsInit for Force Parade triggers.
                lastDebriefTime = time;
            }
        ],
        [
            "goto",
            {
                private _argument = toLower (_this select 0);

                // Maps side name -> arsenal base variable name.
                private _arsenalBases = createHashMapFromArray [
                    ["blufor", "base_action_arsenal_blu"],
                    ["opfor",  "base_action_arsenal_red"],
                    ["grnfor", "base_action_arsenal_grn"]
                ];

                private _entry = DOTT_loadout_cmdSideMap get _argument;
                private _baseName = _arsenalBases get _argument;

                if (isNil "_entry" || isNil "_baseName") exitWith
                {
                    systemChat "Error: Invalid input! Must be 'blufor', 'opfor', or 'grnfor'";
                };

                _entry params ["_target", "_displayName"];

                private _baseObj = missionNamespace getVariable [_baseName, objNull];
                [[], false, getPosASL _baseObj] spawn DOTT_loadout_fnc_flexibleReset;
                systemChat format ["Teleporting to %1 spawn!", _displayName];
            }
        ]
    ],
    [
        [
            "heal",
            "ACE Heals players. '!heal' for all players, otherwise '!heal SIDE' (blufor, opfor, grnfor)"
        ],
        [
            "rearm",
            "Rearms players. '!rearm' for all players, otherwise '!rearm SIDE' (blufor, opfor, grnfor)"
        ],
        [
            "reset",
            "Rearms, heals, and (optionally)"
                + " teleports players to spawn."
                + " '!reset' will rearm, heal, and"
                + " teleport players to spawn."
                + " '!reset stay' will rearm and heal"
                + " them. May also specify side"
                + " (blufor, opfor, grnfor)"
        ],
        [
            "debrief",
            "ACE Heals and teleports players"
                + " for debrief. '!debrief' to teleport"
                + " all players to Blufor base,"
                + " '!debrief here' to teleport all"
                + " players to your position"
        ],
        [
            "goto",
            "Teleports admin to side spawns. '!goto SIDE' (blufor, opfor, grnfor)"
        ]
    ]
] call DOTT_commands_fnc_addModule;
