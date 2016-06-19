/*===================================================================||
||/|¯¯¯¯¯¯¯\///|¯¯|/////|¯¯|//|¯¯¯¯¯¯¯¯¯|//|¯¯¯¯¯¯¯¯¯|//\  \/////  //||
||/|  |//\  \//|  |/////|  |//|  |/////////|  |//////////\  \///  ///||
||/|  |///\  \/|  |/////|  |//|  |/////////|  |///////////\  \/  ////||
||/|  |///|  |/|  |/////|  |//|   _____|///|   _____|//////\    /////||
||/|  |////  //|  \/////|  |//|  |/////////|  |/////////////|  |/////||
||/|  |///  ////\  \////  ////|  |/////////|  |/////////////|  |/////||
||/|______ //////\_______/////|  |/////////|  |/////////////|  |/////||
||===================================================================*/

init( modVersion )
{
	resetspree();

    while( 1 )
    {
		level waittill( "player_killed", owned, eInflictor, killer, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
			
		if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		{
			sMeansOfDeath = "MOD_HEAD_SHOT";
		}	
			
		if( !isPlayer( killer ) || sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_TRIGGER_HURT" || owned.name == killer.name )
		{
		}
		else
		{
			level thread emblem(killer, owned, sMeansOfDeath);
		}
    }
}

resetspree()
{
	wait level.dvar["spawn_time"] + 1;
	
	players = getentarray("player", "classname");
	for(i=0; i<players.size; i++)
		players[i].meleespree = 0;
}

emblem(killer, owned, durch )
{
	level notify("killemblem");
	level endon("killemblem");
	if(!isDefined(killer.meleespree))
		killer.meleespree = 0;
		
	switch(durch)
	{
		case "MOD_HEAD_SHOT":
			players = getentarray("player", "classname");
			for(i=0; i<players.size; i++)
				players[i] playLocalSound( "mp_killstreak_heli" );	
			killer.meleespree++;
			break;
			
		case "MOD_IMPACT":	
			players = getentarray("player", "classname");
			for(i=0; i<players.size; i++)
				players[i] playLocalSound( "mp_killstreak_jet" );
			killer.meleespree++;
			break;
	}
	
	if(durch != "MOD_HEADSHOT" && durch != "MOD_IMPACT" )			
	{
		if(killer.meleespree == 2)
		{
			players = getentarray("player", "classname");
			for(i=0; i<players.size; i++)
				players[i] playLocalSound( "mp_killstreak_radar" );	
		}
		if(killer.meleespree == 4)
		{
			players = getentarray("player", "classname");
			for(i=0; i<players.size; i++)
				players[i] playLocalSound( "mp_killstrk_jetstart" );	
		}
	}
}