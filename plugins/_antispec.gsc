/*
  _____                   _ _                 
 |  __ \                 (_) |                
 | |  | |_   _ _ __   ___ _| |__   ___  _   _ 
 | |  | | | | | '_ \ / __| | '_ \ / _ \| | | |
 | |__| | |_| | | | | (__| | |_) | (_) | |_| |
 |_____/ \__,_|_| |_|\___|_|_.__/ \___/ \__, |
                                         __/ |
                                        |___/ 
Author: Dunciboy © 2014
Function: Fix maps that don't have spectator spawn defined
Version: 1.0
*/

init( version )
{
	if(!isDefined(level.spawn["spectator"]))
		level.spawn["spectator"] = level.spawn["allies"][randomInt(level.spawn["allies"].size)];
}