/*
 * Name:	Hill_fnc_addRadio
 * Date:	8/13/2025
 * Version: 1.1
 * Author:  Hill [29th ID]
 *
 * Description:
 * Assigns faction SR radio to player if none in linked slot.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call Hill_fnc_addRadio;
 */

if (!hasInterface) exitWith {};

if (isClass (configfile >> "CfgPatches" >> "task_force_radio_items")) then 
{
  if (DOTT_addRadio == 0) exitWith {true};

  if (DOTT_addRadio == 2 || {(((getUnitLoadout player) select 9) select 2) == ""}) then 
  {
    switch (side (group player)) do 
    {
      case (WEST): { player linkItem "TFAR_anprc152" };
      case (EAST): { player linkItem "TFAR_fadak" };
      case (INDEPENDENT): { player linkItem "TFAR_anprc148jem" };
      default {false};
    };
  };
};

true