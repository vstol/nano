/* 
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||                 
||| |||| ||| |||   |||       || |||   |||||||||||   ||| |||||||  |||| ||||| |||
||| |||| ||| || ||| ||||| ||||| || ||| ||||||||| ||| || |||||| || |||   ||| |||
||| |||| ||| || ||||||||| ||||| || ||||||||||||| |||||| ||||| |||| || || || |||
||| |||| ||| |||   |||||| ||||| || ||||||    ||| |||||| ||||| |||| || || || |||
||| |||| ||| |||||| ||||| ||||| || ||||||||||||| |||||| |||||      || ||  | |||
|||| || |||| |||||| ||||| ||||| || ||| ||||||||| ||| || ||||| |||| || ||| | |||
|||||  ||||| ||    |||||| ||||| |||   |||||||||||   |||    || |||| || ||||  |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

------------- Map       :	Royals
------------- Mapper  	:	VC' Blade
------------- Server  	:	VC' Deathrun: 62.75.222.118:28960
------------- xFire   	: 	bladetk17
------------- Homepage	:  	vistic-clan.tk
*/
main()
{
	maps\mp\_load::main();

	game["allies"] = "sas";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

  	setdvar( "r_specularcolorscale", "1" );
  	setdvar("r_glowbloomintensity0",".25");
  	setdvar("r_glowbloomintensity1",".25");
  	setdvar("r_glowskybleedintensity0",".3");
  	setDvar( "compassmaxrange", "1024" );

  	thread onJumpersDeath();
  	thread jumperelevator();
  	thread trap1();
  	thread trap2();
  	thread trap3();
  	thread trap4();
  	thread trap5();
  	thread trap6();
  	thread trap7();
  	thread trap8();
  	thread trap9();
  	thread jumptele();
  	thread snip_death();
  	thread knife_death();
  	thread secret();
  	thread endelevator();
  	thread sniper();
  	thread knife();
  	thread old();
  	thread actiteleport();
  	thread mover1();
  	thread mover2();
  	thread randomambient();
  	thread addTestClients();
  	thread banner();

  	level.death = LoadFX ("vistic/water_splash");
  	level.secret = loadfx("vistic/lighttrail");
  	level.lightning = loadfx("weather/lightning_bolt");
  	level.maplightning = loadfx("weather/lightning");
  	level.maprain = loadfx("weather/rain_heavy");
  	//level.mapfog = loadfx("weather/fog_river_200");

  		addtriggertolist("trap1_trig");
		addtriggertolist("trap2_trig");
		addtriggertolist("trap3_trig");
		addtriggertolist("trap4_trig");
		addtriggertolist("trap5_trig");
		addtriggertolist("trap6_trig");
		addtriggertolist("trap7_trig");
		addtriggertolist("trap8_trig");
		addtriggertolist("trap9_trig");
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
}

randomambient()
{
	level waittill("round_started");
	vc = randomint(4);
		if(vc == 0)
		{
			ambientplay("royal1");
			iprintln("Now playing:^1 Lorde - Royals");
			iprintln("Weather keeps unchanged");
		}
		if(vc == 1)
		{
			ambientplay("royal2");
			iprintln("Now playing:^1 Jay Z - Dirt Off Your Shoulder");
			iprintln("Weather turned into lightnings");
			level thread lightnings();
		}
		if(vc == 2)
		{
			ambientplay("royal3");
			iprintln("Now playing:^1 DVBBS & Borgeous - Tsunami");
			iprintln("Weather turned into a Thunder");
			level thread thunder();
		}
		if(vc == 3)
		{
			ambientplay("royal4");
			iprintln("Now playing:^1 Astronomyy - Drivin Me Crazy ");
			iprintln("Weather turned into fog");
			level thread fog();
		}
}

fog()
{
	SetExpFog(256, 900, 0.6, 0.6, 0.6, 0.1);
}
thunder()
{
	//main map
	playloopedfx(level.maprain,0.5,(-504,-936,520));
	playloopedfx(level.maprain,0.5,(-440,344,520));
	playloopedfx(level.maprain,0.5,(-600,-1784,520));
	playloopedfx(level.maprain,0.5,(296,-2616,520));
	playloopedfx(level.maprain,0.5,(1032,424,520));
	playloopedfx(level.maprain,0.5,(2344,472,520));
	playloopedfx(level.maprain,0.5,(1592,-296,520));
	playloopedfx(level.maprain,0.5,(2568,-744,520));
	playloopedfx(level.maprain,0.5,(1624,-1656,520));
	playloopedfx(level.maprain,0.5,(2600,-2072,520));
	playloopedfx(level.maplightning,0.5,(-504,-936,392));
	//rooms
	playloopedfx(level.maprain,0.5,(-3048,24,520));
	playloopedfx(level.maprain,0.5,(-3032,1528,520));
	playloopedfx(level.maprain,0.5,(-2200,1544,632));
	playloopedfx(level.maprain,0.5,(-3896,1512,632));
}
lightnings()
{
	playloopedfx(level.maplightning,0.5,(-504,-936,392));
}

onJumpersDeath()
{
	trig = getEnt ( "jumpers_death", "targetname" );
	while(1)
	{
		trig waittill ( "trigger", player );
		player thread death();
	}
}
snip_death()
{
	trig = getEnt ( "sniper_kill", "targetname" );
	while(1)
	{
		trig waittill ( "trigger", player );
		player thread death();
	}
} 
knife_death()
{
	trig = getEnt ( "knife_kill", "targetname" );
	while(1)
	{
		trig waittill ( "trigger", player );
		player thread death();
	}
}
death()
{
	playfx(level.death,self.origin);
	wait 0.05;
	self suicide();
	iPrintln( "^1" + self.name + "^7 drowned" );
}

jumperelevator()
{
	level waittill("round_started");
	elevator = getEnt("start_elevator", "targetname");
		wait 10;
		thread movespawns();
		elevator movez(256,4,2,1);
		wait 2;
		hud_clock = NewHudElem();
		hud_clock.alignX = "center";
		hud_clock.alignY = "middle";
		hud_clock.horzalign = "center";
		hud_clock.vertalign = "middle";
		hud_clock.alpha = 1;
		hud_clock.x = 0;
		hud_clock.y = 0;
		hud_clock.font = "objective";
		hud_clock.fontscale = 2;
		hud_clock.glowalpha = 1;
		hud_clock.glowcolor = (0,1,1);
		hud_clock.label = &"Map by VC' Blade";
        hud_clock SetPulseFX( 40, 5400, 200 );
        wait 3;
}

movespawns()
{
	spawnPoints = getEntArray( "mp_jumper_spawn", "classname" );

	if ( spawnPoints.size == 0 )
		return;
	for ( i = 0; i < spawnPoints.size; i++ )
	{
		cur_origin = spawnPoints[i] getorigin();
		spawnPoints[i].origin = ( cur_origin+(0,0,260) );
	}
}

trap1()
{
	trig = getEnt("trap1_trig", "targetname");
	trap1 = getEnt("trap1a", "targetname");
	trap2 = getEnt("trap1b", "targetname");
	trap3 = getEnt("trap1c", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");

		thread trap1a();
		thread trap1b();
	while(1)
	{
		trap3 movey(100,2);
		wait 2;
		trap3 movey(-100,2);
		wait 2;
	}
}
trap1a()
{
	trap1 = getEnt("trap1a", "targetname");
		while(1)
		{
			trap1 rotatepitch(360, 2);
			wait 4;
		}
}
trap1b()
{
	trap2 = getEnt("trap1b", "targetname");
		while(1)
		{
			trap2 rotatepitch(-360, 2);
			wait 4;
		}
}

trap2()
{
	trig = getEnt("trap2_trig", "targetname");
	trap = getEnt("trap2", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
	{
		trap notsolid();
		trap hide();
		wait 6;
		trap solid();
		trap show();
	}
}

trap3()
{
	trig = getEnt("trap3_trig", "targetname");
	trap1 = getEnt("trap3a", "targetname");
	trap2 = getEnt("trap3b", "targetname");
	trap3 = getEnt("trap3c", "targetname");
	kill1 = getEnt("trap3akill", "targetname");
	kill2 = getEnt("trap3bkill", "targetname");
	kill3 = getEnt("trap3ckill", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		thread trap3a();
		thread trap3b();
	kill3 enablelinkto ();
  	kill3 linkto (trap3);
	while(1)
	{
		trap3 movez(-140, 2);
		wait 2;
		trap3 movez(140, 2);
		wait 2;
	}
}
trap3a()
{
	trap1 = getEnt("trap3a", "targetname");
	kill1 = getEnt("trap3akill", "targetname");
		kill1 enablelinkto ();
	  	kill1 linkto (trap1);
		while(1)
		{
			trap1 movez(-140, 2);
			wait 2;
			trap1 movez(140, 2);
			wait 3;
		}
}
trap3b()
{
	trap2 = getEnt("trap3b", "targetname");
	kill2 = getEnt("trap3bkill", "targetname");
		kill2 enablelinkto ();
	  	kill2 linkto (trap2);
		while(1)
		{
			trap2 movez(-140, 2);
			wait 2;
			trap2 movez(140, 2);
			wait 4;
		}
}

trap4()
{
	trig = getent("trap4_trig", "targetname");
	trap1 = getent("trap4a", "targetname");
	trap2 = getent("trap4b", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		while(1)
		{
			trap1 movey(70,1);
			wait 2;
			trap2 movey(70,1);
			trap1 movey(-70,1);
			wait 2;
			trap2 movey(-70,1);
		}
}

trap5()
{
	trig = getent("trap5_trig", "targetname");
	trap = getent("trap5", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		trap notsolid();
		trap hide();
}

secret()
{
	trig = getent("secret", "targetname");
	trig waittill("trigger", player);
		player thread fxme();
}
fxme()
{
	self endon("death");
		while(1)
		{
			if(self getStance() == "stand")
			{
				playfx(level.secret, self.origin); 
			}
			wait .2;	
		}		
}

mover1()
{
	move = getent("mover1","targetname");
	move2 = getent("mover2","targetname");
	while(1)
	{
		move movey(378,3,2,1);
		move2 movex(448,3,2,1);
		wait 3;
		move movey(-378,3,2,1);
		move2 movex(-448,3,2,1);
		wait 3;
	}
}
mover2()
{
	move3 = getent("mover3","targetname");
	while(1)
	{
		move3 movey(-1344,10,2,1);
		move3 waittill("movedone");
		move3 movey(1344,10,2,1);
		move3 waittill("movedone");
	}
}

actiteleport()
{
	trig = getEnt("actiporttrig", "targetname");
	target = getEnt("actiport", "targetname");	
	trig setCursorHint("HINT_ACTIVATE");
		while(1)
		{
			trig waittill ("trigger", player);
			
			{
			  player SetOrigin(target.origin);
			  player SetPlayerAngles( target.angles );
			}
		}
}

jumptele()
{
	trig = getEnt("jumpport1", "targetname");
	target = getEnt("jump1", "targetname");	
		while(1)
		{
			trig waittill ("trigger", player);
			
			{
			  player SetOrigin(target.origin);
			  player SetPlayerAngles( target.angles );
			}
		}
}

trap6()
{
	trig = getent("trap6_trig", "targetname");
	trap1 = getent("trap6a", "targetname");
	trap2 = getent("trap6b", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		while(1)
		{
			trap1 movex(150,1.5);
			wait 2;
			trap1 movex(-150,1.5);
			trap2 movex(-150,1.5);
			wait 2;
			trap2 movex(150,1.5);
		}
}

trap8()
{
	trig = getent("trap8_trig", "targetname");
	trap1 = getent("trap8a", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		while(1)
		{
			trap1 rotatepitch(360,2);
			wait 2;
			trap1 movez(50,1);
			wait 1;
			trap1 movez(-50,1);
			wait 1;
		}
}

trap7()
{
	trig = getent("trap7_trig", "targetname");
	trap1 = getent("trap7a", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		while(1)
		{
			trap1 rotateyaw(360,3);
			wait 5;
		}
}

trap9()
{
	trig = getent("trap9_trig", "targetname");
	trap1 = getent("trap9", "targetname");
	trig sethintstring("[^2USE^7]");
	trig setCursorHint("HINT_ACTIVATE");
	trig waittill("trigger");
	trig sethintstring("[^2Activated^7]");
		while(1)
		{
			trap1 rotatepitch(360,4);
			wait 5;
		}
}

endelevator()
{
	trig = getent("endelevator_trig", "targetname");
	trap1 = getent("endelevator", "targetname");
	trig waittill("trigger", p);
	iprintlnbold("^1"+p.name+"^7 finished map 1st");
		trap1 movez(-248,3,2,1);
}

sniper()
{

	level.sniper = getEnt( "sniper", "targetname");
    jump = getEnt ("sniperj", "targetname");
    acti = getEnt ("snipera", "targetname");
    level.sniper setHintString("[^2Sniper^7]");
    level.sniper setCursorHint("HINT_ACTIVATE");
    while(1)
    {
    	level.sniper setHintString("[^2Sniper^7]");
    	level.sniper setCursorHint("HINT_ACTIVATE");
        level.sniper waittill( "trigger", player );
        if( !isDefined( level.sniper ) )
            return;
			level.old delete();
			level.knife delete(); 
		
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		player takeallweapons();
		player GiveWeapon( "m40a3_mp" );
        player SwitchtoWeapon( "m40a3_mp" );

        level.activ takeallweapons();
		level.activ GiveWeapon( "m40a3_mp" );
        level.activ SwitchtoWeapon( "m40a3_mp" );

        player FreezeControls(1);
		level.activ FreezeControls(1);

		noti = SpawnStruct();
            noti.titleText = "[^2SNIPER^7]";
            noti.notifyText = level.activ.name + " ^1against^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1.0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
		player FreezeControls(0);
		level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

knife()
{

	level.knife = getEnt( "knife", "targetname");
    jump = getEnt ("knifej", "targetname");
    acti = getEnt ("knifea", "targetname");
    level.knife setHintString("[^2Knife^7]");
    level.knife setCursorHint("HINT_ACTIVATE");

     while(1)
    {
    	level.knife setHintString("[^2Knife^7]");
    	level.knife setCursorHint("HINT_ACTIVATE");
        level.knife waittill( "trigger", player );
        if( !isDefined( level.knife ) )
            return;
		level.sniper delete();
		level.old delete();		
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
		player takeallweapons();
		player GiveWeapon( "knife_mp" );
        player SwitchtoWeapon( "knife_mp" );
        level.activ takeallweapons();
		level.activ GiveWeapon( "knife_mp" );
        level.activ SwitchtoWeapon( "knife_mp" );
        player FreezeControls(1);
		level.activ FreezeControls(1);

		noti = SpawnStruct();
            noti.titleText = "[^2KNIFE^7]";
            noti.notifyText = level.activ.name + " ^1against^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1.0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
            wait 2;
		player FreezeControls(0);
		level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

old()
{

	level.old = getEnt( "old", "targetname");
    jump = getEnt ("oldj", "targetname");
    acti = getEnt ("olda", "targetname");
    level.old setHintString("[^2Old^7]");
	level.old setCursorHint("HINT_ACTIVATE");
     while(1)
    {
    	level.old setHintString("[^2Old^7]");
    	level.old setCursorHint("HINT_ACTIVATE");
        level.old waittill( "trigger", player );
        if( !isDefined( level.old ) )
            return;
		level.sniper delete();
		level.knife delete();		
		player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        player FreezeControls(1);
		level.activ FreezeControls(1);

		noti = SpawnStruct();
            noti.titleText = "[^2OLD^7]";
            noti.notifyText = level.activ.name + " ^1against^7 " + player.name;
            noti.duration = 6;
            noti.glowcolor = (0, 0, 1.0);
            players = getEntArray("player", "classname");
            for(i=0;i<players.size;i++)
            players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
            wait 2;
		player FreezeControls(0);
		level.activ FreezeControls(0);
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

addTestClients()
{
    setDvar("scr_testclients", "");
    wait 1;
    for(;;)
    {
        if(getdvarInt("scr_testclients") > 0)
            break;
        wait 1;
    }
    testclients = getdvarInt("scr_testclients");
    setDvar( "scr_testclients", 0 );
    for(i=0;i<testclients;i++)
    {
        ent[i] = addtestclient();

        if (!isdefined(ent[i]))
        {
            println("Could not add test client");
            wait 1;
            continue;
        }
        ent[i].pers["isBot"] = true;
        ent[i] thread TestClient("autoassign");
    }
    thread addTestClients();
}

TestClient(team)
{
    self endon( "disconnect" );

    while(!isdefined(self.pers["team"]))
        wait .05;
        
    self notify("menuresponse", game["menu_team"], team);
    wait 0.5;
}

banner()
{
	banner1 = getEnt("banner1","targetname");
	banner2 = getEnt("banner2","targetname");
	banner3 = getEnt("banner3","targetname");
	banner4 = getEnt("banner4","targetname");
	while(1)
	{
		banner1 show();
		banner2 hide();
		banner3 hide();
		banner4 hide();
		wait(5);
		banner1 hide();
		banner2 show();
		banner3 hide();
		banner4 hide();
		wait(5);
		banner1 hide();
		banner2 hide();
		banner3 show();
		banner4 hide();
		wait(5);
		banner1 hide();
		banner2 hide();
		banner3 hide();
		banner4 show();
		wait(5);
	}
}