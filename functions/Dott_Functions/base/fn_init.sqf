#include "..\..\..\data\defines.hpp"

if (hasInterface) then
{
	#ifdef DOTT_TRAINING

	call DOTT_base_fnc_initObjects;

	#endif

	#ifdef DOTT_EVENT

	call DOTT_base_fnc_initObjectsEvent;

	#endif
};