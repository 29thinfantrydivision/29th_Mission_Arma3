/**
 * params.hpp
 * Purpose: Mission parameter definitions shown in the lobby.
 *          Included inside class Params in description.ext.
 * Params:  None (engine config)
 * Return:  None (engine config)
 */

#ifdef DOTT_TRAINING

class enableRoundEventLog
{
    title = "Enable Round Event Logging?";
    values[] = {0, 1};
    texts[] = {"No", "Yes (Default)"};
    default = 1;
};

#endif
