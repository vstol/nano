//map by Lifezor
//scripted by Sheep Wizard and rewritten by Wingzor LOL
//mp_deathrun_holylife
main()
{
	//maps\mp\_load::main();

	setExpFog(500, 2200, 0.81, 0.75, 0.63, 0.5);
		
	precacheItem("m40a3_mp");
	precacheItem("remington700_mp");
	precacheItem("tomahawk_mp");

	ambientPlay("ambient1");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
		
	setdvar( "r_specularcolorscale", "1" );
	setdvar("r_glowbloomintensity0",".25");
	setdvar("r_glowbloomintensity1",".25");
	setdvar("r_glowskybleedintensity0",".3");
	
	 thread credits();
	 thread start_elevator();
	 thread trap1();
     thread trap2();
	 thread trap3();
	 thread trap4();
	 thread trap5();
	 thread trap6();
	 thread trap7();
	 thread old();
	 thread sniper();
	 thread knife();

}

credits()
{
     for(;;)
	 {
	 iPrintLn ("^3>>^1Map By ^2Lifezor");
	 wait 7;
	 iPrintLn ("^3>>^1Youtube ^2http://www.youtube.com/IH8LifesSucks");
	 wait 7;
	 iPrintLn ("^3>>^1Xfire ^2xhdkillerhdx");
	 wait 7;
	 iPrintLn ("^3>>^23xP' ^1Clan");
	 wait 7;
	 iPrintLn ("^3>>^1Thanks to ^2Sheep Wizard and Wingzor^6<3^1!");
	 wait 7;
	 iPrintLn ("^3>>^1Thanks for playing ^2mp_deathrun_holylife");
	 wait 14;
	 }
}


start_elevator()
{
	platform = getent("startplatform","targetname");//randomnameipick =getent("randomnameipickedinradiant","targetnamekey");
	level waittill("round_started");
	wait 3;//we wait 8 seconds before we move the platform up
	thread MoveSpawnsX();
	platform movez(1024,8,2,6);//distance,total time to move,speedup after,slowdownafter
	platform waittill("movedone");//script wait tills the movement of entity with name platform is done
	
}

moveSpawnsX()
{

spawnPoints = getEntArray( "mp_jumper_spawn", "classname" );

if ( spawnPoints.size == 0 )
	return;

	for ( i = 0; i < spawnPoints.size; i++ )
	{
	cur_origin = spawnPoints[i] getorigin();
	spawnPoints[i].origin = ( cur_origin+(0,0,1024) );
	}
}

trap2()
{
	trig = getent("trap2_trig", "targetname");
	brush = getent("brush1", "targetname");
	brush2 = getent("brush2", "targetname");
	trig waittill("trigger", player);
	trig delete();
	x = randomInt(2);
	
		if(x == 0)
			brush notSolid();
		else
			brush2 notsolid();
}

trap1()
{
	trig = getent("trap1_trig", "targetname");
	brush = getent("brush3", "targetname");
	brush2 = getent("brush4", "targetname");
	brush3 = getent("brush5", "targetname");
	trig waittill("trigger", player);
	trig delete();
	x = randomInt(4); //change the ones you want solid or not.
		if(x == 0)
			brush notsolid();
		else if(x == 1)
			brush2 notsolid();
		else if(x == 2)
			brush3 notsolid();
		else
		{
		brush notsolid();
		brush3 notsolid();
		}
}

trap3()
{
	trig = getent("trap3_trig", "targetname");
	brush = getent("brush6", "targetname");
	trig waittill("trigger", player);
	trig delete();
		for(;;)
		{
		brush rotateyaw(360, 3); //3 is the time it takes to do 1 rotation (so it's like the speed), change if you want
		wait 1;
		}
}

trap4()
{
	trig = getent("trap4_trig", "targetname");
	brush = getent("brush7", "targetname");
	trig waittill("trigger", player);
	trig delete();
	brush notsolid();
}

trap5()
{
	trig = getent("trap5_trig", "targetname");
	brush = getent("brush8", "targetname");
	trig waittill("trigger", player);
	trig delete();
	brush notsolid();
	brush hide();
	wait randomint(8);
	brush solid();
	brush show();
}

trap6()//play around with the timeing to get speed you want
{
	trig = getent("trap6_trig", "targetname");
	trig waittill("trigger", player);
	trig delete();
	thread trap6a();
	thread trap6b();
}

trap6a()
{
	brush = getent("brush9", "targetname");
	brush movez (100,1);
	brush waittill("movedone");
		for(;;)
		{
		brush movez (-200,2);
		brush waittill("movedone");
		brush movez (200,2);
		brush waittill("movedone");
		}
}

trap6b()
{
	brush2 = getent("brush10", "targetname");
	brush2 movez (-50,1);
	brush2 waittill("movedone");
		for(;;)
		{
		brush2 movez (200,2);
		brush2 waittill("movedone");
		brush2 movez (-200,2);
		brush2 waittill("movedone");
		}
}

trap7()
{
     trig = getent("trap7_trig", "targetname");
	 trig waittill("trigger");
	 trig delete();
	 thread trap7a();
	 thread trap7b();
}

trap7a()
{
     brush = getent("brush12", "targetname");
	 brush movex(-128,1);
	 brush waittill("movedone");
		while(1)
		{
		brush rotatepitch (360,7.5);
		wait 12.5;
		}
}

trap7b()
{
     brush2 = getent("brush13", "targetname");
	 brush2 movex(128,1);
	 brush2 waittill("movedone");
		while(1)
		{
		brush2 rotatepitch (-360,7.5);
		wait 12.5;
		}
}

old()
{
	level.old_trig = getent("old", "targetname");
	brush = getent("old_door", "targetname");
	level.old_trig waittill("trigger", player);
	brush delete();
	level.sniper_trig delete();
	level.knife_trig delete();
}

sniper()
{
     level.sniper_trig = getEnt( "sniper", "targetname");
     sjump = getEnt( "jumps", "targetname" );
     sacti = getEnt( "actis", "targetname" );
	 
	 if( !isDefined( level.sniper_trig ) )
         return;
		 
	 while(1)
	 {
		level.sniper_trig waittill( "trigger", player );
		
		if(!isdefined(level.firstenter))
			level.firstenter=false;
			
		if(level.firstenter==false)
		{
		 level.old_trig delete();
		 level.knife_trig delete();
		 level.firstenter=true;
		}
			level.activ freezeControls(1);
			player FreezeControls(1);
			
			player SetPlayerAngles( sjump.angles );
			player setOrigin( sjump.origin );
			level.activ setPlayerangles( sacti.angles );
			level.activ setOrigin( sacti.origin );
			level.activ TakeAllWeapons();
			player TakeAllWeapons();
			
			level.activ giveweapon( "m40a3_mp");
			player giveweapon( "m40a3_mp");
			player switchToWeapon( "m40a3_mp" );
			level.activ SwitchToWeapon( "m40a3_mp" );
			player giveMaxAmmo( "m40a3_mp" );
			level.activ giveMaxAmmo( "m40a3_mp" );
			
			level.activ freezeControls(1);
			player FreezeControls(1);
			
					noti = SpawnStruct();
					noti.titleText = "Sniper Fight";
					noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
					noti.duration = 6;
					noti.glowcolor = (0, 0, 1.0);
					
					players = getEntArray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					
			wait 2;
			
			level.activ FreezeControls(0);
			player FreezeControls(0);
			
			wait 0.1;
                     
			while(isAlive(player))
				wait 1;

		}
}

knife()
{
     level.knife_trig = getEnt( "knife", "targetname");
     kjump = getEnt( "jumpk", "targetname" );
     kacti = getEnt( "actik", "targetname" );
	 
	if( !isDefined( level.knife_trig ) )
         return;
		 
	 while(1)
	 {
		level.knife_trig waittill( "trigger", player );
		
		if(!isdefined(level.firstenter))
			level.firstenter=false;
			
		if(level.firstenter==false)
		{
		 level.old_trig delete();
		 level.sniper_trig delete();
		 level.firstenter=true;
		}
			level.activ freezeControls(1);
			player FreezeControls(1);
			
			player SetPlayerAngles( kjump.angles );
			player setOrigin( kjump.origin );
			level.activ setPlayerangles( kacti.angles );
			level.activ setOrigin( kacti.origin );
			level.activ TakeAllWeapons();
			player TakeAllWeapons();
			
			level.activ giveweapon( "tomahawk_mp");
			player giveweapon( "tomahawk_mp");
			player switchToWeapon( "tomahawk_mp" );
			level.activ SwitchToWeapon( "tomahawk_mp" );
			
			level.activ freezeControls(1);
			player FreezeControls(1);
			
					noti = SpawnStruct();
					noti.titleText = "Knife Fight";
					noti.notifyText = level.activ.name + " ^1VS^7 " + player.name;
					noti.duration = 6;
					noti.glowcolor = (0, 0, 1.0);
					
					players = getEntArray("player", "classname");
					for(i=0;i<players.size;i++)
						players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( noti );
					
			wait 2;
			
			level.activ FreezeControls(0);
			player FreezeControls(0);
			
			wait 0.1;
                     
			while(isAlive(player))
				wait 1;

		}
}