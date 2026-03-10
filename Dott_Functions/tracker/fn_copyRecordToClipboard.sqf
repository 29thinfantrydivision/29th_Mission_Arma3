/*
 * Name:	DOTT_tracker_fnc_copyRecordToClipboard
 * Date:	8/18/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Copies text from record to clipboard up to and excluding copy clipboard button.
 * REQUIRES ACE 3
 *
 * Parameter(s): 
 * _subject (String): Diary subject containing the record.
 * _title (String): Title of the record to copy.
 *
 * Returns:
 * true
 *
 * Example:
 * ["Round 1", "Kill Log"] call DOTT_tracker_fnc_copyRecordToClipboard;
 * 
 */

params["_subject", "_title"];

private _allRoundRecords = player allDiaryRecords _subject;
private _idx = _allRoundRecords findIf { _x select 1 == _title };
private _recordText = (_allRoundRecords select _idx) select 2;
_recordText = _recordText select[0, _recordText find "<execute"];
_recordText call DOTT_tracker_fnc_copyToClipboard;
systemChat "Copied to clipboard. (HTML format)";

true
