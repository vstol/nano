main()
{
	maps\mp\_load::main();
	maps\createfx\mp_deathrun_zero_fx::main();
	maps\mp\mp_deathrun_zero_fx::main();
	
	maps\mp\mp_deathrun_zero\fx_load::main();
	maps\mp\mp_deathrun_zero\teleport::main();
	maps\mp\mp_deathrun_zero\teleport2::main();//pridat hlasku o dverich
	maps\mp\mp_deathrun_zero\door::main();
	maps\mp\mp_deathrun_zero\population::main();
	
	maps\mp\mp_deathrun_zero\traps\rotor1::main();
	maps\mp\mp_deathrun_zero\traps\rotor2::main();
	maps\mp\mp_deathrun_zero\traps\mackac1::main();
	maps\mp\mp_deathrun_zero\traps\mackac2::main();
	maps\mp\mp_deathrun_zero\traps\blesky1::main();//dodelat
	maps\mp\mp_deathrun_zero\traps\fire1::main();//dodelat
	maps\mp\mp_deathrun_zero\traps\propadlo::main();
	
	maps\mp\mp_deathrun_zero\auto\mover1::main();
	maps\mp\mp_deathrun_zero\auto\tlacic1::main();
	maps\mp\mp_deathrun_zero\auto\fan1::main();
	maps\mp\mp_deathrun_zero\auto\fan2::main();
	maps\mp\mp_deathrun_zero\auto\pady1::main();//dodelat
	
	//maps\mp\_compass::setupMiniMap("compass_map_mp_deathrun_zero");

	//setExpFog(500, 2200, 0.81, 0.75, 0.63, 0);
	VisionSetNaked( "mp_deathrun_zero" );
	ambientPlay("music_zero");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar("compassmaxrange","2000");
	
	level.trapTriggers = [];
	level.trapTriggers[level.trapTriggers.size] = getEnt( "tmackac1", "targetname" );
    level.trapTriggers[level.trapTriggers.size] = getEnt( "tfire1", "targetname" );
    level.trapTriggers[level.trapTriggers.size] = getEnt( "trotor1", "targetname" );
    level.trapTriggers[level.trapTriggers.size] = getEnt( "tblesky1", "targetname" );
    level.trapTriggers[level.trapTriggers.size] = getEnt( "trotor2", "targetname" );
    level.trapTriggers[level.trapTriggers.size] = getEnt( "tmackac2", "targetname" );
    level.trapTriggers[level.trapTriggers.size] = getEnt( "tpropadlo1", "targetname" );
	level.trapTriggers[level.trapTriggers.size] = getEnt( "tpropadlo2", "targetname" );
	
	thread AntiGlitch();
	thread maps\mp\_wallbang::init();
}

AntiGlitch()
{
	level endon("game over");
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( isAlive( players[i] ) && isDefined( players[i].pers["team"] ) &&players[i].pers["team"] != "spectator" )
			{
				if( players[i].origin[2] >= 380 || players[i].origin[2] < -620 )
					players[i] suicide();
				else if( Distance( players[i].origin, (-1860,-1020,350) ) <= 500 && players[i].origin[2] > 320 )
					players[i] suicide();
			}
		}
		wait 0.1;
	}
}