/**
 * cfgDebriefing.hpp
 * Purpose: Debriefing screen definitions for each possible mission ending.
 *          Included by description.ext.
 * Params:  None (engine config)
 * Return:  None (engine config)
 */

class CfgDebriefing
{
    // --- Neutral / draw ending ---
    class EndNeutral
    {
        title = "Game Over!";
        subtitle = "";
        description = "Game Over";
        pictureBackground = "";
        picture = "";
        pictureColor[] = {0.0, 0.0, 0.0, 1};
    };

    // --- BLUFOR victory ---
    class EndWestVictory
    {
        title = "Blufor Wins!";
        subtitle = "";
        description = "Blufor Wins";
        pictureBackground = "";
        picture = "";
        pictureColor[] = {0.0, 0.0, 0.0, 1};
    };

    // --- OPFOR victory ---
    class EndEastVictory
    {
        title = "Opfor Wins!";
        subtitle = "";
        description = "Opfor Wins";
        pictureBackground = "";
        picture = "";
        pictureColor[] = {0.0, 0.0, 0.0, 1};
    };

    // --- GRNFOR victory ---
    class EndGuerVictory
    {
        title = "Grnfor Wins!";
        subtitle = "";
        description = "Grnfor Wins";
        pictureBackground = "";
        picture = "";
        pictureColor[] = {0.0, 0.0, 0.0, 1};
    };
};
