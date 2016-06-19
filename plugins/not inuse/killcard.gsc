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

	if(isdefined(level.emblem_owned)) level.emblem_owned destroy();
	if(isdefined(level.emblem_killer)) level.emblem_killer destroy();
	if(isdefined(level.emblem_icon)) level.emblem_icon destroy();
	if(isdefined(level.emblem_bindestrich)) level.emblem_bindestrich destroy();
	if(isdefined(level.emblem_killtext)) level.emblem_killtext destroy();
	if(isdefined(level.emblem_killerrank)) level.emblem_killerrank destroy();
	if(isdefined(level.emblem_ownedrank)) level.emblem_ownedrank destroy();
	if(isdefined(level.emblem_killerspray)) level.emblem_killerspray destroy();
	if(isdefined(level.emblem_ownedspray)) level.emblem_ownedspray destroy();
	if(isdefined(level.emblem_killway)) level.emblem_killway destroy();
	
	killerspray = ( "spray" + killer getStat(979) + "_menu" );
	killerrank = ( "rank_" + (killer.pers["rank"]) ); 
	ownedspray = ( "spray" + owned getStat(979) + "_menu" );
	ownedrank = ( "rank_" + (owned.pers["rank"]) );
	
	switch(durch)
	{
		case "MOD_HEAD_SHOT":
			level.killtext = "HEADSHOT";
			level.killway = "killiconheadshot";
			players = getentarray("player", "classname");
			for(i=0; i<players.size; i++)
				players[i] playLocalSound( "mp_killstreak_heli" );	
			killer.meleespree++;
			break;
			
		case "MOD_MELEE":
			level.killtext = "SLAUGHTERED";
			level.killway = "killiconmelee";			
			killer.meleespree++;
			break;
		case "MOD_IMPACT":	
			players = getentarray("player", "classname");
			for(i=0; i<players.size; i++)
				players[i] playLocalSound( "mp_killstreak_jet" );
			killer.meleespree++;
			level.killtext = "OWN3D";
			level.killway = "killiconimpact";
			break;
			
		default:
			killer.meleespree++;
			level.killtext = "ELEMINATED";
			level.killway = "waypoint_defend_a";
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
				players[i] playLocalSound( "oldschool_return" );	
		}
	}
	
	level.emblem_icon = newHudElem();
	level.emblem_icon.x = 0;
	level.emblem_icon.y = -90;
	level.emblem_icon.alignX = "center";
	level.emblem_icon.alignY = "top";
	level.emblem_icon.horzAlign = "center";
	level.emblem_icon.vertAlign = "top";
	level.emblem_icon.alpha = 1;
	level.emblem_icon.sort = 100;
	level.emblem_icon.archived = false;
	level.emblem_icon setShader("stance_prone", 400, 100);
	level.emblem_icon MoveOverTime ( 0.5 );
	level.emblem_icon.x = 0;
	level.emblem_icon.y = 20;
	level.emblem_icon.hidewheninmenu = true;

	level.emblem_killer = newHudElem();
	level.emblem_killer.elemType = "font";
	level.emblem_killer.font = "default";
	level.emblem_killer.fontscale = 3;
	level.emblem_killer.x = -90;
	level.emblem_killer.y = 80.5;
	level.emblem_killer.glowAlpha = 1;
	level.emblem_killer.hideWhenInMenu = true;
	level.emblem_killer.archived = false;
	level.emblem_killer.alignX = "center";
	level.emblem_killer.alignY = "top";
	level.emblem_killer.horzAlign = "center";
	level.emblem_killer.vertAlign = "top";
	level.emblem_killer.alpha = 1;
	level.emblem_killer.sort = 102;
	level.emblem_killer.glowAlpha = 1;
	level.emblem_killer.glowColor = (1.0, 0.0, 0.0);
	level.emblem_killer.label = &"";
	level.emblem_killer setplayernamestring(killer);	
	
	level.emblem_owned = newHudElem();
	level.emblem_owned.elemType = "font";
	level.emblem_owned.font = "default";
	level.emblem_owned.fontscale = 3;
	level.emblem_owned.x = 90;
	level.emblem_owned.y = 80.5;
	level.emblem_owned.glowAlpha = 1;
	level.emblem_owned.hideWhenInMenu = true;
	level.emblem_owned.archived = false;
	level.emblem_owned.alignX = "center";
	level.emblem_owned.alignY = "top";
	level.emblem_owned.horzAlign = "center";
	level.emblem_owned.vertAlign = "top";
	level.emblem_owned.alpha = 1;
	level.emblem_owned.sort = 102;
	level.emblem_owned.glowAlpha = 1;
	level.emblem_owned.glowColor = (1.0, 0.0, 0.0);
	level.emblem_owned.label = &"";
	level.emblem_owned setplayernamestring(owned);	
	
	level.emblem_bindestrich = newHudElem();
	level.emblem_bindestrich.elemType = "font";
	level.emblem_bindestrich.font = "default";
	level.emblem_bindestrich.fontscale = 1.4;
	level.emblem_bindestrich.x = 0;
	level.emblem_bindestrich.y = 20.6;
	level.emblem_bindestrich.glowAlpha = 1;
	level.emblem_bindestrich.hideWhenInMenu = true;
	level.emblem_bindestrich.archived = false;
	level.emblem_bindestrich.alignX = "center";
	level.emblem_bindestrich.alignY = "top";
	level.emblem_bindestrich.horzAlign = "center";
	level.emblem_bindestrich.vertAlign = "top";
	level.emblem_bindestrich.alpha = 1;
	level.emblem_bindestrich.sort = 101;
	level.emblem_bindestrich.glowAlpha = 1;
	level.emblem_bindestrich.glowColor = (1.0, 0.0, 0.0);
	level.emblem_bindestrich.label = &"";
	level.emblem_bindestrich setText( "^1VS" );	
	
	level.emblem_killtext = newHudElem();
	level.emblem_killtext.elemType = "font";
	level.emblem_killtext.font = "default";
	level.emblem_killtext.fontscale = 1.6;
	level.emblem_killtext.x = -8;
	level.emblem_killtext.y = 73;
	level.emblem_killtext.glowAlpha = 1;
	level.emblem_killtext.hideWhenInMenu = true;
	level.emblem_killtext.archived = false;
	level.emblem_killtext.alignX = "center";
	level.emblem_killtext.alignY = "top";
	level.emblem_killtext.horzAlign = "center";
	level.emblem_killtext.vertAlign = "top";
	level.emblem_killtext.alpha = 1;
	level.emblem_killtext.sort = 102;
	level.emblem_killtext.glowAlpha = 1;
	level.emblem_killtext.glowColor = level.randomcolour;
	level.emblem_killtext.label = &"";
	level.emblem_killtext setText( level.killtext );	
	
	level.emblem_killerrank = newHudElem();
	level.emblem_killerrank.x = -20;
	level.emblem_killerrank.y = 19.5;
	level.emblem_killerrank.alignX = "center";
	level.emblem_killerrank.alignY = "top";
	level.emblem_killerrank.horzAlign = "center";
	level.emblem_killerrank.vertAlign = "top";
	level.emblem_killerrank.alpha = 1;
	level.emblem_killerrank.sort = 101;
	level.emblem_killerrank.archived = false;
	level.emblem_killerrank setShader(killerrank, 21, 21);
	level.emblem_killerrank.hidewheninmenu = true;
	
	level.emblem_ownedrank = newHudElem();
	level.emblem_ownedrank.x = 20;
	level.emblem_ownedrank.y = 19.5;
	level.emblem_ownedrank.alignX = "center";
	level.emblem_ownedrank.alignY = "top";
	level.emblem_ownedrank.horzAlign = "center";
	level.emblem_ownedrank.vertAlign = "top";
	level.emblem_ownedrank.alpha = 1;
	level.emblem_ownedrank.sort = 101;
	level.emblem_ownedrank.archived = false;
	level.emblem_ownedrank setShader(ownedrank, 21, 21);
	level.emblem_ownedrank.hidewheninmenu = true;
	
	level.emblem_killerspray = newHudElem();
	level.emblem_killerspray.x = -90;
	level.emblem_killerspray.y = 27;
	level.emblem_killerspray.alignX = "center";
	level.emblem_killerspray.alignY = "top";
	level.emblem_killerspray.horzAlign = "center";
	level.emblem_killerspray.vertAlign = "top";
	level.emblem_killerspray.alpha = 1;
	level.emblem_killerspray.sort = 101;
	level.emblem_killerspray.archived = false;
	level.emblem_killerspray setShader(killerspray, 52, 52);
	level.emblem_killerspray.hidewheninmenu = true;
	
	level.emblem_ownedspray = newHudElem();
	level.emblem_ownedspray.x = 90;
	level.emblem_ownedspray.y = 27;
	level.emblem_ownedspray.alignX = "center";
	level.emblem_ownedspray.alignY = "top";
	level.emblem_ownedspray.horzAlign = "center";
	level.emblem_ownedspray.vertAlign = "top";
	level.emblem_ownedspray.alpha = 1;
	level.emblem_ownedspray.sort = 101;
	level.emblem_ownedspray.archived = false;
	level.emblem_ownedspray setShader(ownedspray, 51, 51);
	level.emblem_ownedspray.hidewheninmenu = true;
	
	level.emblem_killway = newHudElem();
	level.emblem_killway.x = 0;
	level.emblem_killway.y = 53;
	level.emblem_killway.alignX = "center";
	level.emblem_killway.alignY = "top";
	level.emblem_killway.horzAlign = "center";
	level.emblem_killway.vertAlign = "top";
	level.emblem_killway.alpha = 1;
	level.emblem_killway.sort = 101;
	level.emblem_killway.archived = false;
	level.emblem_killway setShader(level.killway, 41, 41);
	level.emblem_killway.hidewheninmenu = true;
	

	
	Earthquake( 0.4, 2, killer.origin, 100 );
	
	level.emblem_killtext moveOverTime( 9 );
	
	level.emblem_killtext.x = 20.8;
	
	level.emblem_icon ScaleOverTime( 0.5,300, 75);
	
	while(level.emblem_killer.fontscale >= 1.6)
	{
		val = level.emblem_killer.fontscale - 0.15;
		level.emblem_killer.fontscale = val;
		level.emblem_owned.fontscale = val;
		wait 0.05;
	}
	
	wait 4;
	
	if( game["state"] == "round ended" )
		wait 4;
	
		level.emblem_owned moveOverTime( 1 );
			level.emblem_owned.y = level.emblem_owned.y + -250;
			
		level.emblem_killer moveOverTime( 1 );
			level.emblem_killer.y = level.emblem_killer.y + -250;
			
		level.emblem_icon moveOverTime( 1 );
			level.emblem_icon.y = level.emblem_icon.y + -250;			
	
		level.emblem_bindestrich moveOverTime( 1 );
			level.emblem_bindestrich.y = level.emblem_bindestrich.y + -250;	
	
		level.emblem_killtext moveOverTime( 1 );
			level.emblem_killtext.y = level.emblem_killtext.y + -250;		
	
		level.emblem_killerrank moveOverTime( 1 );
			level.emblem_killerrank.y = level.emblem_killerrank.y + -250;
			
		level.emblem_ownedrank moveOverTime( 1 );
			level.emblem_ownedrank.y = level.emblem_ownedrank.y + -250;
			
		level.emblem_killerspray moveOverTime( 1 );
			level.emblem_killerspray.y = level.emblem_killerspray.y + -250;
			
		level.emblem_ownedspray moveOverTime( 1 );
			level.emblem_ownedspray.y = level.emblem_ownedspray.y + -250;
			
		level.emblem_killway moveOverTime( 1 );
			level.emblem_killway.y = level.emblem_killway.y + -250;
			
	while(level.emblem_icon.alpha >= 0.11)
	{
		value = level.emblem_icon.alpha - 0.1;
		level.emblem_owned.alpha = value;
		level.emblem_killer.alpha = value;
		level.emblem_icon.alpha = value;
		level.emblem_bindestrich.alpha = value;
		level.emblem_killtext.alpha = value;
		level.emblem_killerrank.alpha = value;
		level.emblem_ownedrank.alpha = value;
		level.emblem_killerspray.alpha = value;
		level.emblem_ownedspray.alpha = value;
		level.emblem_killway.alpha = value;
		wait 0.05;
	}
	
	if(isdefined(level.emblem_owned)) level.emblem_owned destroy();
	if(isdefined(level.emblem_killer)) level.emblem_killer destroy();
	if(isdefined(level.emblem_icon)) level.emblem_icon destroy();
	if(isdefined(level.emblem_bindestrich)) level.emblem_bindestrich destroy();
	if(isdefined(level.emblem_killtext)) level.emblem_killtext destroy();
	if(isdefined(level.emblem_killerrank)) level.emblem_killerrank destroy();
	if(isdefined(level.emblem_ownedrank)) level.emblem_ownedrank destroy();
	if(isdefined(level.emblem_killerspray)) level.emblem_killerspray destroy();
	if(isdefined(level.emblem_ownedspray)) level.emblem_ownedspray destroy();
	if(isdefined(level.emblem_killway)) level.emblem_killway destroy();
}