/**
 * eventSettings.sqf
 * Purpose: Event mission configuration. Defines timer, lives, spectator,
 *          win conditions, and other event-specific variables.
 *          All DOTT_event_* variables are read by the event module at init.
 * Params:  None (called via execVM or preprocessed)
 * Return:  None
 *
 * NOTE: Several variables reference editor-placed objects by variable name
 *       (e.g. base_timerFlagWest, base_endFlag). These MUST exist in the
 *       mission.sqm or the event module will fail to initialize.
 */

// ===================================================================
// Timer / ready system
// ===================================================================
DOTT_event_hasTimer = true;
DOTT_event_safeStart = 10 * 60;    // Seconds after all teams ready up
DOTT_event_timerLength = 45 * 60;  // Round length in seconds

// Editor objects players interact with to ready their team.
// Requires: base_timerFlagWest, base_timerFlagEast, base_timerFlagGuer
DOTT_event_timerObjects = [
    base_timerFlagWest,
    base_timerFlagEast,
    base_timerFlagGuer
];

// Editor object admins interact with to force safestart or end mission.
// Requires: base_endFlag
DOTT_event_endingObject = base_endFlag;

// ===================================================================
// Lives / spectator
// ===================================================================
DOTT_event_numberOfLives = 1;   // 0 = unlimited
DOTT_event_spectateArea = base_endFlag;
DOTT_event_spectateAreaRadius = 200;
DOTT_event_respawnDisarmPlayers = true;

// ===================================================================
// Time acceleration
// ===================================================================
DOTT_event_timeAcc = 1;

// ===================================================================
// Alive check
// ===================================================================
// End mission automatically if only one side has living players.
DOTT_event_hasAliveCheck = true;

// ===================================================================
// Arsenal
// ===================================================================
DOTT_event_arsenalRadius = 20;

// ===================================================================
// Auto-marking
// ===================================================================
DOTT_event_autoMarkObjects = true;

// ===================================================================
// Win conditions
// ===================================================================
// Leave "" for no win condition for that side.
// Format: ["Points", <target>, <atEndOnly>]
//   atEndOnly = false: win as soon as points are reached
//   atEndOnly = true:  only checked when the timer expires
// Tiebreaker priority: OPFOR > BLUFOR > GRNFOR.
// See examples in project documentation for sector/kill scoring.
DOTT_event_score = [0, 0, 0];
DOTT_event_bluforWinConditions = "";
DOTT_event_opforWinConditions = "";
DOTT_event_grnforWinConditions = "";
DOTT_event_winCheckInterval = 3;

// ===================================================================
// Internal setup — do not edit below this line
// ===================================================================
["TN_safeStartTime", DOTT_event_safeStart,
    nil, "server", false] call cba_settings_fnc_set;
["TN_notifyFinalCheck", false,
    nil, "server", false] call cba_settings_fnc_set;
["TN_addRadio", 0,
    nil, "server", false] call cba_settings_fnc_set;
[DOTT_event_timerLength] call DOTT_round_fnc_setTimer;
