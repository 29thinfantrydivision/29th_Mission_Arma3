pvpfw_chatIntercept_commandMarker = "!"; //Character at the front of the chat input to intercept it

[] call compile preProcessFilelineNumbers "Dott_Functions\commands\commands.sqf";

addMissionEventHandler ["HandleChatMessage", {
	params ["_channel", "_owner", "_from", "_text", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType", "_params"];
	_chatArr = toArray _text;
	if ((_chatArr select 0) isEqualTo ((toArray pvpfw_chatIntercept_commandMarker) select 0)) then 
	{
		if (_strID == getPlayerID player) then { [_chatArr] call DOTT_commands_fnc_execute };
		true;
	} else
	{
		nil;
	};
}];