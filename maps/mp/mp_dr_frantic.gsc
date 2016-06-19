main()
{

	maps\mp\_load::main();
	
	precacheitem("ak47_mp");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1500");
	
	thread credit();
	thread trap0();
	thread trap1();
	thread trap2();
	thread trap3();
	thread trap4();
	thread trap5();
	thread trap6();
	thread trap7a();
	thread trap7b();
	thread trap8moving();
	thread trap8();
	thread trap9();
	thread trap9_moving();
	thread actidoor();
	thread Tilt();
	thread teleport_secret();
	thread secret1();
	thread secret2();
	thread secret3();
	thread secret4();
	thread secret5();
	thread secret6();
	thread secret7();
	thread secret8();
	thread start_door();
	thread final_sniper();
	thread final_knife();
	thread final_jump();
	thread jump_acti_tele();
	thread jump_jumper_tele();
	thread jump_givewep();
	thread addTestClients();
	
	
	addTriggerToList( "trap0trigger" );
	addTriggerToList( "trap1trigger" );
	addTriggerToList( "trap2trigger" );
	addTriggerToList( "trap3trigger" );
	addTriggerToList( "trap4trigger" );
	addTriggerToList( "trap6trigger" );
	addTriggerToList( "trap7trigger" );
	addTriggerToList( "trap8trigger" );
	addTriggerToList( "trap9trigger" );
}

start_door()

{
	door = getent("door","targetname");
	
	wait 9;
	
	ambientPlay("faint");
	
	wait 1;
	
	iPrintLnBold("^2Start door is opening, ^1move it!");
	door movez(90,3);
	door waittill ("movedone");
}

credit()
{
wait(2);
thread drawInformation( 800, 0.8, 1, "Frantic's map V0.02 Beta" );
wait(4);
thread drawInformation( 800, 0.8, 1, "© Frantic" );
wait(4);
thread drawInformation( 800, 0.8, 1, "^2Visit: www.clan-rs.tk" );
}

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


trap0()
{	
	trig = getEnt ("trap0trigger", "targetname");	
	hurt = getEnt ("trap0_spikeshurt", "targetname");	
	spikes = getEnt ("trap0", "targetname"); 

	hurt enablelinkto(); 
	hurt linkto (spikes); 

	trig waittill ("trigger");
	trig delete();
	{ 
		spikes moveZ (290,2);
		wait 5;
		spikes moveZ (-290,2);	
	}
}

trap1()
{
	trap1	= getent( "trap1", "targetname" );
	trap1a	= getent( "trap1a", "targetname" );
	trig	= getent( "trap1trigger", "targetname" );

	trig waittill ("trigger");
	trig delete();
	
	while (1)
	{
		trap1 rotateyaw (360, 0.8);
		trap1a rotateyaw (-360, 0.8);
		wait 1.3;
		
	}
}

trap2()
{
	trap2	= getent( "trap2", "targetname" );
	trig	= getent( "trap2trigger", "targetname" );

	trig waittill ("trigger");
	trig delete();
	
	while (1)
	{
		trap2 rotatepitch (360, 2);
		wait 2.8;
	}
}


trap3()
{	
trig = getEnt ("trap3trigger", "targetname");	
platform = getEnt ("trap3", "targetname"); 

trig waittill ("trigger");
trig delete();
{ 
platform moveZ (300,0.5);
wait 7;
platform moveZ (-300,3);
}
}

trap4()
{
trig = getent ("trap4trigger", "targetname");
trap = getent ("trap4", "targetname");

trig waittill ("trigger");
trig delete();
{
trap rotateyaw(90, 1);

}
}

trap5()
{
	trap5	= getent( "trap5", "targetname" );

	while (1)
	{
		trap5 rotateroll (360, 2);
		wait 2;
	}
}

trap6()
{	
trig = getEnt ("trap6trigger", "targetname");	
hurta = getEnt ("trap6_hurt_a", "targetname");
hurtb = getEnt ("trap6_hurt_b", "targetname");
hurtc = getEnt ("trap6_hurt_c", "targetname");
hurtd = getEnt ("trap6_hurt_d", "targetname");
hurte = getEnt ("trap6_hurt_e", "targetname");	
trap6a = getEnt ("trap6a", "targetname"); 
trap6b = getEnt ("trap6b", "targetname"); 
trap6c = getEnt ("trap6c", "targetname"); 
trap6d = getEnt ("trap6d", "targetname"); 
trap6e = getEnt ("trap6e", "targetname"); 

hurta enablelinkto(); 
hurta linkto (trap6a); 
hurtb enablelinkto(); 
hurtb linkto (trap6b); 
hurtc enablelinkto(); 
hurtc linkto (trap6c); 
hurtd enablelinkto(); 
hurtd linkto (trap6d); 
hurte enablelinkto(); 
hurte linkto (trap6e); 

trig waittill ("trigger");
trig delete();
{ 
trap6a moveZ (62,0.9);
trap6b moveZ (64,0.9);
trap6c moveZ (64,0.9);
trap6d moveZ (64,0.9);
trap6e moveZ (64,0.9);
wait 0.9;
trap6a moveZ (-62,0.9);
trap6b moveZ (-64,0.9);
trap6c moveZ (-64,0.9);
trap6d moveZ (-64,0.9);
trap6e moveZ (-64,0.9);
wait 0.9;
trap6a moveZ (62,0.9);
wait 0.9;
trap6b moveZ (64,0.9);
wait 0.9;

while (1)
{
trap6a moveZ (-62,0.9); 
trap6c moveZ (64,0.9); 
wait 0.9; 
trap6b moveZ (-64,0.9); 
trap6d moveZ (64,0.9); 
wait 0.9; 
trap6c moveZ (-64,0.9); 
trap6e moveZ (64,0.9); 
wait 0.9; 
trap6d moveZ (-64,0.9); 
trap6a moveZ (62,0.9); 
wait 0.9; 
trap6e moveZ (-64,0.9); 
trap6b moveZ (64,0.9); 
wait 0.9; 
trap6a moveZ (-62,0.9); 
trap6c moveZ (64,0.9); 
}
}
}

trap7a()
{
	trap7a = getent( "trap7a", "targetname" );
	
	while (1)
	{
		trap7a rotateyaw (360, 4);
		wait 4;
	}
}

trap7b()
{
	trap7b = getent( "trap7b", "targetname" );
	trap7c = getent( "trap7c", "targetname" );
	trig = getent( "trap7trigger", "targetname" );

	trig waittill ("trigger");
	trig delete();
	
	{
		trap7b moveY (64, 0.5);
		trap7c moveY (-64, 0.5);
	}
}

trap8moving()
{
	trap8movinga = getent( "trap8movinga", "targetname" );
	trap8movingb = getent( "trap8movingb", "targetname" );

	while (1)
	{
		trap8movinga moveY (-296,3);
		trap8movingb moveY (296,3);
		wait 3;
		trap8movinga moveY (296,3);
		trap8movingb moveY (-296,3);
		wait 3;
	}
}

trap8()
{
	trap8 = getent( "trap8", "targetname" );
	trig = getent( "trap8trigger", "targetname" );
	
	trig waittill ("trigger");
	trig delete();
	
	while (1)
	{
		trap8 moveZ(-64,0.3);
		wait 0.3;
		trap8 moveY(-432,2);
		wait 2;
		trap8 moveZ(64,0.3);
		wait 0.3;
		trap8 moveY(432,2);
		wait 2;
	}
}

trap9()
{
	trap9 = getEnt( "trap9", "targetname" );
	trig = getEnt( "trap9trigger", "targetname" );
	
	trig waittill ("trigger");
	trig delete();
	
	while (1)
	{
		trap9 moveX(240,1);
		wait 1.5;
		trap9 moveX(-240,1);
		wait 3;
	}
}

trap9_moving()
{
	trap9_moving = getEnt( "trap9_moving", "targetname" );
	
	while (1)
	{ 
		trap9_moving moveY(296,3);
		wait 3;
		trap9_moving moveY(-296,3);
		wait 3;
	}
}

actidoor()
{
	door = getEnt( "acti_door", "targetname" );
	level.old_trig = getEnt( "old_trigger", "targetname" );
    
    while(1)
    {
        level.old_trig waittill( "trigger", player );
        if( !isDefined( level.old_trig ) )
            return;
        
        level.snip_trig delete();
		level.knife_trig delete();
		level.jump_trig delete();
		
		door moveZ(-130,3);
		
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1OLD!" );     //change to what you want it to be

    }
}

Tilt()
{
	tilt_a = getEnt( "tilta", "targetname" );
	tilt_b = getEnt( "tiltb", "targetname" );
	tilt_c = getEnt( "tiltc", "targetname" );
	tilt_d = getEnt( "tiltd", "targetname" );
	tilt_e = getEnt( "tilte", "targetname" );
	tilt_f = getEnt( "tiltf", "targetname" );
	tilt_g = getEnt( "tiltg", "targetname" );
	tilt_h = getEnt( "tilth", "targetname" );
	
	while (1)
	{ 
		tilt_b moveX(128,0.4);
		tilt_d MoveX(128,0.4);
		tilt_f moveY(128,0.4);
		tilt_h moveY(128,0.4);
		wait 0.8;
		tilt_b moveX(-128,0.4);
		tilt_d moveX(-128,0.4);
		tilt_f moveY(-128,0.4);
		tilt_h moveY(-128,0.4);
		tilt_a moveX(128,0.4);
		tilt_c moveX(128,0.4);
		tilt_e moveX(128,0.4);
		tilt_g moveY(128,0.4);
		wait 0.8;
		tilt_a moveX(-128,0.4);
		tilt_c moveX(-128,0.4);
		tilt_e moveX(-128,0.4);
		tilt_g moveY(-128,0.4);
		
	}
}

move()
{
	platform = getEnt( "tilt_move", "targetname" );
	
	while (1)
	{
		platform moveY(-352,1);
		wait 2;
		platform moveY(352,1);
		wait 2;
	}
}

teleport_secret()
{
	trig = getEnt ("teleport_secret", "targetname");
	target = getEnt ("teleport_secret_target", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player iprintlnbold ("Welcome to the secret");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret1()
{
	trig = getEnt ("secret_1", "targetname");
	target = getEnt ("teleport_secret_target", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret2()
{
	trig = getEnt ("secret_2", "targetname");
	target = getEnt ("origin2", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret3()
{
	trig = getEnt ("secret_3", "targetname");
	target = getEnt ("origin3", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
		
secret4()
{
	trig = getEnt ("secret_4", "targetname");
	target = getEnt ("origin4", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret5()
{
	trig = getEnt ("secret_5", "targetname");
	target = getEnt ("origin5", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret6()
{
	trig = getEnt ("secret_6", "targetname");
	target = getEnt ("origin6", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}
		
secret7()
{
	trig = getEnt ("secret_7", "targetname");
	target = getEnt ("origin7", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

secret8()
{
	trig = getEnt ("secret_8", "targetname");
	target = getEnt ("origin8", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		iprintlnbold("^2finished secret!");
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

addTriggerToList( name )
{
    if( !isDefined( level.trapTriggers ) )
        level.trapTriggers = [];
    level.trapTriggers[level.trapTriggers.size] = getEnt( name, "targetname" );
} 

final_knife()
{
    level.knife_trig = getEnt( "knife_trig", "targetname");
    jump = getEnt( "final_jumper_knife", "targetname" );
    acti = getEnt( "final_acti_knife", "targetname" );
    
    while(1)
    {
        level.knife_trig waittill( "trigger", player );
        if( !isDefined( level.knife_trig ) )
            return;
        
        level.snip_trig delete();
		level.old_trig delete();
		level.jump_trig delete();
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "tomahawk_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "tomahawk_mp" );        
        wait 0.05;
        player switchToWeapon( "tomahawk_mp" ); //activator weapon
        level.activ SwitchToWeapon( "tomahawk_mp" );
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1KNIFE!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

final_jump()
{
    level.jump_trig = getEnt( "jump_trig", "targetname");
    jump = getEnt( "final_jumper_jump", "targetname" );
    acti = getEnt( "final_acti_jump", "targetname" );
    
    while(1)
    {
        level.jump_trig waittill( "trigger", player );
        if( !isDefined( level.jump_trig ) )
            return;
        
        level.snip_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "knife_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "knife_mp" );        
        wait 0.05;
        player switchToWeapon( "knife_mp" ); //activator weapon
        level.activ SwitchToWeapon( "knife_mp" );
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1JUMP!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

final_sniper()
{
    level.snip_trig = getEnt( "snip_trig", "targetname");
    jump = getEnt( "final_jumper_sniper", "targetname" );
    acti = getEnt( "final_acti_sniper", "targetname" );
    
    while(1)
    {
        level.snip_trig waittill( "trigger", player );
        if( !isDefined( level.snip_trig ) )
            return;
        
        level.jump_trig delete();
		level.old_trig delete();
		level.knife_trig delete();
        
        player SetPlayerAngles( jump.angles );
        player setOrigin( jump.origin );
        player TakeAllWeapons();
        player GiveWeapon( "m40a3_mp" ); //jumper weapon        
        level.activ setPlayerangles( acti.angles );
        level.activ setOrigin( acti.origin );
        level.activ TakeAllWeapons();
        level.activ GiveWeapon( "m40a3_mp" );        
        wait 0.05;
        player switchToWeapon( "m40a3_mp" ); //activator weapon
        level.activ SwitchToWeapon( "m40a3_mp" );
        iPrintlnBold( " ^2" + player.name + " HAS CHOSEN ^1SNIPPER!" );     //change to what you want it to be
        while( isAlive( player ) && isDefined( player ) )
            wait 1;
    }
}

jump_acti_tele()
{
	trig = getEnt ("jump_acti_tele", "targetname");
	target = getEnt ("final_acti_jump", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_jumper_tele()
{
	trig = getEnt ("jump_jumper_tele", "targetname");
	target = getEnt ("final_jumper_jump", "targetname");
	
	for(;;)
	{
		trig waittill ("trigger", player);
		
		player SetOrigin(target.origin);
		player SetPlayerAngles( target.angles );
	}
}

jump_givewep()
{
weapon = getent ("jump_givewep" , "targetname");
weapon waittill("trigger",player);

player GiveWeapon( "ak47_mp" );
wait 0.01;
player SwitchToWeapon( "ak47_mp" );
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