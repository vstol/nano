//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 
init( modVersion )
{
	level.fx["glow"] = loadFx( "props/glow_latern" );
	map=getDvar("mapname");
	level thread antiGlitch(map);
}

antiGlitch(map)
{
	wait 0.5;
	switch(map)
	{
		case "mp_deathrun_framey_v2":
			thread framey_v2();
			thread printmap(map);
			break;
		case "mp_deathrun_framey_v3":
			thread framey_v3();
			thread printmap(map);
			break;
		case "mp_dr_darmuhv2":
			thread darmuh_v2();
			thread printmap(map);
			break;
		case "mp_deathrun_wipeout_v2":
			thread wipeout_v2();
			thread printmap(map);
			break;
		case "mp_deathrun_saw":
			thread saw();
			thread printmap(map);
			break;
		case "mp_deathrun_mine":
			level.callbackPlayerDamage = ::Callback_PlayerDamage;
			thread mine();
			thread printmap(map);
			break;
		case "mp_dr_bananaphone_v2":
			level.callbackPlayerDamage = ::Callback_PlayerDamage;
			thread bananaphone_v2();
			thread printmap(map);
			break;
		case "mp_dr_indipyramid":
			thread indipyramid();
			thread printmap(map);
			break;
		case "mp_deathrun_wipeout":
			thread wipeout_v1();
			thread printmap(map);
			break;
		case "mp_dr_sm_world":
			level.callbackPlayerDamage = ::Callback_PlayerDamage;
			thread printmap(map);
			break;
		case "mp_dr_up":
			level.callbackPlayerDamage = ::Callback_PlayerDamage;
			thread printmap(map);
			break;
		default: 
			iprintln("^2anti-glitch^7: not available for this map");
			break;
	}	
}

printmap(mapname)
{
	iprintln("^2Anti-Glitch^7: loaded(" +mapname +")");
}

framey_v2()
{
	elevator_glitch = (2802,-467,633);	
	roof_glitch = (2174,1450,700);
	roof_glitch2 = (2174,1300,700);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( (Distance( players[i].origin, elevator_glitch ) <= 250 || Distance( players[i].origin, roof_glitch ) <= 175 || Distance( players[i].origin, roof_glitch2 ) <= 175 ) && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , elevator_glitch );
		playFx( level.fx["glow"] , roof_glitch );
		playFx( level.fx["glow"] , roof_glitch2 );
	}
}

framey_v3()
{
	rotator_glitch = (-329,7100,681);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, rotator_glitch ) <= 400 && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , rotator_glitch );
	}
}


darmuh_v2()
{
	bounce_glitch = (2022,0,-700);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, bounce_glitch ) <= 120 && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , bounce_glitch );
	}
}

wipeout_v2()
{
	end_glitch = (2680,3744,97);
	end_glitch1 = (2680,3400,97);
	end_glitch2 = (2680,4000,97);
	
	end_glitch3 = (2941,3744,97);
	end_glitch4 = (2941,3400,97);
	end_glitch5 = (2941,4000,97);
	
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( ( Distance( players[i].origin, end_glitch ) <= 200 || Distance( players[i].origin, end_glitch1 ) <= 200 || Distance( players[i].origin, end_glitch2 ) <= 200 || Distance( players[i].origin, end_glitch3 ) <= 200 || Distance( players[i].origin, end_glitch4 ) <= 200 || Distance( players[i].origin, end_glitch5 ) <= 200 ) && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , end_glitch );
		playFx( level.fx["glow"] , end_glitch1 );
		playFx( level.fx["glow"] , end_glitch2 );
		playFx( level.fx["glow"] , end_glitch3 );
		playFx( level.fx["glow"] , end_glitch4 );
		playFx( level.fx["glow"] , end_glitch5 );
	}
}

saw()
{
	edge_glitch = (-289,-1175,381);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, edge_glitch ) <= 100 && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , edge_glitch );
	}
}

mine()
{
	roof_glitch = (167,789,450);
	roof_glitch2 = (167,603,450);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( ( Distance( players[i].origin, roof_glitch ) <= 200 || Distance( players[i].origin, roof_glitch2 ) <= 200 ) && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , roof_glitch );
		playFx( level.fx["glow"] , roof_glitch2 );
	}
}

bananaphone_v2()
{
	platform_glitch = (2249,1570,345);
	platform_glitch2 = (2249,1490,345);
	platform_glitch3 = (2249,1410,345);
	platform_glitch4 = (2249,1330,345);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( ( Distance( players[i].origin, platform_glitch ) <= 50 || Distance( players[i].origin, platform_glitch2 ) <= 50 || Distance( players[i].origin, platform_glitch3 ) <= 50 || Distance( players[i].origin, platform_glitch4 ) <= 50 )  && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , platform_glitch );
		playFx( level.fx["glow"] , platform_glitch2 );
		playFx( level.fx["glow"] , platform_glitch3 );
		playFx( level.fx["glow"] , platform_glitch4 );
	}
}

indipyramid()
{
	edge_glitch = (-1440,-361,-100);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, edge_glitch ) <= 120 && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , edge_glitch );
	}
}

wipeout_v1()
{
	rotator_glitch = (1938,1922,227);
	while(1)
	{
		players = getentarray("player", "classname");
		for(i=0;i<players.size;i++)
		{
			if( Distance( players[i].origin, rotator_glitch ) <= 200 && isAlive(players[i]) && !players[i].iscaught)
				players[i] thread glitcherCaught();
		}
		wait 0.05;
		playFx( level.fx["glow"] , rotator_glitch );
	}
}



//////////////anti wallbang//////////////////
Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isDefined(eAttacker) && isPlayer(eAttacker))
	{
		if(!SightTracePassed( eAttacker Geteye(), self.origin + (0, 0, getHitLocHeight(sHitloc)), false, undefined))
			return;
	}
	
	self braxi\_mod::PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
}

getHitLocHeight(sHitLoc)
{
	switch(sHitLoc)
	{
		case "helmet":
		case "head":
		case "neck": return 60;
		case "torso_upper":
		case "right_arm_upper":
		case "left_arm_upper":
		case "right_arm_lower":
		case "left_arm_lower":
		case "right_hand":
		case "left_hand":
		case "gun": return 48;
		case "torso_lower": return 40;
		case "right_leg_upper":
		case "left_leg_upper": return 32;
		case "right_leg_lower":
		case "left_leg_lower": return 10;
		case "right_foot":
		case "left_foot": return 5;
	}
	return 48;
}

glitcherCaught()
{
	self endon( "death" );
	self.iscaught=true;
	self FreezeControls(1);
	self iprintlnbold("^1YOU ARE NOT SUPPOSED TO BE HERE!");
	wait 2;
	self iprintlnbold("^2Little Notice: ^1Learn to Play !");
	wait 1;
	self.iscaught=false;
	self suicide();
}