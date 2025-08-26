params["_weaponName"];
private _num = DOTT_tracker_weapons find _weaponName;
if (_num == -1) then 
{
	DOTT_tracker_weapons pushBack _weaponName;
	_num = count DOTT_tracker_weapons - 1;
};

_num