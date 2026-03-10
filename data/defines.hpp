/**
 * defines.hpp
 * Purpose: Preprocessor definitions for the mission. Selects the active
 *          mission mode (training vs event) and defines the module load
 *          order via DOTT_MODULES.
 * Params:  None (preprocessor)
 * Return:  None (preprocessor)
 */

// Define ONLY ONE of the modes below.
#define DOTT_TRAINING
//#define DOTT_EVENT

/**
 * Module ordering constraints:
 *   - "round" MUST be first; most other modules assume it is initialized.
 *   - "loadout" must come after "radio", otherwise radio saving breaks.
 *   - "base" must come after "event" to properly read arsenal radius.
 */

#ifdef DOTT_TRAINING
#define DOTT_MODULES [ \
    "round", "training", "parade", "tracker", "settings", \
    "curator", "ticket", "thermals", "radio", "loadout", \
    "spectator", "vehicle", "base", "ocap", "commands" \
]
#endif

#ifdef DOTT_EVENT
#define DOTT_MODULES [ \
    "round", "event", "curator", "ticket", "thermals", \
    "radio", "loadout", "spectator", "vehicle", "base", "ocap" \
]
#endif
