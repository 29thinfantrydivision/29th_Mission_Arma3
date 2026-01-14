/*
 * Name:	DOTT_round_fnc_checkAllSidesReady
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] 
 *
 * Description:
 * Check if all sides are ready for the round to start.
 *
 * Parameter(s): 
 * none
 *
 * Returns:
 * true if all sides are ready, false otherwise
 *
 * Example:
 * call DOTT_round_fnc_checkAllSidesReady;
 * 
 */

private _bluCount = west countSide allPlayers;
private _opfCount = east countSide allPlayers;
private _grnCount = resistance countSide allPlayers;

private _opfReady = DOTT_round_sideReady select 0;
private _bluReady = DOTT_round_sideReady select 1;
private _grnReady = DOTT_round_sideReady select 2;

//All sides are ready or have no players
(_bluReady || _bluCount == 0) &&
(_opfReady || _opfCount == 0) &&
(_grnReady || _grnCount == 0)