main()
{
	maps\mp\_load::main();
	
	ambientPlay("ambient_backlot_ext");
	
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
	maps\mp\_compass::setupMiniMap("compass_map_mp_deathrun_takecare");
	setdvar("compassmaxrange","2000");
    thread platfrm ();
	thread trap1 () ;
	thread hiddingtraps () ;
	thread trap3 () ;
	thread trap4 ();
	thread trap5() ;
	thread trap6 () ;
    thread trap7 () ;
	thread trap8 () ;
	thread noneedforactive () ;
	thread doora () ;
	
	thread AntiGlitch();
}
    
	platfrm ()
	 {
	   plat = getEnt ("platform" , "targetname");
	      while (1)
		   {
		   plat moveY (-300 , 2 );
		   wait 2.5 ;
		   plat moveY (300 , 2 );
		   wait 2.5 ;
		   }
	 }
	 
	 trap1 ()
	   {
	   killtrigger = getEnt ("kill_1" , "targetname" ) ;
	   trig = getEnt ("trig_1" , "targetname" ) ;
	   trp1 = getEnt ("trap_1" , "targetname" ) ;
	     trig waittill ("trigger" , player );
		 trig delete () ;
		 killtrigger EnableLinkTo () ;
		 killtrigger linkto (trp1);
		 trp1 moveX ( -196 , 2 ) ;
		 wait 4;
		 trp1 moveX ( 196 , 2 ) ; 
	   }
	   
	   hiddingtraps () 
	      {
		  trig2 = getent ( "trig_2" , "targetname" ) ;
		  half_1= getentarray ( "half_1","targetname" ) ;
		  half_2 = getentarray ( "half_2" , "targetname");
		  trig2 waittill ("trigger", player );
		  trig2 delete ();
		  half_1[randomInt(half_1.size)] delete();
          half_2[randomInt(half_2.size)] delete();

		  }
		  
		  trap3 ()
		   {
		   trig3 = getent ( "trig_3" , "targetname" );
		   trp3 = getent ("trap_3" , "targetname");
		   trig3 waittill ("trigger" , player );
		   trig3 delete ();
		   trp3 rotatepitch (1800 , 12  );
		   wait 1 ;
		   }
		   
		   trap4 ()
		    {
	          killtrig = getEnt ( "killa" , "targetname");
			  trp4 = getent ( "trap_4" , "targetname" ) ;
			  trig4 = getent ("trig_4" , "targetname" ) ;
			  trig4 waittill ("trigger" , player );
			  trig4 delete () ;
			  killtrig enablelinkto () ;
			  killtrig linkto (trp4) ;
			  trp4 movez (-168 , 1);
			  wait 3 ;
			  trp4 movez (168 , 4 );
			}
			
			trap5()
			{
			trig5 = getent ("trig_5" , "targetname" );
			trap5_a = getent ("trap_5_1" , "targetname" );
			trap5_b = getent ("trap_5_2" , "targetname");
			trig5 waittill ("trigger",player);
			trig5 delete ();
			trap5_a rotatepitch (-90 , 0.5 );
			trap5_b rotatepitch (90 , 0.5 );
			wait 4 ;
			trap5_a rotatepitch (90 , 0.5 );
			trap5_b rotatepitch (-90 , 0.5 );
			wait 1;
			}
			
			trap6 ()
			{
			trig6 = getent ("trig_6" , "targetname");
			trp6_1 = getent ("trap_6_1" , "targetname");
			trp6_2 = getent ("trap_6_2" , "targetname");
			trig6 waittill ("trigger", player);
			trig6 delete ();
			trp6_1 movez (150, 1);
			trp6_2 movez (-150 , 1);
			wait 2 ;
			trp6_1 movez (-150,1);
			trp6_2 movez (150,1);
			wait 2 ;
			trp6_1 movez (-150, 1);
			trp6_2 movez (150 , 1);
			wait 2;
			trp6_1 movez (150,1);
			trp6_2 movez (-150,1);
			wait 2 ;
			}
			
			trap7 ()
			{
			  trig7 = getent ("trig_7" ,"targetname");
			  trp7 = getent ("trap_7","targetname");
			  kill1 = getent ("killzone","targetname");
			  trig7 waittill ("trigger",player);
			  trig7 delete ();
			  kill1 enablelinkto ();
			  kill1 linkto (trp7);
			  trp7 rotatepitch (-180 , 1.5 );
			  wait 5;
			  trp7 rotatepitch (180 , 2 );
			  wait 5;
			}
			noneedforactive ()
			{
			push1 = getent ("pusher1","targetname" );
			push2 = getent ("pusher2","targetname" );
			push3 = getent ("pusher3","targetname" );
			push4 = getent ("pusher4","targetname" );
			push1 rotatepitch (45 ,0.5);
			push2 rotatepitch (-45 ,0.5);
			push3 rotatepitch (45 ,0.5);
			push4 rotatepitch (-45 ,0.5);
			wait 0.5;
			while (1) 
			{
			
			push1 rotatepitch (-90 ,1);
			push2 rotatepitch (90 ,1);
			push3 rotatepitch (-90 ,1);
			push4 rotatepitch (90 ,1);
			wait 1;
			push1 rotatepitch (90 ,1);
			push2 rotatepitch (-90 ,1);
			push3 rotatepitch (90 ,1);
			push4 rotatepitch (-90 ,1);
			wait 1 ;
			}
			}
			
			trap8 ()
			{
			part1 = getentarray ("part_1" ,"targetname");
			part2 = getentarray ("part_2" ,"targetname");
			trig8 = getent ("trig_8" , "targetname");
			trig8 waittill ("trigger" , player );
			trig8 delete ();
			part1[randomInt(part1.size)] notsolid();
            part2[randomInt(part2.size)] notsolid();
			
			}
			
			doora ()
			{
			trigdoor = getent ("dooropen" , "targetname");
			dooro = getent ("door" ,"targetname" );
			trigdoor waittill ("trigger",player);
			trigdoor delete ();
			dooro movez (98 , 1.1);
			wait 1 ;
			}
			
AntiGlitch()
{
	level endon("game over");

	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( isAlive( players[i] ) && isDefined( players[i].pers["team"] ) && players[i].pers["team"] != "spectator" )
			{
				if( players[i].origin[2] < -70 )
					players[i] suicide();
				else if( ( Distance( players[i].origin, (870,790,360) ) <= 500 && players[i].origin[2] >= 320 ) || players[i].origin[2] >= 470 )
					players[i] suicide();
			}
		}
		wait 0.1;
	}
}