#define DOTT_TRAINING
//#define DOTT_EVENT

/*
Order of doesn't matter EXCEPT FOR:

event requires round to be initialized first
loadout should be after radio, otherwise radio saving won't work properly
commands should be at the end

*/

#ifdef DOTT_TRAINING
#define DOTT_MODULES ["round", "training", "parade", "tracker", "settings", "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "ocap", "commands"]
#endif

#ifdef DOTT_EVENT
#define DOTT_MODULES ["round", "event", "curator", "ticket", "thermals", "radio", "loadout", "spectator", "vehicle", "ocap"]
#endif