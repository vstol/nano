main()
{
	thread secret_trig();
}

secret_trig()
{
	level.all_trig = getEnt("musictrig","targetname");
	level.all_trig setHintstring("^1[^3Activate All^1]");
	level.all_trig setcursorhint("HINT_ACTIVATE");
	level.all_trig waittill("trigger",player);
	level.all_trig delete();
	iprintlnbold("^1"+player.name+"^7 has activated all Traps!");
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7();
	thread trap8();
	thread trap9();
	thread trap10();
	thread trap11();
	thread trap12();
	thread trap13();
	thread trap14();
	thread trap15();

}

// Traps
trap1()
{
	trap = getEnt("trap1_rotaty1", "targetname");
	atrap = getEnt("trap1_rotaty2", "targetname");

	level.trig_1 delete(); 
	level.effect1 delete();
	while(1)
	{
		trap rotatePitch(360, 2);
		atrap rotateRoll(360, 2);
		wait .1;
	}
}

trap2()
{
	trap = getEnt("trap2_delete", "targetname");
	atrap = getEnt("trap2_dick1", "targetname");
	btrap = getEnt("trap2_dick2", "targetname");

	level.trig_2 delete();
	level.effect2 delete();

	trap delete();
	atrap rotatePitch(90,2);
	btrap rotatePitch(-90,2);

	while(1)
	{
		atrap moveZ(72,2);
		wait 1;
		btrap moveX(-100,1);
		wait 2;
		atrap rotateYaw(360,2);
		btrap rotateYaw(-360,2);
		wait 3;
		atrap moveZ(-72,1);
		btrap moveX(100,1);
		wait 3;
	}
}

trap3()
{
	atrap = getEnt("trap3_rotate1", "targetname");
	btrap = getEnt("trap3_rotate2", "targetname");
	level.trig_3 delete();
	level.effect3 delete();

	while(1)
	{
		atrap rotatePitch(360,2);
		wait 5;
		btrap rotatePitch(360,2);
		wait 5;
	}
}

trap4()
{
	atrap = getEnt("atrap4", "targetname");
	btrap = getEnt("btrap4", "targetname");
	ctrap = getEnt("ctrap4", "targetname");

	level.trig_4 delete();
	level.effect4 delete();

	while(1)
	{
		atrap rotatePitch(360, 5);
		wait 3;
		btrap rotatePitch(360, 5);
		wait 3;
		ctrap rotatePitch(360, 5);
		wait 3;
	}
}

trap5()
{
	level.posion_trig = getEnt("poison","targetname");
	linker = getEnt("linker","targetname");

	level.trig_5 delete();
	level.effect5 delete();

	level.posion_trig enableLinkTo ();
	level.posion_trig LinkTo ( linker );
	
	playFx ( level.poison,(-2792, -4360, -3864));
	wait 1;	
	linker moveZ ( 32, 1);
	wait 12;	
	linker moveZ ( -32, 1);
}
trap5_poison()
{
	level.posion_trig waittill("trigger",player);
	wait 0.05;
	player shellShock( "frag_grenade_mp", 6 );
	wait 0.5;		
	player freezeControls(1);
	wait 5;		
	player freezeControls(0);
	wait 0.05;		
	player suicide();
}

trap6()
{
	atrap = getEnt("trap6a", "targetname");
	a1trap = getEnt("trap6a1", "targetname");
	btrap = getEnt("trap6b", "targetname");
	b1trap = getEnt("trap6b1", "targetname");
	ctrap = getEnt("trap6c", "targetname");
	c1trap = getEnt("trap6c1", "targetname");

	level.trig_6 delete();
	level.effect6 delete();
	thread rotatehurt();

	while(1)
	{
		atrap rotatePitch(360,2);
		a1trap rotatePitch(-360,2);
		wait 2;
		btrap rotatePitch(360,2);
		b1trap rotatePitch(-360,2);
		wait 2;
		ctrap rotatePitch(360,2);
		c1trap rotatePitch(-360,2);
		wait 2;
	}
}
rotatehurt()
{
	dtrap = getEnt("trap6d", "targetname");
	d1trap = getEnt("trap6d1", "targetname");
	hurt = getEnt("trap6h", "targetname");
	hurt1 = getEnt("trap6h1", "targetname");

	hurt enablelinkto();
	hurt1 enablelinkto();

	hurt linkto(dtrap);
	hurt1 linkto(d1trap);

	while(1)
	{
		dtrap rotatepitch(360,3);
		d1trap rotatepitch(-360,3);
		wait 1;
	}
}

trap7()
{
	atrap = getEnt("trap7a", "targetname");
	btrap = getEnt("trap7b", "targetname");
	ctrap = getEnt("trap7c", "targetname");
	htrap1 = getEnt("trap7h","targetname");
	htrap2 = getEnt("trap7h2","targetname");
	htrap3 = getEnt("trap7h3","targetname");

	level.trig_7 delete();
	level.effect7 delete();
	thread trap7moves();

	while(1)
	{
		atrap rotateyaw(360,1);
		btrap rotateyaw(-360,1);
		ctrap rotateyaw(360,1);
		wait .1;
	}
}
trap7moves()
{
	atrap = getEnt("trap7a", "targetname");
	btrap = getEnt("trap7b", "targetname");
	ctrap = getEnt("trap7c", "targetname");
	htrap1 = getEnt("trap7h","targetname");
	htrap2 = getEnt("trap7h2","targetname");
	htrap3 = getEnt("trap7h3","targetname");

	htrap1 enablelinkto();
	htrap2 enablelinkto();
	htrap3 enablelinkto();

	htrap1 linkto(atrap);
	htrap2 linkto(btrap);
	htrap3 linkto(ctrap);

	while(1)
	{
		atrap movez(80,2);
		wait 2;
		atrap movex(-440,2);
		btrap movex(232,2);
		ctrap movex(232,2);
		wait 2;
		atrap movez(-80,2);
		btrap movez(80,2);
		wait 2;
		btrap movex(-440,2);
		atrap movex(232,2);
		ctrap movex(232,2);
		wait 2;
		btrap movez(-80,2);
		ctrap movez(80,2);
		wait 2;
		ctrap movex(-440,2);
		atrap movex(232,2);
		btrap movex(232,2);
		wait 2;
		ctrap movez(-80,2);
		wait 2;
	}
}

trap8()
{
	atrap = getEnt("trap8", "targetname");
	htrap = getEnt("trap8h","targetname");

	level.trig_8 delete();
	level.effect8 delete();

	htrap enablelinkto();
	htrap linkto(atrap);

	while(1)
	{
		atrap rotateYaw(360,2);
		wait .1;
	}
}

trap9()
{
	atrap = getEnt("trap9", "targetname");
	btrap = getEnt("trap9a","targetname");
	ctrap = getEnt("trap9b","targetname");

	btrap hide();
	ctrap hide();


	level.trig_9 delete();
	level.effect9 delete();

	atrap delete();
	btrap show();
	ctrap show();

	while(1)
	{
		btrap movey(190,1.5);
		ctrap movey(-190,1.5);
		wait 3;
		btrap movey(-190,1.5);
		ctrap movey(190,1.5);
		wait 3;
	}
}

trap10()
{
	atrap = getEnt("trap10", "targetname");


	level.trig_10 delete();
	level.effect10 delete();

	playFx ( level.explosion,(-4456, -8472, -3768));
	wait 0.1;
	atrap delete();
	playFx ( level.mine,(-4456, -8472, -3768));
	wait 0.1;
	earthquake ( 1, 1, (-4456, -8472, -3768), 500 );
	wait 0.1;
	
	players = getEntArray( "player", "classname" );	
    for(k=0;k<players.size;k++)
    {
	    dist = Distance2D(players[k].origin, (-4456, -8472, -3768));
	    if(dist < 100)
	    {
		    players[k] suicide();
	    }
	    else if(dist < 140)
	    {
		    RadiusDamage( players[k].origin, 10, 60, 40);
	    }
	    else if(dist < 180)
	    {
		    RadiusDamage( players[k].origin, 10, 30, 10);
		}
	}
}

trap11()
{
	atrap = getEnt("trap11", "targetname");
	bridge = getEnt("trap11_bridge","targetname");

	atrap hide();

	level.trig_11 delete();
	level.effect11 delete();
	atrap show();

	atrap movez(-368,3);
	wait 3;
	atrap movez(-272,3);
	bridge movez(-110,3);
	bridge rotateroll(20,3);
	wait 3;
	atrap delete();
}

trap12()
{

	atrap = getEnt("trap12a", "targetname");
	btrap = getEnt("trap12b","targetname");

	level.trig_12 delete();
	level.effect12 delete();

	atrap delete();
	while(1)
	{
		btrap movez(-150,3);
		wait 2;
		btrap movez(150,3);
		wait 2;
	}
}

trap13()
{
	atrap = getEnt("trap13", "targetname");
	htrap = getEnt("trap13h","targetname");

	level.trig_13 delete();
	level.effect13 delete();

	htrap enablelinkto();
	htrap linkto(atrap);

	atrap movez(40,1);
	wait 6;
	atrap movez(-40,1);
}

trap14()
{
	atrap = getEnt("trap14a", "targetname");
	btrap = getEnt("trap14b","targetname");
	level.trig_14 delete();
	level.effect14 delete();

	while(1)
	{
		atrap hide();
		atrap notsolid();
		btrap show();
		btrap solid();
		wait 2;
		atrap show();
		atrap solid();
		btrap hide();
		btrap notsolid();
		wait 2;
	}
}

trap15()
{
 	amove = getEnt("mapmover2a","targetname");
	bmove = getEnt("mapmover2b","targetname");

	level.trig_15 delete();
	level.effect15 delete();

	while(1)
	{
		amove hide();
		bmove hide();
		wait 4;
		amove show();
		bmove show();
		wait 4;
	}
}