/*===================================================================||
||/|¯¯¯¯¯¯¯\///|¯¯|/////|¯¯|//|¯¯¯¯¯¯¯¯¯|//|¯¯¯¯¯¯¯¯¯|//\  \/////  //||
||/|  |//\  \//|  |/////|  |//|  |/////////|  |//////////\  \///  ///||
||/|  |///\  \/|  |/////|  |//|  |/////////|  |///////////\  \/  ////||
||/|  |///|  |/|  |/////|  |//|   _____|///|   _____|//////\    /////||
||/|  |////  //|  \/////|  |//|  |/////////|  |/////////////|  |/////||
||/|  |///  ////\  \////  ////|  |/////////|  |/////////////|  |/////||
||/|______ //////\_______/////|  |/////////|  |/////////////|  |/////||
||===================================================================||

	Plugin:	 		Advanced deathrun settings
	Version:		1.1
	Requirement:	-
	Author:			DuffMan
	XFire:			mani96x
	Homepage:		3xp-clan.com
	Date:			20.01.2013
*/

//usage:
//settings("mp_mapname", rounds,	roundtime in min,	freerun time in sec, allow bunnyhop(true or false));

init(x)
{
	if(getDvar("dr_rounds_old") != getDvar("dr_rounds") && getDvar("dr_rounds_old") != "") { setDvar("dr_rounds",getDvar("dr_rounds_old")); level.hud_round setText("Round:"+ game["roundsplayed"] + "/" + getDvar("dr_rounds_old") ); setDvar("dr_rounds_old",""); }
	settings("mp_deathrun_dragonball",11,6,90,true);
	settings("mp_deathrun_skypillar",11,4,60,true);
	settings("mp_deathrun_illusion",11,6,90,true);
	settings("mp_dr_tron", 11,6,45,true);
	settings("mp_dr_terror",11,6,45,false);
	settings("mp_dr_frantic",11,5,75,false);
}

settings(map,rounds,time,freeruntime,bunny) 
{
	if(getDvar("mapname") == map) 
	{
		level.dvar["time_limit"] = time;
		level.dvar["freerun_time"] = freeruntime;
		level.dvar["bunnyhoop"] = bunny;
		setDvar("dr_rounds_old",getDvar("dr_rounds"));
		setDvar("dr_rounds",rounds);
		level.dvar["round_limit"] = rounds;
		level.hud_round setText("Round:"+ game["roundsplayed"] + "/" + level.dvar["round_limit"] );
	}
}