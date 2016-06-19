main()
{

maps\mp\_load::main();

//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
ambientPlay("ambient_middleeast_ext");
//VisionSetNaked( "mp_vacant" );

game["allies"] = "marines";
game["axis"] = "opfor";

game["attackers"] = "axis";
game["defenders"] = "allies";
game["allies_soldiertype"] = "desert";
game["axis_soldiertype"] = "desert";
setdvar( "r_specularcolorscale", "1" );

setdvar("r_glowbloomintensity0",".1");
setdvar("r_glowbloomintensity1",".1");
setdvar("r_glowskybleedintensity0",".1");
//setdvar("compassmaxrange","1500");

	addTriggerToList( "trigger_gap" );
	addTriggerToList( "trigger_lifter" );
	addTriggerToList( "labyrinth_trig" );
	addTriggerToList( "spinner_trig" );
	addTriggerToList( "spinner_tube_trig" );
	addTriggerToList( "arrow_trig" );

	thread gaptrap_slider ();
	thread liftertrap_slider ();
	thread labyrinth_slider ();
	thread spinnercone_slider ();
	thread tube_slider ();
	thread arrow_shot_slider ();
	thread door_slider ();
	thread maze_slider ();
	thread brick_blaster_slider ();
	thread FreeRun();
	thread onPlayerSpawned();
}

addTriggerToList( targetname )
{
	if( !isDefined( level.trapTriggers ) )
		level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( targetname, "targetname" );
}


gaptrap_slider() 
{ 
	gaptrap = getent( "gap_trap", "targetname" ); 
	gap_trig = getent( "trigger_gap", "targetname" );

		gap_trig waittill ("trigger"); 
		//wait 4; 
		gaptrap movez (-200,2,0,0.6); 
		gaptrap waittill ("movedone"); 
		wait 4;  
		gaptrap movez(200,4,0,0.6); 
		gaptrap waittill ("movedone");
}

liftertrap_slider() 
{ 
	lifter_left_trap = getent( "lifter_left", "targetname" );
	lifter_right_trap = getent( "lifter_right", "targetname" );
	lifter_trig = getent( "trigger_lifter", "targetname" );

		lifter_trig waittill ("trigger");
			//left lifter movement
		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (-100,1,0,0);
		lifter_right_trap movez (100,1,0,0);
		lifter_right_trap waittill ("movedone");

		lifter_left_trap movez (100,1,0,0);
		lifter_right_trap movez (-100,1,0,0);
		lifter_right_trap waittill ("movedone");
}

labyrinth_slider()
{
	laby_trig = getent( "labyrinth_trig", "targetname" );
	laby_wall = getent( "labyrinth_wall", "targetname" );

		laby_trig waittill ("trigger");
		
		laby_wall movez (128,1,0,0);
		laby_wall waittill ("movedone");
		wait 20;
		laby_wall movez (-128,1,0,0);
}

spinnercone_slider()
{
	spin_trig = getent( "spinner_trig", "targetname" );
	spinner_cone = getent( "spinnercone", "targetname" );

		spin_trig waittill ("trigger");
		
		spinner_cone movez (64,1,0,0);
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		wait 5;
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");

		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone waittill ("rotatedone");
		
		spinner_cone rotateyaw (540,1,0,0);
		spinner_cone movez (-64,1,0,0);
		spinner_cone waittill ("rotatedone");
}

tube_slider()
{
	tube_trig = getent( "spinner_tube_trig", "targetname" );
	tube = getent( "spinner_tube", "targetname" );

		tube_trig waittill ("trigger");
		
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 0.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 0.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 1.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
		wait 1.5;
		tube rotatepitch (720,1,0,0);
		tube waittill ("rotatedone");
}

arrow_shot_slider()
{
	arrw_trig = getent( "arrow_trig", "targetname" );
	arrw_top = getent( "arrow_top", "targetname" );
	arrw_bot = getent( "arrow_bot", "targetname" );

		arrw_trig waittill ("trigger");
		
		arrw_bot movex (-320,1,0,0);
		arrw_bot waittill ("movedone");
		wait 1;
		arrw_top movex (-320,1,0,0);
		arrw_bot movez (-200,1,0,0);
		arrw_top waittill ("movedone");
		
		arrw_top movez (-200,1,0,0);
}

door_slider()
{
	door_trig = getent( "door_trigger", "targetname" );
	door = getent( "door_open", "targetname" );

		door_trig waittill ("trigger");
		
		door movez (-200,5,0,0);
		door waittill ("movedone");

}

maze_slider()
{
	maze_trig = getent( "maze_trigger", "targetname" );
	maze_door = getent( "maze_bitch", "targetname" );

	while(true)
	{
		maze_trig waittill ("trigger");
		
		maze_door movez (-136,1,0,0);
		maze_door waittill ("movedone");
		wait 2.5;
		maze_door movez (136,1,0,0);
		maze_door waittill ("movedone");
		wait 4;
	}
}

//this trap is not a real trap, it is a secret. so dont put the disable on this.
brick_blaster_slider()
{
	wall = getent ( "brick_wall", "targetname" );
	alternate = getent ( "alternate_door", "targetname" );
	brick_trig = getent ( "brick_trigger", "targetname" );
	trig_1 = getent ( "point_1", "targetname" );
	trig_2 = getent ( "point_2", "targetname" );
	trig_3 = getent ( "point_3", "targetname" );
	trig_4 = getent ( "point_4", "targetname" );
	
	wall notsolid();

	//alternate notsolid();
}

FreeRun()
{
	level waittill( "activator", guy );
	level waittill( "traps_disabled" );
	guy SetOrigin((4, 943, 430));
	guy setPlayerAngles((13, 270, 0));
	thread final();
	thread nachricht();
	level.lifeearned = false;
}

onPlayerSpawned()
{
	for(;;)
	{
		level waittill( "player_spawn", player );
		player thread AntiBlock();
		player thread AntiStau();
	}
}

final()
{
	origin = (1, -26, 324);
	for(;;)
	{
		players = getentarray("player", "classname");
		for(i=0; i<players.size; i++)
		{
			if(isDefined( players[i] ) && isDefined( level.activ ) && Distance( players[i].origin, origin ) <= 100)
			{
				if( players[i] useButtonPressed() && players[i].pers["team"] == "allies" && isAlive( players[i] )) 
				{			
					noti = SpawnStruct();
					noti.titleText = "1 ^1vs ^71";
					noti.notifyText = level.activ.name + " ^1VS ^7" + players[i].name;
					noti.duration = 5;
					noti.glowcolor = (1,0,0);
					players = getentarray("player", "classname");
					for(k=0;k<players.size;k++)
						players[k] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
						
					players[i] SetOrigin((131, 1226, 430));
					players[i] setPlayerAngles((0, 229, 0));
					
					players[i] notify( "advjump" );
					
					level.activ SetOrigin((-144, 908, 430));
					level.activ setPlayerAngles((0, 49, 0));
					
					players[i] takeAllWeapons();
					level.activ takeAllWeapons();
					
					players[i] freezeControls( true );
					level.activ freezeControls( true );
					maxhealth = 100;
					level.activ.health = maxhealth;
					players[i].health = maxhealth;
					wait 4;
					players[i] freezeControls( false );
					level.activ freezeControls( false );
					
					weapon = "knife_mp";
					players[i] giveWeapon( weapon );
					players[i] giveMaxAmmo( weapon );
					players[i] switchToWeapon( weapon );
					
					level.activ giveWeapon( weapon );
					level.activ giveMaxAmmo( weapon );
					level.activ switchToWeapon( weapon );
					
					level.activ.knifesleft = 0;
					players[i].knifesleft = 0;
					
					players[i] thread NoWayOut();
					level.activ thread NoWayOut2();
					
					players[i] waittill("death");	
					level notify( "newins" );
				}
				else
				{
					if( players[i] useButtonPressed() && players[i].pers["team"] == "axis" && isAlive( players[i] )) 
					{
						level.activ SetOrigin((-144, 908, 430));
						level.activ setPlayerAngles((0, 49, 0));
					}
				}
			}
		}
		wait 0.05;
	}
}

nachricht()
{
	level endon( "endround" );
	for(;;)
	{
		playFx(level.fx["falling_teddys"], (1, -26, 600));
		wait 15;
	}
}

AntiStau()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	level endon( "endround" );
	
	einbahn = (82, 815, 236);
	port = (-150, 710, 188);
	
	for(;;)
	{
		if( Distance( self.origin, einbahn ) <= 50 && self.pers["team"] == "allies" && level.jumpers >= 3)
		{
			self SetOrigin(port);
			self setPlayerAngles((0, 333, 0));
			self IprintlnBold("^1Use the other stairs");
		}
		wait .05;
	}
}

AntiBlock()
{	
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	level endon( "endround" );
	
	vormabsprung = (79, 942, 300);
	block = (26, 699, 310);
	port = (-150, 710, 188);
	origin = (1, -26, 324);
	i = 0;
	
	for(;;)
	{
		if(isDefined( self ) && Distance( self.origin, vormabsprung ) <= 100 && self.pers["team"] == "allies" || Distance( self.origin, block ) <= 100 && self.pers["team"] == "allies")
			i++;
		else 
			i = 0;
			
		if( i == 10 )
		{
			self SetOrigin(port);
			self setPlayerAngles((0, 333, 0));
			self IprintlnBold("^1Dont Block");
			wait .5;
		}
		
		if(isDefined( self ) && Distance( self.origin, origin ) <= 100 && self.pers["team"] == "allies" && level.trapsDisabled )
		{
			self Iprintln("Press ^3[USE] ^7to Teleport");
			wait 5;
		}
		wait .5;
	}
}

NoWayOut()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	level endon( "endround" );
	
	port = (-150, 710, 188);
	noway = (15, 1265, 324);
	leiter = (142, 891, 171);
	
	for(;;)
	{
		if(isDefined( self ) && Distance( self.origin, noway ) <= 50)
		{
			self SetOrigin((131, 1226, 430));
			self setPlayerAngles((0, 229, 0));
		}	
		else
		{	
			if(isDefined( self ) && Distance( self.origin, leiter ) <= 100 )
			{
				self SetOrigin((131, 1226, 430));
				self setPlayerAngles((0, 229, 0));
				if(!level.lifeearned)
				{
					self braxi\_mod::giveLife();
					level.lifeearned = true;
				}
			}
		}
		wait .05;
	}
}

NoWayOut2()
{	
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	level endon( "newins" );
	
	noway = (15, 1265, 324);
	leiter = (142, 891, 171);
	
	for(;;)
	{
		if( isDefined( self ) && Distance( self.origin, noway ) <= 50)
		{
			self SetOrigin((-144, 908, 430));
			self setPlayerAngles((0, 49, 0));
		}
		else
		{	
			if(isDefined( self ) && Distance( self.origin, leiter ) <= 100 )
			{
				self SetOrigin((-144, 908, 430));
				self setPlayerAngles((0, 49, 0));
				if(!level.lifeearned)
				{
					self braxi\_mod::giveLife();
					level.lifeearned = true;
				}
			}
		}
		wait .05;
	}
}